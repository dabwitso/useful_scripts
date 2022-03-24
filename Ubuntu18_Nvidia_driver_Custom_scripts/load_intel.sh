#!/bin/bash

# This loads intel display drivers
z=0

prime-select intel

for i in {1..1};do
  sleep 1m
  ((z++))
  echo ""
done


sudo -u $USER echo "Finished loading intel graphics drivers"
