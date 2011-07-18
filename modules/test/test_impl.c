#include <test_irssi.h>
#include <test_impl.h>
#include <test_core.h>

void print_load_message(void) {

    printtext(NULL, NULL, MSGLEVEL_CLIENTERROR,
              "Hello, World. xxx \"%s\"", MODULE_NAME);

}

void print_unload_message(void) {

    printtext(NULL, NULL, MSGLEVEL_CLIENTERROR,
              "Goodbye, Cruel World. ~signed \"%s\"", MODULE_NAME);

}

