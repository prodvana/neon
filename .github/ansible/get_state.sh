#!/bin/bash -eux
#
# Inputs:
# PVN_SERVICE_ID: Prodvana service id.

rm -rf /tmp/versions # TODO: Use mktemp -d
mkdir /tmp/versions

ansible-playbook -v get_state.yaml -i prodvana.us-west-2.hosts.yaml -e @ssm_config -e pvn_service_id="${PVN_SERVICE_ID}" >&2

hosts=$(ansible-inventory -i prodvana.us-west-2.hosts.yaml -e @ssm_config storage --list | jq -r '._meta.hostvars | keys')

versions="[]"

while IFS= read -r line; do
	if [[ "$line" == "" ]]; then
		break
	fi
	splits=($line)
	versions=$(jq -n --arg versions "$versions" --arg ver "${splits[1]}" --arg replicas "${splits[0]}" '$versions | fromjson + [ {"service_version": $ver, "replicas": $replicas} ]')

done <<< $(find /tmp/versions -type f -print0 | xargs -0 -I % sh -c 'cat %; echo "";' | sort | uniq -c)

jq -n --argjson inst "$hosts" --argjson v "$versions" '{"instances": $inst, "versions": $v}'
