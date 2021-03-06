FROM centos:7

RUN yum update -y

ADD yum.repos.d/* /etc/yum.repos.d/

RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
    gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 7568D9BB55FF9E5287D586017AE645C0CF8E292A && \
    gpg --armor --export 7568D9BB55FF9E5287D586017AE645C0CF8E292A > key.tmp; rpm --import key.tmp; rm -f key.tmp

RUN yum -y install pritunl

ADD pritunl-wrapper.sh /root/bin/
RUN chmod +x /root/bin/pritunl-wrapper.sh

CMD [ "/root/bin/pritunl-wrapper.sh" ]

