## Modified by Sam KUON - 01/08/17
FROM centos:latest
MAINTAINER Sam KUON "sam.kuonssp@gmail.com"

# System timezone
ENV TZ=Asia/Phnom_Penh
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Repositories and packages
RUN yum -y install epel-release && \
    rpm -Uvh https://dl.iuscommunity.org/pub/ius/stable/CentOS/7/x86_64/ius-release-1.0-14.ius.centos7.noarch.rpm

RUN yum -y update && \
    yum -y install \
        php56u \
        php56u-common \
        php56u-snmp \
        php56u-mysqlnd \
        php56u-ldap \
        php56u-cli \
        httpd \
	unzip \
	wget &&\
    yum clean all

# Download IPPlan version 4.92b
RUN cd /usr/src/ && \
    wget https://nchc.dl.sourceforge.net/project/iptrack/ipplan-win/Release%204.92/ipplan-4.92b.zip && \
    unzip ipplan-4.92b.zip && \
    rm -rf ipplan-4.92b.zip && \
    mkdir /var/spool/ipplanuploads && \
    mkdir /tmp/{dns,dhcp} && \
    chown -R apache.apache /var/spool/ipplanuploads /tmp/{dns,dhcp}

# Copy run-httpd script to image
ADD ./conf.d/run-httpd.sh /run-httpd.sh
RUN chmod -v +x /run-httpd.sh

EXPOSE 80 443

CMD ["/run-httpd.sh"]

