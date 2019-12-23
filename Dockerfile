FROM centos:7
#author
MAINTAINER HM CHO <hyem.cho@gmail.com># extra metadata
# extra metadata
LABEL version="1.0"
LABEL description="An Image with Dockerfile for SNMP trap receiver."

# set the base image
#FROM debian

# update sources list
RUN yum clean all -y
RUN yum update -y

# install basic apps, one per line for better caching
RUN yum install -y vim \
&& yum install -y net-tools \
&& yum install -y python3 \
&& yum install -y python3-pip

# cleanup
RUN yum -y autoremove


# add scripts to the container
#ADD .bashrc ~/.bashrc
#ADD .profile ~/.profile

# add the application to the container
COPY resources /app

# locales to UTF-8
#RUN locale-gen C.UTF-8 && /usr/sbin/update-locale LANG=C.UTF-8
#ENV LC_ALL C.UTF-8

# snmp environment
ENV \
    SNMP_IP="0.0.0.0" \
    SNMP_PORT=162 \
    SNMP_VERSION=2c \
    SNMP_COMMUNITY="qtie" \
    SNMP_USER-NAME="qtie" \
    SNMP_APROTOCOL="MD5" \
    SNMP_APASSPHRASE="" \
    SNMP_SENGINE-ID="00000000" \
    SNMP_CENGINE-ID="00000000" \
    SNMP_LEVEL="authPriv" \
    SNMP_CONTEXT="backup" \
    SNMP_PPROTOCOL="DES" \
    SNMP_PPASSPHRASE="" \
    SNMP_BOOTS_TIME="" \
    MIBS_PATH="/usr/local/share/snmp/mibs" \
    PySNMP_MIBS_PATH="/usr/local/share/snmp/pysnmp_mibs" \
    PYTHONPATH="/usr/local/lib/python"


#RUN pip3 install --upgrade pip && \
RUN  pip3 install pysmi pysnmp_mibs pysnmp \
&&  pip3 install kafka-python 

# volumes
VOLUME \
    /usr/local/bin \
    /usr/local/lib/python \
    /usr/local/share/snmp/mibs \
    /usr/local/share/snmp/pysnmp_mibs


#expose port
EXPOSE 162/udp

# app environment
ENV PYTHONIOENCODING UTF-8
ENV PYTHONPATH /usr/bin/python

CMD python3 /app/snmpTest.py
