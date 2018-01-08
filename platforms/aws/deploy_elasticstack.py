#!/usr/bin/python
from python_terraform import *
import os
import argparse
import time

parser = argparse.ArgumentParser()

parser.add_argument('-access_key', help='AWS access key')

parser.add_argument('-secret_key', help='AWS secret key')

args = parser.parse_args()

access_key = args.access_key
secret_key = args.secret_key

tf = Terraform()
print("Creating Terraform plan")
tf.plan(no_color=IsFlagged, out='py-elk-out', refresh=False, var={'aws_access_key':access_key, 'aws_secret_key':secret_key })
print("Appling Terraform plan")
tf.apply('py-elk-out')

print("slepping 60 sec to allow instances to come up")
time.sleep(60)
print('destroying Terraform plan')
tf.destroy(no_color=IsFlagged, var={'aws_access_key':access_key, 'aws_secret_key':secret_key})