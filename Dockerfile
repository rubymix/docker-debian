FROM debian:jessie
MAINTAINER Junghyun Kim <zerocool@sulhee.com>

RUN apt-get update -q
RUN apt-get install -q -y --no-install-recommends curl build-essential sudo git ca-certificates
RUN apt-get install -q -y vim zip openjdk-7-jre

ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64

# Node.js
RUN LATEST_NODE=$(curl http://nodejs.org/dist/latest/ 2> /dev/null | grep -o href=\".*linux-x64.tar.gz\" | awk -F "\"" '{print $2}') && \
    curl -L -o latest-node.tar.gz http://nodejs.org/dist/latest/${LATEST_NODE}
RUN mkdir -p /usr/local/node && tar xvfz latest-node.tar.gz -C /usr/local/node --strip-components=1 && rm latest-node.tar.gz

ENV PATH ${PATH}:/usr/local/node/bin

# NPM
RUN npm install -g bower gulp nodemon

# Clean
RUN rm -rf /var/lib/apt/lists/*

# Workspace
RUN groupadd -g 1000 rubymix && useradd -u 1000 -g 1000 -m rubymix
RUN echo "rubymix ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/rubymix
RUN mkdir /workspace && chown 1000:1000 /workspace
WORKDIR /workspace


CMD ["/bin/bash"]