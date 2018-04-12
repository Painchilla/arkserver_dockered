FROM debian:stretch-slim
#Update stuff:
RUN apt-get update \
    && apt upgrade -y \
    && dpkg --add-architecture i386 \
    && apt-get install -y lib32gcc1 steamcmd

##Install SteamCMD
#RUN mkdir /usr/local/steam \
#    && cd /usr/local/steam \
#    && wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz \
#    && tar -xvzf steamcmd_linux.tar.gz

#Now install ARK Survival Evolved
RUN mkdir -p /srv/ARK \
    && steamcmd +login anonymous +force_install_dir /srv/ARK +app_update 376030 +quit

#Preemptive Bugfixing 
RUN cat "fs.file-max=100000" >> /etc/sysctl.conf \
    && sysctl -p /etc/sysctl.conf \
    && cat "*               soft    nofile          1000000" >> /etc/security/limits.conf \
    && cat "*               hard    nofile          1000000" >> /etc/security/limits.conf \
    && cat "session required pam_limits.so" >> /etc/pam.d/common-session
    