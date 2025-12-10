#!/bin/bash
set -e
cd /opt/pkgdir
DEPS=$(sed -n '/^depends=/{:a; n; /)/q; p; ba}' PKGBUILD \
    | tr -d '"'\''"' \
    | tr '\n' ' ')
yay -S $DEPS --noconfirm --overwrite '*'

