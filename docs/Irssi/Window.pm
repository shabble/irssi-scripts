__END__

=head1 NAME

Irssi::Window

=head1 FIELDS

UI::Window->{}
  refnum - Reference number
  name - Name

  width - Width
  height - Height

  history_name - Name of named historylist for this window

  active - Active window item
  active_server - Active server

  servertag - active_server must be either undef or have this same tag
              (unless there's items in this window). This is used by
	      /WINDOW SERVER -sticky
  level - Current window level

  sticky_refnum - 1 if reference number is sticky

  data_level - Current data level
  hilight_color - Current activity hilight color

  last_timestamp - Last time timestamp was written in window
  last_line - Last time text was written in window

  theme_name - Active theme in window, undef = default

UI::TextDest->{}
  window - Window where the text will be written
  server - Target server
  target - Target channel/query/etc name
  level - Text level

  hilight_priority - Priority for the hilighted text
  hilight_color - Color for the hilighted text


=head1 METHODS

Window::command(cmd)
Window::print(str[, level])


Window::items()
  Return a list of items in window.

Window
window_create(automatic)
Windowitem::window_create(automatic)
  Create a new window.

Window::destroy()
  Destroy the window.

Irssi::Window
Windowitem::window()
  Returns parent window for window item.

Window
window_find_name(name)
  Find window with name.

Window
window_find_refnum(refnum)
  Find window with reference number.

Window
window_find_level(level)
Server::window_find_level(level)
  Find window with level.

Window
window_find_closest(name, level)
Server::window_find_closest(name, level)
  Find window that matches best to given arguments. `name' can be either
  window name or name of one of the window items.

Window
window_find_item(name)
Server::window_find_item(name)
  Find window which contains window item with specified name/server.


Window::item_add(item, automatic)
Window::item_remove(item)
Window::item_destroy(item)
  Add/remove/destroy window item


Window::set_active()
  Set window active.

Window::change_server(server)
Window::set_refnum(refnum)
Window::set_name(name)
Window::set_history(name)
Window::set_level(level)
  Change server/refnum/name/history/level in window.

Window::item_prev()
Window::item_next()
  Change to previous/next window item.
