FROM ubuntu:18.04

RUN apt-get update && \
    apt-get install -y vim && \
    apt-get install -y ssh && \
    apt-get install -y iputils-ping
    # apt-get install -y openssh-server && \
    # apt-get install -y openssh-client

RUN apt install -y software-properties-common && \
    add-apt-repository -y ppa:deadsnakes/ppa && \
    apt-get install -y python3.6 && \
    apt-get install -y python3-pip

# Upgrade pip
RUN pip3 install --upgrade pip

# Install ansible which runs with Python3
RUN pip3 install ansible

# Install docker-compose module
RUN pip3 install docker-compose

RUN mkdir -p /dev/ansible/
VOLUME "/dev/ansible"

# Create default SSH key
# WORKDIR /root/.ssh
RUN ssh-keygen -t rsa -f ~/.ssh/id_rsa -q -N ""
