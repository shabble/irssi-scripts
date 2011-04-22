# temp place for dumping all the stuff that doesn't belong in uberprompt.

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

my $overlays;
my ($term_w, $term_h) = (0, 0);

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

sub _add_overlay_region {
    my ($x, $y, $text) = @_;
    my $region = { start => $x,
                   text => $text,
                 };

    my $o_line = $overlays->{$y};

    unless (defined $o_line) {
        $o_line = [];
        $overlays->{$y} = $o_line;
    }

    # foreach my $cur_region (@$o_line) {
    #     if (_region_overlaps($cur_region, $region)) {
    #         # do something.
    #         print "Region overlaps";
    #         last;
    #     }
    # }

    push @$o_line, $region;
    redraw_overlay();
}

# sub _remove_overlay_region {
#     my ($line, $start, $end) = @_;

#     my $o_line = $overlay->{$line};
#     return unless $o_line;

#     my $i = 0;
#     foreach my $region (@$o_line) {
#         if ($region->{start} == $start && $region->{end} == $end) {
#             last;
#         }
#         $i++;
#     }
#     splice @$o_line, $i, 1, (); # remove it.
# }

sub redraw_overlay {
    # TODO: we can't assume the active win is the only one with overlays.
    Irssi::active_win->view->redraw();
    foreach my $y (sort keys %$overlays) {
        my $line = $overlays->{$y};
        foreach my $region (@$line) {
            Irssi::gui_printtext($region->{start}, $y, $region->{text});
        }
    }
}

sub augment_redraw {
    #print "Redraw called" if DEBUG;
    #redraw_overlay();
    Irssi::timeout_add_once(10, \&redraw_overlay, 0);
}

sub ctrl_L_intercept {
    my $key = shift;

    if ($key == 12) {  # C-L
        print "C-l pressed" if DEBUG;
        Irssi::command("redraw");
        Irssi::signal_stop();
    }
}

sub init {

    die "needs uberprompt" unless script_is_loaded('uberprompt');

    Irssi::signal_add_last ('command redraw',   \&augment_redraw);
    Irssi::signal_add_first('gui key pressed',  \&ctrl_L_intercept);
    Irssi::signal_add      ('terminal resized', \&update_terminal_size);
    Irssi::signal_add_first('gui print text finished', \&augment_redraw);

    my $api_sigs = {
                    # input signals
                    'overlay create'  => [qw/int int string/], # x, y, str
                    'overlay remove'  => [qw/int int/],        # x, y
                    'overlay clear'   => [],                   # no args
                    # output signals

                   };

    Irssi::signal_register($api_sigs);

    Irssi::signal_add('overlay create', \&_add_overlay_region);
    # Irssi::signal_add('overlay remove', \&_add_overlay_region);
    Irssi::signal_add('overlay clear', \&_clear_overlay);

    Irssi::command_bind('ocr', \&cmd_overlay_create);
    Irssi::command_bind('ocl', sub { Irssi::signal_emit('overlay clear'); });

}

sub cmd_overlay_create {
    my ($args) = @_;
    my ($y, $x, $text) = split(/\s+/, $args, 3);
    print "overlaying $text at [$x, $y]";

    Irssi::signal_emit('overlay create', $x, $y, $text);
}

sub _clear_overlay {
    $overlays = {};
    redraw_overlay();
}

sub script_is_loaded {
    my $name = shift;
    print "Checking if $name is loaded" if DEBUG;
    no strict 'refs';
    my $retval = defined %{ "Irssi::Script::${name}::" };
    use strict 'refs';

    return $retval;
}
print "Moo!";
init();

__END__

# sub _draw_overlay_menu {

#     my $w = 10;

#     my @lines = (
#                  '%7+' . ('-' x $w) . '+%n',
#                  sprintf('%%7|%%n%*s%%7|%%n', $w, 'bacon'),
#                  sprintf('|%*s|', $w, 'bacon'),
#                  sprintf('|%*s|', $w, 'bacon'),
#                  sprintf('|%*s|', $w, 'bacon'),
#                  sprintf('|%*s|', $w, 'bacon'),
#                  sprintf('|%*s|', $w, 'bacon'),
#                  '%7+' . ('-' x $w) . '+%n',
#                 );
#     my $i = 10; # start vert offset.
#     for my $line (@lines) {
#         Irssi::gui_printtext(int ($term_w / 2), $i++, $line);
#     }
# }
