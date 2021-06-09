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

## Expose service

Now you have a running cluster you can expose the container port to the rest of the cluster, so the service can be discovered by other containers, projects or k8s components.

```bash
less 02-service.yaml
oc apply -f 02-service.yaml
```

Check service is configured

```bash
oc get svc
```

You can then try to reach your service from the pod itself

```bash
POD_NAME=$(oc get pods -l app.kubernetes.io/instance=todos -oname)
oc exec $POD_NAME -- curl http://todos:8080
```

or you can try with a temporary pod

```bash
cat <<EOF | oc apply -f -
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    app: testcurl
  name: testcurl
spec:
  containers:
  - image: quay.io/xymox/vue-todos:latest
    name: vue-todos
    resources: {}
status: {}
EOF
oc exec testcurl -- curl --silent -I http://todos:8080
oc exec testcurl -- curl --silent http://todos:8080
```

## Expose your application to the external world

To get access to your application from anywhere, you have to expose the service using a route.

```bash
less 03-route.yaml
oc apply -f 03-route.yaml
```

Check your route is created

```bash
oc get route
```

Then get the url of your application and try to connect with your favorite browser

```bash
echo https://$(oc get route todos -o jsonpath='{.spec.host}')
```
