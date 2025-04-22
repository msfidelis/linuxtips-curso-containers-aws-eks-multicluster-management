resource "helm_release" "argocd" {

  name             = "argocd"
  namespace        = "argocd"
  create_namespace = true

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"

  set {
    name  = "server.extraArgs[0]"
    value = "--insecure"
  }

  set {
    name = "server.service.type"
    value = "NodePort"
  }

  set {
    name  = "server.extensions.enabled"
    value = "true"
  }

  set {
    name  = "server.enable.proxy.extension"
    value = "true"
  }

  set {
    name  = "server.extensions.image.repository"
    value = "quay.io/argoprojlabs/argocd-extension-installer"
  }

  set {
    name  = "server.extensions.extensionList[0].name"
    value = "rollout-extension"
  }

  set {
    name  = "server.extensions.extensionList[0].env[0].name"
    value = "EXTENSION_URL"
  }

  set {
    name  = "server.extensions.extensionList[0].env[0].value"
    value = "https://github.com/argoproj-labs/rollout-extension/releases/download/v0.3.6/extension.tar"
  }

  depends_on = [
    aws_eks_cluster.main,
    helm_release.karpenter
  ]

}

resource "kubectl_manifest" "argocd_target_group" {
  yaml_body = <<YAML
apiVersion: elbv2.k8s.aws/v1beta1
kind: TargetGroupBinding
metadata:
  name: argocd-server
  namespace: argocd
spec:
  serviceRef:
    name: argocd-server
    port: 80
  targetGroupARN: ${aws_lb_target_group.argo.arn}
  targetType: instance
YAML
  depends_on = [
    helm_release.argocd
  ]
}