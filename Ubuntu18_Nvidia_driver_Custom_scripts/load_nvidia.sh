#!/bin/bash

# this loads nvidia drivers upon startup


modprobe nvidia # root

prime-select nvidia # root

sudo -u $USER nvidia-smi

