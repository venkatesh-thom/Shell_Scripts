#!/bin/bash

log="/var/log/myapp.log"
max_size=100  # MB

if [ -f "$log" ]; then
  size=$(du -m "$log" | cut -f1) #Add size check

  if [ "$size" -gt "$max_size" ]; then
    mv "$log" "${log}.$(date +%F-%H%M%S)"
    > "$log"
    echo "Rotated $log"

    # keep only last 5 logs
    ls -t ${log}.* | tail -n +6 | xargs rm -f
  fi
fi

#💡 Follow-up: “Why not delete?” → file descriptor issue

