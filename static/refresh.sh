#!/bin/bash

sudo pkill -f /usr/bin/X
python boot.py
sleep 5
startx
