#!/bin/sh

DEFAULT_NR="$1"
AGENT=/etc/perfsonar/psconfig/maddash-agent.json
BUILD=${TMPDIR:=/tmp}/$(basename $0).$$.build


jq --slurp '.[1] as $reach | .[0].grids *= $reach | .[0]' \
    "${AGENT}" \
    "${DEFAULT_NR}" \
    > "${BUILD}"

mv -f "${BUILD}" "${AGENT}"
chown perfsonar.perfsonar "${AGENT}"
