FROM ubuntu:jammy
SHELL ["/usr/bin/bash", "-c"]
ENV LANG=en_US.UTF-8
ENV HOSTNAME="Jammy"
ENV USER=ubuntu PASSWORD="!2345678a" GID=1001 UID=1001
ENV NX_PUBLICKEY=""

# Update package lists and installing essential packages

## Packages have been removed:
# - cups: printing services (not necessary for a virtual desktop)
# - xterm: (terminal softwares) already have
# - winbind: a client-side service that resolves user and group information on a Windows server, and allows Oracle Linux to understand Windows users and groups: not necessary for linux based OS'

## Packages (after my research), should have:
# - xvfb: X virtual framebuffer, enables you to execute programs headlessly in the background without displaying actual processing
# - zenity: a powerful command-line utility in Linux that enables the creation of graphical dialog boxes and forms within shell scripts and terminal sessions

RUN apt-get update \
    && DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends \
        apt-transport-https \
        ca-certificates \
        cabextract \
        cron \
        dbus-x11 \
        git \
        gnupg \
        gosu \
        gpg-agent \
        ssh \
        htop \
        locales \
        nano \
        net-tools \
        iputils-ping \
        p7zip \
        pavucontrol \
        pulseaudio \
        pulseaudio-utils \
        software-properties-common \
        sudo \
        tzdata \
        unzip \
        vim \
        wget \
        curl \
        psmisc \
        x11-xserver-utils \
        xfce4 \
        xfce4-goodies \
        xfce4-pulseaudio-plugin \
        terminator \
        tmux \
        xubuntu-icon-theme \
        xvfb \
        zenity \
        && apt remove snapd -y \
        && rm -rf /var/lib/apt/lists/* \
        && apt-get clean; apt-get autoremove -y; apt-get autoclean \
        && locale-gen en_US.UTF-8 


## It's maybe used to allow mutiple pulse instances?
RUN sed -i -E 's/^; autospawn =.*/autospawn = yes/' /etc/pulse/client.conf \
    && [ -f /etc/pulse/client.conf.d/00-disable-autospawn.conf ] \
    && sed -i -E 's/^(autospawn=.*)/# \1/' /etc/pulse/client.conf.d/00-disable-autospawn.conf || echo ""


# Download and install additional applications
WORKDIR /tmp/

## Install and configure nomachine server
RUN curl -fSL "https://www.nomachine.com/free/linux/64/deb" -o nomachine.deb && dpkg -i nomachine.deb && rm -f nomachine.deb \
    && sed -i -e "s|#EnableClipboard both|EnableClipboard both|g" \
    -e "s|#EnableUPnP none|EnableUPnP NXUDP|g" \
    -e "s|#NXUDPPort 4000|NXUDPPort 4000|g" \
    -e "s|#DisplayGeometry .*|DisplayGeometry 1600x900|g" \
    -e "s|#EnableLockScreen 0|EnableLockScreen 1|g" \
    -e "s|#VirtualDesktopAccess administrator,trusted,owner,system|VirtualDesktopAccess administrator,trusted,owner|g" \
    -e "s|#VirtualDesktopAccessNoAcceptance administrator,trusted,owner|VirtualDesktopAccessNoAcceptance administrator,trusted,owner|g" \
    -e "s|#PhysicalDesktopAccess .*|PhysicalDesktopAccess administrator,trusted,owner|g" \
    -e "s|#PhysicalDesktopAccessNoAcceptance .*|PhysicalDesktopAccessNoAcceptance administrator,trusted,owner|g" \
    -e "s|#EnableClientAutoreconnect .*|EnableClientAutoreconnect NX,SSH|g" \
    -e "s|#AcceptedAuthenticationMethods .*|AcceptedAuthenticationMethods NX-private-key|g" \
    /usr/NX/etc/server.cfg


## Install Firefox for Linux from Mozilla PPA
RUN add-apt-repository ppa:mozillateam/ppa -y && cat <<'FOT' > /etc/apt/preferences.d/mozilla-firefox && cat <<'FOT2' > /etc/apt/apt.conf.d/51unattended-upgrades-firefox && apt update && DEBIAN_FRONTEND="noninteractive" apt install firefox -y --no-install-recommends && rm -rf /var/lib/apt/lists/* && apt-get clean; apt-get autoremove -y; apt-get autoclean
Package: *
Pin: release o=LP-PPA-mozillateam
Pin-Priority: 1001
FOT
Unattended-Upgrade::Allowed-Origins:: "LP-PPA-mozillateam:jammy";
FOT2


## Install Chromium-based browser(s)

### GoogleChrome
# RUN apt-get update && wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
#     && sudo apt install -y ./google-chrome-stable_current_amd64.deb; \
#     sudo apt install --assume-yes --fix-broken --no-install-recommends; \
#     rm -f google-chrome-stable_current_amd64.deb \
#     && rm -rf /var/lib/apt/lists/* \
#     && apt-get clean; apt-get autoclean

### Vivaldi
RUN lastest_stable_vivaldi_browser_version=$(curl -sL repo.vivaldi.com/stable/deb/pool/main/ | grep -Eo "[A-Za-z0-9\._-]*(\.deb)" | grep stable | grep amd64 | sort -u | tail -1) \
    \
    && apt-get update; \
    wget -O vivaldi-stable_amd64.deb https://repo.vivaldi.com/stable/deb/pool/main/${lastest_stable_vivaldi_browser_version} \
    && sudo apt install -y ./vivaldi-stable_amd64.deb; \
    sudo apt install --assume-yes --fix-broken --no-install-recommends; \
    rm -f vivaldi-stable_amd64.deb \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean; apt-get autoclean 

### Brave
# RUN curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg && \
#     echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"| tee /etc/apt/sources.list.d/brave-browser-release.list && \
#     apt update; apt install -y brave-browser --no-install-recommends \
#     && rm -rf /var/lib/apt/lists/* \
#     && apt-get clean; apt-get autoclean


## Some utilities
### Quick file sharing
RUN curl https://getcroc.schollz.com | bash; \
    wget -qO - portal.spatiumportae.com | bash


# Copy my own files


EXPOSE 4000
VOLUME [/home/nomachine]

# post-script and entrypoint
WORKDIR /
ADD --chmod=755 nxserver.sh / 
ENTRYPOINT ["/nxserver.sh"]
