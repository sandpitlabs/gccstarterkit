# ----------------------------------------------------------------------
# gcci platform terraform state file
# ----------------------------------------------------------------------
sudo chmod -R -f 777 /tf/caf/gcc_starter_kit/landingzone/configuration/level0/gcci_platform/import.sh

cd /tf/caf/gcc_starter_kit/landingzone/configuration/0-launchpad/launchpad

./import.sh

# ----------------------------------------------------------------------
# networking
# ----------------------------------------------------------------------

cd /tf/caf/gcc_starter_kit

./deploy_network.sh

# ----------------------------------------------------------------------
# solution accelerators
# ----------------------------------------------------------------------

cd /tf/caf/gcc_starter_kit

./deploy_aks_pattern.sh
./deploy_app_service_pattern.sh
./deploy_open_ai_pattern.sh

