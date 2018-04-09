#!/bin/sh
set -e
cd "$(dirname "$0")"
test -s stunnel.key || openssl genrsa -out stunnel.key 2048
test -s stunnel.crt || openssl req -x509 -new -key stunnel.key -out stunnel.crt
stunnel stunnel.ini
