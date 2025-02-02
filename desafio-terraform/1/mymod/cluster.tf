terraform {
  required_providers {
    kind = {
      source = "kyma-incubator/kind"
      version = "0.0.11"
    }
  }
}

resource "kind_cluster" "default" {
    name           = "test-cluster"
    wait_for_ready = true

  kind_config {
      kind        = "Cluster"
      api_version = "kind.x-k8s.io/v1alpha4"

      node {
          role = "control-plane"

          kubeadm_config_patches = [
              "kind: InitConfiguration\nnodeRegistration:\n  kubeletExtraArgs:\n    node-labels: \"ingress-ready=true\"\n"
          ]

          extra_port_mappings {
              container_port = 80
              host_port      = 80
          }
      }

      node {
          role = "infra"
      }
      
      node {
          role = "app"
      }
  }
}