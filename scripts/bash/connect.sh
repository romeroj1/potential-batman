#!/bin/bash

#update server name

echo $1
echo 'ssh romeroj1@'$1
ssh -t romeroj1@<servernamehere> 'ssh romeroj1@'$1
