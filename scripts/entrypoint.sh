#!/bin/bash
set -e
# Create user
useradd -m -g wheel -s /bin/sh tester
echo "tester ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
chown -R tester:wheel /opt/pkgdir
# remove old package files
cd /opt/pkgdir
rm -f *.tar.zst
# Install makepkg deps
pacman -Sy git --noconfirm
# install yay
su - tester /opt/scripts/install-yay.sh
# install dependencies
su - tester /opt/scripts/install-dependencies.sh
# Build the package as `tester' user
su - tester /opt/scripts/build-pkg.sh
# Install the package
cd /opt/pkgdir
pacman -U *.tar.zst --noconfirm
# Run the test
bash /opt/test.sh
