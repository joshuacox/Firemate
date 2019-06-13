FROM ubuntu:precise

ENV LANG en-US
ENV NICENESS 19
ENV LINKS http://foundation.webhosting.coop

#RUN apt-get update
#RUN apt-cache search java |grep plugin; sleep 10
RUN apt-get update && apt-get install -y \
	dirmngr \
	gnupg \
	--no-install-recommends \
	&& apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 0AB215679C571D1C8325275B9BDB3D89CE49EC21 \
	&& echo "deb http://ppa.launchpad.net/mozillateam/firefox-next/ubuntu xenial main" >> /etc/apt/sources.list.d/firefox.list \
	&& apt-get update && apt-get install -y \
	ca-certificates \
        bzip2 \
        curl \
	hicolor-icon-theme \
	libasound2 \
	libgl1-mesa-dri \
	libgl1-mesa-glx \
	libpulse0 \
        openjdk-7-jdk \
        icedtea-plugin \
        firefox=11.0+build1-0ubuntu4 \
	--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

COPY local.conf /etc/fonts/local.conf

RUN mkdir -p /etc/firefox && echo 'pref("browser.tabs.remote.autostart", false);' >> /etc/firefox/syspref.js

LABEL maintainer "Josh Cox <josh@webhosting.coop>"

RUN useradd firefox \
  && mkdir -p /home/firefox \
  && chown firefox. /home/firefox \
  && chmod 700 /home/firefox
USER firefox
WORKDIR /home/firefox
RUN curl -sL https://ftp.mozilla.org/pub/firefox/releases/21.0/linux-x86_64/en-US/firefox-21.0.tar.bz2 | tar jxfp -
WORKDIR /home/firefox/firefox

COPY start.sh /start.sh
ENTRYPOINT [ "/start.sh" ]
