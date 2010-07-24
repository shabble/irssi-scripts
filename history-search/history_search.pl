# Search within your typed history as you type (like ctrl-R in bash)
# Usage:
# * First do: /bind ^R /history_search
# * Then type ctrl-R and type what you're searching for

# Copyright 2007  Wouter Coekaerts <coekie@irssi.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

use strict;
use Irssi;
use Irssi::TextUI;
use Data::Dumper;

use vars qw($VERSION %IRSSI);
$VERSION = '1.0';
%IRSSI = (
    authors     => 'Wouter Coekaerts',
    contact     => 'coekie@irssi.org',
    name        => 'history_search',
    description => 'Search within your typed history as you type (like ctrl-R in bash)',
    license     => 'GPLv2 or later',
    url         => 'http://wouter.coekaerts.be/irssi/',
    changed     => '04/08/07'
);

my $prompt_append  = 1;
my $prompt_content = '';

# create a new statusbar item

Irssi::statusbar_item_register ( 'custom_prompt', 0, 'custom_prompt' );

Irssi::signal_add_last 'gui print text finished' => sub {
    Irssi::statusbar_items_redraw ( 'custom_prompt' );
};

Irssi::signal_register({'change prompt' => [qw/string int/]});
Irssi::signal_add('change prompt' => \&handle_change_prompt_sig);

sub handle_change_prompt_sig {
    my ($text, $append) = @_;
    print "sig args: ", Dumper(\@_);
    $prompt_content = $text;
    $prompt_append = $append;
    print "text: $prompt_content, append: $prompt_append";

    Irssi::statusbar_items_redraw('custom_prompt');
}

# TODO: make these work wiht subcommand (runsub)

Irssi::command_bind('set_prompt' => \&dothing );
Irssi::command_set_options('set_prompt', '+string @append');

Irssi::command_bind('install_prompt' => \&install_prompt);
Irssi::command_bind('uninstall_prompt' => \&uninstall_prompt);

Irssi::settings_add_bool('custom_prompt', 'autoinstall_custom_prompt', 0);

if (Irssi::settings_get_bool('autoinstall_custom_prompt')) {
    install_prompt();
}

sub install_prompt {
    Irssi::command("/statusbar prompt add -priority '-5' -alignment left"
                   . " -before prompt custom_prompt");
    Irssi::command("/statusbar prompt remove prompt");
    Irssi::command("/statusbar prompt remove prompt_empty");
}

sub uninstall_prompt {
    Irssi::command("/statusbar prompt remove custom_prompt");
    Irssi::command("/statusbar prompt add -priority '-1' "
                   . "-before input -alignment left prompt");
    Irssi::command("/statusbar prompt add -priority '-2' "
                   . "-before input -alignment left prompt_empty");
}

sub dothing {
    #my ($str, $append) = @_;
    #Irssi::print("str is $str, append=$append");
    my $parsed = [Irssi::command_parse_options('set_prompt', $_[0])];
    my $args = $parsed->[0] // {};
    my $remainder = $parsed->[1] // '';

    my ($str, $append) = ('', 1);
    print Dumper $args;
    if (exists ($args->{string})) {
        $str = $args->{string};
    }

    if (exists($args->{append})) {
        $append = $args->{append};
    }
    print "append in dothing: $append";
    Irssi::signal_emit('change prompt', $str, $append);
}

sub custom_prompt {
    my ($sb_item, $get_size_only) = @_;

    my ($width, $padChar, $padNum, $length);

    #my $prompt_str = '%K[%W$tag%c/%K$cumode%n$*%K]%n ';

    my $theme = Irssi::current_theme;
    my $prompt = '';

    my $var = '';
    if (window_is_empty(Irssi::active_win)) {
        $var = 'winname';
    } else {
        $var = '[.15]itemname';
    }

    if ($prompt_append) {
        $prompt = $theme->format_expand("{prompt \$$var}");
    }

    my $trailing_space = '';
    if ($prompt =~ /(\s*)$/ && length $prompt_content) {
        $trailing_space = $1;
    }

    $prompt .= $prompt_content . $trailing_space;
    $sb_item->default_handler($get_size_only, $prompt, undef, 1);
}

sub window_is_empty {
    my $window = shift;
    return $window->{name} eq $window->get_active_name;
}

sub UNLOAD {
    print Dumper(\@_);
    uninstall_prompt();
}
