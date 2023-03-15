FROM willhallonline/ansible:2.13-bullseye

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
  apt-get install -y python3-boto3 python3-toml curl jq && \
  rm -rf /var/lib/apt/lists/* && \
  apt-get clean

# Versions after 1.2.398.0 (like, 1.2.458.0) appear to hang on S3 interactions. Not sure why. Pin SSM version.
RUN curl https://s3.amazonaws.com/session-manager-downloads/plugin/1.2.398.0/ubuntu_64bit/session-manager-plugin.deb -o /tmp/session-manager-plugin.deb && \
    dpkg -i /tmp/session-manager-plugin.deb && \
    rm /tmp/session-manager-plugin.deb

RUN ansible-galaxy collection install \
    # community.aws bundled with bullseye is ancient. Pull latest collection from galaxy
    community.aws \
    # TOML <-> ansible
    sivel.toiletwater

COPY . .
COPY --from=us-docker.pkg.dev/pvn-infra/pvn-public/pvn-wrapper:latest /pvn-wrapper /bin/pvn-wrapper
ENTRYPOINT ["/bin/pvn-wrapper"]
