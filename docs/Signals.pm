__END__

=head1 NAME

Irssi Signal Documentation

=head1 DESCRIPTION

Perl POD documentation based on the doc/signals.txt documentation supplied with
Irssi.

=head1 USING SIGNALS

See L<Irssi/"Signals">

=begin irssi_signal_types

START OF SIGNAL TYPES

=over

=item C<GList \* of ([^,]*)> C<glistptr_$1>

=item C<GSList \* of (\w+)s> C<gslist_$1>

=item C<char \*> C<string>

=item C<ulong \*> C<ulongptr>

=item C<int \*> C<intptr>

=item C<int> C<int>



=item C<CHATNET_REC> C<iobject>

=item C<SERVER_REC> C<iobject>

=item C<RECONNECT_REC> C<iobject>

=item C<CHANNEL_REC> C<iobject>

=item C<QUERY_REC> C<iobject>

=item C<COMMAND_REC> C<iobject>

=item C<NICK_REC> C<iobject>

=item C<LOG_REC> C<Irssi::Log>

=item C<RAWLOG_REC> C<Irssi::Rawlog>

=item C<IGNORE_REC> C<Irssi::Ignore>

=item C<MODULE_REC> C<Irssi::Module>


=item C<BAN_REC> C<Irssi::Irc::Ban>

=item C<NETSPLIT_REC> C<Irssi::Irc::Netsplit>

=item C<NETSPLIT_SERVER__REC> C<Irssi::Irc::Netsplitserver>


=item C<DCC_REC> C<siobject>

=item C<AUTOIGNORE_REC> C<Irssi::Irc::Autoignore>

=item C<AUTOIGNORE_REC> C<Irssi::Irc::Autoignore>

=item C<NOTIFYLIST_REC> C<Irssi::Irc::Notifylist>

=item C<CLIENT_REC> C<Irssi::Irc::Client>


=item C<THEME_REC> C<Irssi::UI::Theme>

=item C<KEYINFO_REC> C<Irssi::UI::Keyinfo>

=item C<PROCESS_REC> C<Irssi::UI::Process>

=item C<TEXT_DEST_REC> C<Irssi::UI::TextDest>

=item C<WINDOW_REC> C<Irssi::UI::Window>

=item C<WI_ITEM_REC> C<iobject>



=item C<PERL_SCRIPT_REC> C<Irssi::Script>

=back

END OF SIGNAL TYPES

=end irssi_signal_types

=head1 SIGNAL DEFINITIONS

The following signals are categorised as in the original documentation, but
have been revised to note Perl variable types and class names.

Arguments are passed to signal handlers in the usual way, via C<@_>.

=for irssi_signal_defs START OF SIGNAL DEFINITIONS

=head2 Core

=over 4

=item C<"gui exit">

=over

=item I<None>

=back

=item C<"gui dialog">

=over

=item string C<$type>

=item string C<$text>

=back

=item C<"send command">

=over

=item C<string $command>,

=item L<Irssi::Server> C<$server>,

=item L<Irssi::Windowitem> C<$window_item>

=back

This is sent when a command is entered via the GUI, or by scripts via L<Irssi::command>.

=back

=head3 F<chat-protocols.c>:

B<TODO: What are CHAT_PROTOCOL_REC types?>

=over 4

=item C<"chat protocol created">

=over

=item CHAT_PROTOCOL_REC C<$protocol>

=back

=item C<"chat protocol updated">

=over

=item CHAT_PROTOCOL_REC C<$protocol>

=back

=item C<"chat protocol destroyed">

=over

=item CHAT_PROTOCOL_REC C<$protocol>

=back

=back

=head3 F<channels.c>:

=over 4

=item C<"channel created">

=over

=item L<Irssi::Channel> C<$channel>

=item int C<$automatic>

=back

=item C<"channel destroyed">

=over

=item  L<Irssi::Channel> C<$channel>

=back

=back

=head3 F<chatnets.c>:

=over 4

=item C<"chatnet created">

=over

=item CHATNET_REC C<$chatnet>

=back

=item C<"chatnet destroyed">

