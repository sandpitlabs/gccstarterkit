cd /tf/caf/templates
find . -name '*.tf' -exec sed -i -e 's/aoaidev-rg-launchpad/{{resource_group_name}}/g' {} \;
find . -name '*.tf' -exec sed -i -e 's/aoaidevstgtfstateacs/{{storage_account_name}}/g' {} \;
find . -name 'import.sh' -exec sed -i -e 's/xxxxxxxxxx-0ad7-4552-936f-xxxxxxxxxxxx/{{subscription_id}}/g' {} \;
find . -name '*.tfvars' -exec sed -i -e 's/aoaidev/{{prefix}}/g' {} \;
find . -name '*.tfvars' -exec sed -i -e 's/southeastasia/{{location}}/g' {} \;


