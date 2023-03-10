#!/bin/bash

# fetch params from meta-data service
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
AZ_ID=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
declare -A IDS=([i-0db7870a47837f098]=0 [i-02852566b50144b46]=1 [i-0e50c40a5cd11c1f8]=2 [i-097d96cd90d5fc639]=99)

# store fqdn hostname in var
HOST=$(hostname -f)


cat <<EOF | tee /tmp/payload
{
  "version": 1,
  "host": "${HOST}",
  "port": 6400,
  "region_id": "{{ console_region_id }}",
  "instance_id": "${INSTANCE_ID}",
  "http_host": "${HOST}",
  "http_port": 9898,
  "active": false,
  "availability_zone_id": "${AZ_ID}"
}
EOF

if [[ ! -f /storage/pageserver/data/pageserver.toml ]]; then
	# init pageserver
	ID=${IDS["$INSTANCE_ID"]}
	sudo -u pageserver /usr/local/bin/pageserver -c "id=${ID}" -c "pg_distrib_dir='/usr/local'" --init -D /storage/pageserver/data
fi
