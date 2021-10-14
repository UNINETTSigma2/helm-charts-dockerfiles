#!/usr/bin/env bash
set -e

echo "Install TigerVNC server"
wget -O- https://sourceforge.net/projects/tigervnc/files/stable/tigervnc-1.11.0.x86_64.tar.gz | tar xz --strip 1 -C /


