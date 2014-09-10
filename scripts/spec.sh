#!/bin/bash

set -ex

mkdir spec
cd spec/
ssh jowagner@dslab-data.epfl.ch cat /var/dslab-samba/jowagner/spec/cpu2006.tar.bz2 | tar xvj
ssh jowagner@dslab-data.epfl.ch cat /var/dslab-samba/jowagner/spec/447.dealII.explicit_inclusion_of_cstring.cpu2006.v1.0.tar.bz2 | tar xvj
ssh jowagner@dslab-data.epfl.ch cat /var/dslab-samba/jowagner/spec/483.xalancbmk.explicit_inclusion_of_cstring.cpu2006.v1.0.tar.bz2 | tar xvj
echo "y" | ./install.sh
