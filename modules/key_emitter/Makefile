
### Edit these parameters ###

# change this to 'find' if you're on a decent system.
FIND = gfind # stupid OSX non-gnu defaults.

# Where your irssi include files live. You might need to install an
# 'irssi-dev' package or something like that.
IRSSI_DIST = /opt/stow/repo/irssi-debug/include/irssi

# probably $(HOME)/.irssi for most people.
IRSSI_USER_DIR = $(HOME)/projects/tmp/test/irssi-debug
MODULE_NAME = key_emitter

### You shouldn't need to edit anything beyond this point ###

LIB_NAME = lib$(MODULE_NAME).so
CFLAGS = -Wall -O2 -Werror -g -DMODULE_NAME=\"$(MODULE_NAME)\"
LDFLAGS = -avoid-version -module -bundle -flat_namespace -undefined suppress

# When you start adding more components to your module, add them here.
OBJECTS = key_emitter_core.o \
          key_emitter_impl.o

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

all: $(LIB_NAME)

%.o: %.c Makefile
	$(CC) $(CFLAGS) $(GLIB_CFLAGS) $(IRSSI_INCLUDE) -I. -fPIC -c $<

$(LIB_NAME): $(OBJECTS)
	$(CC) $(CFLAGS) $(LDFLAGS) $(OBJECTS) -o $@

install: $(LIB_NAME)
	install $< $(IRSSI_USER_DIR)/modules

clean:
	rm -rf *~ *.o *.so core || true

TAGS:
	$(FIND) -type f -exec etags -a -o TAGS {} \;

.default: all

.phony: clean install TAGS
