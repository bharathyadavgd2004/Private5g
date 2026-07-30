#!/bin/bash

kubectl delete -f ueransim/ --ignore-not-found
kubectl delete -f webui/ --ignore-not-found
kubectl delete -f upf/ --ignore-not-found
kubectl delete -f smf/ --ignore-not-found
kubectl delete -f bsf/ --ignore-not-found
kubectl delete -f pcf/ --ignore-not-found
kubectl delete -f nssf/ --ignore-not-found
kubectl delete -f udr/ --ignore-not-found
kubectl delete -f udm/ --ignore-not-found
kubectl delete -f ausf/ --ignore-not-found
kubectl delete -f amf/ --ignore-not-found
kubectl delete -f scp/ --ignore-not-found
kubectl delete -f nrf/ --ignore-not-found
kubectl delete -f mongodb/ --ignore-not-found
kubectl delete -f namespace.yaml --ignore-not-found

echo "Private 5G resources removed."
