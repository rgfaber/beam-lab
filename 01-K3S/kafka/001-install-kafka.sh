#! /bin/bash
kubectl config use-context $BEAM_CONTEXT

helm repo add bitnami https://charts.bitnami.com/bitnami

helm install beam-release bitnami/kafka -f values.yaml

helm upgrade
