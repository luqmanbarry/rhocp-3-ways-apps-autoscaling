# CronJob Based Auto Scaling

## Overview

Scheduled/CronJob auto scaling uses OpenShift/Kubernetes native resources called **CronJob** that runs a job periodically on a given schedule; written in [Cron](https://en.wikipedia.org/wiki/Cron) format. 

All **CronJob** `schedule:` times are based on the time zone of the [kube-controller-manager](https://kubernetes.io/docs/reference/command-line-tools-reference/kube-controller-manager/).


## Implementation

### Pre-Requisites

- Access to an OpenShift/Kubernetes cluster
- Identification of the `kube-controller-manager` time zone
- ServiceAccount with permission to `get, list, update` kubernetes resources being targeted.
  Here's a sample `ServiceAccount, ClusterRole, ClusterRoleBinding` templates. _Do not create these resoures if theree is a SA with required access on the target namespace; use that instead._
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
      resources: ["Deployments", "Deployments", "StatefulSets"]
      verbs: ["get", "list", "patch"]
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
scaleActions:
  scaleUp:
    # Provide input in Cron Format -- Date/Time must be in kube controller TZ
    schedule: "0 3 * * *"  
    components:
    - name: app1
      resourceType: Deployment
      replicas: 2
    - name: app2
      resourceType: Deployment
      replicas: 2
    - name: app3
      resourceType: Deployment
      replicas: 2
  scaleDown:
    # Provide input in Cron Format -- Date/Time must be in kube controller TZ
    schedule: "0 5 * * *" 
    components:
    - name: app1
      resourceType: Deployment
      replicas: 1
    - name: app2
      resourceType: Deployment
      replicas: 1
    - name: app3
      resourceType: Deployment
      replicas: 1
```

#### 3. Install the helm chart

```
 helm uninstall cronjob-scaler || true
helm upgrade --install cronjob-scaler ./cronjob-scaler \
    --set scaleActions.scaleUp.schedule="${SCALE_UP_SCHEDULE}" \
    --set scaleActions.scaleDown.schedule="${SCALE_DOWN_SCHEDULE}" \
    -f ${VALUES_FILE} \
    -n ${NAMESPACE}
sleep 30
```

## Clean Up

```
helm uninstall cronjob-scaler
sleep 15
oc delete cronjob -l app=cronjob-scaler
```



