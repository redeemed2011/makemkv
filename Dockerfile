FROM fedora:25
MAINTAINER Robpol86 <robpol86@gmail.com>

RUN dnf update -qy && \
    dnf install -qy \
        https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
        https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm \
    && \
    dnf config-manager --add-repo=http://negativo17.org/repos/fedora-multimedia.repo && \
    dnf install -qy dnf-plugins-core sudo makemkv libaacs libbdplus libdvdcss && \
    dnf clean all && \
    sudo useradd -s /sbin/nologin -G cdrom mkv && \
    sudo -u mkv mkdir /home/mkv/.MakeMKV

RUN mkdir -p /etc/xdg/{aacs,bdplus} && \
  wget -c http://www.labdv.com/aacs/KEYDB.cfg -O /etc/xdg/aacs/KEYDB.cfg && \
  wget -c http://www.labdv.com/aacs/libbdplus/bdplus-vm0.bz2 -O /tmp/bdplus-vm0.bz2 && \
  tar -xvjf /tmp/bdplus-vm0.bz2 -C /etc/xdg/

VOLUME /output
WORKDIR /output
COPY bin/env.sh /
COPY bin/rip.sh /
COPY etc/settings.conf /home/mkv/.MakeMKV/
COPY lib/wrappers.so /

CMD ["/rip.sh"]
