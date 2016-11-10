#!/bin/bash
bmcert_path=/etc/bluemix
mkdir -p ${bmcert_path}

# get BlueMix user if not found
[ "${BM_USER}" == "" ] && { echo -n "BlueMix username: "; read BM_USER; }

BM_API="${BM_API:-https://api.${BM_ENV}ng.bluemix.net}"

# Build login command
login_cmd="bluemix login -a ${BM_API} -u ${BM_USER}"
[ "${BM_PASS}" != "" ] && login_cmd+=" -p ${BM_PASS}"
[ "${BM_ORG}" != "" ] && login_cmd+=" -o ${BM_ORG}"
[ "${BM_SPACE}" != "" ] && login_cmd+=" -s \"${BM_SPACE}\""

# log into bluemix and get certs
echo "Logging into BlueMix"
${login_cmd}

# log into container service
echo ""
echo "Logging into IBM Container Service"
#eval $(cf ic login | grep export)
eval "$(bluemix ic init | grep export)"

# link Cert path with volume path
#echo "DOCKER_CERT_PATH=${DOCKER_CERT_PATH}"
ln -s ${DOCKER_CERT_PATH} ${bmcert_path}/certs
echo "done"
echo ""
