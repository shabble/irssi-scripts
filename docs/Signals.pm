__END__

=head1 NAME

Irssi Signal Documentation

=head1 DESCRIPTION

Perl POD documentation based on the doc/signals.txt documentation supplied with
Irssi.

=head1 USING SIGNALS

See L<Irssi/"Signals">

=head1 SIGNAL DEFINITIONS

The following signals are categorised as in the original documentation, but
have been revised to note Perl variable types and class names.

Arguments are passed to signal handlers in the usual way, via C<@_>.

=head2 Core

=over 4

=item C<"gui exit"> I<None>

=item C<"gui dialog" string $type, string $text>

=item C<"send command">
C<string $command, Irssi::Server $server, Irssi::Windowitem
$window_item>

=back

=head2 IRC Core

=head2 IRC Module

=head2 Display (FE) Common

=head2 Display (FE) IRC

=head2 Display (FE) Text

=head2 Perl Scripting

