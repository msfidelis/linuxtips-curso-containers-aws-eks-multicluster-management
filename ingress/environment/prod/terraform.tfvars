project_name = "linuxtips-ingress"


ssm_vpc = "/linuxtips-vpc/vpc/id"

ssm_subnets = [
  "/linuxtips-vpc/subnets/public/us-east-1a/linuxtips-public-1a",
  "/linuxtips-vpc/subnets/public/us-east-1b/linuxtips-public-1b",
  "/linuxtips-vpc/subnets/public/us-east-1c/linuxtips-public-1c",
]

routing_weight = {
  cluster_01 = 0
  cluster_02 = 100
}

route53_hosted_zone = "Z102505525LUE9SZ7HWTY"
dns_name = "*.msfidelis.com.br"