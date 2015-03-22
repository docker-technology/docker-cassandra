FROM ubuntu:14.04.1
MAINTAINER Nhan Tran <dockertechnology@gmail.com>
ENV REFRESHED_AT 2015-03-22

RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install -y wget
RUN apt-get install -y unzip
RUN apt-get install -y curl
RUN apt-get install -y vim
RUN update-alternatives --set editor /usr/bin/vim.basic

ADD jdk-7u71-linux-x64.tar.gz /tmp/
RUN cd /tmp && mv jdk1.7.0_71 /opt/jdk
RUN update-alternatives --install "/usr/bin/java" "java" /opt/jdk/bin/java 1
RUN update-alternatives --set java /opt/jdk/bin/java
ENV JAVA_HOME /opt/jdk

ADD dsc-cassandra-2.0.11-bin.tar.gz /tmp
RUN cd /tmp && mv dsc-cassandra-2.0.11 /opt/cassandra
ENV CASSANDRA_HOME /opt/cassandra

ADD jna-4.1.0.jar $CASSANDRA_HOME/lib/jna.jar
RUN echo "root - memlock unlimited" >> /etc/security/limits.conf
RUN echo "root - nofile 100000" >> /etc/security/limits.conf
RUN echo "root - nproc 32768" >> /etc/security/limits.conf
RUN echo "root - as unlimited" >> /etc/security/limits.conf
RUN sysctl -p

ADD startCassandra $CASSANDRA_HOME/bin/
RUN chmod u+x $CASSANDRA_HOME/bin/startCassandra

EXPOSE 7000 7199 9042 9160 61621

ENTRYPOINT [ "/opt/cassandra/bin/startCassandra" ]

CMD []