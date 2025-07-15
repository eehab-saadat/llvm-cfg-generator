#include "html-private.h"
#include "pool.h"
#include "file.h"

int main() {
    /* HTML content from html.txt */
    const char *html_content = "<!DOCTYPE html>\n<html>\n  <head><title>Test Page</title></head>\n  <body>\n    <h1>Hello, World!</h1>\n    <p>Sample paragraph.</p>\n  </body>\n</html>";
    
    hc_pool_t *pool;
    hc_html_t *html;
    hc_file_t *file;
    hc_node_t *root_node;
    hc_node_t *current_node;
    bool success;
    
    /* Create memory pool */
    pool = hcPoolNew();
    if (!pool) {
        return 1;
    }
    
    /* Create HTML document */
    html = hcHTMLNew(pool, NULL);
    if (!html) {
        hcPoolDelete(pool);
        return 1;
    }
    
    /* Create file from string buffer */
    file = hcFileNewString(pool, html_content);
    if (!file) {
        hcHTMLDelete(html);
        hcPoolDelete(pool);
        return 1;
    }
    
    /* Parse HTML content */
    success = hcHTMLImport(html, file);
    if (!success) {
        hcFileDelete(file);
        hcHTMLDelete(html);
        hcPoolDelete(pool);
        return 1;
    }
    
    /* Get root node */
    root_node = hcHTMLGetRootNode(html);
    if (root_node) {
        /* Navigate through the HTML structure */
        current_node = hcNodeGetFirstChildNode(root_node);
        while (current_node) {
            /* Check if it's an HTML element */
            if (current_node->element == HC_ELEMENT_HTML) {
                hc_node_t *head_node = hcNodeGetFirstChildNode(current_node);
                while (head_node) {
                    if (head_node->element == HC_ELEMENT_HEAD) {
                        /* Found head element */
                        hc_node_t *title_node = hcNodeGetFirstChildNode(head_node);
                        while (title_node) {
                            if (title_node->element == HC_ELEMENT_TITLE) {
                                /* Found title element */
                                hc_node_t *title_text = hcNodeGetFirstChildNode(title_node);
                                if (title_text && title_text->element == HC_ELEMENT_STRING) {
                                    /* Successfully accessed title text */
                                }
                            }
                            title_node = hcNodeGetNextSiblingNode(title_node);
                        }
                    } else if (head_node->element == HC_ELEMENT_BODY) {
                        /* Found body element */
                        hc_node_t *body_child = hcNodeGetFirstChildNode(head_node);
                        while (body_child) {
                            if (body_child->element == HC_ELEMENT_H1) {
                                /* Found h1 element */
                                hc_node_t *h1_text = hcNodeGetFirstChildNode(body_child);
                                if (h1_text && h1_text->element == HC_ELEMENT_STRING) {
                                    /* Successfully accessed h1 text */
                                }
                            } else if (body_child->element == HC_ELEMENT_P) {
                                /* Found p element */
                                hc_node_t *p_text = hcNodeGetFirstChildNode(body_child);
                                if (p_text && p_text->element == HC_ELEMENT_STRING) {
                                    /* Successfully accessed p text */
                                }
                            }
                            body_child = hcNodeGetNextSiblingNode(body_child);
                        }
                    }
                    head_node = hcNodeGetNextSiblingNode(head_node);
                }
            }
            current_node = hcNodeGetNextSiblingNode(current_node);
        }
    }
    
    /* Get DOCTYPE */
    const char *doctype = hcHTMLGetDOCTYPE(html);
    if (doctype) {
        /* Successfully accessed DOCTYPE */
    }
    
    /* Clean up */
    hcFileDelete(file);
    hcHTMLDelete(html);
    hcPoolDelete(pool);
    
    return 0;
} 