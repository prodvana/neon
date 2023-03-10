#!/bin/bash -eux

ansible-playbook -v deploy.yaml -i prodvana.us-west-2.hosts.yaml -e @ssm_config -e pvn_service_version=neon-omnibus-0 -e pvn_service=neon-omnibus >&2
