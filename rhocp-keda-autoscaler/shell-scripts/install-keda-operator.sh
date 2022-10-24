#!/bin/bash

set -e

OPERATOR_NAMESPACE="openshift-keda"

oc create ns ${OPERATOR_NAMESPACE}
sleep 5
echo "Installing RHOCP KEDA Operator"
helm upgrade --install rhocp-keda-operator ./rhocp-keda-operator \
     -n ${OPERATOR_NAMESPACE}
sleep 120
oc get sub,csv,pod,svc,route,pv,pvc -n ${OPERATOR_NAMESPACE}

echo "Installing KEDA Controller"
helm upgrade --install rhocp-keda-controller ./rhocp-keda-controller -n ${OPERATOR_NAMESPACE}
sleep 60 

set +e