=over

=item CHATNET_REC C<$chatnet>

=back

=back

=head3 F<commands.c>:

=over 4

=item C<"commandlist new">

=over

=item L<Irssi::Command> C<$cmd>

=back

=item C<"commandlist remove">

=over

=item L<Irssi::Command> C<$cmd>

=back

=item C<"error command">

=over

=item int C<$err>

=item string C<$cmd>

=back

=item C<"send command"> 

=over

=item string C<$args>

=item L<Irssi::Server> C<$server>

=item L<Irssi::Windowitem> C<$witem>

=back

=item C<"send text"> 

=over

=item string C<$line>

=item L<Irssi::Server> C<$server>

=item L<Irssi::Windowitem> C<$witem>

=back

=item C<"command "<cmd>> 

=over 

=item string C<$args>

=item L<Irssi::Server> C<$server>

=item L<Irssi::Windowitem> C<$witem>

=back

B<TODO: check this "cmd" out?>

=item C<"default command">

=over

=item string C<$args>

=item L<Irssi::Server> C<$server>

=item L<Irssi::Windowitem> C<$witem>

=back

=back

=head3 F<ignore.c>:

=over 4

=item C<"ignore created">

=over

=item L<Irssi::Ignore> C<$ignore>

=back

=item C<"ignore destroyed">

=over

=item L<Irssi::Ignore> C<$ignore>

=back

=item C<"ignore changed">

=over

=item L<Irssi::Ignore> C<$ignore>

=back

=back

=head3 F<log.c>:

=over 4

=item C<"log new"> 

=over

=item L<Irssi::Log> C<$log>

=back

=item C<"log remove">

=over

=item L<Irssi::Log> C<$log>

=back

=item C<"log create failed">

=over

=item L<Irssi::Log> C<$log>

=back

=item C<"log locked">

=over

=item L<Irssi::Log> C<$log>

=back

=item C<"log started">

=over

=item L<Irssi::Log> C<$log>

=back

=item C<"log stopped">

=over

=item L<Irssi::Log> C<$log>

=back

=item C<"log rotated">

=over

=item L<Irssi::Log> C<$log>

=back

=item C<"log written">

=over

=item L<Irssi::Log> C<$log>

=item string C<$line>

=back

=back

=head3 F<modules.c>:

B<TODO: what are these types?>

=over 4

=item C<"module loaded">

=over 

=item MODULE_REC C<$module>

=item MODULE_FILE_REC C<$module_file>

=back

=item C<"module unloaded">

=over 

=item MODULE_REC C<$module>

=item MODULE_FILE_REC C<$module_file>

=back

=item C<"module error">

=over

=item int C<$error>

=item string C<$text>

=item string C<$root_module>

=item string C<$sub_module>

=back

=back

=head3 F<nicklist.c>:

=over 4

=item C<"nicklist new">

=over

=item L<Irssi::Channel> C<$channel>

=item L<Irssi::Nick> C<$nick>

=back

=item C<"nicklist remove">

=over

=item L<Irssi::Channel> C<$channel>

=item L<Irssi::Nick> C<$nick>

=back

=item C<"nicklist changed">

=over

=item L<Irssi::Channel> C<$channel>

=item L<Irssi::Nick> C<$nick>

=item string C<$old_nick>

=back

=item C<"nicklist host changed">

=over

=item L<Irssi::Channel> C<$channel>

=item L<Irssi::Nick> C<$nick>

=back

=item C<"nicklist gone changed">

=over

=item L<Irssi::Channel> C<$channel>

=item L<Irssi::Nick> C<$nick>

=back

=item C<"nicklist serverop changed">

=over

=item L<Irssi::Channel> C<$channel>

=item L<Irssi::Nick> C<$nick>

=back

=back

=head3 F<pidwait.c>:

=over 4

=item C<"pidwait">

=over

=item int C<$pid>

=item int C<$status>

=back

=back

=head3 F<queries.c>:

=over 4

=item C<"query created"> 

=over

=item L<Irssi::Query> C<$query>

=item int C<$automatic>

=back

