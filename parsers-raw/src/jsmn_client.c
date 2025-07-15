#include "jsmn.h"

/* Helper function to compare JSON string with a token */
static int jsoneq(const char *json, jsmntok_t *tok, const char *s) {
    if (tok->type == JSMN_STRING) {
        int len = 0;
        while (s[len] != '\0') len++;
        if (len == tok->end - tok->start) {
            int i;
            for (i = 0; i < len; i++) {
                if (json[tok->start + i] != s[i]) {
                    return -1;
                }
            }
            return 0;
        }
    }
    return -1;
}

/* Helper function to get string length */
static int strlen_custom(const char *s) {
    int len = 0;
    while (s[len] != '\0') len++;
    return len;
}

int main() {
    /* JSON string from json.txt */
    const char *json_string = "{\"JSON Test Pattern pass3\": {\"The outermost value\": \"must be an object or array.\", \"In this test\": \"It is an object.\"}}";
    
    jsmn_parser parser;
    jsmntok_t tokens[32]; /* Array to store tokens */
    int token_count;
    int i;
    
    /* Initialize parser */
    jsmn_init(&parser);
    
    /* Parse JSON */
    token_count = jsmn_parse(&parser, json_string, strlen_custom(json_string), tokens, 32);
    
    if (token_count < 0) {
        /* Parse error */
        return 1;
    }
    
    /* Check if root is an object */
    if (token_count < 1 || tokens[0].type != JSMN_OBJECT) {
        return 1;
    }
    
    /* Navigate through the JSON structure */
    for (i = 1; i < token_count; i++) {
        if (jsoneq(json_string, &tokens[i], "JSON Test Pattern pass3") == 0) {
            /* Found the main object */
            if (i + 1 < token_count && tokens[i + 1].type == JSMN_OBJECT) {
                int j;
                int obj_start = i + 2;
                int obj_size = tokens[i + 1].size;
                
                /* Navigate through the nested object */
                for (j = 0; j < obj_size * 2; j += 2) {
                    int key_idx = obj_start + j;
                    int val_idx = obj_start + j + 1;
                    
                    if (key_idx < token_count && val_idx < token_count) {
                        if (jsoneq(json_string, &tokens[key_idx], "The outermost value") == 0) {
                            /* Found "The outermost value" key */
                            if (tokens[val_idx].type == JSMN_STRING) {
                                /* Successfully accessed the string value */
                            }
                        } else if (jsoneq(json_string, &tokens[key_idx], "In this test") == 0) {
                            /* Found "In this test" key */
                            if (tokens[val_idx].type == JSMN_STRING) {
                                /* Successfully accessed the string value */
                            }
                        }
                    }
                }
                i += obj_size + 1;
            }
        }
    }
    
    return 0;
} 