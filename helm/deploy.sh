#!/bin/bash

IMAGE_TAG=$(../tools/image-tag)

echo ${IMAGE_TAG}

NS=meetup-demo-02
NS=$(tr "[A-Z]" "[a-z]" <<<$NS)
APP=vtodos

current_NS=$(oc get ns ${NS} -o jsonpath='{.metadata.name}' 2> /dev/null)

if [ "X"$current_NS = "X" ];
then
  oc new-project ${NS}
fi

oc project ${NS}

#
# add this to create damage
#
# oc adm policy add-scc-to-user privileged -z vtodos-vue-todos
#

echo "Now run: "
echo helm install --set image.tag=${IMAGE_TAG} -f vue-todos/values-overrides-01.yaml ${APP} vue-todos
# echo helm install --set image.tag=${IMAGE_TAG} ${APP} vue-todos
# helm install --set image.tag=${IMAGE_TAG} -f vue-todos/values-overrides-01.yaml ${APP} vue-todos
# echo helm template --set image.tag=${IMAGE_TAG} ${APP} vue-todos
