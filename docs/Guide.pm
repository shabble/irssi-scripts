__END__

=head1 NAME

Guide To Irssi Scripting.

=head1 DESCRIPTION

=head1 LOADING AND UNLOADING SCRIPTS

=head2 File Locations

=head2 Testing

=head2 Loading

Scripts are loaded via C</SCRIPT LOAD I<filename>>.  A default Irssi
configuration also provides the C</RUN> alias as an alternative to C</SCRIPT
LOAD>.


=head2 Unloading

A script can be unloaded via the C</SCRIPT UNLOAD I<name>> command.  The name is
typically the script filename without the F<.pl> extension, so F<nickcolor.pl>
becomes C</SCRIPT UNLOAD nickcolor>.

As part of the unloading process, if the script contains a

    sub UNLOAD {
        ...
    }

function, it will be run just before the script is unloaded and all variables
destroyed. This can be used to clean up any temporary files, shut down any
network connections or processes, and restore any Irssi modifications made.

=head1 ANATOMY OF A SCRIPT

In this section, we develop a very simplistic script

=head2 Preamble

=head1 USEFUL THINGS

=head2 Sharing code between scripts


There are 2 main ways for scripts to communicate, either via emitting and
handling Irssi signals, or by calling functions from one another directly.


=head2 If In Doubt, Dump!

C<Data::Dumper> is an extremely good way to inspect Irssi internals if you're
looking for an undocumented feature.

The C<DUMP> alias by L<Wouter
Coekaerts|http://wouter.coekaerts.be/site/irssi/aliases> provides an easy way to
check object fields.

Dump perl object (e.g. C</dump Irssi::active_win>):

    /alias DUMP script exec use Data::Dumper\; print Data::Dumper->new([\\$0-])->Dump


=head1 OTHER RESOURCES

=over

=item L<http://irssi.org/documentation/perl>

=item L<http://irssi.org/documentation/signals>

=item L<http://irssi.org/documentation/special_vars>

=item L<http://irssi.org/documentation/formats>

=item L<http://irssi.org/documentation/settings>

=item L<http://juerd.nl/site.plp/irssiscripttut>

=item L<http://irchelp.org/irchelp/rfc/rfc.html>

=item L<http://wouter.coekaerts.be/site/irssi/irssi>

=back
