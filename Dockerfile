FROM rootproject/root:latest

LABEL maintainer.name="Matteo Duranti"
LABEL maintainer.email="matteo.duranti@infn.it"

ENV LANG=C.UTF-8

COPY packages_custom packages_custom

RUN apt-get update -qq \
 && apt-get -y install $(cat packages_custom) \
 && rm -rf /var/lib/apt/lists/*

# Run the following commands as super user (root):
USER root
ENV ROOTHOME /root
WORKDIR ${ROOTHOME}

COPY entrypoint.sh /
RUN  chmod +x /entrypoint.sh

# Install and configure tsocks
COPY tsocks-1.8beta5.tar.gz tsocks-1.8beta5.tar.gz
RUN tar -xvf tsocks-1.8beta5.tar.gz \
 && cd tsocks-1.8 \
 && ./configure \
 && make \
 && make install
COPY tsocks.conf /etc/tsocks.conf

# Create a user that does not have root privileges 
ARG username=testsys
RUN useradd --create-home --home-dir /home/${username} ${username}
ENV HOME /home/${username}

# Switch to our newly created user
USER ${username}

ADD dot-bashrc ${HOME}/.bashrc
ADD dot-rootlogon ${HOME}/.rootlogon.C

# Our working directory will be in our home directory where we have permissions
#WORKDIR /home/${username}
WORKDIR ${HOME}

COPY create_tunnel_and_socksify_everything.sh create_tunnel_and_socksify_everything.sh

RUN ln -s ${HOME}/current_dir/.bash_history ./
RUN ln -s ${HOME}/current_dir/.root_hist ./

# Our (final) working dir is the directory "mounted" from outside the container: docker run --rm -it -v `pwd`:/home/testsys/current_dir bozzochet/jmdccommander:latest
WORKDIR ${HOME}/current_dir

## Checkout AMSDAQ
#RUN svn checkout svn checkout https://svn.code.sf.net/p/amsdaq/code/DAQ/DAQ AMSDAQ

ENTRYPOINT ["/entrypoint.sh"]

#CMD ["root", "-b"]
#CMD exec /bin/bash