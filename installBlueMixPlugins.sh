#!/bin/bash
# This script will install all bluemix plugins available from the public repo

# Display availabe plugins
bluemix plugin repo-plugins

plugins=( $(bluemix plugin repo-plugins | grep 'Not Installed' | awk '{print $3}') )

# Install plugin list
for plugin in "${plugins[@]}"; do
    bluemix plugin install ${plugin} -r ${BLUEMIX_PLUGIN_REPO_NAME}
    echo ""
done

# show installed plugins
echo ""
bluemix plugin list
