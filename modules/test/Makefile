CFLAGS = -Wall -O2 -Werror -g
LDFLAGS = -avoid-version -module -bundle -flat_namespace -undefined suppress
FIND = gfind # stupid non-gnu defaults.

OBJECTS = test_core.o \
		  test_impl.o


IRSSI_DIST = /opt/stow/repo/irssi/include/irssi

IRSSI_USER_DIR = $(HOME)/projects/tmp/test/irssi

IRSSI_INCLUDE = -I$(IRSSI_DIST) \
				-I$(IRSSI_DIST)/src \
				-I$(IRSSI_DIST)/src/fe-common/core \
				-I$(IRSSI_DIST)/src/core \
				-I$(IRSSI_DIST)/src/fe-text \
				-I$(IRSSI_DIST)/src/irc \
				-I$(IRSSI_DIST)/src/irc/core \
				-I$(IRSSI_DIST)/src/irc/dcc \
				-I$(IRSSI_DIST)/src/irc/notifylist


GLIB_CFLAGS = $(shell pkg-config glib-2.0 --cflags)

all: libtest.so

%.o: %.c Makefile
	$(CC) $(CFLAGS) $(GLIB_CFLAGS) $(IRSSI_INCLUDE) -I. -fPIC -c $<

libtest.so: $(OBJECTS)
	$(CC) $(CFLAGS) $(LDFLAGS) $(OBJECTS) -o $@

install: libtest.so
	install $< $(IRSSI_USER_DIR)/modules

clean:
	rm -rf *~ *.o *.so core || true

TAGS:
	$(FIND) -type f -exec etags -a -o TAGS {} \;

.default: all

.phony: clean install TAGS
