.PHONY: all debug test clean

all:
	$(MAKE) -C build all

debug:
	$(MAKE) -C build debug

test:
	$(MAKE) -C test test

clean:
	rm -rf node_modules
	rm -f package-lock.json
	$(MAKE) -C build clean
	$(MAKE) -C vendor/CATS-parsemit cleanall
