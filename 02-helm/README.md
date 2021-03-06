# Deploy todos application on OpenShift using helm

Helm is a package manager widely used to package application deployment and to ship applications to Kubernetes clusters.

## Setup

Create a new namespace for this exercise or use the namespace allocated to you.

```bash
export NS=<mynamespace>
# if namespace does not exists
oc new-project ${NS}
# else
oc project ${NS}
```

## Inspect template generated by Helm

First of all, we are looking at what kind of resources helm is producing.

```bash
helm template todos todos | less
```

You can see that it looks like resources descriptors we use in the previous sample.

## Deploy the application using Helm

You can look at the file values.yaml it contains parameters or variables used to configure the application.
We will see that you can override those variables by using --set helm parameter or using a variables-override.yaml file.

For now, let's apply the helm chart in the current project

```bash
helm install todos todos
```

The first todos parameter is the name of the chart, the second is the directory where the chart is located.
You can also do:

```bash
cd todos
helm install todos .
```

Check that everything is running

```bash
oc get deployment
oc get pods
oc get service
oc get route
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

Then get the url of your application and try to connect with your favorite browser

```bash
echo https://$(oc get route todos -o jsonpath='{.spec.host}')
```
