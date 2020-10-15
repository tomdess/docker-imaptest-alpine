#!/usr/bin/env ash

set -e

# check for required parameters
if   [ -z ${IMAPTEST_HOST} ]; then
  echo "ERROR: variable IMAPTEST_HOST undefined"
  exit 1
elif [ -z ${IMAPTEST_USER} ]; then
  echo "ERROR: variable IMAPTEST_USER undefined"
  exit 1
elif [ -z ${IMAPTEST_PASS} ]; then
  echo "ERROR: variable IMAPTEST_PASS undefined"
  exit 1
fi

## force defaults if not defined
# secs = number of seconds to run the test
if [ -z ${IMAPTEST_SECS} ]; then
  IMAPTEST_SECS=3600
fi
# clients = how many concurrent clients
if [ -z ${IMAPTEST_CLIENTS} ]; then
  IMAPTEST_CLIENTS=50
fi

DEFAULT_OPTIONS="no_tracking"

/usr/local/bin/imaptest mbox=/srv/testmbox host=${IMAPTEST_HOST} user=${IMAPTEST_USER} pass=${IMAPTEST_PASS} secs=${IMAPTEST_SECS} clients=${IMAPTEST_CLIENTS} ${DEFAULT_OPTIONS} $@
