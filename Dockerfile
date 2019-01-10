# Ubuntu has the necessary framework to start from    
FROM ubuntu:16.04

# Run as root
USER root

# Create Distelli user
RUN useradd -ms /bin/bash distelli 

# Set /home/distelli as the working directory
WORKDIR /home/distelli

# ENV gcloud_key $GCLOUD_KEY

# ARG DISTELLI_BUILDNUM
# LABEL buildnumber=$DISTELLI_BUILDNUM

# RUN echo $gcloud_key | base64 --decode > /home/distelli/project-key.json

RUN apt-get update -y && apt-get install -y sudo

# Install prerequisites. This provides me with the essential tools for building with.
# Note. You don't need git or mercurial.
RUN sudo apt-get update -y \
    && sudo apt-get -y install build-essential checkinstall git mercurial \
    && sudo apt-get -y install libssl-dev openssh-client openssh-server \
    && sudo apt-get -y install make \
    && sudo apt-get -y install curl apt-transport-https ca-certificates software-properties-common

# Update the .ssh/known_hosts file:
RUN sudo sh -c "ssh-keyscan -H github.com bitbucket.org >> /etc/ssh/ssh_known_hosts"

# Install Distelli CLI to coordinate the build in the container
RUN curl -sSL https://www.distelli.com/download/client | sh 

# RUN sudo apt-get remove --purge docker docker-engine docker.io
 RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
 RUN sudo add-apt-repository -y \
     "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
     $(lsb_release -cs) \
     stable"

 RUN sudo apt-get -y update \
     && sudo apt-get -y install docker-ce \
     && sudo apt-get -y install xdg-utils

 RUN sudo curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose \
     && sudo chmod +x /usr/local/bin/docker-compose


RUN sudo apt-get -y install default-jdk \
    && sudo apt-get -y install wget \
    && wget https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein \
    && chmod +x lein \
    && sudo mv lein /usr/local/bin 


# #Install docker
# #Note. This is only necessary if you plan on building docker images
# RUN sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D \
#     && sudo sh -c "echo 'deb https://apt.dockerproject.org/repo ubuntu-trusty main' > /etc/apt/sources.list.d/docker.list" \
#     && sudo apt-get update -y \
#     && sudo apt-get purge -y lxc-docker \
#     && sudo apt-get -y install docker-ce \
#     && sudo apt-get -y install xdg-utils \
#     && sudo sh -c 'curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose' \
#     && sudo chmod +x /usr/local/bin/docker-compose \
#     && sudo docker -v

# Setup a volume for writing docker layers/images
VOLUME /var/lib/docker

# # Install gosu
ENV GOSU_VERSION 1.9
RUN sudo curl -o /bin/gosu -sSL "https://github.com/tianon/gosu/releases/download/1.9/gosu-$(dpkg --print-architecture)" \
      && sudo chmod +x /bin/gosu

# # Install node version manager as distelli user
USER distelli
RUN v=8 \
    && curl -sL https://deb.nodesource.com/setup_$v.x | sudo -E bash - \
    && sudo apt-get install -y nodejs \
    && npm install -g npm@latest
# RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.0/install.sh | bash 

# Ensure the final USER statement is "USER root"
USER root

# An informative file I like to put on my shared images
RUN sudo sh -c "echo 'Distelli Build Image maintained by Sarah Thompson sarah@puppet.com' >> /distelli_build_image.info"

CMD ["/bin/bash"]
