#!/bin/bash

cd /home/testsys/current_dir

DIRECTORY="AMSDAQ"
if [ ! -d "$DIRECTORY" ]
then
    # Control will enter here if $DIRECTORY doesn't exist.
    svn checkout svn checkout https://svn.code.sf.net/p/amsdaq/code/DAQ/DAQ AMSDAQ
    cd AMSDAQ
    make clean; make
else
    echo "Found an already existing AMSDAQ checkout. Using it"
    cd AMSDAQ
fi
echo ""

echo "If you need to pass via a lxplus ssh tunnel, remember to issue a:"
echo ""
echo "source ~/create_tunnel_and_socksify_everything.sh"
echo ""

exec /bin/bash
