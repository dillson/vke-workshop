#!/bin/bash
set -x
kubectl create secret generic mysql-pass --from-literal=password=$1
kubectl create -f mysql-configmap.yaml
kubectl create -f fitcycle-percona-total.yaml
kubectl create -f fitcycle-server-total.yaml
./setingress.sh $2
