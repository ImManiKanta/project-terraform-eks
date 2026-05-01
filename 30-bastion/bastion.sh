#!/bin/bash

# We are creating 50GB root disk, but only 20GB is partitioned
# Remaining 30GB we need to extend using below commands
growpart /dev/nvme0n1 4
lvextend -r -L +30G /dev/mapper/RootVG-homeVol
xfs_growfs /home

yum install -y yum-utils
yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
yum -y install terraform

#Databases configuration in bastion host
cd /home/ec2-user/
git clone https://github.com/ImManiKanta/terraform-project.git
chown ec2-user:ec2-user -R terraform-project
cd terraform-project/5.databases
git pull
terraform init
terraform apply -auto-approve

#Components configuration in bastion host
cd /home/ec2-user/
chown ec2-user:ec2-user -R terraform-project
cd terraform-project/91.components
git pull
terraform init
terraform get -update
terraform apply -auto-approve