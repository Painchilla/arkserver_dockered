#Use Debian Buster as base
FROM debian:buster-slim

##Update Packages and install 32bit gcc, wget and htop.
RUN apt-get update \
    && apt upgrade -y \
    && dpkg --add-architecture i386 \
    && apt-get install -y lib32gcc1 wget htop \
    && apt autoclean \
    && rm -r /var/cache/apt
    

##Install SteamCMD
RUN mkdir /usr/local/steam \
    && cd /usr/local/steam \
    && wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz \
    && tar -xzf steamcmd_linux.tar.gz 

##Install ARK Survival Evolved
RUN mkdir -p /srv/ARK \
    && /usr/local/steam/steamcmd.sh \
        +force_install_dir /srv/ARK +app_update 376030 \
        +login anonymous \
        +quit

##Mountpoint for Mods-Folder: /srv/ARK/ShooterGame/Content/Mods (Make Sure Ragnarok and TheCenter are installed if needed)
##Mountpoint for Config-Files: /srv/ARK/ShooterGame/Saved/Config/LinuxServer/GameUserSettings.ini
##Mountpoint for Backup of Gamefiles: /srv/ARK/ShooterGame/Saved/SavedArks

#Create volume for ARK-saves.
VOLUME /srv/ARK/ShooterGame/Saved/SavedArks

#Expose all needed ports
EXPOSE 27015/udp
EXPOSE 7778/udp
EXPOSE 27020/tcp

#Start server
ENTRYPOINT ["/srv/ARK/ShooterGame/Binaries/Linux/ShooterGameServer"]
CMD ["TheIsland?listen?SessionName=DockeredARK?ServerAdminPassword=AdW1nP@55w0rD!?MaxPlayers=24"]
