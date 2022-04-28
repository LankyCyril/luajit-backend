all: lualibs/effil/build/effil.so lualibs/ipc/ipc.so
mpi: lualibs/lua-mpi/MPI.so lualibs/lua-mpi/buffer.so

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

lualibs/ipc/ipc.so: luajit/src/libluajit.so
	rm -f lualibs/ipc/ipc.so 2>/dev/null || :
	sed -E -i 's/^#ifdef _WIN32/#ifndef _NOTAREALDEF/g' lualibs/ipc/ipc.c
	git update-index --assume-unchanged lualibs/ipc 2>/dev/null || :
	make -C lualibs/ipc LUA_INCDIR=../../luajit/src

lualibs/lua-mpi/MPI.so lualibs/lua-mpi/buffer.so: luajit/src/libluajit.so
	rm -f lualibs/lua-mpi/*.so || :
	rm -f lualibs/MPI.so || :
	rm -f lualibs/buffer.so || :
	cd lualibs/lua-mpi; git apply ../lua-mpi.compat-patch || :
	git update-index --assume-unchanged lualibs/lua-mpi 2>/dev/null || :
	$(MAKE) -C lualibs/lua-mpi
	ln -s -r lualibs/lua-mpi/MPI.so lualibs/MPI.so
	ln -s -r lualibs/lua-mpi/buffer.so lualibs/buffer.so
