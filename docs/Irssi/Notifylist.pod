__END__

=head1 NAME

Irssi::Notifylist

=head1 FIELDS

Notifylist->{}
  mask - Notify nick mask
  away_check - Notify away status changes
  idle_check_time - Notify when idle time is reset and idle was bigger
                    than this (seconds)
  ircnets - List of ircnets (strings) the notify is checked


=head1 METHODS

Notifylist::ircnets_match(ircnet)
  Returns 1 if notify is checked in `ircnet'.

