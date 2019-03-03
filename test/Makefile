
MAKE=make
CPF=cp -f
RMF=rm -f

PATSCC=$(PATSHOME)/bin/patscc
PATSOPT=$(PATSHOME)/bin/patsopt

test: ats-go
	./test.sh

ats-go:
	$(MAKE) -C ../build all
