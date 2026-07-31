terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.0"
    }
  }
}

provider "docker" {}

# Criando de uma rede isolada para os containers se comunicarem
resource "docker_network" "etl_network" {
  name = "etl_network"
}

#Imagem e Container do PostgreSQL
resource "docker_image" "postgres" {
  name         = "postgres:15-alpine"
  keep_locally = false
}

resource "docker_container" "postgres" {
  name  = "postgres_db"
  image = docker_image.postgres.image_id
  
  networks_advanced {
    name = docker_network.etl_network.name
  }

  env = [
    "POSTGRES_USER=postgres",
    "POSTGRES_PASSWORD=admin",
    "POSTGRES_DB=atividade_1"
  ]

  ports {
    internal = 5432
    external = 5432
  }
}

#Imagem e Container do Apache Hop (Versão Web)
resource "docker_image" "hop" {
  name         = "apache/hop-web:latest"
  keep_locally = false
}
resource "docker_container" "hop" {
  name  = "apache_hop"
  image = docker_image.hop.image_id
  networks_advanced {
    name = docker_network.etl_network.name
  }
  ports {
    internal = 8080
    external = 8081
  }
  volumes {
    host_path      = "${path.cwd}/dados"
    container_path = "/dados"
  }
}
