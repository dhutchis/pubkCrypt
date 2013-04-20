# Compiler, flags, etc.
CC = gcc
DEBUG = -O3 -DNDEBUG #-g -O2
WFLAGS = -ansi -Wall -Wsign-compare -Wchar-subscripts -Werror
LDFLAGS = -Wl,-rpath,/usr/lib

# Libraries against which the object file for each utility should be linked
INCLUDES = /usr/include/
LIBS = /usr/lib/ 
DCRYPTINCLUDE = /home/nicolosi/devel/libdcrypt/include/
DCRYPTLIB = /home/nicolosi/devel/libdcrypt/lib/
DMALLOC = #-ldmalloc
GMP = -lgmp
DCRYPT = -ldcrypt

# The source file(s) for each program
all : skgu_pki skgu_nidh

pv_misc.o : pv_misc.c pv.h
	$(CC) $(DEBUG) $(WFLAGS) -I. -I$(INCLUDES) -I$(DCRYPTINCLUDE) -c pv_misc.c

skgu_misc.o : skgu_misc.c skgu.h
	$(CC) $(DEBUG) $(WFLAGS) -I. -I$(INCLUDES) -I$(DCRYPTINCLUDE) -c skgu_misc.c

skgu_cert.o : skgu_cert.c skgu.h pv.h
	$(CC) $(DEBUG) $(WFLAGS) -I. -I$(INCLUDES) -I$(DCRYPTINCLUDE)  -c skgu_cert.c

skgu_pki.o : skgu_pki.c skgu.h pv.h
	$(CC) $(DEBUG) $(WFLAGS) -I. -I$(INCLUDES) -I$(DCRYPTINCLUDE)  -c skgu_pki.c

skgu_pki : skgu_pki.o skgu_cert.o skgu_misc.o pv_misc.o
	$(CC) $(DEBUG) $(WFLAGS) -o $@ $@.o skgu_cert.o skgu_misc.o pv_misc.o -L. -L$(LIBS) -L$(DCRYPTLIB) $(DCRYPT) $(DMALLOC) $(GMP)

skgu_nidh.o : skgu_nidh.c skgu.h pv.h
	$(CC) $(DEBUG) $(WFLAGS) -I. -I$(INCLUDES) -I$(DCRYPTINCLUDE)  -c skgu_nidh.c

skgu_nidh : skgu_nidh.o skgu_cert.o skgu_misc.o pv_misc.o
	$(CC) $(DEBUG) $(WFLAGS) -o $@ $@.o skgu_cert.o skgu_misc.o pv_misc.o -L. -L$(LIBS) -L$(DCRYPTLIB) $(DCRYPT) $(DMALLOC) $(GMP)

clean:
	-rm -f core *.core *.o *~ 

cleanall: clean
	-rm -rf al.* bo.* .pki *.b64

dotest:
	./skgu_pki init
	./skgu_pki cert -g al.priv -o al.cert al.pub "al"
	./skgu_pki cert -g bo.priv -o bo.cert bo.pub "bo"
	./skgu_nidh al.priv al.cert "al" bo.pub bo.cert "bo" testlab
	ls testlab*
	cat testlab-al-bo.b64
	./skgu_nidh bo.priv bo.cert "bo" al.pub al.cert "al" testlab
	ls testlab*
	cat testlab-bo-al.b64
	diff testlab-al-bo.b64 testlab-bo-al.b64


.PHONY: all clean cleanall dotest
