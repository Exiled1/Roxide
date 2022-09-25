// asmsyntax = gas

// Hopefully grub compliant bootloader
// Resource/citation for where the bootloader code comes from: https://wiki.osdev.org/Bare_Bones#Booting_the_Operating_System
// Multiboot2 specification: http://nongnu.askapache.com/grub/phcoder/multiboot.pdf
// Gas assembler directives link: https://ftp.gnu.org/old-gnu/Manuals/gas-2.9.1/html_chapter/as_7.html#SEC98

/*
    The layout of the Multiboot2 header must be as follows:
    Offset	Type	Field Name	Note
    0	u32	magic	required
    4	u32	architecture	required
    8	u32	header_length	required
    12	u32	checksum	required
    16-XX		tags	required
*/

/* Declare constants for the multiboot header. */
.set ALIGN, 1 << 0 /* Align all boot modules on i386 page (4KB) boundaries. */
.set MEMINFO, 1 << 1 /* Must pass memory information to OS. */
.set FLAGS, ALIGN | MEMINFO /* this is the Multiboot 'flag' field */
.set MAGIC, 0x1BADB002 /* this is the Multiboot 'magic' field to find the header*/
.set CHECKSUM, -(MAGIC + FLAGS) /* this is the Multiboot 'checksum' field, we're good to multiboot if this passes. */

/* 
Declare a multiboot header that marks the program as a kernel. These are magic
values that are documented in the multiboot standard. The bootloader will
search for this signature in the first 8 KiB of the kernel file, aligned at a
32-bit boundary. The signature is in its own section so the header can be
forced to be within the first 8 KiB of the kernel file.

4 bytes fit within a single 32-bit word, so we can use a single .long (4 bytes)
*/

.section .multiboot
.align 4
.long MAGIC
.long FLAGS
.long CHECKSUM


/*
The multiboot standard does not define the value of the stack pointer register
(esp) and it is up to the kernel to provide a stack. This allocates room for a
small stack by creating a symbol at the bottom of it, then allocating 16384 (16 KiB)
bytes for it, and finally creating a symbol at the top. The stack grows
downwards on x86. The stack is in its own section so it can be marked nobits,
which means the kernel file is smaller because it does not contain an
uninitialized stack. The stack on x86 must be 16-byte aligned according to the
System V ABI standard and de-facto extensions. The compiler will assume the
stack is properly aligned and failure to align the stack will result in
undefined behavior.
*/

// Nice image of program memory layout: https://en.wikipedia.org/wiki/File:Program_memory_layout.pdf
.section .bss
.align 16
stack_bottom:
.skip 16384 /* 16 KiB */
stack_top:

/*
The linker script specifies _start as the entry point to the kernel and the
bootloader will jump to this position once the kernel has been loaded. It
doesn't make sense to return from this function as the bootloader is gone.
*/

.section .text
.global _start
/* 
.type _start, @function meaning: https://developer.arm.com/documentation/102422/0100/GAS-syntax-reference
Type directive tells the tools what a symbol refers to, here we're saying that the _start symbol is a function.
*/
.type _start, @function
_start:
    /*
	The bootloader has loaded us into 32-bit protected mode on a x86
	machine. Interrupts are disabled. Paging is disabled. The processor
	state is as defined in the multiboot standard. The kernel has full
	control of the CPU. The kernel can only make use of hardware features
	and any code it provides as part of itself. There's no printf
	function, unless the kernel provides its own <stdio.h> header and a
	printf implementation. There are no security restrictions, no
	safeguards, no debugging mechanisms, only what the kernel provides
	itself. It has absolute and complete power over the
	machine.
	*/
 
	/*
	To set up a stack, we set the esp register to point to the top of the
	stack (as it grows downwards on x86 systems). This is necessarily done
	in assembly as languages such as C cannot function without a stack.
	*/
    // Code below here is bootloader code :)