=pod

=head1 NAME

template.pl

=head1 DESCRIPTION

A minimalist template useful for basing actual scripts on.

=head1 INSTALLATION

Copy into your F<~/.irssi/scripts/> directory and load with
C</SCRIPT LOAD F<filename>>.

=head1 USAGE

None, since it doesn't actually do anything.

=head1 AUTHORS

Copyright E<copy> 2011 Tom Feist C<E<lt>shabble+irssi@metavore.orgE<gt>>

=head1 LICENCE

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

=head1 BUGS

=head1 TODO

Use this template to make an actual script.

=cut

use strict;
use warnings;

use Irssi;
use Irssi::Irc;
use Irssi::TextUI;

use Data::Dumper;

our $VERSION = '0.1';
our %IRSSI = (
              authors     => 'shabble',
              contact     => 'shabble+irssi@metavore.org',
              name        => '',
              description => '',
              license     => 'MIT',
              updated     => '$DATE'
             );

sub DATA_LEVEL_NONE    () { 0 }
sub DATA_LEVEL_TEXT    () { 1 }
sub DATA_LEVEL_MSG     () { 2 }
sub DATA_LEVEL_HILIGHT () { 3 }

sub SB_START () { '%c[%n' }
sub SB_END   () { '%c]%n' }

my $activity = {};


Irssi::statusbar_item_register('act_simple', 0, 'act_simple_cb');
# Irssi::signal_add('window hilight', \&update_hilight);
# Irssi::signal_add('window dehilight', \&update_hilight);
Irssi::signal_add_first('window activity', \&update_activity);

# wtf to do about these?
# Irssi::signal_add('window item hilight', \&update_hilight);
# Irssi::signal_add('window item activity', \&update_activity);

Irssi::statusbar_items_redraw('act_simple');
Irssi::command_bind('at',
                    sub { my $args = shift;
                          my @stuff = split /\s+/, $args;
                          my $win = Irssi::window_find_refnum($stuff[0]);
                          my $lvl = Irssi::level2bits($stuff[1]);
                          print "Seinding level: $stuff[1]: $lvl to $stuff[0]";
                          $win->print("Blah Blah", $lvl);
                      });

sub update_activity {
    my ($win, $old_level) = @_;
    Irssi::window_find_refnum(1)->print(Dumper(\@_), MSGLEVEL_NEVER | MSGLEVEL_CRAP);
    my $refnum = $win->{refnum};
    my $level  = $win->{data_level};

    my $prev_level = exists $activity->{$refnum}->{old_level}
      ? $activity->{$refnum}->{old_level} : -1;

    $activity->{$refnum}->{old_level} = $old_level;

    print "$refnum: prev: $prev_level, Old: $old_level, new: $level";

    #if ($level = DATA_LEVEL_NONE) {
    $activity->{$refnum}->{level} = $level;

    if ($old_level != $prev_level) {
        Irssi::statusbar_items_redraw('act_simple');
    }
    Irssi::signal_stop();
}

sub render_activity {
    my @act_keys = sort { $a <=> $b } keys %$activity;

    my @out;

    foreach my $refnum (@act_keys) {
        my $act = $activity->{$refnum}->{level};
        if ($act == DATA_LEVEL_TEXT) {
            push @out, ('%_%G' . $refnum . '%n');
        } elsif ($act == DATA_LEVEL_MSG) {
            push @out, ('%_%B' . $refnum . '%n');
        } elsif ($act == DATA_LEVEL_HILIGHT) {
            push @out, ('%_%G' . $refnum . '%n');
        }
    }
    return sprintf('%s %%_Simple:%%_ %s %s', SB_START, join(", ", @out), SB_END);
}

sub act_simple_cb {
    my ($sb_item, $get_size_only) = @_;

    my $sb = render_activity();

    #print "redrawing sbar: $sb";
    return $sb_item->default_handler($get_size_only, $sb, '', 0);
}
