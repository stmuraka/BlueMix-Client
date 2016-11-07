#!/bin/bash
bmcert_path=/etc/bluemix
mkdir -p ${bmcert_path}

# get BlueMix user if not found
[ "${BM_USER}" == "" ] && { echo -n "BlueMix username: "; read BM_USER; }

# log into bluemix and get certs
echo "Logging into BlueMix"
cf login -a api.${BM_ENV}ng.bluemix.net -u ${BM_USER} -p ${BM_PASS} -o ${BM_ORG} -s "${BM_SPACE}"

# log into container service
echo ""
echo "Logging into IBM Container Service"
#eval $(cf ic login | grep export)
cf ic login | grep export

# link Cert path with volume path
#echo "DOCKER_CERT_PATH=${DOCKER_CERT_PATH}"
ln -s ${DOCKER_CERT_PATH} ${bmcert_path}/certs
