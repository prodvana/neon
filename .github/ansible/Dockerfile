FROM willhallonline/ansible:2.13-bullseye

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
  apt-get install -y python3-boto3 python3-toml curl && \
  rm -rf /var/lib/apt/lists/* && \
  apt-get clean

RUN curl https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb -o /tmp/session-manager-plugin.deb && \
    dpkg -i /tmp/session-manager-plugin.deb && \
    rm /tmp/session-manager-plugin.deb

RUN ansible-galaxy collection install \
    # community.aws bundled with bullseye is ancient. Pull latest collection from galaxy
    community.aws \
    # TOML <-> ansible
    sivel.toiletwater

COPY . .
# CMD ["ansible-playbook", "-v", "deploy.yaml", "-i", "prodvana.us-west-2.hosts.yaml", "-e", "@ssm_config"]
