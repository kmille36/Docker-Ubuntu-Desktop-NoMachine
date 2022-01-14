# Docker-Ubuntu-Desktop-NoMachine
Ubuntu Desktop on NoMachine

Base on Ubuntu 18.04 / Ubuntu 20.04

NoMachine: https://www.nomachine.com/download

Enviroment vaiables

USER -> user for the nomachine login PASSWORD -> password for the nomachine login

MATE (Ubuntu 18.04):

docker run --rm -d -p 4000:4000 --privileged --name nomachine-mate -e PASSWORD=password -e USER=user --cap-add=SYS_PTRACE --shm-size=1g thuonghai2711/nomachine-ubuntu-desktop:mate

XFCE4 (Ubuntu 18.04):

docker run --rm -d -p 4000:4000 --privileged --name nomachine-xfce4 -e PASSWORD=password -e USER=user --cap-add=SYS_PTRACE --shm-size=1g thuonghai2711/nomachine-ubuntu-desktop:xfce4
