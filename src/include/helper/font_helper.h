#include <stdint.h>
#include <stddef.h>
#ifndef FONT_HELPER
#define FONT_HELPER

typedef struct
{
    uint32_t magic;
    uint32_t version;
    uint32_t headersize;
    uint32_t flags;
    uint32_t numglyph;
    uint32_t bytesperglyph;
    uint32_t height;
    uint32_t width;
} console_font;

extern char _binary_font_psf_start;
extern char _binary_font_psf_end;

uint16_t *unicode;
void init_font_helper()
{
    uint16_t glyph = 0;
    console_font *font = (console_font*) & _binary_font_psf_start;
}
#endif