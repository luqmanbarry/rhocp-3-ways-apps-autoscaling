# Red Hat OpenShift KEDA Autoscaler

## Overview

As a developer, you can use the custom metrics autoscaler to specify how OpenShift Container Platform should automatically increase or decrease the number of pods for a deployment, stateful set, custom resource, or job based on custom metrics that are not just based on CPU or memory.

> _At the time of writing this content (10/2022), below comments apply._

> **_NOTE_:** The custom metrics autoscaler currently supports only the Prometheus trigger, which can use the installed OpenShift Container Platform monitoring or an external Prometheus server as the metrics source.

> **_IMPORTANT_:** The custom metrics autoscaler is a Technology Preview feature only. Technology Preview features are not supported with Red Hat production service level agreements (SLAs) and might not be functionally complete. Red Hat does not recommend using them in production. These features provide early access to upcoming product features, enabling customers to test functionality and provide feedback during the development process.
> For more information about the support scope of Red Hat Technology Preview features, see https://access.redhat.com/support/offerings/techpreview/.

Helm with bash are used to manage templatization and automation needs.


## Pre-Requisites
- Up & Running OpenShift cluster
- `cluster-admin` privilege
- Enable monitoring for user-defined projects. Follow [this link](https://docs.openshift.com/container-platform/4.6/monitoring/enabling-monitoring-for-user-defined-projects.html) for instructions.

## Procedure

Take a look at each individual script in the `shell-scripts` directory to understand where and how each component is deployed.

`custom-metrics-scaler` will be used as the root directory throughout the steps that follow.

To deploy the entire solution with one command, execute the `sh shell-scripts/install.sh` script.

### Deploy AMQ Broker Operator, Custom Resources

```
sh ./shell-scripts/install-amq.sh
```

### Deploy AMQ Clients -- Producer, Consumer

```
sh shell-scripts/install-amq-clients.sh
```

### Install OpenShift Custom Metrics Operator, Custom Resources

```
sh shell-scripts/install-keda-operator.sh
```

```
sh shell-scripts/install-keda-crs.sh
```



## Cleanup

```
sh shell-scripts/cleanup-keda-crs.sh

sh shell-scripts/cleanup-keda-operator.sh

sh shell-scripts/cleanup-amq-clients.sh

sh shell-scripts/cleanup-amq.sh

```

To cleanup the entire solution with one command, execute the `sh shell-scripts/cleanup.sh` script.

