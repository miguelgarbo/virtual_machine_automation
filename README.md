# Automação de Infraestrutura

Infraestrutura automatizada para o sistema de **aluguel de carros Miguel Aluguel**, utilizando **Vagrant, VirtualBox, Ansible, Docker, AWS ECR e HAProxy**.

**Vagrant**: é responsável por criar as máquinas virtuais localmente
**Ansible**: configura automaticamente os serviços e realiza o deploy da aplicação dentro das VMs.

## 🏗️ Arquitetura

O projeto cria duas máquinas virtuais:

Uma configurada com haproxy e outra para a aplicação Miguel Aluguel com (front back e banco)

Links dos repositórios do projeto:

Front-end com React/Vite: https://github.com/miguelgarbo/miguel_aluguel_front_end

Back-end com Java SpringBoot: https://github.com/Xua1zin/MiguelAluguel-Back

## 📁 Estrutura

```text
miguel_aluguel_infra/
│
├── Vagrantfile
│   # Arquivo responsável pela criação e configuração das duas VMs
│   # através do Vagrant e VirtualBox.
│
├── .env.example
│   # Modelo das variáveis de ambiente necessárias para executar o projeto.
│   # Deve ser utilizado como base para criar o arquivo .env.
│
├── scripts/
│   └── run-ansible.sh
│       # Carrega as variáveis presentes no .env para o ambiente
│       # e executa o playbook do Ansible.
│       # Mantém credenciais e informações sensíveis fora do código.
│
└── ansible/
    │
    ├── playbook.yml
    │   # Arquivo principal responsável por orquestrar a configuração
    │   # das máquinas e definir a **ordem** de execução das roles.
    │
    ├── inventory/
    │   └── hosts.ini
    │       # Define as máquinas gerenciadas pelo Ansible,
    │       # seus IPs e informações utilizadas para conexão SSH.
    │
    ├── group_vars/
    │   └── all.yml
    │       # Define as variáveis utilizadas pelas roles.
    │       # Os valores são obtidos das variáveis de ambiente
    │       # carregadas pelo script run-ansible.sh.
    │
    ├── roles/
    │   │
    │   ├── app/
    │   │   └── tasks/
    │   │       └── main.yml
    │   │           # Cria o diretório da aplicação, utiliza o template
    │   │           # do Docker Compose e inicia os containers da aplicação.
    │   │
    │   ├── aws_auth/
    │   │   └── tasks/
    │   │       └── main.yml
    │   │           # Instala a AWS CLI, configura as credenciais
    │   │           # e autentica o Docker no AWS ECR para permitir
    │   │           # o download das imagens do Frontend e Backend.
    │   │
    │   ├── docker/
    │   │   └── tasks/
    │   │       └── main.yml
    │   │           # Instala e configura o Docker Engine
    │   │
    │   └── haproxy/
    │       ├── tasks/
    │       │   └── main.yml
    │       │       # Instala e configura o serviço HAProxy.
    │       │
    │       └── handlers/
    │           └── main.yml
    │               # Define ações executadas quando uma configuração
    │               # do HAProxy é alterada, como reiniciar o serviço.
    │
    └── templates/
        ├── docker-compose.yml.j2
        │   # Template Jinja2 utilizado pela role app para gerar
        │   # o Docker Compose com as variáveis do ambiente.
        │
        └── haproxy.cfg.j2
            # Template Jinja2 utilizado pela role haproxy para gerar
            # a configuração do HAProxy dentro da VM.

## ⚙️ Requisitos

* WSL 2 + Ubuntu
* VirtualBox
* Vagrant
* Ansible
* Git

> O Ansible é executado pelo WSL (Subsistema do Windows para Linux).

---

## 🚀 Como executar

### 1. Clonar o projeto

```bash
git clone <URL_DO_REPOSITORIO>
cd miguel_aluguel_infra
```

### 2. Configurar as variáveis

Copie o arquivo de exemplo:

```bash
cp .env.example .env
```

Preencha o `.env` com as credenciais e configurações necessárias:

```env
AWS_REGION=us-east-2
ECR_REGISTRY=67547...r.ecr.us-east-....amazonaws.com..

AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=

HAPROXY_HOST=192.168.56.10

DB_USERNAME=
DB_PASSWORD=
HASH_TOKEN=
```

### 3. Criar as VMs

Na raiz do projeto:

```bash
vagrant up
```

Serão criadas:

```text
HAProxy → 192.168.56.10
App     → 192.168.56.20
```

### 4. Executar o Ansible

Depois das VMs subirem:

```bash
./scripts/run-ansible.sh
```

O script carrega as variáveis do `.env` e executa o playbook do Ansible.

O Ansible irá nessa sequência:

* configurar o HAProxy;
* instalar Docker e Docker Compose;
* configurar a autenticação no AWS ECR;
* baixar as imagens da aplicação;
* iniciar Frontend, Backend e PostgreSQL com docker compose.

---

## 🌐 Acessar a aplicação

Depois que o provisionamento terminar:

**Frontend:**

```text
http://192.168.56.10
```

**Backend:**

```text
http://192.168.56.10:8080
```

---

## 🛠️ Comandos úteis

Verificar as VMs:

```bash
vagrant status
```

Acessar a VM do HAProxy:

```bash
vagrant ssh haproxy
```

Acessar a VM da aplicação:

```bash
vagrant ssh app
```

Parar as VMs:

```bash
vagrant halt
```

Destruir as VMs:

```bash
vagrant destroy
```

---

## 🎯 Objetivo

O projeto demonstra uma abordagem de **Infrastructure as Code (IaC)** utilizando Vagrant para provisionamento das máquinas virtuais e Ansible para configuração automatizada da infraestrutura e deploy do sistema de aluguel de carros.

**Vagrant cria. Ansible configura. Docker executa. HAProxy direciona.**
