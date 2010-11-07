/* vim: set sw=4 sts=4 et foldmethod=syntax : */

/* 
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
 */

#include <test_harness.h>
#include <test_harness_irssi.h>

void test_harness_init(void) {
    module_register(MODULE_NAME, "core");
    printtext(NULL, NULL, MSGLEVEL_CLIENTCRAP, "Hello, World.");
    /* int i = 0; */
    /* for (i = 0; i < 26; i++) { */
    /*     signal_emit("gui key pressed", 1, 'a' + i); */
    /* } */

    signal_emit("beep", 0);
}

void test_harness_deinit() {
/* lua_loader_deinit(); */
/* lua_commands_deinit(); */
/* lua_api_deinit(); */
}

/*
 * Plan:
 * Register as a plugin
 * Open a FIFO (named pipe) for control
 * allow emission of arbitrary signals (via fifo control channel)
 * allow signal listeners for arbitrary signals (serialised to some format
 *  and printed to fifo.

 * Issues:
 * How to handle serialisation / args marshalling?
 * 

 */
