FROM ubuntu:14.04
RUN apt-get update -y
RUN sudo apt-get -y install curl
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
    && gosu nobody true \
    && apt-get purge -y --auto-remove ca-certificates wget
RUN curl -sSL https://www.distelli.com/download/client | sh
RUN curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash - \
    && sudo apt-get -y update \
    && sudo apt-get -y install nodejs \
    && npm install npm -g \
    && sudo apt-get -y install build-essential
CMD ["/bin/sh"]
