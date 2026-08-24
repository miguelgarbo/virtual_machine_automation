#!/bin/bash

set -e

echo "==> Carregando variáveis de ambiente..."
set -a
source .env
set +a

echo "==> Limpando chaves antigas das VMs..."
ssh-keygen -f ~/.ssh/known_hosts -R 192.168.56.10 >/dev/null 2>&1 || true
ssh-keygen -f ~/.ssh/known_hosts -R 192.168.56.20 >/dev/null 2>&1 || true

echo "==> Executando Ansible..."

ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook \
  -i ansible/inventory/hosts.ini \
  ansible/playbook.yml