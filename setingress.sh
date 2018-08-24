#!/bin/bash
source setenv $1
sed 's/HOSTNAME/'"$CADD"'/' app-ingress.yaml > tempingress.yaml
kubectl create -f tempingress.yaml


