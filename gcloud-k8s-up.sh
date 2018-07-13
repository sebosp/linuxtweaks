#!/bin/bash

echo "Yes"|gcloud container clusters resize cluster-1 --size=2 --region=us-central1-a --node-pool=pre-2cpu-8mem
echo "Yes"|gcloud container clusters resize cluster-1 --size=1 --region=us-central1-a --node-pool=pre-1cpu-4mem
