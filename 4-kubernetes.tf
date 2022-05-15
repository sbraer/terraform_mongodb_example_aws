provider "kubernetes" {
  host                   = aws_eks_cluster.demo.endpoint
  token                  = data.aws_eks_cluster_auth.demo.token
  cluster_ca_certificate = base64decode(aws_eks_cluster.demo.certificate_authority.0.data)
}

provider "helm" {
    kubernetes {
      host                   = aws_eks_cluster.demo.endpoint
      token                  = data.aws_eks_cluster_auth.demo.token
      cluster_ca_certificate = base64decode(aws_eks_cluster.demo.certificate_authority.0.data)
    }
}

resource "random_password" "password" { 
  count = 1 
  length = 32
  special = false
}

resource "kubernetes_namespace" "mynamespace" { 
  metadata { 
    name = var.namespace_name
  } 
}