FROM ubuntu:14.04

# Create Distelli user and install everything as that user
RUN useradd -ms /bin/bash distelli \
    && sudo sh -c "echo 'distelli ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/distelli" \
    && sudo sh -c "echo 'Defaults:distelli !requiretty' >> /etc/sudoers.d/distelli"
    
USER distelli
WORKDIR /home/distelli

# Install prerequisites
RUN sudo apt-get update -y \
    && sudo apt-get -y install build-essential checkinstall \
    && sudo apt-get -y install libssl-dev openssh-client openssh-server \
    && sudo apt-get -y install curl apt-transport-https ca-certificates

# Update the .ssh/known_hosts file:
RUN sudo sh -c "ssh-keyscan -H github.com bitbucket.org >> /etc/ssh/ssh_known_hosts"

# Install Distelli CLI and Agent
# Installing agent to create distelli account
RUN curl -sSL https://www.distelli.com/download/client | sh 

# Install node version manager
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.0/install.sh | bash 

# Install docker
#RUN sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D \
#    && sudo sh -c "echo 'deb https://apt.dockerproject.org/repo ubuntu-trusty main' > /etc/apt/sources.list.d/docker.list" \
#    && sudo apt-get update -y \
#    && sudo apt-get purge -y lxc-docker \
#    && sudo apt-get -y install docker-engine \
#    && sudo sh -c 'curl -L https://github.com/docker/compose/releases/download/1.6.2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose' \
#    && sudo chmod +x /usr/local/bin/docker-compose

ENV GOSU_VERSION 1.9
#RUN set -x \
#    && apt-get install -y --no-install-recommends ca-certificates wget && rm -rf /var/lib/apt/lists/* \
#    && dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
#    && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" \
#    && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc" \
#    && export GNUPGHOME="$(mktemp -d)" \
#    && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
#    && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
#    && rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
#    && chmod +x /usr/local/bin/gosu \
#    && gosu nobody true

RUN curl -o /bin/gosu -sSL "https://github.com/tianon/gosu/releases/download/1.9/gosu-$(dpkg --print-architecture)" && chmod +x /bin/gosu
     
RUN sudo sh -c "echo 'Brian was here!' >> /testfile.txt"

RUN whoami

CMD ["/bin/bash"]
