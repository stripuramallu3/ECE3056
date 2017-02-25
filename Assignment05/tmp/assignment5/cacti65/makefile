TARGET = cacti

.PHONY: dbg opt depend clean clean_dbg clean_opt

all: opt

dbg: $(TARGET).mk obj_dbg
	@$(MAKE) TAG=dbg -C . -f $(TARGET).mk

opt: $(TARGET).mk obj_opt
	@$(MAKE) TAG=opt -C . -f -I/usr/include/x86_64-linux-gnu/c++/4.9/bits/c++config.h $(TARGET).mk

obj_dbg:
	mkdir $@

obj_opt:
	mkdir $@

clean: clean_dbg clean_opt

clean_dbg: obj_dbg
	@$(MAKE) TAG=dbg -C . -f $(TARGET).mk clean
	rm -rf $<

clean_opt: obj_opt
	@$(MAKE) TAG=opt -C . -f $(TARGET).mk clean
	rm -rf $<

