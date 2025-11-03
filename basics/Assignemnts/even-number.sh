#!/bin/bash
for i in {1..100}; do
    if [ $((i % 2)) -eq 0 ]; then
        echo "$i is an even number"
    fi
done