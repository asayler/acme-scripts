#!/bin/bash

# By Andy Sayler
# April 2016
# Uses https://github.com/diafygi/acme-tiny

SITE="$1"
CHALLENGE="$2"

LE_BASE="/srv/@le"
ACME_TINY="${LE_BASE}/src/acme-tiny/acme_tiny.py"
ACCOUNT_KEY="${LE_BASE}/account.key"
INTER="${LE_BASE}/letsencrypt.crt"
INTER_URL="https://letsencrypt.org/certs/lets-encrypt-x3-cross-signed.pem"
CSR_BASE="${LE_BASE}/files/csr"
CSR="${CSR_BASE}/${SITE}.csr"
CRT_BASE="${LE_BASE}/files/certs"
CRT="${CRT_BASE}/${SITE}.crt"
CHAIN="${CRT}.chain"

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
