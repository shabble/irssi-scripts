#include <overlay_irssi.h>
#include <overlay_impl.h>
#include <overlay_core.h>

void print_load_message(void) {

    printtext(NULL, NULL, MSGLEVEL_CLIENTERROR,
              "Hello, World, ~~ \"%s\"", MODULE_NAME);

}

void print_random_message(char *str) {
    printtext(NULL, NULL, MSGLEVEL_CLIENTCRAP,
              "%s", str);
}

void print_unload_message(void) {

    printtext(NULL, NULL, MSGLEVEL_CLIENTERROR,
              "Goodbye, Cruel World. ~~ \"%s\"", MODULE_NAME);

}

