resource "helm_release" "argocd" {
  name = "argocd"

  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true
  version          = "3.35.4"

  values = [file("${path.module}/values.yaml")]
}

resource "kubernetes_ingress_v1" "argo_cd_ingress" {
  depends_on = [helm_release.argocd]

  metadata {
    name      = "argocd"
    namespace = var.namespace
  }

  spec {
    ingress_class_name = "nginx"
    rule {
      http {
        path {
          path_type = "Prefix"
          path      = "/"
          backend {
            service {
              name = "argocd-server"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}

resource "kubectl_manifest" "argosecret" {
  yaml_body = <<YAML
apiVersion: v1
kind: Secret
metadata:
  name: githubsecret
  namespace: ${var.namespace}
  labels:
    argocd.argoproj.io/secret-type: repository
stringData:
  type: git
  url: git@github.com:iriscafe/devops-test.git
  sshPrivateKey: file("${path.module}/ssh_key.txt")
  
YAML  
}

resource "kubectl_manifest" "app" {
  yaml_body = <<YAML
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: apigo
  namespace: argocd
  finalizers:
    - resources-finalizer.argocd.argoproj.io
spec:
  destination:
    namespace: application
    server: "https://kubernetes.default.svc"
  source:
    path: "infra/helm/my-python-app"
    repoURL: "git@github.com:iriscafe/devops-test.git"
    targetRevision: "HEAD"
    helm:
      valueFiles:
        - "values.yaml"
  project: "default"
  syncPolicy:
    managedNamespaceMetadata:
      labels:
        managed: "argo-cd"
    syncOptions:
      - CreateNamespace=true
  retry:
    limit: 5
    backoff:
      duration: 5s
      maxDuration: 3m0s
      factor: 2
YAML 
}

# # resource "kubectl_manifest" "grafana" {
# #   yaml_body = <<YAML
# # apiVersion: argoproj.io/v1alpha1
# # kind: Application
# # metadata:
# #   name: grafana
# #   namespace: argocd
# #   finalizers:
# #     - resources-finalizer.argocd.argoproj.io
# # spec:
# #   destination:
# #     namespace: monitoring
# #     server: "https://kubernetes.default.svc"
# #   source:
# #     path: "infra/helm/grafana"
# #     repoURL: "git@github.com:iriscafe/devops-test.git"
# #     targetRevision: "HEAD"
# #     helm:
# #       valueFiles:
# #         - "values.yaml"
# #   project: "default"
# #   syncPolicy:
# #     managedNamespaceMetadata:
# #       labels:
# #         managed: "argo-cd"
# #     automated:
# #       prune: true
# #       selfHeal: true
# #     syncOptions:
# #       - CreateNamespace=true
# #       - PruneLast=true
# #   retry:
# #     limit: 5
# #     backoff:
# #       duration: 5s
# #       maxDuration: 3m0s
# #       factor: 2
# # YAML 
# # }

# # resource "kubectl_manifest" "prometheus" {
# #   yaml_body = <<YAML
# # apiVersion: argoproj.io/v1alpha1
# # kind: Application
# # metadata:
# #   name: prometheus
# #   namespace: argocd
# #   finalizers:
# #     - resources-finalizer.argocd.argoproj.io
# # spec:
# #   destination:
# #     namespace: monitoring
# #     server: "https://kubernetes.default.svc"
# #   source:
# #     path: "infra/helm/prometheus"
# #     repoURL: "git@github.com:iriscafe/devops-test.git"
# #     targetRevision: "HEAD"
# #     helm:
# #       valueFiles:
# #         - "values.yaml"
# #   project: "default"
# #   syncPolicy:
# #     managedNamespaceMetadata:
# #       labels:
# #         managed: "argo-cd"
# #     automated:
# #       prune: true
# #       selfHeal: true
# #     syncOptions:
# #       - CreateNamespace=true
# #       - PruneLast=true
# #   retry:
# #     limit: 5
# #     backoff:
# #       duration: 5s
# #       maxDuration: 3m0s
# #       factor: 2
# # YAML 
# # }

# # resource "kubectl_manifest" "kube_metrics" {
# #   yaml_body = <<YAML
# # apiVersion: argoproj.io/v1alpha1
# # kind: Application
# # metadata:
# #   name: kube-metrics
# #   namespace: argocd
# #   finalizers:
# #     - resources-finalizer.argocd.argoproj.io
# # spec:
# #   destination:
# #     namespace: monitoring
# #     server: "https://kubernetes.default.svc"
# #   source:
# #     path: "infra/helm/kube-metrics"
# #     repoURL: "git@github.com:iriscafe/devops-test.git"
# #     targetRevision: "HEAD"
# #     helm:
# #       valueFiles:
# #         - "values.yaml"
# #   project: "default"
# #   syncPolicy:
# #     managedNamespaceMetadata:
# #       labels:
# #         managed: "argo-cd"
# #     automated:
# #       prune: true
# #       selfHeal: true
# #     syncOptions:
# #       - CreateNamespace=true
# #       - PruneLast=true
# #   retry:
# #     limit: 5
# #     backoff:
# #       duration: 5s
# #       maxDuration: 3m0s
# #       factor: 2
# # YAML 
# # }

