__END__

=head1 NAME

Irssi::Log

=head1 FIELDS

Log->{}
  fname - Log file name
  real_fname - The actual opened log file (after %d.%m.Y etc. are expanded)
  opened - Log file is open
  level - Log only these levels
  last - Timestamp when last message was written
  autoopen - Automatically open log at startup
  failed - Opening log failed last time
  temp - Log isn't saved to config file
  items - List of log items


=head1 METHODS


Log::update()
  Add log to list of logs / save changes to config file.


Log::close()
  Destroy log file.

Log::start_logging()
  Open log file and start logging.

Log::stop_logging()
  Close log file.

Log::item_add(type, name, server)
  Add log item to log.

Log::item_destroy(item)
  Remove log item from log.


Logitem
Log::item_find(type, item, server)
  Find item from log.
