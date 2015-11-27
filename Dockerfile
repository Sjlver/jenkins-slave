# A Jenkins slave, ready to run with the dslabci.epfl.ch

# To use this, run it as
# $ docker.io run -d -P sjlver/jenkins-slave
# $ docker.io ps -a
# Note the port. Add a Jenkins slave with that hostname and port.

FROM ubuntu:wily
MAINTAINER Jonas Wagner <jonas.wagner@epfl.ch>

# Set the env variables to non-interactive
ENV DEBIAN_FRONTEND noninteractive
ENV DEBIAN_PRIORITY critical

# Make sure the package repository is up to date.
RUN apt-get update

# Install a basic SSH server
RUN apt-get install -y openssh-server && \
    mkdir -p /var/run/sshd

# Install JDK 8
RUN apt-get install -y --no-install-recommends openjdk-8-jdk

# Add user jenkins to the image
RUN adduser --disabled-password jenkins

# Allow SSH login for the jenkins user
ADD jenkins/ssh /home/jenkins/.ssh

# Git/Mercurial configuration
RUN apt-get install -y --no-install-recommends git mercurial
ADD jenkins/gitconfig /home/jenkins/.gitconfig
ADD jenkins/hgrc /home/jenkins/.hgrc

# Allow sudo for the jenkins user
RUN apt-get install -y --no-install-recommends sudo
ADD etc/sudoers.d/jenkins /etc/sudoers.d/jenkins

# Fix owners and permissions
RUN chown -R jenkins:jenkins /home/jenkins && \
    chown -R root:root /etc/sudoers.d && \
    chmod 700 /home/jenkins/.ssh && \
    chmod 600 /home/jenkins/.ssh/authorized_keys && \
    chmod 600 /etc/sudoers.d/jenkins

# Expose SSH port
EXPOSE 22

# Run SSH; that's all :)
CMD /usr/sbin/sshd -D