=item C<"query destroyed"> 

=over

=item L<Irssi::Query> C<$query>

=back

=item C<"query nick changed"> 

=over

=item L<Irssi::Query> C<$query>

=item string C<$original_nick>

=back

=item C<"window item name changed">

=over

=item L<Irssi::Windowitem> C<$witem>

=back

=item C<"query address changed">

=over

=item L<Irssi::Query> C<$query>

=back

=item C<"query server changed">

=over

=item L<Irssi::Query> C<$query>

=item L<Irssi::Server> C<$server>

=back

=back


=head3 F<rawlog.c>:

=over 4

=item C<"rawlog">

=over

=item L<Irssi::Rawlog> C<$raw_log>

=item string C<$data>

=back

=back

=head3 F<server.c>:

=over 4

=item C<"server looking">

=over

=item L<Irssi::Server> C<$server>

=back

=item C<"server connected">

=over

=item L<Irssi::Server> C<$server>

=back


=item C<"server connecting">

=over

=item L<Irssi::Server> C<$server>

=item ulongptr C<$ip>

=back

=item C<"server connect failed">

=over

=item L<Irssi::Server> C<$server>

=back

=item C<"server disconnected">

=over

=item L<Irssi::Server> C<$server>

=back

=item C<"server quit">

=over

=item L<Irssi::Server> C<$server>

=item string C<$message>

=back

=item C<"server sendmsg">

=over

=item L<Irssi::Server> C<$server>

=item string C<$target>

=item string C<$message>

=item int C<$target_type>

=back

=back

=head3 F<settings.c>:

=over 4

=item C<"setup changed">

=over

=item I<None>

=back

=item C<"setup reread">

=over

=item string C<$fname>

=back

=item C<"setup saved">

=over

=item string C<$fname>

=item int C<$autosaved>

=back

=back

=head2 IRC Core

=head3 F<bans.c>:

=over 4

=item C<"ban type changed">

=over

=item string C<$bantype>

=back

=back

=head3 F<channels>, F<nicklist>:

B<TODO: are these actual files? .c?>

=over 4

=item C<"channel joined">

=over

=item L<Irssi::Channel> C<$channel>

=back

=item C<"channel wholist">

=over

=item L<Irssi::Channel> C<$channel>

=back

=item C<"channel sync">

=over

=item L<Irssi::Channel> C<$channel>

=back

=item C<"channel topic changed">

=over

=item L<Irssi::Channel> C<$channel>

=back

=back

=head3 ctcp.c:

 "ctcp msg", SERVER_REC, char *args, char *nick, char *addr, char *target
 "ctcp msg "<cmd>, SERVER_REC, char *args, char *nick, char *addr, char *target
 "default ctcp msg", SERVER_REC, char *args, char *nick, char *addr, char *target
 "ctcp reply", SERVER_REC, char *args, char *nick, char *addr, char *target
 "ctcp reply "<cmd>, SERVER_REC, char *args, char *nick, char *addr, char *target
 "default ctcp reply", SERVER_REC, char *args, char *nick, char *addr, char *target
 "ctcp action", SERVER_REC, char *args, char *nick, char *addr, char *target

=head3 irc-log.c:

 "awaylog show", LOG_REC, int away_msgs, int filepos

=head3 irc-nicklist.c:

 "server nick changed", SERVER_REC

=head3 irc-servers.c:

 "event connected", SERVER_REC

=head3 irc.c:

 "server event", SERVER_REC, char *data, char *sender_nick, char *sender_address
 "event "<cmd>, SERVER_REC, char *args, char *sender_nick, char *sender_address
 "default event", SERVER_REC, char *data, char *sender_nick, char *sender_address
 "whois default event", SERVER_REC, char *args, char *sender_nick, char *sender_address

 "server incoming", SERVER_REC, char *data

(for perl parser..)
 "redir "<cmd>, SERVER_REC, char *args, char *sender_nick, char *sender_address

=head3 lag.c:

 "server lag", SERVER_REC
 "server lag disconnect", SERVER_REC

=head3 massjoin.c:

 "massjoin", CHANNEL_REC, GSList of NICK_RECs

