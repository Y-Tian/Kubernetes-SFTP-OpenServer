FROM centos:7

RUN yum update -y;
RUN yum install openssh-server -y
RUN mkdir /var/run/sshd
RUN ssh-keygen -A
# Login as root user
RUN echo 'root:test' | chpasswd
# Initial set-up
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
# Add basic user and change home directory to <ANY_DIR>
RUN adduser temp
RUN echo 'sftp:Pass1' | chpasswd
RUN usermod -d /$ANY_DIR temp

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
