#!/bin/bash

set -e

echo "==> Carregando variáveis de ambiente..."
set -a
source <(sed 's/\r$//' .env)
set +a

echo "==> Limpando chaves antigas das VMs..."
ssh-keygen -f ~/.ssh/known_hosts -R 192.168.56.10 >/dev/null 2>&1 || true
ssh-keygen -f ~/.ssh/known_hosts -R 192.168.56.20 >/dev/null 2>&1 || true

echo "==> Copiando chaves privadas do Vagrant para fora do /mnt/c (permissões corretas)..."
mkdir -p ~/.ssh/vagrant_keys
cp .vagrant/machines/haproxy/virtualbox/private_key ~/.ssh/vagrant_keys/haproxy_key
cp .vagrant/machines/app/virtualbox/private_key ~/.ssh/vagrant_keys/app_key
chmod 600 ~/.ssh/vagrant_keys/haproxy_key ~/.ssh/vagrant_keys/app_key

echo "==> Executando Ansible..."

ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook \
  -i ansible/inventory/hosts.ini \
  ansible/playbook.yml