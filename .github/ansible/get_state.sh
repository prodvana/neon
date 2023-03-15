#!/bin/bash -eux
#
# Inputs:
# PVN_SERVICE_ID: Prodvana service id.

rm -rf /tmp/versions # TODO: Use mktemp -d
mkdir /tmp/versions

ansible-playbook -v get_state.yaml -i prodvana.us-west-2.hosts.yaml -e @ssm_config -e pvn_service_id="${PVN_SERVICE_ID}" >&2

hosts=$(ansible-inventory -i prodvana.us-west-2.hosts.yaml -e @ssm_config storage --list | jq -r '._meta.hostvars | keys')

versions="{}"
for f in $(find /tmp/versions/ -name '*.version'); do
	host=$(basename "${f}");
	v=$(cat "${f}")
	versions=$(jq -n --arg versions "$versions" --arg key "$host" --arg value "$v" '$versions | fromjson + { ($key) : $value }')
done

jq -n --argjson inst "$hosts" --argjson v "$versions" '{"instances": $inst, "versions": $v}'
