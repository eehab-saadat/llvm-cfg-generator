#include "ini.h"

/* Structure to store parsed INI data */
typedef struct {
    char user_name[100];
    int user_age;
    char settings_theme[50];
    int settings_autosave;
} ini_data_t;

/* Helper function to compare strings without string.h */
static int strcmp_custom(const char* s1, const char* s2) {
    while (*s1 && *s2 && *s1 == *s2) {
        s1++;
        s2++;
    }
    return *s1 - *s2;
}

/* Handler function called for each key-value pair */
static int my_ini_handler(void* user, const char* section, const char* name, const char* value) {
    ini_data_t* data = (ini_data_t*)user;
    
    if (strcmp_custom(section, "User") == 0) {
        if (strcmp_custom(name, "name") == 0) {
            /* Copy user name */
            int i;
            for (i = 0; value[i] && i < 99; i++) {
                data->user_name[i] = value[i];
            }
            data->user_name[i] = '\0';
        } else if (strcmp_custom(name, "age") == 0) {
            /* Parse age as integer */
            data->user_age = 0;
            int i = 0;
            while (value[i] >= '0' && value[i] <= '9') {
                data->user_age = data->user_age * 10 + (value[i] - '0');
                i++;
            }
        }
    } else if (strcmp_custom(section, "Settings") == 0) {
        if (strcmp_custom(name, "theme") == 0) {
            /* Copy theme */
            int i;
            for (i = 0; value[i] && i < 49; i++) {
                data->settings_theme[i] = value[i];
            }
            data->settings_theme[i] = '\0';
        } else if (strcmp_custom(name, "autosave") == 0) {
            /* Parse autosave as boolean */
            data->settings_autosave = (strcmp_custom(value, "true") == 0) ? 1 : 0;
        }
    }
    
    return 1; /* Return 1 to continue parsing */
}

/* Custom string reader for ini_parse_stream */
static char* string_reader(char* str, int num, void* stream) {
    const char** string_ptr = (const char**)stream;
    if (!*string_ptr || num <= 1) {
        return NULL;
    }
    
    int i = 0;
    while (i < num - 1 && (*string_ptr)[i] && (*string_ptr)[i] != '\n') {
        str[i] = (*string_ptr)[i];
        i++;
    }
    str[i] = '\0';
    
    if ((*string_ptr)[i] == '\n') {
        *string_ptr += i + 1;
    } else {
        *string_ptr += i;
    }
    
    return str;
}

int main() {
    /* INI content from ini.txt */
    const char* ini_content = "[User]\nname = Alice\nage = 30\n\n[Settings]\ntheme = dark\nautosave = true\n";
    
    ini_data_t data = {0}; /* Initialize all fields to 0/NULL */
    const char* current_pos = ini_content;
    
    /* Parse the INI string */
    int result = ini_parse_stream(string_reader, &current_pos, my_ini_handler, &data);
    
    if (result == 0) {
        /* Successfully parsed */
        /* Access the parsed data */
        if (data.user_name[0]) {
            /* User name was parsed */
        }
        if (data.user_age > 0) {
            /* User age was parsed */
        }
        if (data.settings_theme[0]) {
            /* Theme was parsed */
        }
        if (data.settings_autosave) {
            /* Autosave was parsed as true */
        }
    }
    
    return 0;
} 