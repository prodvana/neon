#!/bin/bash

# fetch params from meta-data service
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
AZ_ID=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
declare -A IDS=([i-0e09cd108279eb4f5]=0 [i-06083acd29327dce3]=1 [i-0ba39b03d290c65a3]=2 [i-0f0929baf23d4127e]=99)

# store fqdn hostname in var
HOST=$(hostname -f)


cat <<EOF | tee /tmp/payload
{
  "version": 1,
  "host": "${HOST}",
  "port": 6500,
  "http_port": 7676,
  "region_id": "{{ console_region_id }}",
  "instance_id": "${INSTANCE_ID}",
  "availability_zone_id": "${AZ_ID}",
  "active": false
}
EOF

if [[ ! -f /storage/safekeeper/data/safekeeper.toml ]]; then
	# init safekeeper
	ID=${IDS["$INSTANCE_ID"]}
	sudo -u safekeeper /usr/local/bin/safekeeper --id ${ID} --init -D /storage/safekeeper/data
fi
