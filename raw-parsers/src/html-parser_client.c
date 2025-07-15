#include "flo/html-parser.h"
#include "flo/util/memory/arena.h"
#include "flo/util/text/string.h"

int main() {
    /* HTML content from html.txt */
    const char *html_content = "<!DOCTYPE html>\n<html>\n  <head><title>Test Page</title></head>\n  <body>\n    <h1>Hello, World!</h1>\n    <p>Sample paragraph.</p>\n  </body>\n</html>";
    
    /* Create string from content */
    flo_String html_string = FLO_STRING(html_content);
    
    /* Create memory arena */
    flo_Arena arena = {0};
    char arena_buffer[8192];
    arena.beg = arena_buffer;
    arena.end = arena_buffer + sizeof(arena_buffer);
    arena.cap = sizeof(arena_buffer);
    
    /* Parse HTML content */
    flo_html_Dom *dom = flo_html_createDom(html_string, &arena);
    if (!dom) {
        return 1;
    }
    
    /* Access the parsed DOM structure */
    if (dom->nodes.len > 0) {
        /* Successfully parsed HTML */
        /* The DOM structure contains:
         * - dom->nodes: array of HTML nodes
         * - dom->parentChilds: parent-child relationships
         * - dom->nextNodes: sibling relationships
         * - dom->tagRegistry: tag names
         * - dom->boolPropRegistry: boolean properties
         * - dom->propKeyRegistry: property keys
         * - dom->propValueRegistry: property values
         */
    }
    
    return 0;
} 