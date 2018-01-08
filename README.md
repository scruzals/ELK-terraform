# Introduction 
Deploy an ELK stack on Azure or AWS using Terraform and Fabric

# Getting Started

set environment variables 
Azure Powershell (windows and linux. set in ps profile)
``````````````
$env:sid = <subscription id>
$env:cid = <client id>
$env:tid = <tenent id>
$env:pass = <password>
```````````````
Azure bash/python
`````````````````
export sid = <subscription id>
export cid = <client id>
export tid = <tenent id>
export pass = <password>
`````````````````

AWS powershell
`````````````````
$env:aws_access_key = <access key>
$env:aws_secret_key = <secret key>
`````````````````

AWS bash/python 
``````````````````
export aws_access_key = <access key>
export aws_secret_key = <secret key>
``````````````````
# Software dependencies

- Terraform v11.0 (https://www.terraform.io/)
- Fabric python module (pip install fabric)
- Powershell (non-windows install https://github.com/PowerShell/PowerShell)

# Build and Test
TODO:

# Contribute

TODO: Explain how other users and developers can contribute to make your code better. 

