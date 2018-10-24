# Requirements

## Emulators
### [bochs](http://bochs.sourceforge.net/)

> Bochs is a highly portable open source IA-32 (x86) PC emulator written in 
> C++, that runs on most popular platforms. It includes emulation of the Intel
> x86 CPU, common I/O devices, and a custom BIOS.

#### Installation and setup

You can download the latest release of Bochs
[here](https://sourceforge.net/projects/bochs/files/bochs/).

#### Linux 

1. Modify `.conf.linux` to meet your needs.
   a. To enable the internal debuger add: `--enable-disasm` and `--enable-debugger`.
   b. To enable debugging via gdb add: `--enable-gdb-stub`.
2. `sh .conf.linux`
3. `make`
4. `make install`

#### MacOS

Use `.conf.macos` instead of `.conf.linux` and follow the instructions for
Linux. 

##### Debian installation
```shell
sudo apt-get update -y && sudo apt-get install -y bochs bochs-x
```

For more info, visit
[Bochs: Installation & Setup](https://www.cs.princeton.edu/courses/archive/fall09/cos318/precepts/bochs_setup.html).


### [Qemu](https://www.qemu.org/)

> generic and open source machine emulator and virtualizer.

#### Installation

Follow the [official installation instruction](https://www.qemu.org/download/).

#### Installation instructions for Debian
```shell
sudo apt-get update -y && sudo apt-get install -y qemu qemu-kvm virt-manager
virt-viewer libvirt-bin
```

`KVM` (kernel virtual machine) is a Linux kernel module that allows a user
space program to utilize the processor's hardware virtualization features.

Qemu can use the KVM when running a target architecture that is the same as the
host architecture to accelerate the emulation process.

To use KVM, pass the `--enable-kvm` flag to qemu.

`libvirt` is a C toolkit to interact with the virtualization capablities of
recent versions of Linux and other similar operating systems.
The llibrary aims to provide a long term stable API for different
virtualization mechanisms.
It currently supports QEMU, KVM, XEN, OpenVZ, LXCm and VirtualBox.

`virt-manager` and `virt-viewer` are addons to work with `libvirt`.



## Cross-compiler

For background info, details, and instructions on how to build a GCC
cross-compiler see 
[this page from the osdev wiki](https://wiki.osdev.org/GCC_Cross-Compiler).

### Debian installation

You can try out [this script](../../xv6/cross-compiler/make-jos-cc.sh) to
build a GCC cross-compiler - it has been tested in ubuntu 16.04 and 18.04.
