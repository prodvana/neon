#!/bin/bash -eux
#
for ip in $(aws ec2 describe-instances --filters "Name=instance-state-name,Values=running" | jq -r '.Reservations[].Instances[].PublicIpAddress'); do ssh -o StrictHostKeyChecking=no admin@$ip "wget -O /tmp/amazon-ssm-agent.deb https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/debian_amd64/amazon-ssm-agent.deb && sudo dpkg -i /tmp/amazon-ssm-agent.deb"; done
