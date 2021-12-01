# USAGE

## (basedir/packerRG)
```sh
terraform init
populate terraform.tfvars
terraform apply
```

## (basedir/packer)
```sh
populate variables.pkrvars.hcl
packer build [-force] -var-file="variables.pkrvars.hcl"
```

**grab image id**

## (basedir)
```sh
run ./genRSA.sh
terraform init
populate terrform.tfvars 

**REMEMBER about imageID!** 

terraform apply

run ./grabMasterIP.sh

run ansible-playbook -i inventory.ini join.yml
```
ENJOY!
