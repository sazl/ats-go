
NPM=npm
MAKE=make

all:: ; $(MAKE) -C build -f ../build.mk all

npm:: ; $(MAKE) -C build -f ../build.mk npm

npm-update:: ; $(NPM) update

npm-install:: ; $(NPM) install

cleanall:: ; rm -f node_modules -r
cleanall:: ; rm -f package-lock.json
cleanall:: ; $(MAKE) -f ../build.mk cleanall
