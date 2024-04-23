variable "namespace" {
    type = string
    default = "ingress"
}

variable "node_selector" {
  type        = string
  default     = "general"
  description = "Node labels for K8S Pod assignment of the Deployments/StatefulSets/DaemonSets"
}