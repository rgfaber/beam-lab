#! /bin/bash

curl -sfL https://get.k3s.io | sh -s - server   \
  --datastore-endpoint="mysql://user:pass@tcp(ip_address:3306)/databasename" \
  --disable traefik \
  --node-taint CriticalAddonsOnly=true:NoExecute \
  --tls-san 192.168.1.2 \
  --tls-san k3s.home.lab