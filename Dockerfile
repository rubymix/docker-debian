FROM debian:jessie
MAINTAINER Junghyun Kim <zerocool@sulhee.com>

RUN apt-get update -q
RUN DEBIAN_FRONTEND=noninteractive apt-get install -q -y --no-install-recommends sudo curl build-essential cmake ca-certificates git openssh-client python zip

# AWS CLI
RUN curl -O https://bootstrap.pypa.io/get-pip.py
RUN python get-pip.py && rm get-pip.py
RUN pip install awscli

# Go
ENV GOLANG_VERSION 1.8
ENV GOLANG_DOWNLOAD_URL https://golang.org/dl/go$GOLANG_VERSION.linux-amd64.tar.gz
ENV GOLANG_DOWNLOAD_SHA256 53ab94104ee3923e228a2cb2116e5e462ad3ebaeea06ff04463479d7f12d27ca
RUN curl -fsSL "$GOLANG_DOWNLOAD_URL" -o golang.tar.gz \
    && echo "$GOLANG_DOWNLOAD_SHA256 golang.tar.gz" | sha256sum -c - \
    && tar -C /usr/local -xzf golang.tar.gz \
    && rm golang.tar.gz

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"

# Node.js
ENV NODEJS_DOWNLOAD_URL http://nodejs.org/dist/latest-v6.x/
RUN LATEST_NODE=$(curl ${NODEJS_DOWNLOAD_URL} 2> /dev/null | grep -o href=\".*linux-x64.tar.gz\" | awk -F "\"" '{print $2}') && \
    curl -L -o latest-node.tar.gz ${NODEJS_DOWNLOAD_URL}${LATEST_NODE}
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
