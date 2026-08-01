# eEDB-022-01

## Atividade 1 – Ingestão e ETL com ferramenta visual

Este repositório contém os arquivos necessários para a realização da Atividade 1. Siga o passo a passo abaixo para configurar o ambiente no Ubuntu, instalar o Terraform, inicializar a infraestrutura e configurar as conexões de banco de dados.

---

## Passo a Passo no Ubuntu

### 1. Clonar o Repositório
Abra o terminal e clone o projeto para a sua máquina:
```bash
git clone https://github.com/hrvfreitas/eEDB-022-01
```

### 2. Instalar Dependências e o Terraform
Atualize os pacotes do sistema e instale as ferramentas necessárias para adicionar o repositório da HashiCorp:
```bash
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl
```

Adicione a chave GPG oficial da HashiCorp:
```bash
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
```

Adicione o repositório oficial do Terraform às fontes do Ubuntu:
```bash
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com \$(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
```

Atualize a lista de pacotes e instale o Terraform:
```bash
sudo apt update && sudo apt install terraform
```

### 3. Inicializar o Terraform
Verifique se a instalação foi bem-sucedida:
```bash
terraform -v
```

Navegue até a pasta do projeto (onde estão os arquivos do Terraform) e inicialize o diretório de trabalho e valie e aplique a estrututa:
```bash
terraform init
terraform apply
```

---

## 🗄️ Acesso ao PostgreSQL Localmente

Para se conectar ao banco de dados utilizando ferramentas visuais como **DBeaver** ou **pgAdmin**, utilize as seguintes credenciais:

* **Host:** `localhost` (Mapeado na porta local `8081`)
* **Porta:** `5432`
* **Usuário:** `postgres`
* **Senha:** `admin`
* **Banco de Dados:** `atividade_1`

---

## Atenção à Conexão Dentro do Apache Hop

Ao criar a conexão de banco de dados (`Relational Database Connection`) dentro da interface do **Apache Hop**, atente-se às seguintes configurações de rede:

* **Host no Hop:** Utilize `postgres_db` (nome do serviço/container na rede interna).
* **Porta no Hop:** `5432`.
* **Nota sobre as portas:** A porta externa foi configurada como `8081` porque a porta padrão `8080` já estava ocupada no sistema. 

> **Importante:** Caso precise alterar a porta `8081` para outra de sua preferência, faça essa modificação diretamente no arquivo **`main.tf`** antes de subir o ambiente.

---

## Preparação dos Dados

1. Certifique-se de baixar os arquivos de dados da atividade.
2. Descompacte os arquivos.
3. Mova o conteúdo extraído diretamente para a pasta chamada **`dados`** na raiz deste projeto.

