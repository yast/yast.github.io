---
layout: post
date: 2018-12-04 14:32:45.000000000 +00:00
title: Highlights of YaST Development Sprint 68
description: UDF and Raspberry Pi support in YaST!
category: SCRUM
tags:
- YaST
- installation
- partitioner
- Raspberry Pi
- UDF
---

* UDF: Share big files with other operating systems
* Raspberry Pi: Fully customized installation with YaST

### Support for UDF file system   {#support-for-udf-file-system}

UDF ([Universal Disk Format][1]) is a file system format widely used for
DVDs and newer optical disk formats, replacing ISO 9660. But this
technology is not limited to optical media only, in fact it can be
perfectly used on flash devices like USB sticks and hard drives too. UDF
is one of the best choices when transferring data between platforms.
Mostly all modern operating system already support it, including
Windows, BSD, MacOS X, Solaris, OS/2 (eComStation), BeOS (Haiku) as well
as Linux kernel.

UDF offers several advantages. One of them is the support for quite very
large files. With UDF you can create files of several terabytes, making
really ridiculous the maximum limitation of 4 gigabytes in VFAT. And not
only that, UDF also has optional built-in ability to minimize
wearing-off of rewritable media with limited rewrite cycles, such as
flash, CD-RW and DVD-RAM.

YaST is starting to support UDF file systems out of the box. The Expert
Partitioner now offers the UDF option when formatting a device, see the
following screenshot. And this is available even during the
installation, so you could create a volume with UDF format and share it
between your different operating systems.

{% include blog_img.md alt=""
src="49377614-8e0cd100-f702-11e8-9832-10b5dac142a6-300x218.png" full_img="49377614-8e0cd100-f702-11e8-9832-10b5dac142a6.png" %}

### Just click \"next\" to install (open)SUSE in a Raspberry Pi   {#just-click-next-to-install-opensuse-in-a-raspberry-pi}

Anybody who has not been living under a rock for the last five years
knows [Raspberry Pi][2]. And anyone who has used one of those devices
knows the usual way to put an operating system into it is different from
what we are used to do in other computers. Instead of installing from a
regular ISO, customizing all the options in the process, Raspberry Pi
and similar mini-computers are usually loaded with a pre-built image of
an operating system (specific for each model) downloaded from the
Internet. Many of those precooked Linux systems are purpose-specific and
many decisions (like the file-system type to use) are already taken by
those who built the image.

But we wanted SLE 15-SP1 and openSUSE Leap 15.1 to be the first
multi-purpose operating systems to support a full standard Linux
experience in Raspberry Pi. No custom specific ISO to install from, no
precooked image to be copied, just taking the standard unmodified SLE or
openSUSE ISO image and installing like you would do in any other
computer. And we wanted the process to be as easy as pressing \"next\",
\"next\", \"next\", \"install\". With the installer detecting and
proposing the set of default configurations that makes sense, as usual.

The main challenge in that regard was the partitioning layout. In order
to boot, the Raspberry Pi needs a very specific partition containing the
system firmware. So it is important for the installer to detect such a
partition and preserve it no matter what, mounting it in `/boot/vc` to
allow the operating system to perform updates of the firmware. In the
following screenshot of the installation process performed trough the
Raspberry Pi serial console you can see that in action.

{% include blog_img.md alt=""
src="49296302-25321880-f4b8-11e8-9796-7363bc9ddbc4-300x198.png" full_img="49296302-25321880-f4b8-11e8-9796-7363bc9ddbc4.png" %}

The serial console is the method preferred by the experts to manage the
Raspberry Pi locally and it works out of the box with the pre-releases
of the upcoming SLE-15-SP1 and Leap 15.1. But less advanced users will
likely prefer to perform a graphical installation with a keyboard and a
screen attached to the device. For it to work flawlessly, the following
arguments must be provided to the installer during boot.

    textmode=0 modprobe.blacklist=vc4

The second argument prevents the HDMI output to be disconnected shortly
after the computer has booted, something that will only happen with some
monitors. It happened to us during our testing (that you can see below)
and that argument certainly made the problem disappear.

{% include blog_img.md alt=""
src="49433714-ebf8f180-f7b2-11e8-9541-36e49113f2f2-208x300.jpg" full_img="49433714-ebf8f180-f7b2-11e8-9541-36e49113f2f2.jpg" %}

Just one final note if you want to play with this: Take into account
Raspberry Pi uses a different internal architecture than usual PCs. So
instead of the x86 image of the installer, you will need to use the
aarch64 one. The aarch64 architecture is officially fully supported by
SLE and also available for openSUSE Leap and Tumbleweed as an unofficial
port.



[1]: https://en.wikipedia.org/wiki/Universal_Disk_Format
[2]: https://www.raspberrypi.org/
