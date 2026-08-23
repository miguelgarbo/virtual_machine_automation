#!/bin/bash

set -a
source .env
set +a

ansible-playbook \
  -i ansible/inventory/hosts.ini \
  ansible/playbook.yml
