#!/bin/bash

oc delete route todos
oc delete service todos
oc delete deployment todos
oc delete pods testcurl
