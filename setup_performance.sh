#!/usr/bin/env bash
set -e

# THP
echo always  > /sys/kernel/mm/transparent_hugepage/enabled
echo madvise > /sys/kernel/mm/transparent_hugepage/defrag

# Open-file limit for this session
ulimit -n 4096

# Confirm
echo "THP enabled:  $(cat /sys/kernel/mm/transparent_hugepage/enabled)"
echo "THP defrag:   $(cat /sys/kernel/mm/transparent_hugepage/defrag)"
echo "open files:   $(ulimit -n)"

