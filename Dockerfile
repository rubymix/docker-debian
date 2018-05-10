FROM debian:stretch-slim
MAINTAINER Junghyun Kim <zerocool@sulhee.com>

RUN apt-get update -q
RUN DEBIAN_FRONTEND=noninteractive apt-get install -q -y --no-install-recommends sudo build-essential ca-certificates cmake curl git mariadb-client openssh-client python rsync zip

# AWS CLI
RUN curl -O https://bootstrap.pypa.io/get-pip.py
RUN python get-pip.py && rm get-pip.py
RUN pip install awscli

# Go
ENV GOLANG_VERSION 1.10.2
ENV GOLANG_DOWNLOAD_URL https://golang.org/dl/go$GOLANG_VERSION.linux-amd64.tar.gz
ENV GOLANG_DOWNLOAD_SHA256 4b677d698c65370afa33757b6954ade60347aaca310ea92a63ed717d7cb0c2ff
RUN curl -fsSL "$GOLANG_DOWNLOAD_URL" -o golang.tar.gz \
    && echo "$GOLANG_DOWNLOAD_SHA256 golang.tar.gz" | sha256sum -c - \
    && tar -C /usr/local -xzf golang.tar.gz \
    && rm golang.tar.gz

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"

# Node.js
ENV NODEJS_DOWNLOAD_URL https://nodejs.org/dist/latest-v8.x/
ENV NODEJS_SHASUMS256 SHASUMS256.txt
RUN LATEST_NODE=$(curl ${NODEJS_DOWNLOAD_URL} 2> /dev/null | grep -o href=\".*linux-x64.tar.gz\" | awk -F "\"" '{print $2}') \
    && curl -SLO ${NODEJS_DOWNLOAD_URL}${LATEST_NODE} \
    && curl -SLO ${NODEJS_DOWNLOAD_URL}${NODEJS_SHASUMS256} \
    && grep ${LATEST_NODE} ${NODEJS_SHASUMS256} | sha256sum -c - \
    && mkdir -p /usr/local/node \
    && tar -C /usr/local/node -xzf ${LATEST_NODE} --strip-components=1 \
    && rm ${LATEST_NODE} ${NODEJS_SHASUMS256}
ENV PATH ${PATH}:/usr/local/node/bin


# Clean
RUN rm -rf /var/lib/apt/lists/*

# Workspace
RUN groupadd -g 1000 rubymix && useradd -u 1000 -g 1000 -m rubymix
RUN echo "rubymix ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/rubymix
RUN mkdir /workspace && chown 1000:1000 /workspace
WORKDIR /workspace


CMD ["/bin/bash"]
