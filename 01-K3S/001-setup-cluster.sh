#! /bin/bash

# Unfortunately, the setup without Traefik and ServiceLB doesnt seem to work as documented,
# Since the aim of this cluster is mainly to test Kafka as a potential eventstore,
# we'll not make our life too difficult and just go with the default...


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
  --context $BEAM_CONTEXT 

kubectl config get-contexts

kubectl config use-context $BEAM_CONTEXT

kubectl config get-contexts



## AGENT 01

## Hmmm...this setup with --no-extras doesnt seem to work either
## Reference: https://github.com/alexellis/k3sup/issues/324
## AHA!! "k3sup install --help" did help :)


k3sup install \
  --ip $BEAM01_IP \
  --user $BEAM_USER 


k3sup join \
  --ip $BEAM01_IP \
  --server-ip $BEAM00_IP \
  --user $BEAM_USER \
  --server-user $BEAM_USER 
  

## AGENT 02

k3sup install \
  --ip $BEAM02_IP \
  --user $BEAM_USER 

k3sup join \
  --ip $BEAM02_IP \
  --server-ip $BEAM00_IP \
  --user $BEAM_USER \
  --server-user $BEAM_USER 

## AGENT 03

k3sup install \
  --ip $BEAM03_IP \
  --user $BEAM_USER 

k3sup join \
  --ip $BEAM03_IP \
  --server-ip $BEAM00_IP \
  --user $BEAM_USER \
  --server-user $BEAM_USER 

## Taint the Master node 
# Reference: https://github.com/k3s-io/k3s/issues/1401
kubectl taint node beam00.lab k3s-controlplane=true:NoSchedule
