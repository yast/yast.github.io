---
layout: post
date: 2018-10-01 20:13:39.000000000 +00:00
title: YaST Squad Sprint 63
description: 'Another YaST sprint is over and it is our pleasure to offer a report
  which includes a wide ranging of topics.'
category: SCRUM
tags:
- Factory
- Systems Management
- YaST
---

### The Sprint Summary

* The partitioner continues getting more love and attention: now you can
  partition your RAID devices and we have started to work on supporting
  Bcache.
* A new YaST2 firewall UI is around the corner.
* The self-update feature has been extended to cover more cases.
* YaST supports now your brand new 4K display during installation.

And, of course, some bugfixes (like proper handling of problems when
trying to deactivate a DASD channel) and infrastructure improvements
(check out our take on Travis caching).

### Managing partitions within MD RAID devices

Our beloved Partitioner was one of the stars of the [previous
report][1], with news about several improvements and refinements. During
this sprint it also received some love, not only with the addition of a
couple of new features but also with more discussions and prototypes
about the reorganization of the UI needed to bring even more
improvements.

One of those features introduced in the previous sprint was the ability
to create a RAID based on whole disks with no partitions. Now we have
closed the circle by allowing to manage partitions within a RAID. So now
it’s possible to create RAID arrays based on any combination of disks
and partitions and then either use those arrays directly to host a file
system (or to act as LVM physical volume) or create partitions inside
the array. Partitions that can be, of course, formatted, encrypted, used
as LVM physical volumes, etc. With that, we can now say the Partitioner
support every possible MD RAID setup.

In the following animated screenshot you can see how the partitions of
an MD RAID are listed in the left-hand tree of the Partitioner and in
the table of devices of the RAID section, similar to how partitions of a
hard disk are displayed.

{% include blog_img.md alt="RAID" src="partitioned_raids.gif" %}

As you may have noticed, the main difference with other views is that,
as already anticipated by the UI discussions summarized in our previous
sprint report, the set of buttons adapts dynamically to the selected
item on the table offering a different set of actions for MD arrays and
for partitions.

### Another step to define the future of the Partitioner user interface

The interface showed in the previous screenshot, with its dynamic
behavior, is just the first step in the direction already defined in
[the document][2] that resulted from the previous sprint. Having that
first fully functional prototype enabled us to rekindle the discussion
about the best way to offer all the new possibilities of storage-ng in
the Partitioner while keeping the user interface recognizable and
familiar to the YaST users.

After another round of discussions and several iterations of mock-ups,
we ended up with the idea documented [at this gist][3]. That will be the
guide for the UI changes we are already implementing as part of the next
sprint as a way to unleash even more of the underlying power of
storage-ng.

### Initial support for Bcache in the Partitioner

But apart from revamping and improving the support for existing
technologies with new possibilities, we also want the Partitioner to
grow in scope, putting the new kernel technologies into the hands of our
users. One of such technologies is Bcache.

Bcache allows to improve the performance of any big but relative slow
storage device (so-called “backing device” in Bcache terminology) by
using a faster and smaller device (so-called caching device) to speed up
read and write operations. The resulting Bcache device has then the size
of the backing device and (almost) the effective speed of the caching
one.

As a first step to offer full Bcache support, the Partitioner can
visualize all the Bcache devices and allows to manipulate its
partitions. Broader support, like creating new Bcache devices, will
follow in upcoming sprints.

{% include blog_img.md alt="Initial Bcache support in the Partitioner"
src="bcache-300x220.png" full_img="bcache.png" %}

### A New YaST2 Firewall UI is Coming   {#new-yast-firewall-ui}

[firewalld][4] replaced the venerable [SuSEfirewall2][5] as the default
firewall solution in SUSE Linux Enterprise 15 and openSUSE Leap 15.0.
And there is high chance that you have noticed that YaST does not offer
a user interface to manage the firewall configuration anymore. Instead,
it asks the user to use *firewall-config*, the official *firewalld* UI.

But, fortunately, that’s about to change. During recent sprints we have
been working in a new UI to manage firewalld configuration. It is still
a work in progress, but it is capable of assigning interfaces to zones
and opening services/ports for a given zone.

