#!/bin/bash

set -e

NAMESPACE="amq-keda"

oc new-project ${NAMESPACE}
sleep 5
echo "Installing AMQ Operator"
helm install amq-broker-operator ./amq-broker-operator -n ${NAMESPACE}
sleep 30
helm list

echo "Installing AMQ CRs"
helm install amq-broker-crs ./amq-broker-crs -n ${NAMESPACE}
sleep 30
helm list
oc get all -n ${NAMESPACE}

set +e
