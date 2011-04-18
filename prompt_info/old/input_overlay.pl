
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

my $overlay_active = 0;
my $prompt_len = 5;
my $region_id = 0;

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

sub find_region {
    my ($pos) = @_;
    foreach my $region (@regions) {
        next unless $pos > $region->{start};
        return $region if $pos <= $region->{end};
    }
    print "failed to find region for pos: $pos";
    return undef;
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

sub observe_keypress {
    my $key = shift;
    print "Key " . chr ($key) . " pressed, pos: " . _pos();
    if ($key > 31 && $key <= 127) {
        # see if we're still appending to the last region:
        #print "Observed printable key: " . chr($key) if DEBUG;
        #print '';
        my $latest_region = $regions[-1];
        $latest_region = {} unless defined $latest_region;


        my $pos = _pos();
        my $reg = find_region($pos);

        if (defined $reg) {
            insert_into_region($key, $reg);
        } elsif (not $latest_region->{open}) {
            my $style = $overlay_active?'%_':'';
            new_region($style, $key);
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

    setup_bindings();

    Irssi::signal_add('prompt changed', sub {
                          print "Updated prompt length: $_[1]";
                          $prompt_len = $_[1];
                      });

    Irssi::signal_emit('prompt length request');

    update_terminal_size();
}

sub setup_bindings {

    Irssi::command_bind('region_start', \&region_toggle);
    Irssi::command_bind('region_clear', \&region_clear);
    Irssi::command_bind('region_print', \&print_regions);


    Irssi::command('/bind ^C /region_start');
    ##Irssi::command('/bind ^D /region_clear');
    Irssi::command('/bind ^D /region_print');

}


################################################################################

sub escape_style {
    my ($style) = @_;
    $style =~ s/%/%%/g;

    return $style;
}

sub print_regions {
    foreach my $reg (@regions) {
        printf("start: %d end: %d style: %s, text: \"%s\", open: %d, draw: %d",
               $reg->{start}, $reg->{end}, escape_style($reg->{style}),
               $reg->{text},  $reg->{open}, $reg->{draw});
    }
}

sub new_region {
    my ($style, $key) = @_;

    my $new_id = $region_id++;
    _debug("Creating new Region: $new_id");

    my $new_region
      = {
         id    => $region_id++,
         text  => '',
         start => _pos(),
         end   => _pos(),
         style => $style,
         open  => 1,
         draw  => 1,
        };

    insert_into_region($key, $new_region);

    push @regions, $new_region;
}

sub delete_region {
    my ($region) = @_;
    my $idx = 0;
    foreach my $i (0..$#regions) {
        if ($regions[$i]->{id} == $region->{id}) {
            $idx = $i;
            last;
        }
    }
    print "Deleting region: $idx";
    splice(@regions, $idx, 1); # remove the selected region.
}

sub insert_into_region {
    my ($key, $region) = @_;

    my $pos = _pos();

    if ($key == 127) { # backspace
        substr($region->{text}, -1, 1) = '';
        $region->{end}--;
        if ($region->{end} <= $region->{start}) {
            delete_region($region);
        }
    } else {
        printf("text: '%s', pos: %d, offset: %d",
               $region->{text}, $pos, $pos - $region->{start});
        if ( $region->{end} < $pos) {
            $region->{text} .= chr $key;
        } else {
            substr($region->{text}, $pos - $region->{start}, 0) = chr $key;
        }
        $region->{end}++;
    }
}

sub region_clear {
    @regions = ();
    Irssi::signal_emit('command redraw');
}

sub region_toggle {
    $overlay_active = not $overlay_active;
    _debug("Region is %sactive", $overlay_active?'':'in');
    #@regions = ();
    # terminate the previous region

    my $region = find_region(_pos());
    if (defined $region) {
        $region->{open} = 0;
        $region->{end}  = _pos();
        debug("Region closed: %d-%d", $region->{start}, $region->{end});
    }
}

sub script_is_loaded {
    my $name = shift;
    _debug("Checking if $name is loaded");
    no strict 'refs';
    my $retval =  %{ "Irssi::Script::${name}::" };
    use strict 'refs';

    return $retval;
}

sub _pos {
    return Irssi::gui_input_get_pos();
}

sub _input {
    return Irssi::parse_special('$L');
}

sub _debug {
    printf @_ if DEBUG();
}

init();

