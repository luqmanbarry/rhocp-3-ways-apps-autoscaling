#!/bin/bash

set -e


TEST_NAMESPACE="amq-keda"

echo "Installing RHOCP KEDA CRs"
oc create sa thanos-metrics-reader -n ${TEST_NAMESPACE} || true
SA_TOKEN=$(oc describe sa thanos-metrics-reader -n ${TEST_NAMESPACE}  | grep Tokens | awk '{print $2}')
echo "ServiceAccount Token: ${SA_TOKEN}"
helm upgrade --install rhocp-keda-crs ./rhocp-keda-crs \
     --set prometheus.auth.serviceAccountToken=${SA_TOKEN} \
      -n ${TEST_NAMESPACE}
sleep 15
helm list

set +e