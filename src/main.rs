#![no_std]
#![no_main]
use core::panic::PanicInfo;

// Need a panic handler to avoid compiler errors, as it's a required item for no_std
#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    loop {}
}

#[no_mangle]
pub extern "C" fn _start() -> ! {
    
    // Rename this later on when handling the linker script
    loop {}
}

