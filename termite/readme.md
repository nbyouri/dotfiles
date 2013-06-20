#Termite on Mac OS X: (tested on 10.8.3)

##First, you have to install the patched vte:

###Dependencies:
- gtk3

###Build:
``tar xzf working-vte.tar.gz``    
``cd vte-0.32.2-old``    
``./configure --prefix=/opt/local --disable-python --disable-Bsymbolic``    
``make``      
``sudo make install``       


###Fetching termite:
``git clone --recursive https://github.com/thestinger/termite``     
``cd termite``    

###Add this to termite.cc, at the beginning:
``#include <errno.h>``      
``#include <math.h>``    

Now make sure to use the makefile from this repository.

``make``       
``sudo make install``     


#Termite on FreeBSD:(tested on 9.1)

##Install:
- gtk3
- gmake
- intltool

##In /etc/make.conf, add:
``CC=clang``    
``CXX=clang++``     
``CPP=clang-cpp``     
``WITH_LIBCPLUSPLUS=yes``     


##install the working vte:
###Build:
``tar xzf working-vte.tar.gz``    
``cd vte-0.32.2-old``    
``cd gnome-pty-helper``     
``replace <utmp.h> by <utmpx.h> in gnome-pty-helper.c``     
``cd ../``    
``./configure``    
``gmake``      
``gmake install clean``    
``cp vte-2.90.pc /usr/local/libdata/pkgconfig/``    


###Fetching termite:
``git clone --recursive https://github.com/thestinger/termite``     
``cd termite``    

###Get FreeBSD src if you dont have it:
``cd /usr/src/lib/licxxrt``     
``make;make install``    
``cd ../libstdc++``    
``make;make install``     

###Use the makefile from this repo.

###Add this to termite.cc, at the beginning:
``#include <errno.h>``      
``#include <math.h>``    
``#include <sys/wait.h>``    
``#define	M_PI		3.14159265358979323846``     

Now make sure to use the makefile from this repository.

``gmake``       
``sudo gmake install``     
