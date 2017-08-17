## Modified by Sam KUON - 17/08/2017
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
	php56u-gmp \
        httpd \
	unzip \
        mod_ldap \
	wget &&\
    yum clean all

# Set PHP Timezone
RUN sed -i '890idate.timezone = "Asia/Phnom_Penh"' /etc/php.ini

# Download IPPlan version 4.92b
RUN cd /usr/src/ && \
    wget https://nchc.dl.sourceforge.net/project/iptrack/ipplan-win/Release%204.92/ipplan-4.92b.zip && \
    unzip ipplan-4.92b.zip && \
    rm -rf ipplan-4.92b.zip && \
    mkdir /var/spool/ipplanuploads && \
    mkdir /tmp/{dns,dhcp} && \
    chown -R apache.apache /var/spool/ipplanuploads /tmp/{dns,dhcp}

# Allow user access for IPPlan authentication
RUN echo $'<Directory /var/www/html/user>\n\
AllowOverride All\n\
</Directory>\n'\
>> /etc/httpd/conf/httpd.conf

# Copy run-httpd script to image
ADD ./conf.d/run-httpd.sh /run-httpd.sh
RUN chmod -v +x /run-httpd.sh

EXPOSE 80 443

CMD ["/run-httpd.sh"]

