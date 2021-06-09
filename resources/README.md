# Deploy todos application on OpenShift using static yaml resources descriptor

## Setup

Create a new namespace for this exercise or use the namespace allocated to you.

```bash
export NS=<mynamespace>
# if namespace does not exists
oc new-project ${NS}
# else
oc project ${NS}
```

## Deploy the deployment descriptor

You can have a look at the content of the deployment descriptor (01-deployment.yaml). For more information about deployment check https://kubernetes.io/fr/docs/concepts/workloads/controllers/deployment/


```bash
less 01-deployment.yaml
```

Now you can create the deployment on the cluster issueing the command:

```bash
oc apply -f 01-deployment.yaml
# or kubectl apply -f 01-deployment.yaml
```

Check that everything is running

```bash
oc get deployment
oc get pods
```

