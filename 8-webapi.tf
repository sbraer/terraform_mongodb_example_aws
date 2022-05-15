resource "kubernetes_deployment" "testdb" { 
  metadata { 
    name = "testdb"
    namespace = kubernetes_namespace.mynamespace.metadata.0.name
  } 

  spec { 
    replicas = 1 
    selector { 
      match_labels = { 
        app = "testdb" 
      } 
    } 
    template { 
      metadata { 
        labels = { 
          app = "testdb" 
        } 
        annotations = { 
          custom_test = "Ecco il mio testo casuale per il secondo deployment"
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
          image = "sbraer/mongodbtest:v1" 
          name  = "testdb"
          port {
            protocol = "TCP"
            container_port = 5000
          } 
          env { 
            name= "MONGODB_SERVER_USERNAME_FILE" 
            value = "/etc/secretvolume/username"
          } 
          env { 
            name= "MONGODB_SERVER_PASSWORD_FILE" 
            value = "/etc/secretvolume/mongodb-root-password"
          } 
          env { 
            name= "MONGODB_SERVER_LIST" 
            value="mongodb-easy-0.mongodb-easy-headless,mongodb-easy-1.mongodb-easy-headless,mongodb-easy-2.mongodb-easy-headless" 
          } 
          env { 
            name= "MONGODB_REPLICA_SET" 
            value="rs0" 
          } 
          env { 
            name= "MONGODB_DATABASE_NAME" 
            value="MyDatabase" 
          } 
          env { 
            name= "MONGODB_BOOKS_COLLECTION_NAME" 
            value="MyTest" 
          } 
          env { 
            name= "TMPDIR" 
            value="/tmp" 
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

resource "kubernetes_service" "webapp-service" {
  metadata {
    name = "testdb-service"
    annotations = { 
        "service.beta.kubernetes.io/aws-load-balancer-type" =  "nlb" 
    } 
    namespace = kubernetes_namespace.mynamespace.metadata.0.name
  }
  spec {
    selector = {
      app = "testdb"
    }
    port {
      port        = 80
      target_port = 5000
    }

    type = "LoadBalancer"
  }
  depends_on = [kubernetes_deployment.testdb]
}