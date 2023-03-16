#!/bin/bash -eux
#
# Inputs:
# PVN_DOCKER_IMAGE: Full docker image in "repository:version" format
# PVN_SERVICE_NAME: Human readable service name. Can be used to pick a subset of processes/hosts to deploy.
# PVN_SERVICE_VERSION: Opaque service version string. This needs to be sent back in get_state.sh
# PVN_SERVICE_ID: Prodvana service id. Used to tag and uniquely identify a service. This variable is passed in get_state.sh.

REPO_ROOT=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
DOCKER_TAG=${PVN_DOCKER_IMAGE} "${REPO_ROOT}"/get_binaries.sh

ansible-playbook -v deploy.yaml -i prodvana.us-west-2.hosts.yaml -e @ssm_config -e pvn_service_version="${PVN_SERVICE_VERSION}" -e pvn_service_id="${PVN_SERVICE_ID}" >&2
