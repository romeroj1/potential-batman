#!/bin/sh
cd '/opt/arcsight/db/bin'
./arcsight agentsetup -w -i 'SWING' -f '' "$@"
