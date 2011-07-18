
/* Originally this code was part of the irssi-lua module
 * <https://github.com/ahf/irssi-lua> and copyright as below:
 *
 * Copyright (c) 2009 Alexander Færøy <ahf@irssi.org>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 *
 */

#include <overlay_core.h>
#include <overlay_irssi.h>
#include <overlay_impl.h>
#include <terminfo-core.h>

static void cmd_overlay(const char *data, SERVER_REC *server) {

    terminfo_move(current_term->width, current_term->height);
    //terminfo_clear();
    print_random_message("What is going on here?");
}

void overlay_init() {
    module_register(MODULE_NAME, "core");
    print_load_message();

    command_bind("overlay", NULL, (SIGNAL_FUNC) cmd_overlay);
}


void overlay_deinit() {
    command_unbind("overlay", (SIGNAL_FUNC) cmd_overlay);
    print_unload_message();
}
