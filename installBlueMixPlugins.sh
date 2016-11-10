#!/bin/bash
# This script will install all bluemix plugins available from the public repo

# Display availabe plugins
bluemix plugin repo-plugins

plugins=( $(bluemix plugin repo-plugins | awk '{print $1}') )

# Trim plugin list
for p in "${plugins[@]}"; do
    if [ "${p}" == "Name" ]; then
        plugins=("${plugins[@]:1}")
        break
    else
        plugins=("${plugins[@]:1}")
    fi
done

# Install plugin list
for plugin in "${plugins[@]}"; do
    bluemix plugin install ${plugin} -r ${BLUEMIX_PLUGIN_REPO_NAME}
    echo ""
done

# show installed plugins
echo ""
bluemix plugin list
