#!/bin/sh

# the purpose of this script is to be callable from cron. It will make a logfile and only output on failure.

set -e

exec > build.log 2>&1

SCRIPT_DIR=$(cd $(dirname $0); pwd)
_LOCK=$SCRIPT_DIR/.cron-build.lock
if ! lockfile -2 -r 2 $_LOCK; then
    # silently exit, since lock failure indicates another build running
    exit 1
fi
trap 'rm -f $_LOCK"' EXIT INT QUIT HUP TERM

$SCRIPT_DIR/build.sh
ret=$?

if [ $ret -eq 0 ]; then
	: # SUCCESS!
else
	echo "BUILD FAILURE - $(date)"
fi