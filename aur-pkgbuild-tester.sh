#!/usr/bin/env bash
set -e
SCRIPTDIR=$(dirname "$(readlink -f "$0")")
DATADIR=$(readlink -f $1)
TESTER="$SCRIPTDIR/scripts/default-noop-tester.sh"
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
podman pull docker.io/library/archlinux:base-devel
TTY_ARGS=()
if [ -t 0 ]; then
    TTY_ARGS=(-it)
fi
podman run --rm "${TTY_ARGS[@]}" \
    --userns=keep-id:uid=1000,gid=1000 \
    --user=root \
    -v "$DATADIR/:/opt/pkgdir:z" \
    -v "$TESTER:/opt/test.sh:ro,z" \
    -v "$SCRIPTDIR/scripts:/opt/scripts:ro,z" \
    docker.io/library/archlinux:base-devel \
    /opt/scripts/entrypoint.sh
# Remove build artifacts (all git-ignored files) after a successful run
if [ -z "$KEEP_BUILD" ] && git -C "$DATADIR" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    git -C "$DATADIR" clean -ffdX
fi
