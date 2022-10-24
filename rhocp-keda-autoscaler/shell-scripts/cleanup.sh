#!/bin/bash

sh shell-scripts/cleanup-amq-clients.sh
sleep 10
sh shell-scripts/cleanup-keda-crs.sh
sleep 10
sh shell-scripts/cleanup-keda-operator.sh
sleep 10
sh shell-scripts/cleanup-amq.sh
sleep 10