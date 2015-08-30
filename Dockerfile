FROM ubuntu:trusty

RUN apt-get update && apt-get -y upgrade && apt-get -y install wget && apt-get -y install git git-core

# Install the build tools (dpkg-dev g++ gcc libc6-dev make)
RUN apt-get -y install build-essential

# automatic configure script builder (debianutils m4 perl)
RUN apt-get -y install autoconf

# Needed for terminal handling (libc-dev libncurses5 libtinfo-dev libtinfo5 ncurses-bin)
RUN apt-get -y install libncurses5-dev

# For building with wxWidgets
RUN apt-get -y install libwxgtk2.8-dev libgl1-mesa-dev libglu1-mesa-dev libpng3

# For building ssl (libssh-4 libssl-dev zlib1g-dev)
RUN apt-get -y install libssh-dev

# ODBC support (libltdl3-dev odbcinst1debian2 unixodbc)
RUN apt-get -y install unixodbc-dev
RUN mkdir -p ~/code/erlang
WORKDIR ~/code/erlang
 
RUN wget http://www.erlang.org/download/otp_src_18.0.tar.gz

RUN tar -xvzf otp_src_18.0.tar.gz; chmod -R 777 otp_src_18.0; cd otp_src_18.0; ./configure; make; make install

WORKDIR ~/code

#RUN git clone https://github.com/rebar/rebar3.git

#RUN cd rebar3; ./bootstrap; cp rebar3 /bin/rebar3;

#RUN echo "export PATH=$PATH:/bin/rebar3" >> ~/.bashrc

RUN mkdir /src

COPY . /src/notification_center/

WORKDIR /src/notification_center

EXPOSE 8080

CMD ./start-dev.sh

#CMD /bin/bash

#CMD notification_server/_build/default/rel/notification_server/bin/notification_server