use Irssi;
our $VERSION = '0.1';
our %IRSSI = (
              authors     => 'shabble',
              contact     => 'shabble+irssi@metavore.org',
              name        => '',
              description => '',
              license     => 'MIT',
              updated     => '$DATE'
             );

Irssi::timeout_add_once(1000, 'die_horribly', undef);

sub die_horribly {
    die "Oh noes, I broke!";
}
