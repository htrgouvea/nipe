#!/usr/bin/env bash

set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "usage: $0 <debian|fedora|opensuse|void|arch>" >&2
  exit 64
fi

distro="$1"

case "$distro" in
  debian)
    image="debian:stable-slim"
    shell="sh"
    bootstrap='
      set -eu
      apt-get update
      DEBIAN_FRONTEND=noninteractive apt-get install -y \
        bash \
        perl \
        cpanminus \
        gcc \
        make \
        iptables \
        tor \
        curl \
        ca-certificates \
        zlib1g-dev \
        libssl-dev \
        libio-socket-ssl-perl \
        libnet-ssleay-perl
    '
    ;;
  fedora)
    image="fedora:latest"
    shell="sh"
    bootstrap='
      set -eu
      dnf -y install \
        bash \
        perl \
        perl-App-cpanminus \
        gcc \
        make \
        iptables \
        tor \
        curl \
        ca-certificates \
        openssl-devel \
        perl-IO-Socket-SSL \
        perl-Net-SSLeay
    '
    ;;
  opensuse)
    image="opensuse/tumbleweed:latest"
    shell="sh"
    bootstrap='
      set -eu
      zypper --non-interactive refresh
      zypper --non-interactive install \
        bash \
        perl \
        perl-App-cpanminus \
        gcc \
        make \
        iptables \
        tor \
        curl \
        ca-certificates \
        libopenssl-devel \
        perl-IO-Socket-SSL \
        perl-Net-SSLeay
    '
    ;;
  void)
    image="ghcr.io/void-linux/void-linux:latest"
    shell="sh"
    bootstrap='
      set -eu
      xbps-install -Suy xbps
      xbps-install -Sy \
        bash \
        perl \
        perl-App-cpanminus \
        gcc \
        make \
        iptables \
        tor \
        curl \
        ca-certificates \
        openssl-devel \
        perl-IO-Socket-SSL \
        perl-Net-SSLeay
    '
    ;;
  arch)
    image="archlinux:latest"
    shell="sh"
    bootstrap='
      set -eu
      pacman -Sy --noconfirm archlinux-keyring
      pacman -S --noconfirm --needed \
        bash \
        perl \
        perl-app-cpanminus \
        gcc \
        make \
        iptables \
        tor \
        curl \
        ca-certificates \
        openssl \
        perl-io-socket-ssl \
        perl-net-ssleay
    '
    ;;
  *)
    echo "unsupported distro: $distro" >&2
    exit 64
    ;;
esac

docker run --rm --privileged \
  -v "$PWD":/workspace \
  -w /workspace \
  "$image" \
  "$shell" -lc "
    $bootstrap
    cpanm --notest --installdeps --with-test .
    perl nipe.pl install
    perl nipe.pl status
    prove -lr tests
  "
