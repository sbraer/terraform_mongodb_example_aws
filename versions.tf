terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.0.0"
      }

    kubernetes = { 
      source  = "hashicorp/kubernetes" 
      version = ">= 2.0.0" 
    } 

    random = { 
      source = "hashicorp/random" 
      version = "3.0.1" 
    }

    aws = {
      source = "hashicorp/aws"
      version = ">= 4.0.0"
    }
  }
}