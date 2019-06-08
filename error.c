
#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include <assert.h>
#include "error.h"

void panic(const char *msg) {
    fprintf(stderr, "ERROR: %s\n", msg);
    assert(false);
}
