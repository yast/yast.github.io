---
layout: post
date: 2017-08-24 13:03:35.000000000 +02:00
title: Highlights of YaST development sprint 41
description: We all know that everything slows down in summertime and software development
  is not an exception. But heat is not enough to stop the YaST team from turning the
  Scrum wheel and delivering the corresponding sprint reports. Let&#8217;s take a
  look to what we have been doing the last two weeks.
category: SCRUM
tags:
- Distribution
- Factory
- Programming
- Systems Management
- YaST
---

### The storage reimplementation gets on the launchpad

As already anticipated in the [previous report][1], one of the goals of
this sprint was to merge the new storage stack into the codebase of SUSE
Linux Enterprise 15 and openSUSE Leap 15. That implies submitting
everything to Factory first and making sure the result looks harmless
and good enough there. Thanks to the awesome openSUSE tools and
processes, that kind of experiments can be isolated in a dedicated
staging project allowing us to reach useful conclusions without risking
the stability and features of Tumbleweed.

So we submitted two new source packages `libstorage-ng` and
`yast2-storage-ng` to Factory, together with new versions of all the
affected packages (already adapted to use the new system, instead of the
old `yast2-storage`) and a modified version of the list of packages to
be used during installation.

Everything was mixed and cooked in the Staging:E project and… guess
what! We got brand new Factory ISOs with storage-ng, successfully
building and verified to work by openQA, as you can see in this
screenshot of the Staging Dashboard.

{% include blog_img.md alt="Storage-NG in the Staging Dashboard"
src="staging_e-1-300x156.png" full_img="staging_e-1.png" %}

Yes, we know there are two failing tests in that dashboard, but that was
fully expected since those tests use the expert partitioner to configure
an installation of openSUSE on top of a MD RAID system and the
reimplemented partitioner still lacks some controls to configure MD RAID
arrays.

The new stack will live in Factory:Staging:E (or any other staging
project the Tumbleweed crew decides) for quite some time, until it’s
feature-pair with the old storage layer and, thus, can progress further
in its travel to Tumbleweed. But Factory was just the first stop, the
ultimate goal of this sprint was getting into the preliminary versions
of the next SLE and openSUSE Leap.

That second integration is taking a little bit longer because it has
coincided on time with other important changes in the installer and the
base system… and the fact that August is the typical European vacation
period is not exactly helping to iron all the details out. But since the
new storage system works for Factory, we are certain it will do it for
SUSE Linux and Leap.

As readers familiar with the Tumbleweed development process may have
noticed already, having all those packages in Staging:E implies that
newer versions of them will only reach Tumbleweed all at once, when
`yast2-storage-ng` is considered mature enough for that. Somehow, that
will block us from delivering new features for the packages you see in
the list in the mentioned image of the dashboard. But don’t worry, if
something serious happens and a critical update is needed we will not
let our beloved Tumbleweed users down.

But there is much more happening in YaSTland beyond the storage
reimplementation. Let’s take a look to the improvements in other areas.

### Installation without Grub packages

Sometimes, users have already Linux installed in their system and they
do not want to install Grub in MBR again with a new Linux distribution
since the installed Linux can manage the bootloader. For this case, the
user may decide to not install grub packages at all in the system.
However, until now the user was obligated to install this package
otherwise an error message would appear, as the image below shows.

{% include blog_img.md alt="YaST2-bootloader wrongly reporting about grub2 installation"
src="bootloader-with-no-grub-300x224.png" full_img="bootloader-with-no-grub.png" %}

For some specific scenarios, as you may find [here][2], even other
packages are required, and when the user decided for not installing the
bootloader, these packages were still required for the installation.

We changed this behavior in Tumbleweed and SLE 15, and now the users
will be able to install the system without the packages that are not
required, in case they decide to manage bootloader through another
operational system.

But that’s not the only improvement introduced in the bootloader
management during this sprint.

### Improve how YaST finds disk to install Grub in MBR

In Leap 42.3 and SLE 12.3, we found out that, in some very specific
cases (check [the bug report][3] for more details), YaST was not finding
the correct disk to install Grub in MBR. When it happened, an error
message appeared at the end of the installation, showing that Grub could
not be installed in /dev/btrfs disk.

{% include blog_img.md alt="Error during bootloader installation"
src="bootloader-btrfs-300x224.png" full_img="bootloader-btrfs.png" %}

We improved our approach to finding the correct MBR device, by adding a
specific search for the disk where the partition `/boot` or `/` (in case
`/boot` does not exist) is located.

Such a change will be released as maintenance update and self-update,
and it affects only Leap 42.3 and SLE 12.3, since SLE 15 will use the
new storage layer, which does not need this double check for the correct
disk.

And talking about the new storage system…

### Remove support for ReiserFS

