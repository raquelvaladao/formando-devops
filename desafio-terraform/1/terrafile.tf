# provider "kind" {}
module "kind_child_module" {
  source = "./mymod"
  cluster_name = var.cluster_name
  kubernetes_version = var.kubernetes_version
  
  cluster_config_path = "~/.kube/config"
}

output "api_endpoint" {
  value = module.kind_child_module.api_endpoint
}

output "kubeconfig" {
  value = module.kind_child_module.kubeconfig
}

output "client_certificate" {
  value = module.kind_child_module.client_certificate
}

output "client_key" {
  value = module.kind_child_module.client_key
}

output "cluster_ca_certificate" {
  value = module.kind_child_module.cluster_ca_certificate
}