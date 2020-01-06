---
layout: post
date: 2019-10-23 14:02:18.000000000 +00:00
title: Highlights of YaST Development Sprint 87
description: It&#8217;s time for another YaST team report! Let&#8217;s see what&#8217;s
  on the menu today.
category: SCRUM
tags:
- Distribution
- Factory
- Programming
- Systems Management
- YaST
---

## Introduction

It’s time for another YaST team report! Let’s see what’s on the menu
today.

* More news and improvements in the storage area, specially regarding
  encryption support.
* Some polishing of the behavior of YaST Network.
* New widgets in libYUI.
* A look into systemd timers and how we are using them to replace
  `cron`.
* And a new cool tool for developers who have to deal with complex
  object-oriented code!

So let’s go for it all.

### Performance Improvements in Encrypted Devices

As you may know, we have recently extended YaST to support additional
encryption mechanisms like volatile encryption for swap devices or
pervasive encryption for data volumes. You can find more details in our
blog post titled \"[Advanced Encryption Options Land in the YaST
Partitioner][1]\".

Those encryption mechanisms offer the possibility of adjusting the
sector size of the encryption layer according to the sector size of the
disk. That can result in a performance boost with storage devices based
on 4k blocks. To get the best of your systems, we have instructed YaST
to set the sector size to 4096 bytes whenever is possible, which should
improve the performance of the encrypted devices created with the
recently implemented methods.

Additionally, we took the time to improve the codebase related to
encryption, based on the lessons we learned while implementing volatile
and pervasive encryption. We also performed some additional tests and we
found [a problem][2] that we are already fixing in the sprint that has
just started.

### Other improvements related to encryption

One of those lessons we have learnt recently is that resizing a device
encrypted with a LUKS2 encryption layer works slightly different to the
traditional LUKS1 case. With LUKS2 the password must be provided in the
moment of resizing, even if the device is already open and active. So we
changed how libstorage-ng handles the passwords provided by the user to
make it possible to resize LUKS2 devices in several situations, although
there are still some cases in which it will not be possible to use the
YaST Partitioner to resize a LUKS2 device.

