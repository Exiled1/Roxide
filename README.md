These files exist for these reasons:
-    boot.s - kernel entry point that sets up the processor environment
-    kernel.c - your actual kernel routines
-    linker.ld - for linking the above files 

---

Keeping this here for now, might need to change entry later, also link-args for rustc might be outdated.
# Linux
cargo rustc -- -C link-arg=-nostartfiles
# Windows
cargo rustc -- -C link-args="/ENTRY:_start /SUBSYSTEM:console"
# macOS
cargo rustc -- -C link-args="-e __start -static -nostartfiles"

---

Interesting unstable rust features that might be useful

Custom test frameworks:
- https://doc.rust-lang.org/beta/unstable-book/language-features/custom-test-frameworks.html

Inline Const Pattern:
- https://doc.rust-lang.org/beta/unstable-book/language-features/inline-const-pat.html

Inline Const:
- https://doc.rust-lang.org/beta/unstable-book/language-features/inline-const.html

Negative Impls:
- https://doc.rust-lang.org/beta/unstable-book/language-features/negative-impls.html

