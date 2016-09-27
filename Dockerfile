FROM debian:jessie
MAINTAINER Junghyun Kim <zerocool@sulhee.com>

RUN apt-get update -q
RUN DEBIAN_FRONTEND=noninteractive apt-get install -q -y --no-install-recommends curl build-essential sudo git ca-certificates python
RUN apt-get install -q -y vim zip

# AWS CLI
RUN curl -O https://bootstrap.pypa.io/get-pip.py
RUN python get-pip.py && rm get-pip.py
RUN pip install awscli

# Go
RUN curl -O https://storage.googleapis.com/golang/go1.7.1.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf go1.7.1.linux-amd64.tar.gz && rm go1.7.1.linux-amd64.tar.gz
ENV PATH ${PATH}:/usr/local/go/bin

# Node.js
RUN LATEST_NODE=$(curl http://nodejs.org/dist/latest-argon/ 2> /dev/null | grep -o href=\".*linux-x64.tar.gz\" | awk -F "\"" '{print $2}') && \
    curl -L -o latest-node.tar.gz http://nodejs.org/dist/latest-argon/${LATEST_NODE}
RUN mkdir -p /usr/local/node && tar xzf latest-node.tar.gz -C /usr/local/node --strip-components=1 && rm latest-node.tar.gz
ENV PATH ${PATH}:/usr/local/node/bin

# NPM
RUN npm install -g bower gulp nodemon

# MySQL client
RUN apt-get install -q -y libnuma1 libaio1
RUN mkdir /tmp/mysql && cd /tmp/mysql
RUN curl -LO http://dev.mysql.com/get/Downloads/MySQL-5.6/mysql-server_5.6.33-1debian8_amd64.deb-bundle.tar
RUN tar xvf mysql-server_5.6.33-1debian8_amd64.deb-bundle.tar
RUN dpkg -i mysql-common_5.6.33-1debian8_amd64.deb
RUN dpkg -i mysql-community-client_5.6.33-1debian8_amd64.deb
RUN dpkg -i libmysqlclient18_5.6.33-1debian8_amd64.deb
RUN rm -rf /tmp/mysql


# Clean
RUN rm -rf /var/lib/apt/lists/*

# Workspace
RUN groupadd -g 1000 rubymix && useradd -u 1000 -g 1000 -m rubymix
RUN echo "rubymix ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/rubymix
RUN mkdir /workspace && chown 1000:1000 /workspace
WORKDIR /workspace


CMD ["/bin/bash"]
