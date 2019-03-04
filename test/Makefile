.PHONY: test ats-go

CPF=cp -f
RMF=rm -f

CATSPARSEMIT=vendor/CATS-parsemit
PATSCC=$(PATSHOME)/bin/patscc
PATSOPT=$(PATSHOME)/bin/patsopt

test: ats-go-debug
	./test.sh

ats-go-debug:
	$(MAKE) -C .. debug
