FROM centos
RUN rpm --import http://download.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7
RUN rpm --import https://rpms.remirepo.net/RPM-GPG-KEY-remi
RUN yum update -y
RUN yum install -y deltarpm
RUN yum install -y openssl
RUN yum install -y epel-release
RUN yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm
RUN yum install -y yum-utils
RUN yum install -y vim
RUN yum-config-manager --enable remi-php72
RUN yum install -y php72 php php-cli php-xml php-soap php-mysqli php-pdo php-tidy php-gd php-mbstring php-fpm php-memcache
RUN yum install -y httpd
RUN yum install -y http://dev.mysql.com/get/mysql57-community-release-el7-7.noarch.rpm
RUN yum install -y mysql-community-server
RUN yum install -y vsftpd
EXPOSE  80
EXPOSE  21
CMD ["/usr/sbin/httpd","-D","FOREGROUND"]
CMD ["echo","Image created and configured"]