=head3 mode-lists.c:

 "ban new", CHANNEL_REC, BAN_REC
 "ban remove", CHANNEL_REC, BAN_REC, char *setby

=head3 modes.c:

 "channel mode changed", CHANNEL_REC, char *setby
 "nick mode changed", CHANNEL_REC, NICK_REC, char *setby, char *mode, char *type
 "user mode changed", SERVER_REC, char *old
 "away mode changed", SERVER_REC

=head3 netsplit.c:

 "netsplit server new", SERVER_REC, NETSPLIT_SERVER_REC
 "netsplit server remove", SERVER_REC, NETSPLIT_SERVER_REC
 "netsplit new", NETSPLIT_REC
 "netsplit remove", NETSPLIT_REC


=head2 IRC Modules


=head3 dcc*.c:

 "dcc ctcp "<cmd>, char *args, DCC_REC
 "default dcc ctcp", char *args, DCC_REC
 "dcc unknown ctcp", char *args, char *sender, char *sendaddr

 "dcc reply "<cmd>, char *args, DCC_REC
 "default dcc reply", char *args, DCC_REC
 "dcc unknown reply", char *args, char *sender, char *sendaddr

 "dcc chat message", DCC_REC, char *msg

 "dcc created", DCC_REC
 "dcc destroyed", DCC_REC
 "dcc connected", DCC_REC
 "dcc rejecting", DCC_REC
 "dcc closed", DCC_REC
 "dcc request", DCC_REC, char *sendaddr
 "dcc request send", DCC_REC
 "dcc chat message", DCC_REC, char *msg
 "dcc transfer update", DCC_REC
 "dcc get receive", DCC_REC
 "dcc error connect", DCC_REC
 "dcc error file create", DCC_REC, char *filename
 "dcc error file open", char *nick, char *filename, int errno
 "dcc error get not found", char *nick
 "dcc error send exists", char *nick, char *filename
 "dcc error unknown type", char *type
 "dcc error close not found", char *type, char *nick, char *filename

=head3 autoignore.c:

 "autoignore new", SERVER_REC, AUTOIGNORE_REC
 "autoignore remove", SERVER_REC, AUTOIGNORE_REC

=head3 flood.c:

 "flood", SERVER_REC, char *nick, char *host, int level, char *target

=head3 notifylist.c:

 "notifylist new", NOTIFYLIST_REC
 "notifylist remove", NOTIFYLIST_REC
 "notifylist joined", SERVER_REC, char *nick, char *user, char *host, char *realname, char *awaymsg
 "notifylist away changed", SERVER_REC, char *nick, char *user, char *host, char *realname, char *awaymsg
 "notifylist left", SERVER_REC, char *nick, char *user, char *host, char *realname, char *awaymsg

=head3 proxy/listen.c:

 "proxy client connected", CLIENT_REC
 "proxy client disconnected", CLIENT_REC
 "proxy client command", CLIENT_REC, char *args, char *data
 "proxy client dump", CLIENT_REC, char *data


=head2 Display (FE) Common

B<Requires to work properly:>

 "gui print text", WINDOW_REC, int fg, int bg, int flags, char *text, TEXT_DEST_REC

(Can be used to determine when all "gui print text"s are sent (not required))
 "gui print text finished", WINDOW_REC

B<Provides signals:>

=head3 completion.c:

 "complete word", GList * of char*, WINDOW_REC, char *word, char *linestart, int *want_space

=head3 fe-common-core.c:

 "irssi init read settings"

=head3 fe-exec.c:

 "exec new", PROCESS_REC
 "exec remove", PROCESS_REC, int status
 "exec input", PROCESS_REC, char *text

