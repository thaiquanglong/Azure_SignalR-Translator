.\Azure_login.ps1     
terraform init
terraform plan -out main.tfplan
terraform apply main.tfplan
$resource_group_name=$(terraform output -raw resource_group_name)
az group show --name $resource_group_name