{% include blog_img.md alt="Allowed services in a firewall\'s zone"
src="yast2-firewall-allowed-services-300x239.png" full_img="yast2-firewall-allowed-services.png" %}

We plan to release a first version as soon as we finish the integration
with the AutoYaST user interface. So stay tunned!

### Better HiDPI (4k Display) Support   {#better-hidpi-support}

What is better than a high screen resolution? Simple: a higher screen
resolution. 4k displays are arriving in the consumer mainstream, and 8k
displays are the next big thing.

But there are some real-world problems with that: with that large
resolution, texts and graphics may become tiny – too tiny to read, too
small to fill the available space on the screen.

On your desktop, you can tweak those things – select larger fonts or
larger icon sizes. But for the installer that’s another matter; it needs
to autodetect the presence of such a display and then auto-scale the
user interface so it is actually usable.

We had a number of such issues in YaST; one was the font size, another
the size of pixel graphics such as the time zone selection map. Those
are now fixed.

For backwards compatibility, the Qt library which we are using for the
graphical UI of YaST does not do that completely automatically but we
needed to explicitly enable a HiDPI mode. But now it does it all
automagically for YaST.

### Updating Additional Installation Data   {#self-update-temporary-repository}

As you may know, YaST is able to update itself during system
installation, which enables us to fix the installer by releasing updated
packages even after the official release.

However, sometimes we need to fix packages which are not part of the
installer but they provide some additional data for it like installation
defaults, system role definitions, etc.

In order to support those scenarios, we have extended the installer to
use the self-update repository as a regular (but temporary) one during
the installation process. So with the next SUSE Linux Enterprise release
we will be able to update that data too.

### Fixing DASD Channel Deactivation Support   {#fixing-dasd-channel-deactivation}

Recently we discovered that YaST was getting frozen in s390 architecture
when the user tried to deactivate a DASD channel in use. The problem was
that *dasd\_configure*, the underlying tool which takes care of
deactivating the channel, was waiting for user confirmation.

Definitely, losing user data is not an option so, from now on, the
operation will be just canceled and YaST will report the problem,
including all the details, so the user can solve the issue before trying
to deactivate the channel again.

{% include blog_img.md alt="DASD deactivation details"
src="dasd-deactivation-details-300x245.png" full_img="dasd-deactivation-details.png" %}

### Faster Travis Rebuilds using ccache   {#travis-ccache}

For continuous integration at GitHub we use Travis which is easy to
configure and use. Unfortunately, building there a big project like
[libstorage-ng][6] takes a lot of time. In this case it is almost half
an hour.

Waiting so long to see the result after doing a small change in the code
is quite annoying and unconvenient. And this is exactly the scenario
where using the [ccache][7] tool helps a lot. ccache is a small wrapper
around the standard C/C++ compiler which saves the compilation result
for later. So if the same file is compiled later again then the cached
result is returned immediately without calling the real compiler.

Together with the [Travis caching mechanism][8], which we use for
storing and restoring the ccache files for each build, we reached a
significant speed up. From 29 minutes to about 6 minutes, that is about
**four times faster**!

Of course, it highly depends how much the environment (compiler,
libraries) or the source files have been changed since the last build.
The bigger changes the more recompilation is needed, so in reality the
speedup might be smaller.

Check [the related pull request][9] if you are interested in the
implementation details.

### More to come   {#more-to-come}

The following sprint is already running and the team is working in
really interesting stuff: finishing the bcache support, releasing a
first version of the new firewall UI, proper support to use a whole disk
as an LVM PV in AutoYaST, several improvements to the installer for
CaaSP/Kubic, etc.

So stay tunned!



[1]: {{ site.baseurl }}{% post_url 2018-09-12-yast-squad-sprint-62 %}
[2]: https://github.com/yast/yast-storage-ng/blob/master/doc/sle15_features_in_partitioner.md
[3]: https://gist.github.com/ancorgs/25eb67a90b666ec2211ca34034df8771
[4]: http://firewalld.org
[5]: https://en.opensuse.org/SuSEfirewall2
[6]: https://github.com/openSUSE/libstorage-ng
[7]: https://ccache.samba.org
[8]: https://docs.travis-ci.com/user/caching/
[9]: https://github.com/openSUSE/libstorage-ng/pull/575
