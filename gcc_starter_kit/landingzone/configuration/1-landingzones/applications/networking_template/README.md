cd {{working directory}}

terraform init  -reconfigure \
-backend-config="resource_group_name=aoaidev-rg-launchpad" \
-backend-config="storage_account_name=aoaidevstgtfstateosv" \
-backend-config="container_name=1-landingzones" \
-backend-config="key=network-???????.tfstate"

terraform plan \
-var="storage_account_name=aoaidevstgtfstateosv" \
-var="resource_group_name=aoaidev-rg-launchpad"

terraform apply -auto-approve \
-var="storage_account_name=aoaidevstgtfstateosv" \
-var="resource_group_name=aoaidev-rg-launchpad"