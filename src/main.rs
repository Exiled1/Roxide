#![no_std]
#![no_main]
use core::{panic::PanicInfo, arch::global_asm};

global_asm!(include_str!("boot.S"));


// Need a panic handler to avoid compiler errors, as it's a required item for no_std
#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {

    loop {}
}

static HELLO: &[u8] = b"Hello World!";

#[no_mangle]
pub extern "C" fn kernel_main() -> ! {
    let vga_buffer = 0xb8000 as *mut u8;
    
    for (i, &byte) in HELLO.iter().enumerate() {
        unsafe {
            *vga_buffer.offset(i as isize * 2) = byte;
            *vga_buffer.offset(i as isize * 2 + 1) = 0xb;
        }
    }

    loop {}
}