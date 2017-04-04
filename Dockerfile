FROM ubuntu:16.04

MAINTAINER Darius Kristapavicius <darius@darneta.lt>

RUN apt-get update
RUN apt-get -y install wget
RUN apt-get -y install python
RUN apt-get -y install sudo
RUN apt-get -y install bzip2
RUN apt-get -y install supervisor

RUN useradd -ms /bin/bash rhodecode
RUN sudo adduser rhodecode sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN locale-gen en_US.UTF-8
RUN update-locale 

USER rhodecode

RUN mkdir -p /home/rhodecode/.rccontrol/cache

WORKDIR /home/rhodecode/.rccontrol/cache

RUN wget https://dls.rhodecode.com/linux/RhodeCodeVCSServer-4.6.1+x86_64-linux_build20170213_1900.tar.bz2
RUN wget https://dls.rhodecode.com/linux/RhodeCodeCommunity-4.6.1+x86_64-linux_build20170213_1900.tar.bz2

WORKDIR /home/rhodecode

RUN wget --content-disposition https://dls-eu.rhodecode.com/dls/NzA2MjdhN2E2ODYxNzY2NzZjNDA2NTc1NjI3MTcyNzA2MjcxNzIyZTcwNjI3YQ==/rhodecode-control/latest-linux-ce
RUN chmod 755 ./RhodeCode-installer-*
RUN ./RhodeCode-installer-* --accept-license --create-install-directory
RUN .rccontrol-profile/bin/rccontrol self-init

ADD ./container/start.sh start.sh

RUN sudo chmod +x start.sh

RUN mkdir -p /home/rhodecode/repo

CMD ["sh", "start.sh"]
