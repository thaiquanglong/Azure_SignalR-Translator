.\Azure_login.ps1     
terraform init
terraform plan -out main.tfplan
terraform apply main.tfplan

terraform output -json | set-content ./keys.json 