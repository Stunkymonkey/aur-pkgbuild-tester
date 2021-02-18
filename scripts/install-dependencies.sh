#!/bin/bash
set -e
cd /opt/pkgdir
DEPS=`cat PKGBUILD | grep depends | awk -F'[()]' '{print $2}' | tr '\n' ' ' | tr -d "'" | tr -d '"' `
yay -S $DEPS --noconfirm
