# A Jenkins slave, ready to run with the dslabci.epfl.ch

FROM ubuntu:trusty
MAINTAINER Jonas Wagner <jonas.wagner@epfl.ch>

# Make sure the package repository is up to date.
RUN apt-get update

# Install a basic SSH server
RUN apt-get install -y openssh-server

# Install JDK 7
RUN apt-get install -y --no-install-recommends openjdk-7-jdk

# Add user jenkins to the image
RUN adduser --disabled-password jenkins

# Allow SSH login for the jenkins user
ADD jenkins/ssh /home/jenkins/.ssh
RUN chown -R jenkins:jenkins /home/jenkins/.ssh
RUN chmod 700 /home/jenkins/.ssh
RUN chmod 600 /home/jenkins/.ssh/authorized_keys

# Expose SSH port
EXPOSE 22
