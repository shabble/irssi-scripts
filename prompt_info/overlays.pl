# temp place for dumping all the stuff that doesn't belong in uberprompt.

# overlay  := { $num1 => line1, $num2 => line2 }
# line     := [ region, region, region ]
# region   := { start => x, end => y, ...? }

my $overlay;



sub _add_overlay_region {
    my ($line, $start, $end, $text, $len) = @_;
    my $region = { start => $start,
                   end => $end,
                   text => $text,
                   len => $len };

    my $o_line = $overlay->{$line};

    unless (defined $o_line) {
        $o_line = [];
        $overlay->{$line} = $o_line;
    }

    foreach my $cur_region (@$o_line) {
        if (_region_overlaps($cur_region, $region)) {
            # do something.
            print "Region overlaps";
            last;
        }
    }

    push @$o_line, $region;

}

sub _remove_overlay_region {
    my ($line, $start, $end) = @_;

    my $o_line = $overlay->{$line};
    return unless $o_line;

    my $i = 0;
    foreach my $region (@$o_line) {
        if ($region->{start} == $start && $region->{end} == $end) {
            last;
        }
        $i++;
    }
    splice @$o_line, $i, 1, (); # remove it.
}

sub _redraw_overlay {
    foreach my $line_num (sort keys %$overlay) {
        my $line = $overlay->{$line_num};

        foreach my $region (@$line) {
            Irssi::gui_printtext($region->{start}, $line_num,
                                 $region->{text});
        }
    }
}

sub init {

}
sub _clear_overlay {
    Irssi::active_win->view->redraw();
}

sub _draw_overlay_menu {

    my $w = 10;

    my @lines = (
                 '%7+' . ('-' x $w) . '+%n',
                 sprintf('%%7|%%n%*s%%7|%%n', $w, 'bacon'),
                 sprintf('|%*s|', $w, 'bacon'),
                 sprintf('|%*s|', $w, 'bacon'),
                 sprintf('|%*s|', $w, 'bacon'),
                 sprintf('|%*s|', $w, 'bacon'),
                 sprintf('|%*s|', $w, 'bacon'),
                 '%7+' . ('-' x $w) . '+%n',
                );
    my $i = 10; # start vert offset.
    for my $line (@lines) {
        Irssi::gui_printtext(int ($term_w / 2), $i++, $line);
    }
}
