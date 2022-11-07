resource "kind_cluster" "default" {
    name = "test-cluster"
    node_image = "kindest/node:v1.25.3"
    kind_config  {
        kind = "Cluster"
        api_version = "kind.x-k8s.io/v1alpha4"
        node {
            role = "control-plane"
        }
        node {
            role =  "worker"
        }
    }
}


resource "gitlab_project" "sample_project" {
  name = "desafio-repo"
}