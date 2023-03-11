#!/bin/bash -eux
# Inputs:
# DOCKER_IMAGE: Full docker image in "repository:version" format
# SERVICE_NAME: Service name. Can be used to pick a subset of processes/hosts to deploy.
# SERVICE_VERSION: Opaque service version string. This needs to be sent back in get_state.sh

./get_binaries.sh

ansible-playbook -v deploy.yaml -i prodvana.us-west-2.hosts.yaml -e @ssm_config -e pvn_service_version="${SERVICE_VERSION}" -e pvn_service="${SERVICE_NAME}" >&2
