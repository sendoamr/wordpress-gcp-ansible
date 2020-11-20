### Install

- Ansible
- Terraform

### Config

- Reserve static IP:
https://console.cloud.google.com/networking/addresses

- Change file `ansible/group_vars/all` - Change `server_hostname: X.X.X.X`
- Change file `terraform/main` - Change `nat_ip = "X.X.X.X"` to use the static ip you have setup

### Running

- run `terraform init ./terraform/`
- run `terraform plan -var-file="./terraform/dev.tfvars" -out=dev_plan ./terraform/`
- run `terraform apply -auto-approve "dev_plan"`

