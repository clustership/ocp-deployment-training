#!/bin/bash

IMAGE_TAG=$(../tools/image-tag)

NS=meetup-demo-02
NS=$(tr "[A-Z]" "[a-z]" <<<$NS)

oc project ${NS}

helm uninstall vtodos
oc delete project ${NS}
