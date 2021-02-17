#!/bin/bash
set -e
# Create user
useradd -m -g wheel -s /bin/sh tester
echo "tester ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
chown -R tester:wheel /opt/pkgdir
# Install makepkg deps
pacman -Sy
# Build the package as `tester' user
su - tester /opt/scripts/build-pkg.sh
# Install the package
cd /opt/pkgdir
pacman -U *.tar.zst --noconfirm
# Run the test
bash /opt/test.sh
