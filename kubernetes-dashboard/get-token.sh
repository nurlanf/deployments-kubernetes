#!/bin/bash
kubectl describe secret $(kubectl get secret -n kube-system|grep token|grep dashb|awk '{print $1}') -n kube-system
