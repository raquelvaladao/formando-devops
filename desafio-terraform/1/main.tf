terraform {
  required_providers {
    kind = {
      source = "kyma-incubator/kind"
      version = "0.0.11"
    }
  }
}
variable "cluster_name" {
  type = string
  description = "Nome dado ao cluster"
  default = "NomeDefault"
}


variable "kubernetes_version" {
  default = "v1.16.1"
  type = string
  description = "Versão do Kubernetes"
}
