__END__

=head1 NAME

Irssi::Rawlog

=head1 FIELDS


Rawlog->{}
  logging - The rawlog is being written to file currently
  nlines - Number of lines in rawlog

=head1 METHODS


Rawlog::destroy()
  Destroy the rawlog.

Rawlog::get_lines()
  Returns all lines in rawlog.

Rawlog::open(filename)
  Start logging new messages in rawlog to specified file.

Rawlog::close()
  Stop logging to file.

Rawlog::save(filename)
  Save the current rawlog history to specified file.

Rawlog::input(str)
  Send `str' to raw log as input text.

Rawlog::output(str)
  Send `str' to raw log as output text.

Rawlog::redirect(str)
  Send `str' to raw log as redirection text.

