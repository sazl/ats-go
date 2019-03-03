
NPM=npm
MAKE=make

all:
	$(MAKE) -C build all

test:
	$(MAKE) -C test all

clean:
	rm -rf node_modules
	rm -f package-lock.json
	$(MAKE) -C build clean
	$(MAKE) -C vendor/CATS-parsemit cleanall
