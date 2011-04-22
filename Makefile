SCRIPT_DIRS = \
		history-search \
		ido-mode \
		prompt_info \
		quit-notify \
		sb-position \
		scrolled-reminder \
		tinyurl-tabcomplete \
		vim-mode

#		act_hide \
#		auto-server \
#		colour-popup \
#		feature-tests \
#		joinforward \
#		masshilight \
#		modules \
#		no-key-modes \
#		patches \
#		testing \
#		throttled-autojoin \
#		undo \
#		url_hilight \

SCRIPT_FILES = 	$(foreach FOO, $(SCRIPT_DIRS), $(wildcard $(FOO)/*.pl))

$GENERATOR = "./readme_generator"

.PHONY: all clean rebuild

all:

	echo making all: $(SCRIPT_DIRS)
	echo files are: $(SCRIPT_FILES)

rebuild: clean all

clean:
	-echo cleaning.

README.pod:
	-echo stuff
