FROM ubuntu:14.04
RUN apt-get update -y \
    && sudo apt-get -y install build-essential checkinstall \
    && sudo apt-get -y install libssl-dev \
    && sudo apt-get -y install curl ca-certificates \
    && curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.0/install.sh | bash

ENV GOSU_VERSION 1.9
RUN set -x \
    && apt-get install -y --no-install-recommends ca-certificates wget && rm -rf /var/lib/apt/lists/* \
    && dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
    && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" \
    && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc" \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
    && rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu \
    && gosu nobody true
     
RUN curl -sSL https://www.distelli.com/download/client | sh

RUN sudo sh -c "echo 'Brian was here!' >> /testfile.txt"

CMD ["/bin/sh"]
