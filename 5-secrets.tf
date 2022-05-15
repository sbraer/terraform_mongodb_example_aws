resource "kubernetes_secret" "credentials1" {
  metadata {
    name = "credentials1"
    namespace = kubernetes_namespace.mynamespace.metadata.0.name
  }

  data = {
    "username" = var.mongodb_username
    "mongodb-password" = random_password.password.0.result
    "mongodb-root-password" = random_password.password.0.result
    "mongodb-replica-set-key" = "ba436283462dcaada36367"
  }

  type = "Opaque"
  depends_on = [random_password.password, aws_eks_cluster.demo]
}