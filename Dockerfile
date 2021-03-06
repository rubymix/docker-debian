FROM debian:10-slim
MAINTAINER Junghyun Kim <zerocool@sulhee.com>

RUN apt-get update -q
RUN DEBIAN_FRONTEND=noninteractive apt-get install -q -y --no-install-recommends sudo build-essential ca-certificates cmake curl git mariadb-client openssh-client python rsync zip

# AWS CLI
RUN curl -O https://bootstrap.pypa.io/get-pip.py
RUN python get-pip.py && rm get-pip.py
RUN pip install awscli

# Go
ENV GOLANG_VERSION 1.13
ENV GOLANG_DOWNLOAD_URL https://golang.org/dl/go$GOLANG_VERSION.linux-amd64.tar.gz
ENV GOLANG_DOWNLOAD_SHA256 68a2297eb099d1a76097905a2ce334e3155004ec08cdea85f24527be3c48e856
RUN curl -fsSL "$GOLANG_DOWNLOAD_URL" -o golang.tar.gz \
    && echo "$GOLANG_DOWNLOAD_SHA256 golang.tar.gz" | sha256sum -c - \
    && tar -C /usr/local -xzf golang.tar.gz \
    && rm golang.tar.gz

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"


# Clean
RUN rm -rf /var/lib/apt/lists/*

# Workspace
RUN groupadd -g 1000 rubymix && useradd -u 1000 -g 1000 -m rubymix
RUN echo "rubymix ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/rubymix
RUN mkdir /workspace && chown 1000:1000 /workspace
WORKDIR /workspace


CMD ["/bin/bash"]
