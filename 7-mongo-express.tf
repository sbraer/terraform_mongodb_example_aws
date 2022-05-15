resource "kubernetes_deployment" "showdb" { 
  metadata { 
    name = "showdb"
    namespace = kubernetes_namespace.mynamespace.metadata.0.name
  } 

  spec { 
    replicas = 1 
    selector { 
      match_labels = { 
        app = "showdb" 
      } 
    }
    template { 
      metadata { 
        labels = { 
          app = "showdb" 
        } 
        annotations = { 
          custom_test = "Ecco il mio testo casuale"
        } 
      } 
      spec {
        affinity {
          node_affinity {
            required_during_scheduling_ignored_during_execution {
              node_selector_term {
                match_expressions {
                  key = "role"
                  operator = "In"
                  values = ["webapp"]
                }
              }
            }
          }
        }
        volume {
          name = "secretvolume"
          secret {
            secret_name = "credentials1"
          }
        } 
        container { 
          image = "mkucuk20/mongo-express" 
          name  = "showdb" 
          env { 
            name= "ME_CONFIG_MONGODB_ADMINUSERNAME_FILE" 
            value="/etc/secretvolume/username" 
          } 
          env { 
            name= "ME_CONFIG_MONGODB_ADMINPASSWORD_FILE" 
            value = "/etc/secretvolume/mongodb-root-password"
          } 
          env { 
            name= "ME_CONFIG_MONGODB_SERVER" 
            value="mongodb-easy-0.mongodb-easy-headless,mongodb-easy-1.mongodb-easy-headless,mongodb-easy-2.mongodb-easy-headless" 
          }
          volume_mount {
            name = "secretvolume"
            read_only = true
            mount_path = "/etc/secretvolume"
          }
        } 
      } 
    } 
  } 
  depends_on = [helm_release.mongodb1, kubernetes_secret.credentials1]
} 

resource "kubernetes_service" "mongoexpress-service" {
  metadata {
    name = "showdb-service"
    annotations = { 
        "service.beta.kubernetes.io/aws-load-balancer-type" =  "nlb" 
    } 
    namespace = kubernetes_namespace.mynamespace.metadata.0.name
 }
  spec {
    selector = {
      app = "showdb"
    }
    port {
      port        = 80
      target_port = 8081
    }

    type = "LoadBalancer"
  }
  depends_on = [kubernetes_deployment.showdb]
}