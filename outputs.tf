output "mongodb-password" {
  description = "MongoDb password"
  value       = random_password.password[0].result
  sensitive = true
}

output "mongodb-express-dns-name" {
  description = "MongoDb password"
  value       = "http://${kubernetes_service.mongoexpress-service.status[0].load_balancer[0].ingress[0].hostname}"
}

output "testdb-dns-name" {
  description = "Api rest port"
  value       = "http://${kubernetes_service.webapp-service.status[0].load_balancer[0].ingress[0].hostname}/api/info"
}

output "namespace" {
  description = "Namespace used"
  value       = kubernetes_namespace.mynamespace.metadata.0.name
}