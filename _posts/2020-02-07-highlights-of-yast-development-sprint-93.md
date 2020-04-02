---
layout: post
date: 2020-02-07 16:31:11.000000000 +00:00
title: Highlights of YaST Development Sprint 93
description: 'Lately, the YaST team has been quite busy fixing bugs and finishing
  some features for the upcoming (open)SUSE releases.'
category: SCRUM
tags:
- Base System
- Distribution
- Factory
- Hackweek
- Network
- Software Management
- Systems Management
- YaST
---

### The Contents

Lately, the YaST team has been quite busy fixing bugs and finishing some
features for the upcoming (open)SUSE releases. Although we did quite
some things, in this report we will have a closer look at just a few
topics:

* A feature to search for packages across all SLE modules has arrived to
  YaST.
* Improved support for S390 systems in the network module.
* YaST command-line interface now returns a proper exit-code.
* Added progress feedback to the Expert Partitioner.
* Partial support for Bitlocker and, as a lesson learned from that, a
  new warning about resizing empty partitions.

### The Online Search Feature Comes to YaST   {#the-online-search-feature-comes-to-yast}

As you already know, starting in version 15, SUSE Linux follows a
modular approach. Apart from the base products, the packages are spread
through a set of different modules that the user can enable if needed
(Basesystem module, Desktop Applications Module, Server Applications
Module, Development Tools Module, you name it).

In this situation, you may want to install a package, but you do not
know which module contains such a package. As YaST only knows the data
of those packages included in your registered modules, you will have to
do a manual search.

Fortunately, zypper introduced a new `search-packages` command some time
ago that allows to find out where a given package is. And now it is time
to bring this feature to YaST.

For technical reasons, this online search feature cannot be implemented
within the package manager, so it is available via the *Extra* menu.

{% include blog_img.md alt="Search Online Menu Option"
src="search-online-menu-option-300x207.png" full_img="search-online-menu-option.png" %}

YaST offers a simple way to search for the package you want across all
available modules and extensions, no matter whether they are registered
or not. And, if you find the package you want, it will ask you about
activating the needed module/extension right away so you can finally
install the package.

{% include blog_img.md alt="Online Search: Enable Containers Module"
src="online-search-enable-containers-module-300x207.png" full_img="online-search-enable-containers-module.png" %}

{% capture img_path %}/assets/images/blog/{{ page.date | date: "%Y-%m-%d" }}/{% endcapture %}
If you want to see this feature in action, check out the [demonstration
video]({{ img_path | append: "online-search-install-php7.webm" | relative_url }}).
  
Like any other new YaST feature, we are looking forward to your
feedback.

### Fixing and Improving Network Support for S390 Systems   {#fixing-and-improving-network-support-for-S390-systems}

We have mentioned a lot of times that we recently refactored the Network
module, fixing some long-standing bugs and preparing the code for the
future. However, as a result, we introduced a few new bugs too. One of
those bugs was dropping, by accident, the network devices activation
dialog for S390 systems. Thus, during this sprint, we re-introduced the
dialog and, what is more, we did a few improvements as the old one was
pretty tricky. Let’s have a look at them.

The first obvious change is that the overview shows only one line per
each s390 group device, instead of using one row per each channel as the
old did.

{% include blog_img.md alt="New YaST Network Overview for S390 Systems"
src="yast2-network-s390-new-overview-300x239.png" full_img="yast2-network-s390-new-overview.png" %}

Moreover, the overview will be updated after the activation, displaying
the Linux device that corresponds to the just activated device.

{% include blog_img.md alt="YaST2 Network Overview After Activation"
src="yast2-network-s390-overview-after-activation-300x190.png" full_img="yast2-network-s390-overview-after-activation.png" %}

Last but not least, we have improved the error reporting too. Now, when
the activation fails, YaST will give more details in order to help the
user to solve the problem.

