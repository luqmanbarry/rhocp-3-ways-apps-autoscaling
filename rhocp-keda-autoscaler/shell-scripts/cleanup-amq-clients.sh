#!/bin/bash

set -e

NAMESPACE="amq-keda"

echo "Removing AMQ Clients"

helm uninstall amq-clients -n ${NAMESPACE} || true
sleep 5

set +e