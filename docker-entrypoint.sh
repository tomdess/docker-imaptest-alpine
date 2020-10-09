#!/usr/bin/env ash

set -e

if [[ ! -f /srv/testmbox ]]; then
        cd /srv
        create-testmbox.py
fi

exec "$@"
