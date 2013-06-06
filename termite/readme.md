#Termite on Mac OS X:

##First, you have to install vte:

###Dependencies:
- gtk3

###Build:
``tar xzf working-vte.tar.gz``
``cd vte-0.32.2-old``
``./configure --prefix=/opt/local --disable-python --disable-Bsymbolic``
``make``
``sudo make install``


###Fetching termite:
``git clone https://github.com/thestinger/termite``

Now make sure to use the makefile from this repository.

``make``
``sudo make install``
