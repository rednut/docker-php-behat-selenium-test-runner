FROM million12/nginx-php:latest
MAINTAINER Marcin Ryzycki marcin@m12.io

# Install java, Xvfb, x11vnc server and firefox
# Download Selenium Standalone Server
# Remove supervisord configs for nginx and php - we don't need to run them in this container
# (but we need PHP configuration to run Behat tests)
RUN \
  yum install -y java-1.7.0-openjdk-headless xorg-x11-server-Xvfb x11vnc firefox && \
  yum clean all && \
  curl -sSL -o /usr/bin/selenium-server-standalone.jar http://selenium-release.storage.googleapis.com/2.45/selenium-server-standalone-2.45.0.jar && \
  rm -f /etc/supervisor.d/nginx.conf /etc/supervisor.d/php-fpm.conf
  

# grab latest google chrome
ADD https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm /root/google-chrome-stable_current_x86_64.rpm
RUN yum -y install /root/google-chrome-stable_current_x86_64.rpm; yum clean all
#
RUN dbus-uuidgen > /etc/machine-id
#
#

# Chrome Driver
RUN wget https://chromedriver.storage.googleapis.com/2.8/chromedriver_linux64.zip
RUN unzip chromedriver_linux64.zip && rm chromedriver_linux64.zip && mv chromedriver /usr/bin && chmod 755 /usr/bin/chromedriver


# ----
RUN rm -f /opt/google/chrome/chrome-sandbox
RUN wget https://googledrive.com/host/0B5VlNZ_Rvdw6NTJoZDBSVy1ZdkE -O /opt/google/chrome/chrome-sandbox
RUN chown root:root /opt/google/chrome/chrome-sandbox && chmod 4755 /opt/google/chrome/chrome-sandbox && md5sum /opt/google/chrome/chrome-sandbox


RUN useradd jenkins -m -s /bin/bash
#RUN mv /selenium-server-standalone-2.44.0.jar /home/jenkins
#RUN chown jenkins:jenkins /home/jenkins/selenium-server-standalone-2.44.0.jar
RUN mkdir /.pki && chown jenkins:jenkins /.pki && mkdir /.local && chown jenkins:jenkins /.local
#USER jenkins
WORKDIR /home/jenkins
# -----


ADD container-files /

ENV \
  SCREEN_DIMENSION=1600x1000x24 \
  VNC_PASSWORD=password

EXPOSE 4444 5900
