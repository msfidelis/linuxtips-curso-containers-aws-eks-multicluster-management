variable "project_name" {
}

variable "region" {
    default = "us-east-1"
}

variable "k8s_version" {
    default = "1.32"
}

variable "ssm_vpc" {}

variable "ssm_subnets" {
  type = list(string)
}


variable "node_group_temp_desired" {
  type = number
  default = 2
}

variable "karpenter_capacity" {
  type = list(object({
    name               = string
    workload           = string
    ami_family         = string
    ami_ssm            = string
    instance_family    = list(string)
    instance_sizes     = list(string)
    capacity_type      = list(string)
    availability_zones = list(string)
  }))
}

// Istio

variable "istio_version" {
  type        = string
  description = "Versão do Istio"
  default     = "1.25.0"
}

variable "istio_min_replicas" {
  type        = string
  description = "value of min replicas"
  default     = "3"
}

variable "istio_cpu_threshold" {
  type        = string
  description = "value of cpu threshold"
  default     = "60"
}

variable "istio_ssm_target_group" {
  type = string
}

variable "argocd_deployer_role" {
  default = "arn:aws:iam::181560427716:role/linuxtips-control-plane-argocd-deployer"
}