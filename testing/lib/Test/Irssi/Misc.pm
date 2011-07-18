package Test::Irssi::Misc;
use strictures 1;



sub keycombo_to_code {
    my ($key_combo) = @_;
    my $output = '';
    my $ctrl = 0;
    my $meta = 0;
    if ($key_combo =~ m/[cC](?:trl)?-(.+)/) {
        $ctrl = 1;
        _parse_rest($1);
    }
    if ($key_combo =~ m/[Mm](?:eta)?-(.+)/) {
        $meta = 1;
        _parse_rest($1);
    }
}

sub _parse_key {
    my ($rest) = @_;
    my $special = {
                   left => '',
                   right => '',
                   up => '',
                   down => '',
                   tab => '',
                   space => '',
                   spc => '',
                  };
}


1;
