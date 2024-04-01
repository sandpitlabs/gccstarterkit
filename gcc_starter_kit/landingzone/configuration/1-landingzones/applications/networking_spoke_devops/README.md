cd /tf/avm/gcc_starter_kit/landingzone/configuration/1-landingzones/applications/networking_spoke_devops

terraform init -reconfigure
terraform plan
terraform apply -auto-approve 



# --------------------------------------------------------------------------

terraform init  -reconfigure \
-backend-config="resource_group_name=aoaidev-rg-launchpad" \
-backend-config="storage_account_name=aoaidevstgtfstatewny" \
-backend-config="container_name=1-landingzones" \
-backend-config="key=network-spoke-devops.tfstate"

terraform plan \
-var="storage_account_name=aoaidevstgtfstatewny" \
-var="resource_group_name=aoaidev-rg-launchpad"

terraform apply -auto-approve \
-var="storage_account_name=aoaidevstgtfstatewny" \
-var="resource_group_name=aoaidev-rg-launchpad"

# --------------------------------------------------------------------------

terraform apply -var='"storage_account_name=aoaidevstgtfstatewny","resource_group_name=aoaidev-rg-launchpad"'


terraform init \
-backend-config="resource_group_name=$${{vars.BACKEND_AZURE_RESOURCE_GROUP_NAME}}" \
-backend-config="storage_account_name=$${{vars.BACKEND_AZURE_STORAGE_ACCOUNT_NAME}}" \
-backend-config="container_name=$${{vars.BACKEND_AZURE_STORAGE_ACCOUNT_CONTAINER_NAME}}" \
-backend-config="key=terraform.tfstate"
