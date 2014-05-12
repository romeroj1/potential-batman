#!/bin/bash

# Change to runlevel 3 now
systemctl isolate runlevel3.target

#Make run level 3 the default
ln -sf /lib/systemd/system/multi-user.target /etc/systemd/system/default.target

