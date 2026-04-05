#!/bin/bash
set -e

supercronic /etc/pgbackrest/crontab &

exec docker-entrypoint.sh "$@"
