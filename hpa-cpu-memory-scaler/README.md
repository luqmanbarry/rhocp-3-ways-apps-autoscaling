# CPU/Memory Based Auto Scaling -- HorizontalPodAutoscaler

## Overview

> As a developer, you can use a horizontal pod autoscaler (HPA) to specify how OpenShift Container Platform should automatically increase or decrease the scale of a replication controller or deployment configuration, based on metrics collected from the pods that belong to that replication controller or deployment configuration. You can create an HPA for any any deployment, deployment config, replica set, replication controller, or stateful set. -- OpenShift Docs

Supported metrics
The following metrics are supported by horizontal pod autoscalers:

| Metric | Description | API version |
|--------|-------------|-------------|
| CPU utilization | Number of CPU cores used. Can be used to calculate a percentage of the pod’s requested CPU.  | autoscaling/v1, autoscaling/v2 |
| Memory utilization | Amount of memory used. Can be used to calculate a percentage of the pod’s requested memory.  | autoscaling/v2 |


## Implementation

### Pre-Requisites

- Access to an OpenShift/Kubernetes cluster
- ServiceAccount with permission to  create `HorizontalPodAutoscaler`.
  Here's a sample `ServiceAccount, ClusterRole, ClusterRoleBinding` templates. _Do not create these resoures if there is a SA with required access on the target namespace; use that instead._
  ```
  ---
    apiVersion: v1
    kind: ServiceAccount
    metadata:
      name: cronjob-scaler
      namespace: {{ include "cronjob-scaler.namespace" . }}
    labels:
        {{- include "cronjob-scaler.labels" . | nindent 4 }}
    ---
    apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRole
    metadata:
      name: cronjob-scaler
    rules:
    - apiGroups: ["*"]
      resources: ["Pods"]
      verbs: ["get", "list"]
    - apiGroups: ["apps", "extensions"]
      resources: ["DeploymentConfigs", "Deployments", "StatefulSets"]
      verbs: ["get", "list", "patch"]
    - apiGroups: ["autoscaling/v1", "autoscaling/v2beta2"]
      resources: ["HorizontalPodAutoscaler"]
      verbs: ["get", "list", "patch", "create"]
    ---
    apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRoleBinding
    metadata:
      name: cronjob-scaler
    subjects:
    - kind: ServiceAccount
      name: cronjob-scaler
      namespace: {{ include "cronjob-scaler.namespace" . }}
    roleRef:
      apiGroup: rbac.authorization.k8s.io
      kind: ClusterRole
      name: cronjob-scaler
  ```


### Procedure

#### 1. Identify deployables target for scheduled scaling

`DepoymentConfig, Deployment, StatefulSet` are examples of scalable kubernetes objects.

#### 2. Build the chart values file

Here's an example

```
hpa:
  targetCPUScalePercentage: 50
  scaleDownStabilizationPeriodSeconds: 60
  scaleUpStabilizationPeriodSeconds: 60
  scaleTargets:
  - name: loadtest
    kind: Deployment
    maxReplicas: 5
    minReplicas: 1
 - name: app1
   kind: Deployment
   maxReplicas: 2
   minReplicas: 1
```

#### 3. Install the helm chart

```
 helm uninstall hpa-cpu-memory-scaler || true
helm upgrade --install hpa-cpu-memory-scaler ./hpa-cpu-memory-scaler \
    -f ${VALUES_FILE} \
    -n ${NAMESPACE}
sleep 30
```

#### 4. HorizontalPodAutoscaler in Action

To the HPA, there is a Deployment example named `loadtest` deployed in the cluster.

Run the below command to induce app CPU utilization spikes.

```
 curl http://$(oc get route/loadtest -ojsonpath={.spec.host})/api/loadtest/v1/cpu/3

 watch oc get po
```

## Clean Up

```
helm uninstall hpa-cpu-memory-scaler
sleep 15
oc delete hpa -l app=hpa-cpu-memory-scaler
```