The support of new installations with ReiserFS was removed from YaST in
SUSE Linux Enterprise 12 and openSUSE Leap 42 but upgrades were still
supported.

With SUSE Linux Enterprise 15 and Leap 15 the support of ReiserFS will
be completely removed from YaST and the installer will block the upgrade
of systems formatted with ReiserFS.

If some of the entries in the `/etc/fstab` file of the system to be
upgraded is using ReiserFS, the installer will suggest to convert them
to another filesystem type before migrating the system to SUSE Linux
Enterprise 15 or openSUSE Leap 15.

{% include blog_img.md alt="Preexisting /opt formatted as ReiserFS"
src="reiserfs-in-opt-300x225.png" full_img="reiserfs-in-opt.png" %}

A similar blocking error will be reported for ReiserFS root partitions.

{% include blog_img.md alt="Updating a ReiserFS root system"
src="reiserfs-as-root-300x225.png" full_img="reiserfs-as-root.png" %}

### Another Ruby 2.4 fix

This may be interesting for Ruby developers in general. We got a bug
report about [crashing YaST][4] which in the end turned out to be caused
by upgrade to Ruby 2.4. The tricky part was that YaST crashed randomly
and it was difficult to reproduce the problem.

It turned out that the crash happened when Ruby wanted to print a
warning on the error output, which in some situations failed. We did not
fix the race condition, as it likely would be too difficult to debug the
Ruby internals, but we at least [fixed the code][5] to not produce the
warnings anymore.

So if you are a Ruby developer take this free advise from your YaST
fellows – if your code crashes randomly with Ruby 2.4 then check for the
Ruby warnings first.

### A heads-up about network devices names

Two sprints ago [we told you][6] about the new possibility of
configuring the network with AutoYaST already in the first stage,
avoiding an extra restart of the system in most cases.

During this sprint we spent some time trying to test old AutoYaST
profiles (with complex network configurations) with the upcoming version
of SUSE Linux Enterprise Server, using our suite of automatic [AutoYaST
Integration Tests][7]. But we found some issues caused by the current
architecture of our test suite that may be of interest for some of our
readers.

Let’s see some technical background first.

Tumbleweed has been using ‘predictable network interface names’ for some
time now and it fits most regular use cases. Inspired or following the
scheme idea introduced by ‘biosdevname’, **[Predictable Network
Interface Names][8]** was adopted in systemd/udev v197 trying to solve
an historical problem with the non deterministic classic naming scheme
for network interfaces (eth0, eth1, eth2 …)

Basically it will assign fixed names based on [firmware, topology, and
location information][9] making them stable between system reboots,
hardware additions or removals and also between kernel or drivers
updates.

For the upcoming SLE15, we are giving predictable network interface
names a try (they are disabled in SLE12 and openSUSE Leap 42.x). For us
that turned to be a problem because our AutoYaST testsuite dynamically
creates new virtual machines on every system reboot (instead of really
rebooting the virtual machine created in the previous step). So from the
point of view of the operating system being tested, all the network
devices are replaced by new ones in every reboot and that drives the
network settings nuts.

That was only our case (arguably “our fault”), but there might be other
situations in which going back to the old naming scheme (with names like
‘eth0’) would be more convenient than adapting the preexisting AutoYaST
profiles to the new one. In such cases you still can use the old scheme
(not fully predictable but very well known by Linux veterans) by just
booting the SLE15 installation with this parameters.

```
biosdevname=0 net.ifnames=0
```

{% include blog_img.md alt="Disabling predictable network names in SLE15"
src="biosdevname-300x225.png" full_img="biosdevname.png" %}

### More to come

In addition to everything reported in this post, we have been working
hard to get some new cool features to the upcoming SLE15 and to get the
storage reimplementation full-featured enough to substitute the old one
in all possible situations.

So, although it would still be summertime (in Europe), stay tuned for
more news in two weeks.



[1]: {{ site.baseurl }}{% post_url 2017-08-10-highlights-of-yast-development-sprint-40 %}
[2]: https://github.com/yast/yast-bootloader/blob/master/SUPPORTED_SCENARIOS.md#required-packages
[3]: https://bugzilla.opensuse.org/show_bug.cgi?id=1014167
[4]: https://bugzilla.suse.com/show_bug.cgi?id=1049433
[5]: https://github.com/yast/yast-yast2/pull/609
[6]: {{ site.baseurl }}{% post_url 2017-07-31-highlights-of-yast-development-sprint-39 %}
[7]: https://github.com/yast/autoyast-integration-test
[8]: https://www.freedesktop.org/wiki/Software/systemd/PredictableNetworkInterfaceNames
[9]: https://github.com/systemd/systemd/blob/master/src/udev/udev-builtin-net_id.c#L20
