resource "kubectl_manifest" "argo_system" {

  yaml_body = <<YAML
apiVersion: argoproj.io/v1alpha1
kind: AppProject
metadata:
  name: system
  namespace: argocd
spec:
  clusterResourceWhitelist:
  - group: '*'
    kind: '*'
  destinations:
  - namespace: '*'
    server: '*'
  sourceRepos:
  - '*'
YAML

  depends_on = [
    helm_release.argocd
  ]

}