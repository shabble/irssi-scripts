__END__

=head1 NAME

Irssi::Channel

=head1 FIELDS

Channel->{}
  type - "CHANNEL" text
  chat_type - String ID of chat protocol, for example "IRC"

  (..contains all the same data as Windowitem above..)

  topic - Channel topic
  topic_by - Nick who set the topic
  topic_time - Timestamp when the topic was set

  no_modes - Channel is modeless
  mode - Channel mode
  limit - Max. users in channel (+l mode)
  key - Channel key (password)

  chanop - You are channel operator
  names_got - /NAMES list has been received
  wholist - /WHO list has been received
  synced - Channel is fully synchronized

  joined - JOIN event for this channel has been received
  left - You just left the channel (for "channel destroyed" event)
  kicked - You was just kicked out of the channel (for
           "channel destroyed" event)

=head1 METHODS



Server::channels_join(channels, automatic)
  Join to channels in server. `channels' may also contain keys for
  channels just like with /JOIN command. `automatic' specifies if this
  channel was joined "automatically" or if it was joined because join
  was requested by user. If channel join is "automatic", irssi doesn't
  jump to the window where the channel was joined.


Channel::destroy()
  Destroy channel.

Channel
channel_find(channel)
  Find channel from any server.

Channel
Server::channel_find(channel)
  Find channel from specified server.
