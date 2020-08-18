#include <display/vga.h>
#include <drivers/keyboard.h>
void kernel_start()
{
    make_vga_terminal();
    write_string_to_terminal("TINAOS Kernel v1.0\n");
    while(1)
    {
        if((inb(0x64) & 1) != 0)
        {
            int code = scan_code();
            write_string_to_terminal("User has made keyboard input!\n");
        }
    }
}