As a side effect of the new passwords management, now the process that
analyzes the storage devices at the beginning of the installation should
be more pleasant in scenarios like the one described in the [report of
bug#1129496][3], where there are many encrypted devices but the user
doesn’t want to activate them all.

And talking about improvements based on our users’ feedback, we have
also adapted the names of the new methods for encrypting swap with
volatile keys, as suggested in the comments of our already mentioned
previous blog post. We also took the opportunity to improve the
corresponding warning messages and help texts.

{% include blog_img.md alt="New name and description for encryption with volatile keys"
src="volatile-300x226.png" full_img="volatile.png" %}

### Network and Dependencies Between Devices

Similar to encryption, the network backend is another area that needed
some final adjustments after the big implementation done in the previous
sprints. In particular, we wanted to improve the management of devices
that depend on other network devices, like VLANs (virtual LANs) or
bridges.

Historically, YaST has simply kept the name of the device as a
dependency, even if such device does not exist any longer. That leaded
to inconsistent states. Now the dependencies are updated dynamically. If
the user renames a device, then it’s automatically renamed in all its
dependencies. If the user deletes a device that is needed by any other
one, YaST will immediately ask the user whether to modify (in the case
of bonding and bridges) or to remove (in the case of VLANs) those
dependent devices.

### New libYUI Widget: ItemSelector

Now that we mention the user experience, it’s fair to note that it has
been quite a while since we created the last new widget for libYUI, our
YaST UI toolkit. But we identified a need for a widget that lets the
user select one or many from a number of items with not only a short
title, but also a descriptive text for each one (and optionally an
icon), and that can scroll if there are more items than fit on the
screen.

So say hello to the new `SingleItemSelector`.

{% include blog_img.md alt="SingleItemSelector in graphical mode"
src="single-qt-300x215.png" full_img="single-qt.png" %}

As you would expect from any libYUI widget, there is also a text-based
(ncurses) alternative.

{% include blog_img.md alt="SingleItemSelector in text mode"
src="single-ncurses-300x176.png" full_img="single-ncurses.png" %}

Please, note the screenshots above are just short usage examples. We are
NOT planning to bring back the desktop selection screen. On the other
hand, now we have the opportunity to make a prettier screen to select
the computer role. Stay tuned for more news about that.

There is also an alternative version of the new widget that allows to
select several items. The unsurprisingly named `MultiItemSelector`.

{% include blog_img.md alt="MultiItemSelector in graphical mode"
src="multi-qt-300x227.png" full_img="multi-qt.png" %}

Which, of course, also comes with an ncurses version.

{% include blog_img.md alt="MultiItemSelector in text mode"
src="multi-ncurses-300x176.png" full_img="multi-ncurses.png" %}

In the near future, we are planning to use that for selecting products
and add-on modules. But this kind of widgets will find other uses as
well.

### Fun with Systemd Timers

And talking about the close future, many of you may know there is a plan
coming together to replace the usage of `cron` with systemd timers as
the default mechanism for (open)SUSE packages to execute periodic tasks.

In our case, we decided to start the change with `yast2-ntp-client`,
which offers the possibility to synchronize the system time once in a
while. So let’s take a look to how systemd timers work and how we used
them to replace `cron`.

When defining a service in systemd it is possible to specify a type for
that service to define how it behaves. When started, a service of type
`oneshot` will simply execute some action and then finish. Those
services can be combined with the timers, which invoke any service
according to monotonous clock with a given cadence. To make that cadence
configurable by the user, the YaST module overrides the default timer
with another one located at `/etc/systemd/system`.

As a note for anyone else migrating to systemd timers, our first though
was to use the `EnvironmentFile` directive instead of overriding the
timer. But that seems to not be possible for timers.

One clear advantage of using a systemd service to implement this is the
possibility of specifying dependencies and relations with other
services. In our case, that allows us to specify that one time
synchronization cannot be used if the chrony daemon is running, since
they would both conflict. So the new system is slightly more complex
than a one-liner cron script, but it’s also more descriptive and solid.

And another tip for anyone dealing with one-shot services and systemd
timers, you can use `systemd-cat` to catch the output of any script and
redirect it to the systemd journal.

### Everybody Loves Diagrams

But apart from tips for sysadmins and packagers, we also have some
content for our fellow developers. You know YaST is a huge project that
tries to manage all kind of inter-related pieces. Often, the average
YaST developer needs to jump into some complex module. Code
documentation can help to know your way around YaST internals that you
don’t work with every day. To generate such documentation, we use the
[YARD][4] tool, and its output is for example here, for
[yast-network][5]. Still, for large modules with many small classes,
this is not enough to get a good overview.

Enter [yard-medoosa][6], a plugin for YARD that automatically creates
[UML class diagrams][7], clickable to get you to the classes textual
documentation.

{% include blog_img.md alt="The yast2-network medoosa"
src="medoosa-300x35.png" full_img="medoosa.png" %}

It is still a prototype but it has proven useful for navigating a
certain large pull request. We hope to soon tell you about an improved
version.

### More Solid Device Names in fstab and crypttab

Back to topics related to storage management, you surely know there are
several ways to specify a device to be mounted in the `/etc/fstab` file
or a device to be activated in the `/etc/crypttab`. Apart from using
directly the name of the device (like `/dev/sda1`) or any of its
alternative names based on udev, you can also use the UUID or the label
of the file-system or of the LUKS device.

By default, YaST will use the udev path in s390 systems and the UUID in
any other architecture. Although that’s something that can be configured
modifying the `/etc/sysconfig/storage` file or simply using this screen
of the Partitioner, which makes possible to change how the installation
(both the Guided Setup and the Expert Partitioner) writes the resulting
`fstab` and `crypttab` files.

{% include blog_img.md alt="Changing the way devices are referenced"
src="mount_by_setting-300x225.png" full_img="mount_by_setting.png" %}

But, what happens when the default option (like the udev path) is not a
valid option for some particular device? So far, YaST simply used the
device name (e.g. `/dev/sda1`) as an immediate fallback. That happened
at the very end of the process, when already writing the changes to
disk.

We have improved that for Tumbleweed, for SLE-15-SP1 (which implies Leap
15.1) and for the upcoming versions of (open)SUSE. Now, if the default
value is not suitable for a particular device because the corresponding
udev path does not exists, because using a given name is incompatible
with the chosen encryption method, or for any other reason, YaST will
fall back to the most reasonable and stable alternative. And it will do
it from the very beginning of the process, being immediately visible in
the Partitioner.

### Stay Tuned for More… and Stay Communicative

As usual, when we publish our sprint report we are already working on
the next development sprint. So in approximately two weeks you will have
more news about our work, this time likely with a strong focus in
AutoYaST.

Don’t forget to keep providing us feedback. As commented above, it’s
very valuable for us and we really use it as an input to plan subsequent
development sprints.



[1]: {{ site.baseurl }}{% post_url 2019-10-09-advanced-encryption-options-land-in-the-yast-partitioner %}
[2]: https://bugzilla.suse.com/show_bug.cgi?id=1154267
[3]: https://bugzesilla.suse.com/show_bug.cgi?id=1129496
[4]: https://yardoc.org/
[5]: https://www.rubydoc.info/github/yast/yast-network
[6]: https://github.com/mvidner/yard-medoosa
[7]: https://en.wikipedia.org/wiki/Class_diagram
