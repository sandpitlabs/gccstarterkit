cd {{working directory}}

terraform init -reconfigure
terraform plan
terraform apply -auto-approve
