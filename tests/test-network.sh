#!/usr/bin/env bash

set -ex

rm -f network.log

if [[ $WITHOUT_COVERAGE -eq 1 ]]; then
	my_command="python"
else
	my_command="coverage run --debug=dataio"
fi

# start the master instance
COVERAGE_FILE=.coverage.1 $my_command monitor.py -f tests/network/master/monitor.ini -d --loops=2 &
sleep 1

# run the client instance
COVERAGE_FILE=.coverage.2 $my_command monitor.py -f tests/network/client/monitor.ini -1 -d

# let them run
sleep 15

# make sure the client reached the master
grep test2 network.log

wait

if [[ $WITHOUT_COVERAGE -ne 1 ]]; then
	coverage combine --append
fi
