.PHONY: all debug cats-parsemit clean

CPF=cp -f
RMF=rm -f

PATSCC=$(PATSHOME)/bin/patscc
PATSOPT=$(PATSHOME)/bin/patsopt

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

all: ats-go

debug: ats-go-debug

$(SOURCES_CATS):
	$(MAKE) -C $(CATSPARSEMIT) all

ats-go-debug: $(SOURCES_DATS) $(SOURCES_SATS) $(SOURCES_CATS)
	$(PATSCC) -DATS_MEMALLOC_GCBDW -g -O0 -o $@ $^ -lgc

ats-go: $(SOURCES_DATS) $(SOURCES_SATS) $(SOURCES_CATS)
	$(PATSCC) -DATS_MEMALLOC_GCBDW -O2 -o $@ $^ -lgc

clean:
	$(RMF) *_?ats.o
	$(RMF) *_?ats.c
	$(RMF) ats-go
