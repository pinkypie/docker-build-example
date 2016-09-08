FROM ubuntu:14.04

USER root

# Create Distelli user
RUN useradd -ms /bin/bash distelli 

WORKDIR /home/distelli
    
# Install prerequisites
RUN sudo apt-get update -y \
    && sudo apt-get -y install build-essential checkinstall git mercurial \
    && sudo apt-get -y install libssl-dev openssh-client openssh-server \
    && sudo apt-get -y install curl apt-transport-https ca-certificates

# Update the .ssh/known_hosts file:
RUN sudo sh -c "ssh-keyscan -H github.com bitbucket.org >> /etc/ssh/ssh_known_hosts"

# Install Distelli CLI and Agent
# Installing agent to create distelli account
RUN curl -sSL https://www.distelli.com/download/client | sh 

# Install node version manager as distelli user
USER distelli
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.0/install.sh | bash 
USER root

# Install docker
RUN sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D \
    && sudo sh -c "echo 'deb https://apt.dockerproject.org/repo ubuntu-trusty main' > /etc/apt/sources.list.d/docker.list" \
    && sudo apt-get update -y \
    && sudo apt-get purge -y lxc-docker \
    && sudo apt-get -y install docker-engine \
    && sudo sh -c 'curl -L https://github.com/docker/compose/releases/download/1.6.2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose' \
    && sudo chmod +x /usr/local/bin/docker-compose \
    && sudo docker -v

# See https://github.com/docker-library/docker/blob/master/1.12/Dockerfile
# Install docker client:
#RUN curl -fSL "https://get.docker.com/builds/Linux/x86_64/docker-1.12.0.tgz" -o /tmp/docker.tgz \
#    && echo "3dd07f65ea4a7b4c8829f311ab0213bca9ac551b5b24706f3e79a97e22097f8b  /tmp/docker.tgz" | sha256sum -c - \
#    && tar -C /tmp -xzvf /tmp/docker.tgz \
#    && mv /tmp/docker/* /usr/local/bin/ \
#    && rm -r /tmp/docker /tmp/docker.tgz \
#    && docker -v

# Install gosu
ENV GOSU_VERSION 1.9
RUN sudo curl -o /bin/gosu -sSL "https://github.com/tianon/gosu/releases/download/1.9/gosu-$(dpkg --print-architecture)" \
     && sudo chmod +x /bin/gosu
     
#ADD ./wrapdocker.sh /usr/local/bin/wrapdocker.sh
#RUN chmod +x /usr/local/bin/wrapdocker.sh

VOLUME /var/lib/docker

RUN sudo sh -c "echo 'Distelli Build Image maintained by Brian McGehee bmcgehee@distelli.com' >> /distelli_build_image.info"

#CMD ["/usr/local/bin/wrapdocker.sh"]
CMD ["/bin/bash"]
