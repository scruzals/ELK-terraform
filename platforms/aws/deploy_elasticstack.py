#!/usr/bin/python
from python_terraform import *
import os

access_key = os.environ.get('aws_access_key')
secret_key = os.environ.get('aws_secret_key')
tf = Terraform()
print("Creating Terraform plan")
tf.plan(no_color=IsFlagged, out='py-elk-out', refresh=False, var={'aws_access_key':'access_key', 'aws_secret_key':'secret_key' })
print("Appling Terraform plan")
tf.apply('py-elk-out')

KIPS=tf.output('kibana_network_interface_private_ips')
DIPS=tf.output('data_network_interface_private_ips')
MIPS=tf.output('master_network_interface_private_ips')

print("Kibana IPs")
print(KIPS)
print("Data IPs")
print(DIPS)
print("Master IPs")
print(MIPS)

print('destroying Terraform plan')
DESTROY=tf.destroy(no_color=IsFlagged, var={'aws_access_key':access_key, 'aws_secret_key':secret_key})