#!/bin/bash

# By Andy Sayler
# April 2016
# Uses https://github.com/diafygi/acme-tiny

ACME_CONF="$1"
SITE="$2"

# Read Site Vars
if [[ ! -e "${ACME_CONF}" ]]
then
    echo "Could not find ${ACME_CONF}"
    exit 1
fi
source "${ACME_CONF}" || { echo 'source failed' ; exit 1; }

# Backup Existing Cert
if [[ -e "${CRT}" ]]
then
    echo "Backing up cert for ${SITE}"
    mv "${CRT}" "${CRT}.old" || { echo 'mv failed' ; exit 1; }
fi

# Request New Cert
echo "Requesting new cert for ${SITE}"
python3 "${ACME_TINY}" --account-key "${ACCOUNT_KEY}" \
        --csr "${CSR}" --acme-dir "${CHALLENGE}" \
        > "${CRT}"  || { echo 'acme_tiny failed' ; exit 1; }

# Generate Cert Chain
wget -O - "${INTER_URL}" > "${INTER}"  || { echo 'wget failed' ; exit 1; }
cat "${CRT}" "${INTER}" > "${CHAIN}"  || { echo 'cat failed' ; exit 1; }

# Reload Apache
echo "Reloading Apache"
sudo service apache2 reload  || { echo 'apache reload failed' ; exit 1; }

# Exit
exit 0
