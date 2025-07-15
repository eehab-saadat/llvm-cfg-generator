#include "cJSON.h"
#include <stdio.h>

int main() {
    // Sample JSON string (content from json.txt)
    const char *json_string = "{\"JSON Test Pattern pass3\": {\"The outermost value\": \"must be an object or array.\", \"In this test\": \"It is an object.\"}}";
    
    // Parse JSON
    cJSON *json = cJSON_Parse(json_string);
    if (!json) {
        return 1; // Parse failed
    }
    
    // Access the root object
    cJSON *test_pattern = cJSON_GetObjectItem(json, "JSON Test Pattern pass3");
    if (test_pattern && cJSON_IsObject(test_pattern)) {
        // Access nested properties
        cJSON *outermost = cJSON_GetObjectItem(test_pattern, "The outermost value");
        if (outermost && cJSON_IsString(outermost)) {
            // Successfully accessed the string value
        }
        
        cJSON *in_this_test = cJSON_GetObjectItem(test_pattern, "In this test");
        if (in_this_test && cJSON_IsString(in_this_test)) {
            // Successfully accessed the string value
        }
    }
    
    // Print the parsed JSON back to string (formatted)
    char *formatted_json = cJSON_Print(json);
    if (formatted_json) {
        cJSON_free(formatted_json);
    }
    
    // Clean up
    cJSON_Delete(json);
    
    return 0;
} 