---
layout: post
date: 2019-02-27 16:12:14.000000000 +00:00
title: Recapping the Bcache support in the YaST Partitioner
description: Usual readers of the YaST Team development sprint reports on this blog
  already know we have been working steadily on adding support for the Bcache technology
  to the YaST Partitioner. We have already reached a point in which we consider such
  feature to be ready to be shipped with openSUSE Leap 15.1 and SUSE Linux [&#8230;]
category: SCRUM
tags:
- Distribution
- Factory
- Programming
- Systems Management
- YaST
---

Usual readers of the YaST Team development sprint reports on this blog
already know we have been working steadily on adding support for the
Bcache technology to the YaST Partitioner. We have already reached a
point in which we consider such feature to be ready to be shipped with
openSUSE Leap 15.1 and SUSE Linux Enterprise 15 SP1. That sounds like a
nice occasion to offer the full picture in a single blog post, so our
beloved users don’t need to dig into several blog posts to know what the
future releases will bring regarding Bcache in YaST. Needless to say,
all this is already available for openSUSE Tumbleweed users, or will be
available in the following weeks.

### Bcache 101

But, to begin with, what is [Bcache][1]? It’s a Linux technology that
allows to improve the performance of any big but relative slow storage
device (so-called “backing device” in Bcache terminology) by using a
faster and smaller device (so-called caching device) to speed up read
and write operations. The resulting Bcache device has then the size of
the backing device and (almost) the effective speed of the caching one.

In other words, you can use one or several solid state drives, which are
typically fast but small and expensive, to act as a cache for one or
several traditional rotational (cheap and big) hard disks… effectively
getting the best of both worlds.

How does it all look in your Linux system? Let’s explain it with some
good old ASCII art:

    
    (slow hard disk)   (faster device, SSD)
        /dev/sda            /dev/sdb
          |                     |
    [Backing device]    [Caching device]  <-- Actually, this is a set of
          |                     |             caching devices (Caching Set)
          |__________ __________|                   
                     |
                  [Bcache]
               /dev/bcache0

Take into account that the same caching device (or the same “caching
set”, sticking to Bcache terminology) can be shared by several Bcache
devices.

If you are thinking about using Bcache later, it is also possible to
setup all your slow devices as Bcache backing devices without a cache.
Then you can add the caching device(s) at a later point in time.

    
    (slow hard disk)   
        /dev/sda            
          |                     
    [Backing device]    
          |                     
          |__________ __________|                   
                     |
                  [Bcache]
               /dev/bcache0

Last but not least, the Bcache technology allows to create virtual
devices on top of an existing caching set without an associated backing
device. Such a device is known as Flash-only Bcache and is only useful
in some very specific use cases.

    
                       (faster device, SSD)
                            /dev/sdb
                                |
                        [Caching device]
                                |
          |__________ __________|                   
                     |
             [Flash-only Bcache]
               /dev/bcache0

You may be thinking: “*hmm, all that sounds interesting and daunting at
the same time… how can I get started with it in an easy way?*“. And sure
you are already figuring the answer.
![😉](https://s.w.org/images/core/emoji/2.2.1/72x72/1f609.png){:
.wp-smiley style="height: 1em; max-height: 1em;"}

### Bcache in the YaST Partitioner

When running on an x86 64 bits system, the YaST Partitioner will offer a
Bcache entry in its usual left tree. There you can see two tabs. The
second one lists the Bcache caching sets available in the system and its
purely informative. But the first one is your entry door to all the
power of the Bcache world. That tab allows to visualize, modify and
delete the existing Bcache devices. And, of course, it also enables you
to create new Bcache devices on top of any of your not-so-fast existing
block devices.

[![Bcache devices in the
Partitioner](../../../../images/2019-02-27/bcache-devices-300x223.png)](../../../../images/2019-02-27/bcache-devices.png)

All Bcache devices can be formatted, mounted or partitioned with the
same level of flexibility than other block devices in the system. See
the previous screenshots, in which some devices contains partitions
while others are formatted directly.

The creation and edition of Bcache devices allow to select which devices
to use as backing and as caching, and also to choose one of the
available cache modes (more on this below). Any available block devices
(like a disk, a partition or an LVM logical volume) can be used as
backing device or as caching one. But a screenshot is worth a thousand
words.

[![Screen for creating and editing a
Bcache](../../../../images/2019-02-27/bcache-create-300x168.png)](../../../../images/2019-02-27/bcache-create.png)

The backing device is mandatory. Flash-only Bcaches cannot be created
and there are no plans to include support for them in the future. But as
you can see in the previous screenshot, the caching device can be
specified as “without caching”. That allows to create Bcache devices
that will get their caching devices in the future, as explained at the
beginning of this post.

As mentioned, the third field allows to choose one of the cache modes
offered by Bcache. If you are not sure what a particular cache mode
means, YaST also provides a quite extensive help text explaining them.

[![Help about
Bcache](../../../../images/2019-02-27/bcache-help-300x237.png)](../../../../images/2019-02-27/bcache-help.png)

Moreover, when modifying a device, the Partitioner will limit risky
combinations, preventing data loss and avoiding operations that can
result in unreliable results. For example, it prevents modifying Bcache
devices with a caching device that is being already used by the system,
because that would require a detaching action. That could take a very
long time in some situations and interfere with other operations
performed by the Partitioner.

[![Only safe operations
allowed](../../../../images/2019-02-27/bcache-detach-warning-300x212.png)](../../../../images/2019-02-27/bcache-detach-warning.png)

Of course the operation to delete a Bcache device offers the usual
checks and information available in other parts of the YaST Partitioner,
like shown in the following screenshot (this time using the look and
feel of the SLE installer).

[![Deleting a Bcache
device](../../../../images/2019-02-27/bcache-delete-300x221.png)](../../../../images/2019-02-27/bcache-delete.png)

### Bcache for everyone?

With all the functionality explained above, we could say the YaST
Partitioner lowers the entry barrier enough for all the (open)SUSE users
to begin enjoying the bells and whistles of the Bcache technology.
Unfortunately, that’s not exactly true for all the hardware
architectures supported by our beloved distributions.

Bcache is only considered stable and mature enough in x86\_64 systems
(i.e. x86 architecture of 64 bits). If you don’t know whether your
computer fits into that description, then almost for sure it does.
![😉](https://s.w.org/images/core/emoji/2.2.1/72x72/1f609.png){:
.wp-smiley style="height: 1em; max-height: 1em;"} We have no evidence of
anyone using Bcache successfully in 32 bits systems or in any ARM
platform. Moreover, we know for sure the technology is unreliable in the
PPC64LE and S390x architectures.

As a result, the YaST Partitioner will only present the “Bcache” section
in the left tree when running in a x86\_64 system, even in the highly
unlikely case of an unsupported system in which a Bcache device is
found. If that would even happen, YaST will alert the users about the
dangers of using Bcache in such unsupported scenario and will urge them
to use manual procedures to modify the existing setup.

[![Warning: Bcache not
supported!](../../../../images/2019-02-27/bcache-not-supported-warning-300x170.png)](../../../../images/2019-02-27/bcache-not-supported-warning.png)

### What’s next?

Obviously, as it always happens when a new technology is added to YaST,
there is still a lot of room for improvement regarding the Bcache
management in the Partitioner. But now it’s the turn for our users to
test it and come with bug reports and ideas for further improvements and
use cases. Profit!



[1]: https://bcache.evilpiepirate.org/
