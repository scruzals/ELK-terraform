#!/bin/bash
./deploy_elasticstack.py -access_key $aws_access_key -secret_key $aws_secret_key


KIPS=$(terraform output kibana_network_interface_private_ips)
DIPS=$(terraform output data_network_interface_private_ips)
MIPS=$(terraform output master_network_interface_private_ips)

echo "deploying ES Masters"
fab -H "$MIPS" install_elasticsearch
fab -H "$MIPS" config_elasticsearch_master:master_servers="$MIPS"
echo "deploying ES Data"
fab -H "$DIPS" install_elasticsearch
fab -H "$MIPS" config_elasticsearch_data:master_servers="$MIPS"
echo "deploying ES Kibana"
fab -H "$KIPS" install_kibana
fab -H "$MIPS" config_elasticsearch