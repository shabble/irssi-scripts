use strict;
use warnings;
use Cwd;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.

WriteMakefile(
              NAME              => 'Test::Irssi',
              AUTHOR            => 'shabble <shabble+cpan@metavore.org>',
              VERSION_FROM      => 'lib/Test/Irssi.pm', # finds $VERSION
              ABSTRACT_FROM     => 'lib/Test/Irssi.pm',
              PL_FILES          => {},
              # LIBS              => ["-L/opt/local/lib -lcprops"],
              # INC               => "-I/opt/local/include/cprops",
              PREREQ_PM         => {
                                    'Test::More'        => 0,
                                    'Carp'              => 0,
                                    'MooseX::Declare'   => 0,
                                    'IO::File'          => 0,
                                    'Term::VT102'       => 0,
                                    'Term::Terminfo'    => 0,
                                    'strictures'        => 0,
                                    'Data::Dump'        => 0,
                                   },
              dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
              # clean               => {
              #                         FILES => 'CProps-Trie-* Trie.inl _Inline'
              #                        },
             );
