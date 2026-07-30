#!/bin/bash

set -e

kubectl apply -f namespace.yaml

kubectl apply -f mongodb/
kubectl apply -f nrf/
kubectl apply -f scp/
kubectl apply -f amf/
kubectl apply -f ausf/
kubectl apply -f udm/
kubectl apply -f udr/
kubectl apply -f nssf/
kubectl apply -f pcf/
kubectl apply -f bsf/
kubectl apply -f smf/
kubectl apply -f upf/
kubectl apply -f webui/
kubectl apply -f ueransim/

echo "Private 5G deployment completed."
