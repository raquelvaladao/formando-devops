terraform {
  required_providers {
    kind = {
      source = "tehcyx/kind"
      version = "0.0.15"
    }
    
    gitlab = {
      source = "gitlabhq/gitlab"
      version = "3.18.0"
    }
  }
}

provider "kind" {
  # Configuration options
}


provider "gitlab" {
  token = var.gitlab_token
}
