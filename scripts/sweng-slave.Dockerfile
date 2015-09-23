# Additional configuration to set a SwEng build host.
# NOTE: Change kvm gid below to match your own configuration!
# Build using:
# $ docker build -t sjlver/sweng-slave -f scripts/sweng-slave.Dockerfile .
FROM sjlver/jenkins-slave

# Create a kvm group, and add the jenkins user. Note that this needs to have
# the same GID as the group on the host.
RUN addgroup --gid 111 kvm
RUN adduser jenkins kvm

# The following is heavily inspired from:
# https://hub.docker.com/r/aluedeke/appium-android/~/dockerfile/

# Install Android SDK dependencies.
RUN apt-get install -y --no-install-recommends openjdk-7-jre-headless lib32z1 lib32ncurses5 lib32bz2-1.0 g++-multilib unzip
RUN apt-get install -y qemu-kvm --no-install-recommends
    
# Install the Android SDK.
ENV ANDROID_HOME /home/jenkins/tools/android-sdk
USER jenkins
RUN wget -qO- "http://dl.google.com/android/android-sdk_r24.3.4-linux.tgz" | \
    tar -zxv -C /tmp/ && \
    rm -rf $ANDROID_HOME && \
    mkdir -p $( dirname $ANDROID_HOME ) && \
    mv /tmp/android-sdk-linux $ANDROID_HOME
RUN ( while true; do sleep 1; echo y; done ) | $ANDROID_HOME/tools/android update sdk -u -a -t platform-tool
RUN ( while true; do sleep 1; echo y; done ) | $ANDROID_HOME/tools/android update sdk -u -a -t tool
# Android sometimes fails to update tools... sigh...
RUN ( set -e; cd $ANDROID_HOME; if [ -f temp/tools_*-linux.zip ]; then rmdir tools; unzip temp/tools_*-linux.zip; rm temp/*; fi )
RUN ( while true; do sleep 1; echo y; done ) | $ANDROID_HOME/tools/android update sdk -u -a -t build-tools-23.0.1,extra-android-m2repository,extra-google-m2repository
# TODO: Alternatively, change x86 to x86_64... need more experimentation on an Intel CPU.
RUN ( while true; do sleep 1; echo y; done ) | $ANDROID_HOME/tools/android update sdk -u -a -t android-23,addon-google_apis-google-23,sys-img-x86-addon-google_apis-google-23 

# NOTE: This fixes a bug that will be addressed in an upcoming release of the emulator.
# https://android-review.googlesource.com/#/c/159194/
# File taken from: https://code.google.com/p/android/issues/detail?id=174557#c10
RUN mv $ANDROID_HOME/tools/lib/pc-bios/bios.bin $ANDROID_HOME/tools/lib/pc-bios/bios.bin.bak
ADD bios.bin $ANDROID_HOME/tools/lib/pc-bios/bios.bin

# Expose SSH port
EXPOSE 22

# Run SSH; that's all :)
USER root
CMD /usr/sbin/sshd -D
