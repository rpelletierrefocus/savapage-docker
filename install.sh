ENV SAVA_VERSION=1.2.0-rc



apt-get update && \
    apt-get -y install cups cups-bsd poppler-utils qpdf imagemagick wget gnupg \
    software-properties-common avahi-daemon avahi-discover libnss-mdns \
    binutils wget curl supervisor openssh-server git

apt-get install cpio openjdk-11-jdk -y

useradd -r savapage && \
    mkdir -p /opt/savapage && \
    chown savapage:savapage /opt/savapage && \
    usermod -s /bin/bash savapage && \
    usermod -d /opt/savapage savapage && \
    mkdir -p /run/sshd 
    
systemctl stop cups.service 

git clone https://github.com/rpelletierrefocus/savapage-docker.git && \    
    cd savapage-docker

cp /etc/cups/cupsd.conf ./cupsd.conf.bak

cp config/cupsd.conf /etc/cups/cupsd.conf

cp config/cups-browsed.conf /etc/cups/cups-browsed.conf

echo a4 > /etc/papersize
COPY config/papersize /etc/papersize

RUN mkdir -p /opt/savapage && cd /opt/savapage && \
    wget https://www.savapage.org/download/snapshots/savapage-setup-${SAVA_VERSION}-linux-x64.bin -O savapage-setup-linux.bin && \
    chown savapage:savapage /opt/savapage && \
    chmod +x savapage-setup-linux.bin

RUN su savapage sh -c "/opt/savapage/savapage-setup-linux.bin -n" && \
    /opt/savapage/MUST-RUN-AS-ROOT

CMD ["/usr/bin/supervisord"]

# CMD ["/bin/bash"]
