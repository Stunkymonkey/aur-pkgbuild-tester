#!/bin/bash
set -e
cd /opt/pkgdir
makepkg -fs --noconfirm
makepkg --printsrcinfo > .SRCINFO

