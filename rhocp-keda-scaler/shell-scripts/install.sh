#!/bin/bash

sh shell-scripts/install-amq.sh
sleep 10
sh shell-scripts/install-keda-operator.sh
sleep 10
sh shell-scripts/install-keda-crs.sh
sleep 10
sh shell-scripts/install-amq-clients.sh