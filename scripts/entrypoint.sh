#!/bin/bash
set -e
# Create user. uid/gid 1000 is mapped to the host user (podman --userns=keep-id),
# so files written to /opt/pkgdir end up owned by the host user.
groupadd -g 1000 tester
useradd -m -u 1000 -g tester -G wheel -s /bin/sh tester
echo "tester ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
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
