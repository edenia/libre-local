#!/usr/bin/env bash
echo -ne "Stopping Nodeos \n"
pid="$(pidof nodeos)"

if [ ! -z "$pid" ]; then
    kill -SIGTERM $pid
else
    exit
fi

while true; do
    [ ! -d "/proc/$pid/fd" ] && break
    echo -ne "."
    sleep 1
done
echo -ne "\rNodeos Stopped.\n"