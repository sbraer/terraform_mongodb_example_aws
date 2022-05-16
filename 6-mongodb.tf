resource "helm_release" "mongodb1" {
  name  = "mongodb-easy"

    repository = "https://charts.bitnami.com/bitnami"
    chart      = "mongodb"
    version    = "12.0.0"

  set {
    name = "global.namespaceOverride"
    value = kubernetes_namespace.mynamespace.metadata.0.name
  }

  set {
    name  = "architecture"
    value = "replicaset"
  }

  set {
    name  = "auth.rootUser"
    value = var.mongodb_username
  }

  set {
    name = "auth.existingSecret"
    value = "credentials1"
  }

  set {
    name = "auth.existingSecret"
    value = "credentials1"
  }

  set {
    name = "image.tag"
    value = "4.4.13-debian-10-r51"
  }

  set {
    name = "persistence.enabled"
    value = false
  }

  set {
    name = "arbiter.enabled"
    value = false
  }

  set {
    name = "replicaCount"
    value = 3
  }

  set {
    name = "nodeAffinityPreset.type"
    value = "hard"
  }
  
  set {
    name = "nodeAffinityPreset.key"
    value = "role"
  }

  set {
    name = "nodeAffinityPreset.values[0]"
    value = "mongodb"
  }

  depends_on = [
    random_password.password,
    kubernetes_secret.credentials1,
    aws_eks_node_group.mongodb-nodes,
    aws_eks_node_group.webapp-nodes
  ]
}