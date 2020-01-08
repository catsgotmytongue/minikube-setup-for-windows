#!/bin/bash

mkdir output/
# generate a root CA key
openssl genrsa -des3 -out /output/rootCA.key 2048

# generate rootCA.pem certificate in output/rootCA.pem
openssl req -x509 -new -nodes -key /output/rootCA.key -sha256 -days 1024 -out /output/rootCA.pem

# generate output/server.csr(certificate request) and output/server.key using server.csr.cnf
openssl req -new -sha256 -nodes -out /output/server.csr -newkey rsa:2048 -keyout /output/server.key -config <( cat server.csr.cnf ) -subj 'C = US, ST = OR, L = Salem, O = End Point, OU = Testing Domain, emailAddress = user@minikube.dev, CN = minikube.dev'

# generate server.crt using v3.ext for alternate names (chrome won't trust without)
openssl x509 -req -in /output/server.csr -CA /output/rootCA.pem -CAkey /output/rootCA.key -CAcreateserial -out /output/server.crt -days 500 -sha256 -extfile v3.ext

