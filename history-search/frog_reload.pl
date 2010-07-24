use strict;
use warnings;

use Irssi;
use File::ChangeNotify();
use File::Spec ();
use File::Basename qw(basename);

#my $THIS_SCRIPT = basename __FILE__;

my $irssi_dir = Irssi::get_irssi_dir();
my @watch_dirs = ($irssi_dir, $irssi_dir . '/scripts',
                  $irssi_dir . '/scripts/autorun');

my $watcher = File::ChangeNotify->instantiate_watcher
  (
   directories => \@watch_dirs,
   filter => qr/\.(?:pl|py)$/,
  );

my @watchers = File::ChangeNotify->usable_classes();
print "Started reloader watching: ", join(", ", @watch_dirs), " using $watchers[0]";

my %action_for = (
	create => sub {
		my ($path) = @_;
		Irssi::print ("CREATE: Loading $path");
        load_script($path);
	},

	modify => sub {
		my ($path) = @_;
		Irssi::print ("MODIFY: reloading $path");
        reload($path);
    },

	delete => sub {
		my ($path) = @_;
		Irssi::print ("DELETE: Unloading $path");
        unload_script($path);
	},
);

#TODO: change me back.
Irssi::timeout_add(3000, \&timer_sub, undef);

sub timer_sub {
    print "Timer sub called";
    my @new_events = $watcher->new_events;
	for my $event (@new_events) {

        print "Handling event: ", $event->type, " path: ", $event->path;

		if (my $callback = $action_for{$event->type}) {
			$callback->($event->path);
		}
	}
}

sub reload {
    my ($path) = @_;

    unload_script($path);
    load_script($path);
}

sub unload_script {
    my ($script_path) = @_;
    my $name = filepath_to_script($script_path);

    if (script_is_loaded($name)) {
        Irssi::print ("unloading $name...");
        Irssi::command("script unload $name");
    }
}

sub load_script {
    my ($script_path) = @_;
    Irssi::command("script load \"$script_path\"");
}

sub filepath_to_script {
    my ($path) = @_;

    my $name = basename $path;
    $name =~ s/\.pl$//i;

    return $name;
}

sub script_is_loaded {
    my $name = shift;
    print "Checking if $name is loaded";
    no strict 'refs';
    my $retval = defined %{ "Irssi::Script::${name}::" };
    use strict 'refs';

    return $retval;
}
