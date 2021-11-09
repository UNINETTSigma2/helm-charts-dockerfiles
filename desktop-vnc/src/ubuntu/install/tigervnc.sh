#!/usr/bin/env bash
set -e

echo "Install TigerVNC server"

#wget -O- https://dl.bintray.com/tigervnc/stable/tigervnc-1.8.0.x86_64.tar.gz | tar xz --strip 1 -C /
wget -O- https://downloads.sourceforge.net/project/tigervnc/stable/1.10.0/tigervnc-1.10.0.x86_64.tar.gz | tar xz --strip 1 -C /
