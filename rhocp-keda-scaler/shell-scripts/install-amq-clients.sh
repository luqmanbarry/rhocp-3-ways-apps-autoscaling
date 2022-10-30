#!/bin/bash

set -e

NAMESPACE="amq-keda"

sleep 5
echo "Installing AMQ Clients"
helm uninstall amq-clients || true
sleep 5
helm install amq-clients ./amq-clients -n ${NAMESPACE}
sleep 15
helm list
sleep 5
oc get all -n ${NAMESPACE}

set +e
