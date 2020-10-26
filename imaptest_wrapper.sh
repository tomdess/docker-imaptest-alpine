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
  IMAPTEST_SECS=1800
fi
# clients = how many concurrent clients
if [ -z ${IMAPTEST_CLIENTS} ]; then
  IMAPTEST_CLIENTS=10
fi

DEFAULT_OPTIONS="users=10000 no_tracking"

# if profile not defined run benchmark mode
if [ -z ${IMAPTEST_PROFILE} ]; then
  imaptest mbox=/srv/testmbox host=${IMAPTEST_HOST} user=${IMAPTEST_USER} pass=${IMAPTEST_PASS} secs=${IMAPTEST_SECS} clients=${IMAPTEST_CLIENTS} ${DEFAULT_OPTIONS} $@
else
  # else run profile
  if [ -f /srv/${IMAPTEST_PROFILE} ]; then
    imaptest mbox=/srv/testmbox host=${IMAPTEST_HOST} pass=${IMAPTEST_PASS} profile=${IMAPTEST_PROFILE} user=profile secs=${IMAPTEST_SECS} clients=${IMAPTEST_CLIENTS} ${DEFAULT_OPTIONS} $@
  else
    echo "ERROR: profile file not found"
    exit 1
  fi
fi

