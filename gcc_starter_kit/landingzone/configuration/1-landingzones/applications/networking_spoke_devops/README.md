cd /tf/avm/gcc_starter_kit/landingzone/configuration/1-landingzones/applications/networking_spoke_devops

terraform init  -reconfigure \
-backend-config="resource_group_name=aoaidev-rg-launchpad" \
-backend-config="storage_account_name=aoaidevstgtfstateosv" \
-backend-config="container_name=1-landingzones" \
-backend-config="key=network-spoke-devops.tfstate"

terraform plan \
-var="storage_account_name=aoaidevstgtfstateosv" \
-var="resource_group_name=aoaidev-rg-launchpad"

terraform apply -auto-approve \
-var="storage_account_name=aoaidevstgtfstateosv" \
-var="resource_group_name=aoaidev-rg-launchpad"
