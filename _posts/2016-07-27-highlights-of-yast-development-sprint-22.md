---
layout: post
date: 2016-07-27
title: Highlights of YaST development sprint 22
description: openSUSE Conference’16, Hackweek 14 and the various SUSE internal
  workshops are over. So it’s time for the YaST team to go back to usual
  three-weeks-long development sprints… and with new sprints come new public
  reports!
category: SCRUM
tags:
- Distribution
- Factory
- Programming
- Systems Management
- YaST
---

With Leap 42.2 in Alpha phase and SLE12-SP2 in Beta phase our focus is
on bugs fixing, so we don’t have as much fancy stuff to show in this
report. Still, here you are some bits you could find interesting.

### Installer memory consumption reduced

For our SLE customers we promise installations on machines with as
little as 512MB of RAM. For Tumbleweed, 1GB is required – so the
situation is more relaxed there.

But look at the total size of filesystem images that must be kept in
memory during installation: 176MB for SLE12 (Tumbleweed: 224MB). This is
leaving not much room to run programs.

The size has grown considerably over time, and we had to look for places
to save space. We came up with some major areas for improvement.

The initrd and the installation system (the file system image containing
the installer) share many files (mainly libraries). By removing any
overlap, we were able to reduce the image size by 17MB for SLE12
(Tumbleweed: 30MB).

After the package installation starts, kernel modules and some raw
libzypp cache data are no longer needed. By deleting zypp data we save
another 3MB and kernel modules occupy even 29MB in SLE12 (Tumbleweed:
50MB). But we do this only on systems with less than 1GB memory.

So, compared to the available 512MB, these savings are quite substantial
and will hopefully keep us going for a while…

### Storage reimplementation: another step to an installable system

It’s time for our reimplementation of the storage layer to prove it can
do the real work. Thus, we have integrated the new code in a set of
[modified Tumbleweed ISO images][1] automatically generated in OBS. They
cannot still be used to install a system, but the installer is already
able to boot and reach the language selection screen (the first
milestone we were aiming for).

We already had code that works in a simulated test environment (unit
tests) and now we have a way to use that code in a real installer. Stay
tuned for exciting news!

### Make many extensions fit on the screen properly

For SUSE Linux Enterprise we offer so many optional modules that their
listing did not fit on lower resolution screens. Below you can see how
the screen looked before the fix – checkbox widgets and their labels do
not fit so their bottoms are cropped.

[![Old interface with cropped
extensions](../../../../images/2016-07-27/bcropped-300x225.png)](../../../../images/2016-07-27/bcropped.png)

We have to make sure YaST works across different interfaces, including
text-based ncurses. That limits the set of widgets we can use when
designing interfaces, so finding a solution to that kind of problems is
not always easy. We also took the opportunity to add a filter for beta
extensions, as you can see in the following screenshot.

[![The beta extensions filter in
action](../../../../images/2016-07-27/bfiltered-300x225.png)](../../../../images/2016-07-27/bfiltered.png)

And finally you can see how it looks like with all the extensions,
including beta ones. Instead of cropping elements we now have a
scroll-bar in the right.

[![The new extensions UI in all its
glory](../../../../images/2016-07-27/bmodules-300x225.png)](../../../../images/2016-07-27/bmodules.png)

### Storage reimplementation: LVM unit testing

The next step in the storage layer reimplementation is adding support
for LVM, since right now only regular partitions are supported. We
always write a lot of unit tests to make sure the different pieces work
in isolation before integrating everything together into the installer.
During this sprint we created all the infrastructure for testing LVM at
such level. Armed with that, we can start writing reliable code to
handle LVM (something we have already started to do).

### Improved patterns handling for system roles

We recently introduced the concept of system roles during installation.
The chosen role affects the selection of package patterns. But we
realized that the roles were not completely overriding the default
selection of packages. Before the fix introduced in this sprint, desktop
related patterns were included for a [KVM server role][2] and, thus, the
systemd target was graphical.

[![The KVM Server role before the
fix](../../../../images/2016-07-27/bbadrole-300x234.png)](../../../../images/2016-07-27/bbadrole.png)

Now, only the 3 patterns explicitly intended for the KVM role are
selected, with no desktop related patterns. Accordingly, the system
boots to text mode.

[![Fixed KVM Server
role](../../../../images/2016-07-27/bgoodrole-300x234.png)](../../../../images/2016-07-27/bgoodrole.png)

### Storage reimplementation: the future of booting

We have explained in several previous posts how we are collaborating
with Grub and hardware architecture experts to make sure the new storage
layer makes always sensible partitioning proposals. For that purpose
[RSpec][3] has proven to be an excellent tool. It does not only allow us
to have full unit test coverage or our code, but also the generated
output has become the perfect base to discuss the expected behavior of
the system in every possible scenario.

During this sprint, we spent quite some time together with SUSE’s Grub
genius Michael Chang defining the best possible partitioning schema in
x86 architectures. Once we had a human-readable and non-ambiguous
specification, we modified our code to make sure the associated RSpec
tests generated exactly the [same specification][4] as output. This way
we make sure that our code works and that it fits 100% the experts
expectations.

Kudos to Michael for his infinite patience with our questions and for
coming up with an innovative way of using Grub2 that will allow us to
boot in many tricky scenarios, eliminating the need of introducing a
separate `/boot` in almost all cases.

### Conclusion

As said, most of the sprint was invested in chasing bugs… and we don’t
expect next sprint to be different in that regard. Even though, we hope
this post to contain enough new stuff to keep you entertained and
informed about what is going on in the YaST trenches.

See you in three weeks!



[1]: http://download.opensuse.org/repositories/YaST:/storage-ng/images/iso/
[2]: https://github.com/yast/yast-installation/wiki/System-Role
[3]: http://rspec.info/
[4]: https://github.com/yast/yast-storage-ng/blob/master/doc/boot-requirements.md