{% include blog_img.md alt="YaST2 Network Error Reporting in S390 Systems"
src="yast2-network-s390-error-reporting-300x239.png" full_img="yast2-network-s390-error-reporting.png" %}

### Fixing the CLI   {#fixing-the-cli}

YaST command-line interface is a rather unknown feature, although it has
been there since ever. Recently, we got some bug reports about its exit
codes. We discovered that, due to a technical limitation of our internal
API, it always returned a non-zero exit code on any command that was
just reading values but not writing anything. Fortunately, we were able
to fix the problem and, by the way, we improved the behavior in several
situations where, although the exit code was non-zero, YaST did not give
any feedback. Now that the CLI works again, it is maybe time to give it
a try, especially if it is the first time you hear about it.

### Adding Progress Feedback to the Partitioner   {#yast2-partitioner-feedback}

The *Expert Partitioner* is a very powerful tool. It allows you to
perform very complex configurations in your storage devices. At every
time you can check the changes you have been doing in your devices by
using the Installation Summary option on the left bar. All those changes
will not be applied on the system until you confirm them by clicking the
Next button. But once you confirm the changes, the Expert Partitioner
simply closes without giving feedback about the progress of the changes
being performed.

Actually, this is a kind of regression after migrating YaST to its new
Storage Stack (a.k.a. storage-ng). The old Partitioner had a final step
which did inform the user about the progress of the changes. That dialog
has been brought back, allowing you to be aware of what is happening
once you decide to apply the configuration. This progress dialog will be
available in SLE 15 SP2, openSUSE 15.2 and, of course, openSUSE
Tumbleweed.

{% include blog_img.md alt="YaST Partitioner Progress Feedback"
src="yast2-storage-ng-progress-feedback-300x155.png" full_img="yast2-storage-ng-progress-feedback.png" %}

### Recognizing Bitlocker Partitions   {#bitlocker}

[Bitlocker][1] is a filesystem encrypting technology that comes included
with Windows. Until the previous sprint, YaST was not able to recognize
that a given partition was encrypted with such technology.

As a consequence, the automatic partitioning proposal of the (open)SUSE
installer would happily delete any partition encrypted with Bitlocker to
reclaim its space, even for users that had specified they wanted to keep
Windows untouched. Moreover, YaST would allow users to resize such
partitions using the Expert Partitioner without any warning (more about
that below).

All that is fixed. Now Bitlocker partitions are correctly detected and
displayed as such in the Partitioner, which will not allow users to
resize them, explaining that such operation is not supported. And the
installer’s Guided Setup will consider those partitions to be part of a
Windows installation for all matters.

### Beware of Empty Partitions   {#beware-of-empty-partitions}

As explained before, whenever YaST is unable to recognize the content of
a partition or a disk, it considers such device to be empty. Although
that’s not longer the case for Bitlocker devices, there are many more
technologies out there (and more to come). So users should not blindly
trust that a partition displayed as empty in the YaST Partitioner can
actually be resized safely.

In order to prevent data loss, in the future YaST will inform the user
about a potential problem when trying to resize a partition that looks
empty.

{% include blog_img.md alt="YaST Expert Partitioning Warning when Resizing Empty Partitions"
src="yast2-storage-ng-empty-partition-warning-message-300x180.png" full_img="yast2-storage-ng-empty-partition-warning-message.png" %}

### Hack Week is coming…   {#hack-week-is-coming}

That special time of the year is already around the corner. Christmas?
No, Hack Week! From February 10 to February 14 we will be celebrating
the 19th Hack Week at SUSE. The theme of this edition is *Simplify,
Modernize &amp; Accelerate*. If you are curious about the projects that
we are considering, have a look at [SUSE Hack Week’s Page][2]. Bear in
mind that the event is not limited to SUSE employees, so if you are
interested in any project, do not hesitate to join us.

[1]: https://en.wikipedia.org/wiki/BitLocker
[2]: https://hackweek.suse.com/
