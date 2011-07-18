=pod

=head1 NAME

act_hide.pl

=head1 DESCRIPTION

A minimalist template useful for basing actual scripts on.

=head1 INSTALLATION

Copy into your F<~/.irssi/scripts/> directory and load with
C</SCRIPT LOAD F<filename>>.

=head1 USAGE

None, since it doesn't actually do anything.

=head1 AUTHORS

Derived from the L<hide.pl|http://scripts.irssi.org/scripts/hide.pl> script,
Original Copyright E<copy> 2002 Marcus Rueckert C<E<lt>darix@irssi.deE<gt>>

Modifications Copyright E<copy> 2011 Tom Feist C<E<lt>shabble+irssi@metavore.orgE<gt>>

=head1 LICENCE

B<TODO:> Is this Public Domain enough?

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

=head1 BUGS

=head1 TODO

=cut

use strict;
use warnings;

use Irssi;
use Irssi::Irc;
use Irssi::TextUI;

use Data::Dumper;

our $VERSION = '0.1';
our %IRSSI = (
              authors     => 'Marcus Rueckert, shabble',
              contact     => 'shabble+irssi@metavore.org',
              name        => 'act_hide',
              description => 'Improved interface to activity_hide_* settings',
              license     => 'Public Domain',
             );

# Globals.

my $CMD_NAME = "hide";
my $SUB_CMDS = {
                add  => \&cmd_hide_add,
                del  => \&cmd_hide_del,
                list => \&cmd_hide_list,
               };

my $CMD_OPTS = "-target -level";


act_hide_init();

sub act_hide_init {

    Irssi::command_bind($CMD_NAME, \&subcmd_handler);

    foreach my $subcmd (keys %$SUB_CMDS) {
        my $coderef = $SUB_CMDS->{$subcmd};
        Irssi::command_bind("$CMD_NAME $subcmd", $coderef);
        Irssi::command_set_options("$CMD_NAME $subcmd", $CMD_OPTS);
    }
}

sub subcmd_handler {
    my ($data, $server, $w_item) = @_;
    $data =~ s/\s+$//g; # strip trailing whitespace.
    Irssi::command_runsub($CMD_NAME, $data, $server, $w_item);
}

sub parse_args {
    my ($cmd, $data) = @_;
    my $options = {};
    my @opts = Irssi::command_parse_options($cmd, $data);

    if (@opts and ref($opts[0]) eq 'HASH') {
        $options = $opts[0];
        $options->{__remainder} = $opts[1];
        print "Options: " . Dumper($options);
    } else {
        $options->{__remainder} = $data;
    }
    return $options;
}

sub cmd_hide_add {
    my ($args, $server, $w_item) = @_;
    my $opts = parse_args("$CMD_NAME add", $args);

    if (exists $opts->{target}) {
        my $target = $opts->{__remainder};
        $target =~ s/^\s*(\S+)\s*$/$1/;

        if (add_item_to_targets($target)) {
            $w_item->print("added $target");
        } else {
            $w_item->print("failed to add $target");
        }
    } elsif (exists $opts->{level}) {

    } else {
        print "Bah";
    }

}

sub cmd_hide_del {
    my ($args, $server, $w_item) = @_;
    my $opts = parse_args("$CMD_NAME del", $args);
    if (exists $opts->{target}) {
        my $target = $opts->{__remainder};
        $target =~ s/^\s*(\S+)\s*$/$1/;

        if (remove_item_from_targets($target)) {
            $w_item->print("removed $target");
        } else {
            $w_item->print("failed to remove $target");
        }
    } elsif (exists $opts->{level}) {

    } else {
        print "Bah";
    }

}

sub cmd_hide_list {
    my ($args, $server, $w_item) = @_;
    my $opts = parse_args("$CMD_NAME list", $args);
    if (exists $opts->{target}) {
        $w_item->print("Targets: "
                       . Irssi::settings_get_str('activity_hide_targets'));
    } elsif (exists $opts->{level}) {
      $w_item->print("Levels: "
                     . Irssi::settings_get_level('activity_hide_level'));
    } else {
        $w_item->print("Bah");
    }

}

sub add_item_to_targets {
    my ($item) = @_;
    my $current = Irssi::settings_get_str('activity_hide_targets');
    my %map = map { $_ => 1 } split /\s+/, $current;

    if (not exists $map{$item}) {
        Irssi::settings_set_str('activity_hide_targets', $current . ' ' . $item);
        return 1;
    } else {
        print "Cannot add $item, already exists";
        return 0;
    }
}

sub remove_item_from_targets {
    my ($item) = @_;
    my $current = Irssi::settings_get_str('activity_hide_targets');
    my %map = map { $_ => 1 } split /\s+/, $current;

    if (exists $map{$item}) {
        my $new_str = join ' ', grep { $_ ne $item } keys %map;
        Irssi::settings_set_str('activity_hide_targets', $new_str);
        return 1;
    } else {
        print "Cannot remove $item, doesn't exist";
        return 0;
    }
}




