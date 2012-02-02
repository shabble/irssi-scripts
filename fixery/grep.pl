# /GREP [-i] [-w] [-v] [-F] <perl-regexp> <command to run>
#
# -i: match case insensitive
# -w: only print matches that form whole words
# -v: Invert the sense of matching, to print non-matching lines.
# -F: match as a fixed string, not a regexp
#
# if you want /FGREP, do: /alias FGREP GREP -F

use Irssi;
use strict;
use Text::ParseWords;

my $HELP_SUMMARY = "GREP [-i] [-w] [-v] [-F] <perl-regex> /irssi-command";

our $VERSION = "2.1";
our %IRSSI = (
	authors	    => "Timo 'cras' Sirainen, Wouter Coekaerts, Tom Feist",
	contact	    => 'tss@iki.fi, wouter@coekaerts.be',
	name        => "grep",
	description => $HELP_SUMMARY,
	license     => "Public Domain",
	url         => "http://wouter.coekaerts.be/irssi/",
	changed	    => "2012-02-02"
);

my $HELP_TEXT
  = [ $HELP_SUMMARY,
      "",
      "The following options are supported:",
      " \x{02}-i\x{02}: match case insensitively",
      " \x{02}-w\x{02}: only print matches that form whole words",
      " \x{02}-v\x{02}: Invert the sense of matching, to print non-matching lines.",
      " \x{02}-F\x{02}: match as a fixed string, not a regexp",
      "",
      "Examples:",
      "",
      " \x{02}*\x{02} /GREP -i bacon /echo I LOVE BACON",
      "",
      "if you want /FGREP, do: /alias FGREP GREP -F"
    ];

my $match_pattern;
my $match_count = 0;

my $options = { };

sub sig_grep_text {
	my ($dest, $text, $stripped_text) = @_;

    if ($stripped_text =~ $match_pattern) {

        if (not $options->{'-v'}) {
            $match_count++;
            return;
        }
    }

    Irssi::signal_stop;
}

sub cmd_grep {
	my ($data, $server, $item) = @_;

    if ($data =~ m/^\s*$/) {

        Irssi::print("\x{02}GREP Error\x{02} Invalid arguments. "
                     . "Usage: $HELP_SUMMARY", MSGLEVEL_CLIENTERROR);
        return;
    }

    $options = { map { $_ => 0 } qw/-i -v -w -F/ };

	# split the arguments, keep quotes
	my @args = quotewords(' ', 1, $data);

	# search for options
	while ($args[0] =~ /^-\w/) {

        my $opt_arg = shift @args;

        if (exists $options->{$opt_arg}) {
            $options->{$opt_arg} = 1;
        } else {
            Irssi::print("Unknown option: $opt_arg", MSGLEVEL_CLIENTERROR);
			return;
		}
	}

	# match = first argument, but remove quotes
	my ($match_str) = quotewords(' ', 0, shift @args);
    print "Match string >>$match_str<<";

	# cmd = the rest (with quotes)
	my $cmd = join(' ', @args);

    print "CMD >>$cmd<<";

	if ($options->{'-F'}) {
        $match_str = quotemeta($match_str);
	}

	if ($options->{'-w'}) {
        $match_str = '\b' . $match_str . '\b';
	}

	if ($options->{'-i'}) {
		$match_str = '(?i)' . $match_str;
	}

    $match_pattern = eval {
        qr/$match_str/;
    };

    if ($@) {
		chomp $@;
		Irssi::print("\x{02}Invalid pattern\x{02}: $@", MSGLEVEL_CLIENTERROR);
		return;
    }

    $match_count = 0;

	Irssi::signal_add_first('print text', 'sig_grep_text');
	Irssi::signal_emit('send command', $cmd, $server, $item);
	Irssi::signal_remove('print text', 'sig_grep_text');

    if ($match_count > 0) {
        Irssi::print(sprintf("Matched %d entr%s", $match_count,
                             $match_count == 1?"y":"ies"),
                     MSGLEVEL_CLIENTCRAP);
    } else {
        Irssi::print("No matches", MSGLEVEL_CLIENTCRAP);
    }
}

sub cmd_help_intercept_grep {
    if ($_[0] =~ m/grep/i) {
        Irssi::print($_, MSGLEVEL_CLIENTCRAP) for (@$HELP_TEXT);
        Irssi::signal_stop;
    }
}

Irssi::command_bind('grep', 'cmd_grep');
Irssi::command_bind('help', 'cmd_help_intercept_grep');
