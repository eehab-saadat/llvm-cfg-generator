#include "parson.h"
#include <stdio.h>

int main(int argc, char *argv[]) {
    if (argc < 2) {
        return 1;
    }

    const char *filename = argv[1];

    JSON_Value *root_value = json_parse_file(filename);

    if (root_value == NULL) {
        return 1;
    }

    // Successfully parsed JSON
    printf("JSON parsed successfully from file: %s\n", filename);
    json_value_free(root_value);
    return 0;
}
