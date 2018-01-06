param(
$aws_access_key = $env:aws_access_key,
$aws_secret_key = $env:aws_secret_key,
[switch] $destroy,
[switch] $config
)

$ErrorActionPreference="stop"

if($destroy.ispresent){
	terraform destroy -var "aws_access_key=$aws_access_key" -var "aws_secret_key=$aws_secret_key"
}
else{
terraform plan -var "aws_access_key=$aws_access_key" -var "aws_secret_key=$aws_secret_key" -out aws-ELK-plan

terraform apply "aws-ELK-plan"
}

if($config.ispresent)
{
$internal_ips=$null
$external_ips = $null
$data_external_ips = $null
$a = terraform output master_network_interface_private_ips
$a = $a.trimend(",")
foreach ($ip in $a){
	$holder=@"
	\"$ip\"\,
"@
	$internal_ips +=$holder
}
$internal_ips = $internal_ips.TrimEnd(',')
$internal_ips = $internal_ips.TrimEnd('\')
$b = terraform output master_network_interface_private_ips
$b = $b.trimend(",")
	foreach ($ip in $b){
	$holder=@"
	$ip,
"@
	$external_ips +=$holder
}
$external_ips = $external_ips.TrimEnd(',')
$external_ips = $external_ips.TrimEnd('\')
$c = terraform output data_network_interface_private_ips
$c = $c.trimend(",")
foreach ($ip in $c){
	$holder=@"
	$ip,
"@
	$data_external_ips +=$holder
}

$data_external_ips = $data_external_ips.TrimEnd(',')
$data_external_ips = $data_external_ips.TrimEnd('\')

$internal_ips
$external_ips
$data_external_ips


write-host sleeping 60 seconds to allow instances to come up -ForegroundColor Yellow
sleep 60

write-host setting up master nodes -ForegroundColor Yellow

fab -H $external_ips install_elasticsearch
fab -H $external_ips config_elasticsearch_master:master_servers=$internal_ips

write-host seting up data nodes -ForegroundColor Yellow

fab -H $data_external_ips install_elasticsearch
fab -H $data_external_ips config_elasticsearch_data:master_servers=$internal_ips
}
