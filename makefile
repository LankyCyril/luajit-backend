all: lualibs/effil/build/effil.so

luajit/src/luajit luajit/src/libluajit.so:
	$(MAKE) -C luajit
	cd luajit/src; ln -s libluajit.so libluajit-5.1.so 2>/dev/null || :
	cd luajit/src; ln -s libluajit.so libluajit-5.1.so.2 2>/dev/null || :
	git update-index --assume-unchanged luajit 2>/dev/null || :

lualibs/effil/build/effil.so: luajit/src/libluajit.so
	rm -rf lualibs/effil/build 2>/dev/null || :
	mkdir lualibs/effil/build 2>/dev/null || :
	cd lualibs/effil/build; cmake .. \
		-DLUA_LIBRARY=$(PWD)/luajit/src/libluajit.so \
		-DLUA_INCLUDE_DIR=$(PWD)/luajit/src
	$(MAKE) -C lualibs/effil/build
