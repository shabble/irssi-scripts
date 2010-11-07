CFLAGS = -Wall -O2 -Werror -g
# TODO: parameterise this to support linux/OSX better (OSX Specific code here)
LDFLAGS = -avoid-version -module -bundle -flat_namespace -undefined suppress


# --------- configurable file locations --------
IRSSI_DIST = /opt/stow/repo/irssi/include/irssi
INSTALL_DIR = $(HOME)/projects/tmp/test/irssi


OBJECTS = test_harness.o


IRSSI_INCLUDE = -I$(IRSSI_DIST) -I$(IRSSI_DIST)/src \
				-I$(IRSSI_DIST)/src/fe-common/core \
				-I$(IRSSI_DIST)/src/core -I$(IRSSI_DIST)/src/fe-text \
				-I$(IRSSI_DIST)/src/irc -I$(IRSSI_DIST)/src/irc/core \
				-I$(IRSSI_DIST)/src/irc/dcc -I$(IRSSI_DIST)/src/irc/notifylist

LUA_CFLAGS  = $(shell pkg-config lua --cflags)
GLIB_CFLAGS = $(shell pkg-config glib-2.0 --cflags)
LUA_LIBS    = $(shell pkg-config lua --libs)

all: libtest_harness.so

%.o: %.c
	$(CC) $(CFLAGS) $(LUA_CFLAGS) $(GLIB_CFLAGS) $(IRSSI_INCLUDE) -I. -fPIC -c $<

libtest_harness.so: $(OBJECTS)
	$(CC) $(CFLAGS) $(LDFLAGS) $(LUA_LIBS)  $(OBJECTS) -o $@

install: libtest_harness.so
	install $< $(INSTALL_DIR)/modules/

clean:
	rm -rf *~ *.o *.so core || true

.default: all

.phony: clean install
