
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

#include <perl_plus_core.h>
#include <perl_plus_irssi.h>
#include <perl_plus_impl.h>

void perl_plus_init() {
    module_register(MODULE_NAME, "core");
    print_load_message();
}

void perl_plus_deinit() {
    print_unload_message();
}
