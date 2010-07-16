__END__

=head1 NAME

Irssi::Reconnect

=head1 FIELDS

Reconnect->{}
  type - "RECONNECT" text
  chat_type - String ID of chat protocol, for example "IRC"

  (..contains all the same data as Connect above..)

  tag - Unique numeric tag
  next_connect - Unix time stamp when the next connection occurs


=head1 METHODS

