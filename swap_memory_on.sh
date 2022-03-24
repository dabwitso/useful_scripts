#!/bin/bash

SWAPSIZE=$1
if [ -z $SWAPSIZE ];
then
    echo "Expecting a swapsize argument to be passed. Example,

    ./swap_memory_on.sh <swapsize>

    swapsize: 1,2,3 or 4 signifying # of Gigs
    "
    exit 1
fi

MEMORYSIZE=$(($SWAPSIZE*64))

# check if swap is on already
ISSWAPON=$(cat /proc/swaps | grep swapfile)


if [ -z ${ISSWAPON} ];
then
    echo "
    creating new swap...
    "
    sudo dd if=/dev/zero of=/swapfile bs="${MEMORYSIZE}M" count=16
    sudo mkswap /swapfile
    sudo swapon /swapfile
else
    echo "
    Removing old swap...
    "
    sudo swapoff /swapfile
    sudo rm /swapfile

    sudo dd if=/dev/zero of=/swapfile bs="${MEMORYSIZE}M" count=16
    sudo mkswap /swapfile
    sudo swapon /swapfile
fi


echo "
Swap created successfully!
To remove swap, run:

     ./swap_memory_off.sh
"
