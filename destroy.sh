#!/bin/bash


echo "Destroy do Control Plane"

cd control-plane/

rm -rf  .terraform

terraform init -backend-config=environment/prod/backend.tfvars

terraform destroy -var-file=environment/prod/terraform.tfvars --auto-approve

cd ../clusters


echo "Destroy do Cluster 02"

rm -rf  .terraform

terraform init -backend-config=environment/prod/cluster-02/backend.tfvars

terraform destroy -var-file=environment/prod/cluster-02/terraform.tfvars --auto-approve



echo "Destroy do Cluster 01"

rm -rf  .terraform

terraform init -backend-config=environment/prod/cluster-01/backend.tfvars

terraform destroy -var-file=environment/prod/cluster-01/terraform.tfvars --auto-approve


cd ../ingress


echo "Destroy do Ingress"

rm -rf  .terraform

terraform init -backend-config=environment/prod/backend.tfvars

terraform destroy -var-file=environment/prod/terraform.tfvars --auto-approve


