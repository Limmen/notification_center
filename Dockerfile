FROM ubuntu:trusty

RUN apt-get update && apt-get -y upgrade && apt-get -y install wget && apt-get -y install git git-core build-essential


COPY . /notification_center

# Install Erlang

RUN cp /notification_center/build-erlang-17.0.sh .

RUN chmod u+x ./build-erlang-17.0.sh

RUN ./build-erlang-17.0.sh

#install rebar3
RUN git clone https://github.com/rebar/rebar3.git

RUN cd rebar3; ./bootstrap; cp rebar3 /bin/rebar3;

RUN echo "export PATH=$PATH:/bin/rebar3" >> ~/.bashrc


EXPOSE 8001

WORKDIR /notification_center

CMD ./init.sh start
#CMD cd notification_server; make run & cd ..; ./init-dev.sh 


