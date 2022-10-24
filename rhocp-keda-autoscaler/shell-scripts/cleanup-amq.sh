#!/bin/bash

set -e

NAMESPACE="amq-keda"

echo "Uninstalling AMQ Operator and CRs"

helm uninstall amq-broker-crs -n ${NAMESPACE} || true
helm uninstall amq-broker-operator -n ${NAMESPACE} || true
sleep 5
oc delete sub,csv,ip,operatorgroup --all -n ${NAMESPACE} || true
sleep 5
oc delete all --all -n ${NAMESPACE} || true
oc get namespace "${NAMESPACE}" -o json \
   | jq 'del(.spec.finalizers)' \
   | oc replace --raw /api/v1/namespaces/"${NAMESPACE}"/finalize -f - || true

oc delete project ${NAMESPACE} || true

sleep 10

set +e