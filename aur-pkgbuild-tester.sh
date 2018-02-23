#!/bin/bash
set -e
DATADIR=$(readlink -f $1)
TESTER=$(readlink -f scripts/default.sh)
if [ ! -z "$2" ]; then
    TESTER=$(readlink -f $2)
fi
if [ ! -d "$DATADIR" ]; then
    echo "First argument must be a directory"
    exit 1
fi

if [ -d "$TESTER" ]; then
    echo "Second argument must not be a directory"
    exit 1
fi
docker run --rm -it \
    -v "$DATADIR/:/opt/pkgdir" \
    -v "$TESTER:/opt/test.sh" \
    -v "$(pwd)/scripts:/opt/scripts" \
    base/archlinux \
    /opt/scripts/entrypoint.sh
