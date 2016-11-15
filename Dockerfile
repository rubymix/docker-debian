FROM debian:jessie
MAINTAINER Junghyun Kim <zerocool@sulhee.com>

RUN apt-get update -q
RUN DEBIAN_FRONTEND=noninteractive apt-get install -q -y --no-install-recommends sudo curl build-essential cmake ca-certificates git python zip

# AWS CLI
RUN curl -O https://bootstrap.pypa.io/get-pip.py
RUN python get-pip.py && rm get-pip.py
RUN pip install awscli

# Go
ENV GOLANG_VERSION 1.7.3
ENV GOLANG_DOWNLOAD_URL https://golang.org/dl/go$GOLANG_VERSION.linux-amd64.tar.gz
ENV GOLANG_DOWNLOAD_SHA256 508028aac0654e993564b6e2014bf2d4a9751e3b286661b0b0040046cf18028e
RUN curl -fsSL "$GOLANG_DOWNLOAD_URL" -o golang.tar.gz \
    && echo "$GOLANG_DOWNLOAD_SHA256 golang.tar.gz" | sha256sum -c - \
    && tar -C /usr/local -xzf golang.tar.gz \
    && rm golang.tar.gz

ENV GOPATH /go
ENV PATH ${PATH}:/usr/local/go/bin:${GOPATH}/bin
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"

# Node.js
RUN LATEST_NODE=$(curl http://nodejs.org/dist/latest-argon/ 2> /dev/null | grep -o href=\".*linux-x64.tar.gz\" | awk -F "\"" '{print $2}') && \
    curl -L -o latest-node.tar.gz http://nodejs.org/dist/latest-argon/${LATEST_NODE}
RUN mkdir -p /usr/local/node && tar xzf latest-node.tar.gz -C /usr/local/node --strip-components=1 && rm latest-node.tar.gz
ENV PATH ${PATH}:/usr/local/node/bin

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
