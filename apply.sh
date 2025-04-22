#!/bin/bash



cd ingress/

echo "Setup do Ingress"

rm -rf  .terraform

terraform init -backend-config=environment/prod/backend.tfvars

terraform apply -var-file=environment/prod/terraform.tfvars --auto-approve



cd ../clusters

echo "Setup do Cluster 01"

rm -rf  .terraform

terraform init -backend-config=environment/prod/cluster-01/backend.tfvars

terraform apply -var-file=environment/prod/cluster-01/terraform.tfvars --auto-approve



echo "Setup do Cluster 02"

rm -rf  .terraform

terraform init -backend-config=environment/prod/cluster-02/backend.tfvars

terraform apply -var-file=environment/prod/cluster-02/terraform.tfvars --auto-approve


cd ../control-plane

rm -rf  .terraform

terraform init -backend-config=environment/prod/backend.tfvars

terraform apply -var-file=environment/prod/terraform.tfvars --auto-approve