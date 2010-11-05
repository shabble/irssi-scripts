
use strict;
use warnings;

use Irssi;
use Irssi::TextUI;              # for sbar_items_redraw
use Data::Dumper;


# TODO: maybe eval { use Term::Size } and use tthat if poss.
our $VERSION = "0.2";
our %IRSSI =
  (
   authors         => "shabble",
   contact         => 'shabble+irssi@metavore.org, shabble@#irssi/Freenode',
   name            => "overlays",
   description     => "Library script for drawing overlays on irssi UI",
   license         => "MIT",
   changed         => "24/7/2010"
  );

# overlay  := { $num1 => line1, $num2 => line2 }
# line     := [ region, region, region ]
# region   := { start => x, end => y, ...? }

my @regions;

my ($term_w, $term_h) = (0, 0);

my $key_capture = 0;
my $prompt_len = 5;

sub DEBUG () { 1 }

sub update_terminal_size {

    my @stty_data = qx/stty -a/;
    my $line = $stty_data[0];

    # linux
    # speed 38400 baud; rows 36; columns 126; line = 0;
    if ($line =~ m/rows (\d+); columns (\d+);/) {
        $term_h = $1;
        $term_w = $2;
        # osx
        # speed 9600 baud; 40 rows; 235 columns;
    } elsif ($line =~ m/(\d+) rows; (\d+) columns;/) {
        $term_h = $1;
        $term_w = $2;
    } else {
        # guess?
        $term_h = 24;
        $term_w = 80;
    }

    print "Terminal detected as $term_w cols by $term_h rows" if DEBUG;
}

sub redraw_overlay {
    # TODO: we can't assume the active win is the only one with overlays.
    #Irssi::active_win->view->redraw();
    foreach my $region (@regions) {
        if ($region->{draw}) {
            my $str = $region->{style} . $region->{text} . '%n';
            my $x_offset = $region->{start} +  $prompt_len;

            Irssi::gui_printtext($x_offset, $term_h, $str);
        }
    }
    # my $inp = Irssi::parse_special('$L');
    # Irssi::gui_input_set($inp . '');
}

sub augment_redraw {
    #print "Redraw called" if DEBUG;
    #redraw_overlay();
    Irssi::timeout_add_once(20, \&redraw_overlay, 0);
}

sub intercept_keypress {
    my $key = shift;

    # intercept C-l for redraw, and force it to call
    # /redraw instead of the internal function.
    if ($key == 12) {           # C-L
        print "C-l pressed" if DEBUG;
        Irssi::command("redraw");
        Irssi::signal_stop;
    }

}

sub new_region {
    my $key = shift;
    print "Creating new Region";
    my $new_region
      = {
         text  => '',
         start => _pos() -1,
         style => '%_',
         open  => 1,
         draw  => 1,
        };

    insert_into_region($key, $new_region);

    push @regions, $new_region;
}

sub insert_into_region {
    my ($key, $region) = @_;

    # if ($key == 127) { # backspace
    #     substr($region->{text}, -1, 1) = '';
    # } else {
    #     $region->{text} .= chr $key;
    # }
    my $input = Irssi::parse_special('$L');
    my $len = _pos() - $region->{start};
#    print "Input: $input, len: $len" if DEBUG;

    my $str = substr($input, $region->{start} , $len);
#    print "Str: $str" if DEBUG;
    $region->{text} = $str;

 #   printf("region [%d-%d] now contains '%s'",
 #          $region->{start}, _pos(),
 #          $region->{text}) if DEBUG;
}

sub observe_keypress {
    my $key = shift;
    if ($key_capture && $key > 31 && $key <= 127) {
        # see if we're still appending to the last region:
        #print "Observed printable key: " . chr($key) if DEBUG;
        #print '';
        my $latest_region = $regions[-1];
        $latest_region = {} unless defined $latest_region;

        if (not $latest_region->{open}) {
            new_region($key);
        } else {
            insert_into_region($key, $latest_region);
        }
        #Irssi::signal_stop;
        # TODO: if the cursor pos is inside a region, handle it
        # extend the region on addition?
        redraw_overlay();
    }
}
sub init {

    die "This script requires uberprompt.pl"
      unless script_is_loaded('uberprompt');

    Irssi::signal_add_last ('command redraw',          \&augment_redraw);
    Irssi::signal_add_first('gui key pressed',         \&intercept_keypress);
    Irssi::signal_add_last ('gui key pressed',         \&observe_keypress);

    Irssi::signal_add      ('terminal resized',        \&update_terminal_size);
    Irssi::signal_add_first('gui print text finished', \&augment_redraw);

    Irssi::command_bind('region_start', \&region_toggle);
    Irssi::command('/bind ^C /region_start');

    Irssi::signal_add('prompt changed', sub {
                          print "Updated prompt length: $_[1]";
                          $prompt_len = $_[1];
                      });

    Irssi::signal_emit('prompt length request');

    update_terminal_size();
}

sub region_toggle {
    $key_capture = not $key_capture;
    printf("Region is %sactive", $key_capture?'':'in');
    #@regions = ();
    # terminate the previous region
    my $latest_region = $regions[-1];
    if (defined $latest_region) {
        $latest_region->{open} = 0;
    }
}

sub script_is_loaded {
    my $name = shift;
    print "Checking if $name is loaded" if DEBUG;
    no strict 'refs';
    my $retval = defined %{ "Irssi::Script::${name}::" };
    use strict 'refs';

    return $retval;
}

sub _pos {
    return Irssi::gui_input_get_pos();
}

init();

