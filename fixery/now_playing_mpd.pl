# MPD Now-Playing Script for irssi
# Copyright (C) 2005 Erik Scharwaechter
# <diozaka@gmx.de>
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License version 2
# as published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# The full version of the license can be found at
# http://www.gnu.org/copyleft/gpl.html.
#
#
#######################################################################
# I'd like to thank Bumby <bumby@evilninja.org> for his impc script,  #
# which helped me a lot with making this script.                      #
#######################################################################
# Type "/np help" for a help page!                                    #
#######################################################################
# TODO:                                                               #
#  - add more format directives                                       #
#######################################################################
# CHANGELOG:                                                          #
#  0.4: First official release                                        #
#######################################################################

use strict;
#use IO::Socket;
use Irssi;
use IrssiX::Async qw(fork_off);
use Audio::MPD;
#use Storable;
use JSON::Any;
use Data::Dumper;

our $VERSION = "0.5";
our %IRSSI = (
          name        => 'mpd',
          authors     => 'Erik Scharwaechter',
          contact     => 'diozaka@gmx.de',
          license     => 'GPLv2',
          description => 'print the song you are listening to',
         );

sub _to_json {
    my $data = shift;
    # add terminal newline to ensure flushing without having to mess
    # with autoflush on all pipes.
    return JSON::Any->new->objToJson($data) . "\n";
}

sub _from_json {
    my $json = shift;
    return JSON::Any->new->jsonToObj($json);
}

sub _freeze_witem {
    my ($witem) = @_;
    my $win_item_ref;

    if (defined $witem) {
        $win_item_ref = { server_tag => $witem->window->{servertag},
                          win_refnum => $witem->window->{refnum},
                          item_name  => $witem->{name} };

    } else {
        # make this more better (find status window)
        $win_item_ref = { server_tag => undef,
                          win_refnum => 1,
                          item_name  => '' };

    }

    return $win_item_ref;
}

sub _thaw_witem {
    my ($frozen_witem) = @_;

    my $witem;
    my ($server_tag, $win_refnum, $witem_name)
      = map { $frozen_witem->{$_} } qw/server_tag win_refnum item_name/;

    my $server = Irssi::server_find_tag($server_tag);
    my $win    = Irssi::window_find_refnum($win_refnum);

    if ($win) {
        $witem = $win->item_find($server, $witem_name);
    } else {
        Irssi::print("Failed to find window item from params: tag: $server_tag, "
                     . "refnum: $win_refnum, item_name: $witem_name");
    }
    return $witem;
}

sub cmd_now_playing {
    my ($data, $server, $witem) = @_;

    if($data =~ /^help/i){
        cmd_now_playing_help();
        return;
    }

    my $host    = Irssi::settings_get_str('mpd_port')    || 'localhost';
    my $port    = Irssi::settings_get_str('mpd_host')    || 6060;
    my $pass    = Irssi::settings_get_str('mpd_pass')    || '';
    my $timeout = Irssi::settings_get_str('mpd_timeout') || 5;


    my $mpd_options = { win      => _freeze_witem($witem),
                        host     => $host,
                        port     => $port,
                        password => $pass };

    my $json_data = _to_json($mpd_options);
    fork_off($json_data, \&now_playing_request, \&now_playing_callback);
}

sub now_playing_request {
    my (@input) = <STDIN>;
    my $json_data = join('', @input);

    my $data = _from_json($json_data);
    #my $win = delete $data->{win};

#    my $mpd = Audio::MPD->new(%options);

#    my $am_playing = $mpd->current->as_string;
#    my %x;
#    if (defined $am_playing) {
    #     %x = ( result => $am_playing, win => $win );

    # } else {
    #     %x = ( result => '__ERROR__', win => $win );
    # }
    # my %x = (result => "foo", win => undef);
    # my $r = Storable::freeze(\%x);
    #print $r;

    my $response = { status  => 1,
                     message => "Foo",
                     win     => $data->{win},
                   };

    my $json_data = _to_json($response);
    print $json_data;
}

sub now_playing_callback {
    my ($json_data) = @_;
    #chomp $result;
    #my $data = Storable::thaw($frozen_data);
    my $data = _from_json($json_data);
    print "received data: " . Dumper($data);
    my $witem = _thaw_witem($data->{win});
    print "Witem: " . Dumper($witem);
    if ($witem) {
        $witem->print("Moo!");
    }
    # unless ($deserialised->{result} eq "__ERROR__") {
    #     my $output_message = "/me is playing: " . $deserialised->{result};
    #     my $witem = $deserialised->{win};

    #     if ($witem && ($witem->{type} eq "CHANNEL" ||
    #                    $witem->{type} eq "QUERY")) {
    #         #$witem->command($output_message);
    #         $witem->print("Printing: $output_message");
    #     }
    # } else {
    #     print "Now Playing MPD: Unable to do thingie (Got ERROR from child)";
    # }

}

sub cmd_now_playing_help {
   print '
 MPD Now-Playing Script
========================

by Erik Scharwaechter (diozaka@gmx.de)

Variables:
  mpd_host     (137.224.241.20)
  mpd_port     (6600)
  mpd_timeout  (5)

Usage:
  /np          Print the song you are listening to
  /np help     Print this text
';
}


Irssi::settings_add_str('mpd', 'mpd_host', '137.224.241.20');
Irssi::settings_add_str('mpd', 'mpd_port', '6600');
Irssi::settings_add_str('mpd', 'mpd_timeout', '5');
Irssi::settings_add_str('mpd', 'mpd_pass', '');

Irssi::command_bind('np'      => \&cmd_now_playing);
Irssi::command_bind('np help' => \&cmd_now_playing_help);

