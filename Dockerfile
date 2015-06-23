FROM ubuntu:latest
ENV DEBIAN_FRONTEND=noninteractive

# Make sure the package repository is up to date.
RUN apt-get update
RUN apt-get -y upgrade

# Install a basic SSH server
RUN apt-get install -y openssh-server
RUN sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd
RUN mkdir -p /var/run/sshd

# Install JDK 7 (latest edition)
RUN apt-get install -y openjdk-7-jdk

# Add user jenkins to the image
RUN adduser --quiet jenkins
# Set password for the jenkins user (you may want to alter this).
RUN echo "jenkins:jenkins" | chpasswd


MAINTAINER Stuart Nixon <stuart@rednut.net>


# Install java, Xvfb, x11vnc server and firefox
# Download Selenium Standalone Server
# Remove supervisord configs for nginx and php - we don't need to run them in this container
# (but we need PHP configuration to run Behat tests)
RUN \
  apt-get install -y openjdk-7-jre-headless xvfb x11vnc firefox curl wget supervisor php5-dev php-pear php5-cli git subversion 
#  apt-get install -y java-1.7.0-openjdk-headless xorg-x11-server-Xvfb x11vnc firefox curl wget supervisord php php-pear php5-cli && \


RUN  curl -sSL -o /usr/bin/selenium-server-standalone.jar http://selenium-release.storage.googleapis.com/2.45/selenium-server-standalone-2.45.0.jar

#RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -o /tmp/
#RUN dpkg -i /tmp/google-chrome-stable_current_amd64.deb


# grab latest google chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
RUN echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list
RUN apt-get update && apt-get install -y google-chrome-stable unzip


#RUN curl -sSL -o /root/google-chrome-stable_current_x86_64.rpm https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm && \
#    yum -y install /root/google-chrome-stable_current_x86_64.rpm; \
#    yum clean all; \
RUN    dbus-uuidgen > /etc/machine-id



#
#

# Chrome Driver
RUN curl -sSL -o /root/chromedriver_linux64.zip https://chromedriver.storage.googleapis.com/2.8/chromedriver_linux64.zip && \
    cd /root ; unzip chromedriver_linux64.zip && rm chromedriver_linux64.zip && mv chromedriver /usr/bin && chmod 755 /usr/bin/chromedriver


# ----
RUN rm -f /opt/google/chrome/chrome-sandbox
RUN wget https://googledrive.com/host/0B5VlNZ_Rvdw6NTJoZDBSVy1ZdkE -O /opt/google/chrome/chrome-sandbox
RUN chown root:root /opt/google/chrome/chrome-sandbox && chmod 4755 /opt/google/chrome/chrome-sandbox && md5sum /opt/google/chrome/chrome-sandbox
#

# install php composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin


#RUN useradd jenkins -m -s /bin/bash
#RUN mv /selenium-server-standalone-2.44.0.jar /home/jenkins
#RUN chown jenkins:jenkins /home/jenkins/selenium-server-standalone-2.44.0.jar
RUN mkdir /.pki && chown jenkins:jenkins /.pki && mkdir /.local && chown jenkins:jenkins /.local
#USER jenkins
WORKDIR /home/jenkins
# -----

# Standard SSH port
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]


ADD container-files /

ENV \
  SCREEN_DIMENSION=1600x1000x24 \
  VNC_PASSWORD=password

EXPOSE 4444 5900

