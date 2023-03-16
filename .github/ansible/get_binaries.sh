#!/bin/bash -x

set -e

if [ -n "${DOCKER_TAG}" ]; then
  # Verson is DOCKER_TAG but without prefix
  VERSION=$(echo $DOCKER_TAG | sed 's/^.*://g')
else
  echo "Please set DOCKER_TAG environment variable"
  exit 1
fi


# do initial cleanup
rm -rf neon_install postgres_install.tar.gz neon_install.tar.gz .neon_current_version
mkdir neon_install

# retrieve binaries from docker image
# Running docker inside Docker or inside Kubernetes is a bit iffy. Download the image using other means.
echo "getting binaries from docker image"
./download-frozen-image-v2.sh /tmp/neondb neondatabase/neon:${VERSION} >&2
mkdir /tmp/out
for f in $(jq -r '.[0].Layers[]' /tmp/neondb/manifest.json); do
	tar -C /tmp/out -xf "/tmp/neondb/${f}"
done
cp /tmp/out/data/postgres_install.tar.gz .
tar -xzf postgres_install.tar.gz -C neon_install
mkdir neon_install/bin/
cp /tmp/out/usr/local/bin/pageserver neon_install/bin/
cp /tmp/out/usr/local/bin/pageserver_binutils neon_install/bin/
cp /tmp/out/usr/local/bin/safekeeper neon_install/bin/
cp /tmp/out/usr/local/bin/storage_broker neon_install/bin/
cp -r /tmp/out/usr/local/bin/proxy neon_install/bin/
cp -r /tmp/out/usr/local/v14/bin/ neon_install/v14/bin/
cp -r /tmp/out/usr/local/v15/bin/ neon_install/v15/bin/
cp -r /tmp/out/usr/local/v14/lib/ neon_install/v14/lib/
cp -r /tmp/out/usr/local/v15/lib/ neon_install/v15/lib/

# store version to file (for ansible playbooks) and create binaries tarball
echo ${VERSION} > neon_install/.neon_current_version
echo ${VERSION} > .neon_current_version
tar -czf neon_install.tar.gz -C neon_install .

# do final cleaup
rm -rf neon_install postgres_install.tar.gz
