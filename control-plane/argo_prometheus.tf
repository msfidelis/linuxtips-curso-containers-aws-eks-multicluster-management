resource "kubectl_manifest" "prometheus" {

  yaml_body = <<YAML
apiVersion: argoproj.io/v1alpha1
kind: ApplicationSet
metadata:
  name: prometheus
  namespace: argocd
spec:
  generators:
    - list:
        elements:
          - cluster: linuxtips-cluster-01
            shard: "01"
          - cluster: linuxtips-cluster-02
            shard: "02"
  template:
    metadata:
      name: prometheus-{{shard}}
    spec:
      project: "system"
      source:
        repoURL: 'https://prometheus-community.github.io/helm-charts'
        chart: prometheus
        targetRevision: 27.11.0
        helm:
          releaseName: prometheus
          valuesObject:
            server:
              global:
                scrape_interval: 15s
                evaluation_interval: 15s
                external_labels:
                    cluster: "{{ cluster }}"
              persistentVolume:
                enabled: false
              remoteWrite:
                - url: "http://mimir.linuxtips-observability.local:80/api/v1/push"
                  queue_config:
                    max_samples_per_send: 1000
                    max_shards: 20
                    capacity: 5000
                
              extraScrapeConfigs: |
                - job_name: "envoy-stats-monitor"
                  honor_labels: true
                  scrape_interval: 15s
                  kubernetes_sd_configs:
                    - role: pod
                  relabel_configs:
                    - action: drop
                      source_labels: [__meta_kubernetes_pod_label_istio_prometheus_ignore]
                      regex: .+
                    - action: keep
                      source_labels: [__meta_kubernetes_pod_container_name]
                      regex: "istio-proxy"
                    - action: keep
                      source_labels: [__meta_kubernetes_pod_annotationpresent_prometheus_io_scrape]
                      regex: "true"
                    - action: replace
                      source_labels:
                        - __meta_kubernetes_pod_annotation_prometheus_io_port
                        - __meta_kubernetes_pod_ip
                      regex: (\d+);(([A-Fa-f0-9]{1,4}::?){1,7}[A-Fa-f0-9]{1,4})
                      replacement: '[$2]:$1'
                      target_label: __address__
                    - action: replace
                      source_labels:
                        - __meta_kubernetes_pod_annotation_prometheus_io_port
                        - __meta_kubernetes_pod_ip
                      regex: (\d+);((([0-9]+?)(\.|$)){4})
                      replacement: $2:$1
                      target_label: __address__
                    - action: labeldrop
                      regex: "__meta_kubernetes_pod_label_(.+)"
                    - action: replace
                      source_labels: [__meta_kubernetes_namespace]
                      target_label: namespace
                    - action: replace
                      source_labels: [__meta_kubernetes_pod_name]
                      target_label: pod_name
                  metrics_path: /stats/prometheus
            prometheus-node-exporter:
              enabled: true
            alertmanager:
              enabled: false
      destination:
        name: '{{ cluster }}'
        namespace: prometheus
      syncPolicy:
        syncOptions:
          - CreateNamespace=true
        automated: {}
YAML

  depends_on = [
    helm_release.argocd
  ]
}