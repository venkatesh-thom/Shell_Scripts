#!/bin/bash
name="vthommasi"
age=23
if [[ "$name" = "vthommasi" && $age -ge 18 ]]; then
    echo "Adult vthommasi"
else
    echo "Either unknown or underage"
fi
