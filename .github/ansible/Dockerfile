FROM willhallonline/ansible:2.13-bullseye

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
  apt-get install -y python3-boto3 python3-toml curl jq && \
  rm -rf /var/lib/apt/lists/* && \
  apt-get clean

RUN mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian bullseye stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
  apt-get install -y docker-ce-cli docker-ce && \
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
