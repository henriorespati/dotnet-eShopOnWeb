#! /bin/bash

export NAMESPACE=eshoponweb
export PASSWORD=<<PASSWORD>>
oc create secret generic mssql --from-literal=SA_PASSWORD="$PASSWORD" -n $NAMESPACE
oc create serviceaccount sqlserver-sa -n $NAMESPACE
oc adm policy add-scc-to-user anyuid -z sqlserver-sa -n $NAMESPACE
oc create -f pvc.yaml
oc create -f Deployment.yaml
oc expose deployment/sqlserver -n $NAMESPACE
