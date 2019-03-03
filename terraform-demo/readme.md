# Terraform demo

Simple demo to introduce Terraform:
* CLI and HCL
* core concepts:
  * provider
  * resources
  * terraform init & apply

## Usage
First, login to Azure:
```bash
az login
```

Then, you can deploy:
```bash
terraform init
terraform plan
terraform apply
```

Finally, you can cleanup:
```bash
terraform destroy
```