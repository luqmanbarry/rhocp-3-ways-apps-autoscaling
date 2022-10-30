#!/bin/bash

set -e

TEST_NAMESPACE="amq-keda"

helm uninstall rhocp-keda-crs -n ${TEST_NAMESPACE} || true
oc delete serviceaccount thanos-metrics-reader -n ${TEST_NAMESPACE} || true


set +e