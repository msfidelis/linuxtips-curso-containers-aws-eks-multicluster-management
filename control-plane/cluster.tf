data "aws_eks_cluster" "members" {
  count = length(var.clusters_configs)
  name  = lookup(var.clusters_configs[count.index], "cluster_name")
}

resource "kubectl_manifest" "argo_clusters" {

  count = length(var.clusters_configs)

  yaml_body = <<YAML
apiVersion: v1
kind: Secret
metadata:
  name: ${data.aws_eks_cluster.members[count.index].id}
  namespace: argocd
  labels:
    argocd.argoproj.io/secret-type: cluster
type: Opaque
stringData:
  name: ${data.aws_eks_cluster.members[count.index].id}
  config: |
    {
      "awsAuthConfig": {
        "clusterName": "${data.aws_eks_cluster.members[count.index].id}",
        "roleARN": "${aws_iam_role.argo_deployer.arn}"
      },
      "tlsClientConfig": {
        "insecure": false,
        "caData": "${data.aws_eks_cluster.members[count.index].certificate_authority.0.data}"
      }
    }
  server: "${data.aws_eks_cluster.members[count.index].endpoint}"
YAML

  depends_on = [
    helm_release.argocd
  ]

}
