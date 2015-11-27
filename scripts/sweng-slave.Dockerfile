# Additional configuration to set a SwEng build host.
# Build using:
# $ docker build -t sjlver/sweng-slave -f scripts/sweng-slave.Dockerfile .
FROM sjlver/jenkins-slave

# Create a kvm group, and add the jenkins user. Note that this needs to have
# the same GID as the group on the host.
RUN addgroup --gid 111 kvm && \
    adduser jenkins kvm

# The following is heavily inspired from:
# https://hub.docker.com/r/aluedeke/appium-android/~/dockerfile/

# Install Android SDK dependencies...
# ... and other packages that teams commonly use
RUN apt-get install apt-transport-https && \
    echo "deb https://dl.bintray.com/sbt/debian /" > /etc/apt/sources.list.d/sbt.list && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 642AC823 && \
    apt-get update && \
    apt-get install -y --no-install-recommends lib32z1 lib32ncurses5 g++-multilib unzip \
                                               maven ant sbt
    
# Install the Android SDK.
ENV ANDROID_HOME /home/jenkins/tools/android-sdk
USER jenkins
RUN wget -qO- "http://dl.google.com/android/android-sdk_r24.3.4-linux.tgz" | \
    tar -zxv -C /tmp/ && \
    rm -rf $ANDROID_HOME && \
    mkdir -p $( dirname $ANDROID_HOME ) && \
    mv /tmp/android-sdk-linux $ANDROID_HOME
RUN ( while true; do sleep 1; echo y; done ) | $ANDROID_HOME/tools/android update sdk -u -a -t platform-tool && \
    ( while true; do sleep 1; echo y; done ) | $ANDROID_HOME/tools/android update sdk -u -a -t tool && \
# Android sometimes fails to update tools... sigh...
    ( set -e; cd $ANDROID_HOME; if [ -f temp/tools_*-linux.zip ]; then rmdir tools; unzip temp/tools_*-linux.zip; rm temp/*; fi ) && \
    ( while true; do sleep 1; echo y; done ) | $ANDROID_HOME/tools/android update sdk -u -a -t build-tools-23.0.2,build-tools-23.0.1,extra-android-m2repository,extra-google-m2repository && \
    ( while true; do sleep 1; echo y; done ) | $ANDROID_HOME/tools/android update sdk -u -a -t android-23,addon-google_apis-google-23,sys-img-x86_64-addon-google_apis-google-23 

# Install Gradle
ENV GRADLE_HOME /home/jenkins/tools/gradle-2.7
RUN wget -q -O "/tmp/gradle-2.7-all.zip" "https://services.gradle.org/distributions/gradle-2.7-all.zip" && \
    cd $( dirname $GRADLE_HOME ) && \
    unzip "/tmp/gradle-2.7-all.zip" && \
    rm "/tmp/gradle-2.7-all.zip"

# Expose SSH port
EXPOSE 22

# Run SSH; that's all :)
USER root
CMD /usr/sbin/sshd -D
