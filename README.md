# USAGE

**(basedir/packerRG)** `terraform init`
**(basedir/packerRG)** populate terraform.tfvars
**(basedir/packerRG)** `terraform apply`

**(basedir/packer)** populate variables.pkrvars.hcl
**(basedir/packer)** `packer build [-force] -var-file="variables.pkrvars.hcl"`

**grab image id**

**(basedir)** run `./genRSA.sh`
**(basedir)** `terraform init`
**(basedir)** populate terrform.tfvars 
**REMEMBER about imageID!** 

**(basedir)** `terraform apply`

**(basedir)** run `./grabMasterIP.sh`

**(basedir)** run `ansible-playbook -i inventory.ini join.yml`

ENJOY!
