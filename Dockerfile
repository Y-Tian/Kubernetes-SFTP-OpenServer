FROM centos:7

RUN yum update -y && yum clean all && \
    yum install -y wget openssh-server openssh-clients sshpass lsof initscripts sudo
RUN wget http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN rpm -ivh epel-release-latest-7.noarch.rpm

COPY sshd_config /etc/ssh/sshd_config

RUN mkdir /var/run/sshd
RUN ssh-keygen -A

RUN groupadd sftpgroup \
    && useradd --home-dir /home/testUser --group sftpgroup --create-home --shell /sbin/nologin testUser \
    && mkdir -p /chroots/testUser/home/testUser/sample \
    && chown -R root:sftpgroup /chroots \
    && chmod 710 /chroots \
    && chmod -R 750 /chroots/testUser \
    && mkdir /chroots/testUser/etc \
    && chgrp sftpgroup /chroots/testUser/etc \ 
    && chmod 710 /chroots/testUser/etc \
    && getent passwd testUser > /chroots/testUser/etc/passwd \
    && echo "root:x:0:0:fakeroot:::" >> /chroots/testUser/etc/passwd \
    && chmod 644 /chroots/testUser/etc/passwd \
    && getent group sftpgroup > /chroots/testUser/etc/group \
    && getent group testUser >> /chroots/testUser/etc/group \
    && chmod 644 /chroots/testUser/etc/group

RUN mkdir -p /chroots/testUser/home/testUser/.ssh \
    && touch /chroots/testUser/home/testUser/.ssh/authorized_keys

RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22

#Entrypoints for kubernetes deployments
#CMD ["/usr/sbin/sshd", "-D"]
