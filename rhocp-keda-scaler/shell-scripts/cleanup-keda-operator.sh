#!/bin/bash

set -e

OPERATOR_NAMESPACE="openshift-keda"

echo "Uninstalling RHOCP KEDA Operator"

helm uninstall rhocp-keda-controller -n ${OPERATOR_NAMESPACE} || true
helm uninstall rhocp-keda-operator  -n ${OPERATOR_NAMESPACE} || true

oc delete sub,csv,ip,operatorgroup --all -n ${OPERATOR_NAMESPACE} || true
oc delete crd clustertriggerauthentications.keda.sh kedacontrollers.keda.sh scaledjobs.keda.sh scaledobjects.keda.sh triggerauthentications.keda.sh || true
oc delete clusterrole.keda.sh-v1alpha1-admin || true
oc delete clusterrolebinding.keda.sh-v1alpha1-admin || true
oc delete all --all -n ${OPERATOR_NAMESPACE} || true
sleep 5
oc get namespace "${OPERATOR_NAMESPACE}" -o json \
   | jq 'del(.spec.finalizers)' \
   | oc replace --raw /api/v1/namespaces/"${OPERATOR_NAMESPACE}"/finalize -f - || true

oc delete ns "${OPERATOR_NAMESPACE}"

set +e