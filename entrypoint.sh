#!/bin/bash

cd /home/testsys/current_dir

DIRECTORY="JMDCCommander"
if [ ! -d "$DIRECTORY" ]
then
    # Control will enter here if $DIRECTORY doesn't exist.
    svn checkout https://svn.code.sf.net/p/jmdccommander/code/trunk JMDCCommander
    cd JMDCCommander
    make clean; make
else
    echo "Found an already existing JMDCCommander checkout. Using it"
    cd JMDCCommander
fi
echo ""

echo "If you need to pass via a lxplus ssh tunnel, remember to issue a:"
echo ""
echo "source ~/create_tunnel_and_socksify_everything.sh"
echo ""

exec /bin/bash
