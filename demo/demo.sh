#!/usr/bin/env bash

set -eu

# No variable management

# do a run of our benchmark
export TRACKBENCH_BASE="2021-03-06--afternoon"
../trackbench init
for numjobs in $(seq 1 16); do
	../trackbench next-run numjobs=$numjobs

	../trackbench attach-string "pre-procstat" "$(cat /proc/stat)"
	../trackbench exec "fio" perf record -operf.data -F99 -- echo fio ... --numjobs=$numjobs
	../trackbench attach-string  "post-procstat" "$(cat /proc/stat)"
	../trackbench attach-file "perf.data" "perf.data"
	rm perf.data
done

../trackbench finish
