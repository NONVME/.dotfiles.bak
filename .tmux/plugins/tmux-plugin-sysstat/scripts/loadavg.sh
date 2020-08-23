#!/usr/bin/env bash

set -u
set -e

LC_NUMERIC=C

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/helpers.sh"
NULL="/dev/null"

loadavg_per_cpu_core=$(get_tmux_option "@sysstat_loadavg_per_cpu_core" "true")

print_load_average() {
    printf "$(cat /proc/loadavg | cut -d' ' -f 1,2,3)"
}

main() {
	print_load_average
}
main

