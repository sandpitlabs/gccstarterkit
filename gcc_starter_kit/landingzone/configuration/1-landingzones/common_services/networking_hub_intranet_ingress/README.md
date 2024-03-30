cd /tf/avm/gcc_starter_kit/landingzone/configuration/1-landingzones/common_services/networking_hub_intranet_ingress

terraform init -reconfigure
terraform plan
terraform apply -auto-approve
