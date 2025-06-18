# Azure Security Lab
This is an individual project of mine with the goal of creating a security lab in Azure using the student subscription. This lab will create the following modules:

**Features**
- Ubuntu 22.04 LTS
	- Running docker (for docker compose)
	- Pre-installed [GitHub](https://github.com/vulhub/vulhub) repository
	- Wazuh manager
- Kali-Linux
	- Kali-Linux default tools
	- Desktop environment
- Windows 10
	- Wazuh Agent
- Azure Container Registry
	- Automated image upload functionality
- Azure Container Instance
	- Automatically uses the image uploaded to the ACR

## Prerequisites
This environment will require the following prerequisites to be installed:
- An Azure student subscription + tenant
- the Azure CLI
- Terraform
- Docker

## Setting up lab
After all the prerequisites have been installed and configured you will need to perform the following steps:

**Step 1**
Clone the repository using Git or download the zip file:
```
git clone https://github.com/LuukRaaijmakers/Azure-Security-Lab.git
```

**Step 2**
Login using the Azure CLI and select the correct subscription:
```
Az login
```

And accept the VM image terms:
```
az vm image terms accept --urn kali-linux:kali:kali-2024-4:2024.4.1
```

**Step 3**
Initialize terraform:
```
terraform init
```

**Step 4**
configure the *config.tfvars* file by filling out the all the requested variables. Beware that the username and password fields need to comply with the default username and password policies. 

**Step 5**
Ensure that there are no errors and create the environment!
*Important, if you plan on using Azure container instances ensure that Docker is running on your system. This is required to pull, tag and push the image.*
```
terraform plan -var-file="config.tfvars"
```
then:
```
terraform apply -var-file="config.tfvars" -auto-approve
```

## Clean up
Once you are done you can destroy the environment using the following command: 
```
terraform destroy -var-file="config.tfvars" -auto-approve
```

Terraform wil destroy the entire environment using 