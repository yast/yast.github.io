---
layout: post
date: 2018-05-08 09:40:33.000000000 +00:00
title: Highlights of YaST Development Sprint 56
description: LEAP/SLE 15 is getting more stable and closer to be released, but to
  keep this process flowing, our team of bug killers is having a lot of work to do!
category: SCRUM
tags:
- Distribution
- Factory
- Localization
- Systems Management
- YaST
---

This last sprint we had several fixes for really special scenarios. The
kind of problems that you can find once <del>most of</del> things are
working fine! So let’s take a look at some of these cases and how we’re
working to stabilize this upcoming release.

## Keep predictable network devices settings on S390x

A not well-known feature in YaST is that many specific boot parameters
for installation are also used on the target system. However, this
approach has one exception: the S390 mainframe. In this case, many
installation specific parameters should not go to the target system and,
therefore, we ignore all installation parameter for this system.  
In the last sprint, we worked on a bug, which reported that at least
systemd predictable names for network devices should be also used for
S390 systems, otherwise the configuration done during the installation
won’t be valid in a running system as network names will differ. So,
from SLE15 we start to keep the settings of predictable network names
for S390 systems.

## Fun with console configuration of GRUB2

Another report that helped us to learn about other not well-known
features was the one reporting that bootloader module does not support
multiple console outputs of GRUB2. After digging into some code, we
found out that YaST bootloader takes only native terminal, gfxterm or
serial console in consideration, but not a mix of them.  
 Once we looked at the manual of GRUB2, we learned that it supports some
funny outputs such as morse code, PC beeper or simple data protocol
using system speaker. Of course, YaST2 bootloader does not support all
these options and when it gets one of them, it is treated as an
unexpected value and bootloader fails.

As we are really close to Leap/SLE 15 release, we want to avoid big
changes in the system. So we decided to handle this issue by showing a
popup, which informs that the configuration contains an unexpected value
and asks if the whole proposed configuration should be proposed again or
if YaST should quit and let the user edit it manually.

If you are curious about how it looks like:

{% include blog_img.md alt=""
src="unsuported_conf_grub-300x192.png" full_img="unsuported_conf_grub.png" %}

For Leap 15.1 / SLE 15 SP1 we plan to extend the values that we support
to provide a nicer experience for the user.

## Bootloader configuration during upgrade

Another reported issue in bootloader was also solved this last sprint.
When upgrading from Leap 42/SLE 12 to Leap/SLE 15, if the user clicks on
booting on the proposal, the system crashes. The reason is that usually
on openSUSE 13.2/SLE 11 it needs to repropose bootloader during the
upgrade. This is no longer required for the latest upgrade and,
therefore, YaST does not expect that the user will click on it. We would
like to remove this option completely, but YaST still support upgrade
from SLE11 to SLE15, so we still need it there. In the end, the solution
is to show a popup informing the user that the modification of
bootloader is not supported during upgrade.

In short, take a look at the screenshot:

{% include blog_img.md alt=""
src="bootloader_conf_upgrade-300x220.png" full_img="bootloader_conf_upgrade.png"
%}

## Fixing kdump on Xen

We got a report about [kdump][1] breaking when it is used in Xen. To
explain the problem, we need to go back to how we configure a parameter
and the reasons we implemented it in this way: In current versions
(before this fix) when a user wants to use kdump, we configure the
crashkernel kernel parameter for all targets, for the common kernel, Xen
PV0 domain and also Xen guests. This approach worked very well in the
past because traditional xenlinux ignores crashkernel for PV0 and just
pass it to Xen VMs. However, the current pvops implementation of Xen no
longer ignores this parameter and consequently, it results in breaking
the Xen virtualization. The solution for this issue was pretty simple:
YaST stopped to propose using crashkernel for Xen PV0 and everything
works again. This is a perfect example to show how to understand the
issue, sometimes, takes much more time than to fix it!

## Improving the upgrade from SLE11/12 to SLE15

We are still improving the migration from SLE11 or SLE12 to SLE15 and
this sprint we were focused on the automated registration upgrade using
AutoYaST. If you are not familiar with the autoupgrade feature you can
find more details in the [documentation][2].

We already supported manual registration upgrade from the old products,
but the automated way was still not adapted to the new SUSE Customer
Center (SCC) API and it did not work correctly. This sprint we have
adapted the registration upgrade code to correctly work in the
interactive mode and also in the automatic upgrade.

The code was adapted to skip the user interaction and do everything
manually when running in the autoupgrade mode. The only problematic part
was how to handle multiple migration targets, which in the interactive
upgrade we ask the user to choose one. To have a simple solution we
decided to take the first migration, later (SP1) we might allow
configuring this as well. But as now there is only one migration
possible anyway, this looks like a good enough solution.

## Falling back to the guided proposal

During this sprint, we were informed that AutoYaST was unable to display
a proper error message when no `partitioning` section was specified and
there was not enough disk space. The bug was rather easy to solve, but
we wanted to take the opportunity to highlight how AutoYaST works when
the `partitioning` section is missing from the profile.

In the past, AutoYaST implemented its own logic, different from the one
used during a normal installation. Fortunately, as part of the
adaptation to the new storage layer, AutoYaST relies now on the same
code than the regular installation in order to propose a partitioning
layout when the `partitioning` section is not specified. What is more,
you can override some values which are defined in the product’s control
file by setting them in the `general/storage` section from the AutoYaST
profile.

## Leap /SLE 15 is closed, but Tumbleweed is still rolling

We are really close to release Leap/SLE 15 and we are more focused on
minimal changes that fix only critical stuff. On the other hand,
Tumbleweed users are looking always for the latest and greatest
features. In order to satisfy both groups, YaST separated Leap 15.1/SLE
15 and Tumbleweed in two different git branches. In this way, we can
easily start adding new features, bug fixes and other improvements for
Tumbleweed while we keep SLE15 stabilized. Besides that, there is
another planned Service Pack for SLE12, and once we start to work at it,
we’ll also create a new separated branch to include these changes. We
also adapted all related infrastructure around the branches, such as CI,
docker testing images, among others.

This way, we are able to allow you to enjoy the stable Leap 15 or the
latest and hottest Tumbleweed.

## Conclusion

We’re now working on our last sprint before the openSUSE Conference 2018.
In two weeks we’ll come back with the highlights of Sprint 57 and
until there we hope that you have already everything planned to enjoy
the conference that will occur in Prague this year (we hope that you
enjoy the city too). We’re looking forward to seeing you there!



[1]: https://en.wikipedia.org/wiki/Kdump_(Linux)
[2]: https://www.suse.com/documentation/sles-12/singlehtml/book_autoyast/book_autoyast.html#CreateProfile.upgrade
