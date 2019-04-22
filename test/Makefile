.PHONY: test ats-go check

CPF=cp -f
RMF=rm -f

PATSCC=$(PATSHOME)/bin/patscc
PATSOPT=$(PATSHOME)/bin/patsopt

check:
	@echo "PATSCC: $(PATSCC)"
	@echo "PATSOPT: $(PATSOPT)"

test: ats-go-debug
	./test.sh $(fixture)

ats-go-debug:
	$(MAKE) -C .. debug