# sub add_item {
#     my ($target_type, $data) = @_;
#     my $target = target_check ($target_type);
#     return 0 unless $target;
#     if ($data =~ /^\s*$/ ) {
#         print (CRAP "\cBNo target specified!\cB");
#         print (CRAP "\cBUsage:\cB hide $target_type add [$target_type]+");
#     }
#     else {
#         my $set = settings_get_str($target);
#         for my $item ( split (/\s+/, $data) ) {
#             if ($set =~ m/^\Q$item\E$/i) {
#                 print (CRAP "\cBWarning:\cB $item is already in in $target_type hide list.")
#             }
#             else {
#                 print (CRAP "$item added to $target_type hide list.");
#                 $set = join (' ', $set, $item);
#             }
#         };
#         settings_set_str ($target, $set);
#         signal_emit('setup changed');
#     }
#     return 1;
# }

# sub remove_item {
#     my ($target_type, $data) = @_;
#     my $target = target_check ($target_type);
#     if ( not ( $target )) { return 0 };
#     if ($data =~ /^\s*$/ ) {
#         print (CRAP "\cBNo target specified!\cB");
#         print (CRAP "\cBUsage:\cB hide $target_type remove [$target_type]+");
#     }
#     else {
#         my $set = settings_get_str($target);
#         for my $item ( split (/\s+/, $data) ) {
#             if ($set =~ s/$item//i) {
#                 print (CRAP "$item removed from $target_type hide list.")
#             }
#             else {
#                 print (CRAP "\cBWarning:\cB $item was not in $target_type hide list.")
#             }
#         };
#         settings_set_str ($target, $set);
#         signal_emit('setup changed');
#     }
#     return 1;
# }

# sub target_check {
#     my ($target_type) = @_;
#     my $target = '';
#     if ($target_type eq 'level') {
#         $target = 'activity_hide_level';
#     }
#     elsif ($target_type eq 'target') {
#         $target = 'activity_hide_targets';
#     }
#     else {
#         print (CLIENTERROR "\cBadd_item: no such target_type $target_type\cB");
#     }
#     return $target;
# }

# sub print_usage {
#     print (CRAP "\cBUsage:\cB");
#     print (CRAP "  hide target [add|remove] [targets]+");
#     print (CRAP "  hide level [add|remove] [levels]+");
#     print (CRAP "  hide usage");
#     print (CRAP "  hide print");
#     print (CRAP "See also: levels");
# };

# sub print_items {
#     my ($target_type) = @_;
#     my $delimiter = settings_get_str('hide_print_delimiter');
#     my $target = target_check ($target_type);
#     if ( not ( $target )) { return 0 };
#     print ( CRAP "\cB$target_type hide list:\cB$delimiter", join ( $delimiter, sort ( split ( " ", settings_get_str($target) ) ) ) );
#     return 1;
# }

# #
# # targets
# #

# command_bind 'hide target' => sub {
#     my ($data, $server, $item) = @_;
#     if ($data =~ m/^[(add)|(remove)]/i ) {
#         command_runsub ('hide target', $data, $server, $item);
#     }
#     else {
#         print (CRAP "\cBUsage:\cB hide target [add|remove] [targets]+");
#     }
# };

# command_bind 'hide target add' => sub {
#     my ($data, $server, $item) = @_;
#     add_item ('target', $data);
# };

# command_bind 'hide target remove' => sub {
#     my ($data, $server, $item) = @_;
#     remove_item ('target', $data);
# };

# #
# # levels
# #
# command_bind 'hide level' => sub {
#     my ($data, $server, $item) = @_;
#     if ($data =~ m/^[(add)|(remove)]/i ) {
#         command_runsub ('hide level', $data, $server, $item);
#     }
#     else {
#         print (CRAP "\cBUsage:\cB hide level [add|remove] [levels]+");
#         print (CRAP "See also: levels");
#     }
# };

# command_bind 'hide level add' => sub {
#     my ($data, $server, $item) = @_;
#     add_item ('level', $data);
# };

# command_bind 'hide level remove' => sub {
#     my ($data, $server, $item) = @_;
#     remove_item ('level', $data);
# };

# #
# # general
# #

# command_bind 'hide' => sub {
#     my ($data, $server, $item) = @_;
#     if ($data =~ m/^[(target)|(level)|(help)|(usage)|(print)]/i ) {
#         command_runsub ('hide', $data, $server, $item);
#     }
#     else {
#         print_usage();
#     }
# };

# command_bind 'hide print' => sub {
#     print_items ('level');
#     print_items ('target');
# };

# command_bind  'hide usage' => sub {  print_usage (); };
# command_bind  'hide help' => sub {  print_usage (); };

# #
# # settings
# #

# settings_add_str ( 'script', 'hide_print_delimiter',  "\n - ");
