# [GCC cross compiler](https://wiki.osdev.org/GCC_Cross-Compiler)

The host and the target may differ in processor, opearating system, or
executable format.

For our purposes, we will build a cross compiler for the i686 architecture that
uses the elf executable format - i686-elf.

The steps in [this guide](make-jos-cc) are intended for Debian and have been
tested in Ubuntu 16.04 and Ubuntu 18.04.
