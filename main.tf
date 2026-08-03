# Define configurações necessárias para execução do projeto.
terraform {

  # Especifica os provedores (providers) que serão utilizados.
  required_providers {

    # Define o provider Docker.
    docker = {

      # Indica a origem oficial do provider no Terraform Registry.
      source = "kreuzwerker/docker"

      # Restringe a versão utilizada para a série 3.x.
      # O operador "~>" permite atualizações de correção,
      # mas impede mudanças incompatíveis de versão.
      version = "~> 3.0.0"
    }
  }
}

# Inicializa o provider Docker utilizando o daemon Docker
# instalado na máquina local.
provider "docker" {}

# -------------------------------------------------------------------
# Criação da rede Docker
# -------------------------------------------------------------------

# Cria uma rede virtual exclusiva para comunicação entre os containers.
# Dessa forma PostgreSQL e Apache Hop conseguem trocar dados utilizando
# seus nomes internos sem depender da rede padrão do Docker.
resource "docker_network" "etl_network" {

  # Nome atribuído à rede.
  name = "etl_network"
}

# -------------------------------------------------------------------
# Download da imagem do PostgreSQL
# -------------------------------------------------------------------

# Faz o download da imagem postgres:15-alpine caso ela ainda
# não exista localmente.
resource "docker_image" "postgres" {

  # Define qual imagem será utilizada.
  name = "postgres:15-alpine"

  # Remove a imagem local caso ela deixe de ser utilizada
  # após a destruição da infraestrutura.
  keep_locally = false
}

# -------------------------------------------------------------------
# Criação do container PostgreSQL
# -------------------------------------------------------------------

resource "docker_container" "postgres" {

  # Nome do container.
  name = "postgres_db"

  # Utiliza a imagem baixada anteriormente.
  image = docker_image.postgres.image_id

  # Conecta o container à rede criada anteriormente.
  networks_advanced {

    # Nome da rede Docker.
    name = docker_network.etl_network.name
  }

  # Define variáveis de ambiente utilizadas
  # durante a inicialização do PostgreSQL.
  env = [

    # Usuário administrador do banco.
    "POSTGRES_USER=postgres",

    # Senha do usuário administrador.
    "POSTGRES_PASSWORD=admin",

    # Banco de dados criado automaticamente.
    "POSTGRES_DB=atividade_1"
  ]

  # Mapeamento de portas.
  ports {

    # Porta utilizada internamente pelo PostgreSQL.
    internal = 5432

    # Porta disponibilizada para acesso no computador hospedeiro.
    external = 5432
  }
}

# -------------------------------------------------------------------
# Download da imagem Apache Hop Web
# -------------------------------------------------------------------

resource "docker_image" "hop" {

  # Utiliza a versão mais recente disponível.
  name = "apache/hop-web:latest"

  # Remove a imagem caso ela não seja mais necessária.
  keep_locally = false
}

# -------------------------------------------------------------------
# Criação do container Apache Hop
# -------------------------------------------------------------------

resource "docker_container" "hop" {

  # Nome do container.
  name = "apache_hop"

  # Utiliza a imagem baixada anteriormente.
  image = docker_image.hop.image_id

  # Conecta o Apache Hop à mesma rede do PostgreSQL,
  # permitindo comunicação direta entre os dois containers.
  networks_advanced {

    # Nome da rede criada anteriormente.
    name = docker_network.etl_network.name
  }

  # Mapeamento das portas do serviço web.
  ports {

    # Porta utilizada pelo Apache Hop dentro do container.
    internal = 8080

    # Porta disponibilizada ao usuário no computador local.
    external = 8081
  }

  # Montagem de volume entre o computador e o container.
  volumes {

    # Diretório existente na máquina local.
    host_path = "${path.cwd}/dados"

    # Diretório correspondente dentro do container.
    container_path = "/dados"
  }
}
