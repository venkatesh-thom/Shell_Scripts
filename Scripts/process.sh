#!/bin/bash

process="nginx"

if ! pgrep -x "$process" > /dev/null
then
  echo "$process is not running"
else
  echo "$process is running"
fi