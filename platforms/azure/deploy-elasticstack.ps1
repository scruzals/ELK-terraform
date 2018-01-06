param(
[guid]$sid = $env:sid,
[guid]$cid = $env:cid,
[guid]$tid = $env:tid,
[string]$pass = $env:pass,
[switch] $destroy,
[switch] $config
)

$ErrorActionPreference="stop"

if($destroy.ispresent){
	terraform destroy -var "subscription_id=$sid" -var "client_id=$cid" -var "tenant_id=$tid" -var "client_secret=$pass"
}
else{
terraform plan -var "subscription_id=$sid" -var "client_id=$cid" -var "tenant_id=$tid" -var "client_secret=$pass" -out ELK-plan

terraform apply "ELK-plan"
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


#write-host sleeping to allow instances to come up -ForegroundColor Yellow
#sleep 60

write-host setting up master nodes -ForegroundColor Yellow

fab -H $external_ips install_elasticsearch
fab -H $external_ips config_elasticsearch_master:master_servers=$internal_ips

write-host seting up data nodes -ForegroundColor Yellow

fab -H $data_external_ips install_elasticsearch
fab -H $data_external_ips config_elasticsearch_data:master_servers=$internal_ips
}
