
NPM=npm
MAKE=make

all:: ; $(MAKE) -C build all

npm:: ; $(MAKE) -C build npm

npm-update:: ; $(NPM) update

npm-install:: ; $(NPM) install

cleanall:: ; rm -f node_modules -r
cleanall:: ; rm -f package-lock.json
cleanall:: ; $(MAKE) -C build cleanall
cleanall:: ; $(MAKE) -C vendor/CATS-parsemit cleanall
