
MAKE=make
PATSCC=$(PATSHOME)/bin/patscc
PATSOPT=$(PATSHOME)/bin/patsopt

all::

CATSPARSEMIT=./../vendor/CATS-parsemit

SOURCES_DATS :=
SOURCES_DATS += ./../src/DATS/main.dats
SOURCES_DATS += ./../src/DATS/emit.dats
SOURCES_DATS += ./../src/DATS/emit2.dats
SOURCES_DATS += ./../src/DATS/util.dats
SOURCES_DATS += ./../src/DATS/cli.dats

SOURCES_SATS :=
SOURCES_SATS += $(CATSPARSEMIT)/SATS/catsparse.sats
SOURCES_SATS += ./../src/SATS/main.sats
SOURCES_SATS += ./../src/SATS/emit.sats
SOURCES_SATS += ./../src/SATS/emit2.sats
SOURCES_SATS += ./../src/SATS/util.sats
SOURCES_SATS += ./../src/SATS/cli.sats

SOURCES_CATS :=
SOURCES_CATS += $(CATSPARSEMIT)/CATS/catsparse_all_dats.c

all:: ; $(MAKE) -C $(CATSPARSEMIT) all

all:: \
ats-go
ats-go: \
$(SOURCES_DATS); \
$(PATSCC) \
  -DATS_MEMALLOC_GCBDW -O2 -o ./../bin/ats-go \
  $(SOURCES_DATS) $(SOURCES_SATS) $(SOURCES_CATS) -lgc

npm:: ats-go
npm:: ; \
$(CPF) catsparse_sats.c atscc2py3_*_dats.c ./../npm/CATS/.

CPF=cp -f
RMF=rm -f

testall:: all
testall:: cleanall

clean:: ; $(RMF) *~
clean:: ; $(RMF) *_?ats.o
clean:: ; $(RMF) *_?ats.c

cleanall:: clean

cleanall:: ; $(RMF) ./../bin/ats-go
cleanall:: ; $(RMF) ./../npm/CATS/catsparse_sats.c
cleanall:: ; $(RMF) ./../npm/CATS/atscc2py3_*_dats.c
