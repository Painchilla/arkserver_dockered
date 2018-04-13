FROM debian:stretch

ENV ARK_SERVER_NAME=DockeredARK
ENV ARK_SERVER_MAP=TheIsland
ENV ARK_SERVER_ADMINPW=AdW1nP@55w0rD!
ENV ARK_SERVER_MAXPLAYERS=12

##Update stuff:
RUN apt-get update \
    && apt upgrade -y \
    && dpkg --add-architecture i386 \
    && apt-get install -y lib32gcc1 wget

##Install SteamCMD
RUN mkdir /usr/local/steam \
    && cd /usr/local/steam \
    && wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz \
    && tar -xvzf steamcmd_linux.tar.gz

##Now install ARK Survival Evolved
RUN mkdir -p /srv/ARK \
    && /usr/local/steam/steamcmd.sh +login anonymous +force_install_dir /srv/ARK +app_update 376030 +quit

#Preemptive Bugfixing 
#RUN echo "fs.file-max=100000" >> /etc/sysctl.conf \
#    && sysctl -p /etc/sysctl.conf \
#    && echo "*               soft    nofile          1000000" >> /etc/security/limits.conf \
#    && echo "*               hard    nofile          1000000" >> /etc/security/limits.conf \
#&& echo "session required pam_limits.so" >> /etc/pam.d/common-session

##Mountpoint for Mods-Folder: /srv/ARK/ShooterGame/Content/Mods (Make Sure Ragnarok and TheCenter and 11111 Mod are installed)
##Mountpoint for Config-Files: /srv/ARK/ShooterGame/Saved/Config/LinuxServer/GameUserSettings.ini
##Mountpoint for Backup of Gamefiles: /srv/ARK/ShooterGame/Saved/SavedArks

#Auslagern der SaveGames in eigenes Volume, sodass diese nicht verloren Gehen!
VOLUME /srv/ARK/ShooterGame/Saved/SavedArks
#Auslagern der Config-Files in eigenes Volume
VOLUME /srv/ARK/ShooterGame/Saved/Config/LinuxServer

#Portfreigaben
EXPOSE 27015/udp
EXPOSE 7778/udp
EXPOSE 27020/tcp

#Starten des Servers
ENTRYPOINT ["/srv/ARK/ShooterGame/Binaries/Linux/ShooterGameServer"]
CMD ["$ARK_SERVER_MAP?listen?SessionName=$ARK_SERVER_NAME?ServerAdminPassword=$ARK_SERVER_ADMINPW?MaxPlayers=$ARK_SERVER_MAXPLAYERS"]