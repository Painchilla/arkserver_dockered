FROM debian:stretch-slim

##Update stuff:
RUN apt-get update \
    && apt upgrade -y \
    && dpkg --add-architecture i386 \
    && apt-get install -y lib32gcc1 wget htop

##Install SteamCMD
RUN mkdir /usr/local/steam \
    && cd /usr/local/steam \
    && wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz \
    && tar -xzf steamcmd_linux.tar.gz

##Now install ARK Survival Evolved
RUN mkdir -p /srv/ARK \
    && /usr/local/steam/steamcmd.sh \
        +login anonymous \
        +force_install_dir /srv/ARK +app_update 376030 \
        +quit

##Mountpoint for Mods-Folder: /srv/ARK/ShooterGame/Content/Mods (Make Sure Ragnarok and TheCenter are installed if needed)
##Mountpoint for Config-Files: /srv/ARK/ShooterGame/Saved/Config/LinuxServer/GameUserSettings.ini
##Mountpoint for Backup of Gamefiles: /srv/ARK/ShooterGame/Saved/SavedArks

#Auslagern der SaveGames in eigenes Volume, sodass diese nicht verloren Gehen!
VOLUME /srv/ARK/ShooterGame/Saved/SavedArks

#Portfreigaben
EXPOSE 27015/udp
EXPOSE 7778/udp
EXPOSE 27020/tcp

#Starten des Servers
ENTRYPOINT ["/srv/ARK/ShooterGame/Binaries/Linux/ShooterGameServer"]
CMD ["TheIsland?listen?SessionName=DockeredARK?ServerAdminPassword=AdW1nP@55w0rD!?MaxPlayers=24"]