=head3 fe-messages.c:

 "message public", SERVER_REC, char *msg, char *nick, char *address, char *target
 "message private", SERVER_REC, char *msg, char *nick, char *address
 "message own_public", SERVER_REC, char *msg, char *target
 "message own_private", SERVER_REC, char *msg, char *target, char *orig_target
 "message join", SERVER_REC, char *channel, char *nick, char *address
 "message part", SERVER_REC, char *channel, char *nick, char *address, char *reason
 "message quit", SERVER_REC, char *nick, char *address, char *reason
 "message kick", SERVER_REC, char *channel, char *nick, char *kicker, char *address, char *reason
 "message nick", SERVER_REC, char *newnick, char *oldnick, char *address
 "message own_nick", SERVER_REC, char *newnick, char *oldnick, char *address
 "message invite", SERVER_REC, char *channel, char *nick, char *address
 "message topic", SERVER_REC, char *channel, char *topic, char *nick, char *address

=head3 keyboard.c:

 "keyinfo created", KEYINFO_REC
 "keyinfo destroyed", KEYINFO_REC

=head3 printtext.c:

 "print text", TEXT_DEST_REC *dest, char *text, char *stripped

=head3 themes.c:

 "theme created", THEME_REC
 "theme destroyed", THEME_REC

=head3 window-activity.c:

 "window hilight", WINDOW_REC
 "window dehilight", WINDOW_REC
 "window activity", WINDOW_REC, int old_level
 "window item hilight", WI_ITEM_REC
 "window item activity", WI_ITEM_REC, int old_level

=head3 window-items.c:

 "window item new", WINDOW_REC, WI_ITEM_REC
 "window item remove", WINDOW_REC, WI_ITEM_REC
 "window item moved", WINDOW_REC, WI_ITEM_REC, WINDOW_REC
 "window item changed", WINDOW_REC, WI_ITEM_REC
 "window item server changed", WINDOW_REC, WI_ITEM_REC

=head3 windows.c:

 "window created", WINDOW_REC
 "window destroyed", WINDOW_REC
 "window changed", WINDOW_REC, WINDOW_REC old
 "window changed automatic", WINDOW_REC
 "window server changed", WINDOW_REC, SERVER_REC
 "window refnum changed", WINDOW_REC, int old
 "window name changed", WINDOW_REC
 "window history changed", WINDOW_REC, char *oldname
 "window level changed", WINDOW_REC

=head2 Display (FE) IRC

=head3 fe-events.c:

 "default event numeric", SERVER_REC, char *data, char *nick, char *address

=head3 fe-irc-messages.c:

 "message irc op_public", SERVER_REC, char *msg, char *nick, char *address, char *target
 "message irc own_wall", SERVER_REC, char *msg, char *target
 "message irc own_action", SERVER_REC, char *msg, char *target
 "message irc action", SERVER_REC, char *msg, char *nick, char *address, char *target
 "message irc own_notice", SERVER_REC, char *msg, char *target
 "message irc notice", SERVER_REC, char *msg, char *nick, char *address, char *target
 "message irc own_ctcp", SERVER_REC, char *cmd, char *data, char *target
 "message irc ctcp", SERVER_REC, char *cmd, char *data, char *nick, char *address, char *target

=head3 fe-modes.c:

 "message irc mode", SERVER_REC, char *channel, char *nick, char *addr, char *mode

=head3 dcc/fe-dcc-chat-messages.c:

 "message dcc own", DCC_REC *dcc, char *msg
 "message dcc own_action", DCC_REC *dcc, char *msg
 "message dcc own_ctcp", DCC_REC *dcc, char *cmd, char *data
 "message dcc", DCC_REC *dcc, char *msg
 "message dcc action", DCC_REC *dcc, char *msg
 "message dcc ctcp", DCC_REC *dcc, char *cmd, char *data

=head2 Display (FE) Text

=head3 F<gui-readline.c>:

=over 4

=item C<"gui key pressed"> int C<$key>

=back

=head3 F<gui-printtext.c>:

=over 4

=item C<"beep"> I<None>

=back

=head2 Perl Scripting

=over 4

=item C<"script error"> PERL_SCRIPT_REC, string C<$errormsg>

=back

=for irssi_signal_defs END OF SIGNAL DEFINITIONS

=head1 SIGNAL AUTO-GENERATION

This file is used to auto-generate the signal definitions used by Irssi, and hence
must be edited in order to add new signals.

=head2 Format


