cd /tf/avm/gcc_starter_kit/landingzone/configuration/1-landingzones/common_services/networking_hub_internet_egress

terraform init  -reconfigure \
-backend-config="resource_group_name=aoaidev-rg-launchpad" \
-backend-config="storage_account_name=aoaidevstgtfstateosv" \
-backend-config="container_name=1-landingzones" \
-backend-config="key=network-hub-internet-egress.tfstate"

terraform plan \
-var="storage_account_name=aoaidevstgtfstateosv" \
-var="resource_group_name=aoaidev-rg-launchpad"

terraform apply -auto-approve \
-var="storage_account_name=aoaidevstgtfstateosv" \
-var="resource_group_name=aoaidev-rg-launchpad"

