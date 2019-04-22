.PHONY: all debug test clean check

all:
	$(MAKE) -C build all

debug:
	$(MAKE) -C build debug

test:
	$(MAKE) -C test test

check:
	@echo "\n==== BUILD ====\n"
	$(MAKE) -C build check
	@echo "\n==== TEST ====\n"
	$(MAKE) -C test check

clean:
	rm -rf node_modules
	rm -f package-lock.json
	$(MAKE) -C build clean
	$(MAKE) -C vendor/CATS-parsemit cleanall
