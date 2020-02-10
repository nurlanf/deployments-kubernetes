#!/bin/bash

printf $(kubectl get secret --namespace default orientdb-incubator-secret -o jsonpath="{.data.root-password}" | base64 --decode);echo

CONNECT remote:localhost root 9KIfpSW3IX
list databases