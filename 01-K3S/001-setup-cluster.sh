#! /bin/bash

## CLEANUP
kubectl config get-contexts

kubectl config delete-user $BEAM_CONTEXT

kubectl config delete-cluster $BEAM_CONTEXT

kubectl config delete-context $BEAM_CONTEXT

kubectl config use-context default

## MASTER 00

k3sup install \
  --ip $BEAM00_IP \
  --user $BEAM_USER \
  --merge \
  --local-path $HOME/.kube/config \
  --context $BEAM_CONTEXT \
  --k3s-extra-args "--no-extras"

kubectl config get-contexts

kubectl config use-context $BEAM_CONTEXT

kubectl config get-contexts

## AGENT 01

k3sup install \
  --ip $BEAM01_IP \
  --user $BEAM_USER \
  --k3s-extra-args "--no-extras"

k3sup join \
  --ip $BEAM01_IP \
  --server-ip $BEAM00_IP \
  --user $BEAM_USER \
  --server-user $BEAM_USER \
  --k3s-extra-args "--no-extras"
  

## AGENT 02

k3sup install \
  --ip $BEAM02_IP \
  --user $BEAM_USER \
  --k3s-extra-args "--no-extras"

k3sup join \
  --ip $BEAM02_IP \
  --server-ip $BEAM00_IP \
  --user $BEAM_USER \
  --server-user $BEAM_USER \
  --k3s-extra-args "--no-extras"


## AGENT 03

k3sup install \
  --ip $BEAM03_IP \
  --user $BEAM_USER \
  --k3s-extra-args "--no-extras"

k3sup join \
  --ip $BEAM03_IP \
  --server-ip $BEAM00_IP \
  --user $BEAM_USER \
  --server-user $BEAM_USER \
  --k3s-extra-args "--no-extras"


