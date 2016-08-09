# acme-scripts

This is a set of basic scripts built around [acme-tiny](https://github.com/diafygi/acme-tiny)
with the aim of making acme-tiny eaiser to call via cron.

To use, run (or call via cron):

`./get_cert.sh <path to config file> <site name>`

An example config file is included in this repo.
You must manully generate a CSR in advance and point the config file to its location.
See the acme-tiny [README](https://github.com/diafygi/acme-tiny/blob/master/README.md) for more details.
