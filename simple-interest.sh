#!/bin/bash
while getopts "p:r:t:" opt; do
  case $opt in
    p) P=$OPTARG ;;
    r) R=$OPTARG ;;
    t) T=$OPTARG ;;
    *) echo "Usage: $0 -p <principal> -r <rate_%> -t <years>" >&2; exit 1 ;;
  esac
done
SI=$(echo "scale=2; ($P * $R * $T) / 100" | bc)
TOTAL=$(echo "scale=2; $P + $SI" | bc)
echo "Simple interest: $SI"
echo "Total amount: $TOTAL"