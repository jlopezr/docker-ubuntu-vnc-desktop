FROM ubuntu:17.04
MAINTAINER Juan López <j.lopez.r@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN sed -i 's#http://archive.ubuntu.com/#http://es.archive.ubuntu.com/#' /etc/apt/sources.list

# built-in packages
RUN apt-get update \
    && apt-get install -y --no-install-recommends software-properties-common curl \
    && add-apt-repository ppa:fcwu-tw/ppa \
    && add-apt-repository -y ppa:ubuntu-desktop/ubuntu-make \
    && curl -sL https://deb.nodesource.com/setup_6.x | bash - \
    && apt update \
    && apt install -y --no-install-recommends --allow-unauthenticated \
        supervisor \
        openssh-server pwgen sudo vim \
        net-tools \
        lxde x11vnc xvfb \
        gtk2-engines-murrine ttf-ubuntu-font-family \
        firefox \
        nginx \
        python-pip python-dev build-essential \
        mesa-utils libgl1-mesa-dri \
        gnome-themes-standard gtk2-engines-pixbuf gtk2-engines-murrine \
        arc-theme \
        dbus-x11 x11-utils \
        git maven wget \
        encfs nginx \
        libxtst-dev libssl-dev libjpeg-dev autoconf \
        nodejs tomcat8 ubuntu-make \
    && umake ide idea /opt/idea \
    && apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/* \
    && cd /tmp \
    && wget http://x11vnc.sourceforge.net/dev/x11vnc-0.9.14-dev.tar.gz \
    && gzip -dc x11vnc-0.9.14-dev.tar.gz | tar -xvf - \
    && cd x11vnc-0.9.14 \
    && ./configure --prefix=/usr/local CFLAGS='-g -O2 -fno-stack-protector -Wall' \
    && make \
    && make install \
    && cd /tmp \
    && rm -rf * \
    && cp /usr/local/bin/x11vnc /usr/bin/x11vnc

# tini for subreap
ENV TINI_VERSION v0.9.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /bin/tini
RUN chmod +x /bin/tini

ADD image /
RUN pip install setuptools wheel && pip install -r /usr/lib/web/requirements.txt

EXPOSE 80
WORKDIR /root
ENV HOME=/home/ubuntu \
    SHELL=/bin/bash
ENTRYPOINT ["/startup.sh"]
