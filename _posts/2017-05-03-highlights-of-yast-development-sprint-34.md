---
layout: post
date: 2017-05-03 17:38:15.000000000 +02:00
title: Highlights of YaST development sprint 34
description: Here we go again! Only one week after our previous report!
category: SCRUM
tags:
- Distribution
- Documentation
- Factory
- Hackweek
- Programming
- Systems Management
- YaST
---

Here we go again! Only one week after our previous report, we already
have a new bunch of (hopefully) exciting news. Let’s take a look to the
outcome of our 34th Scrum sprint.

### Trusted boot support for EFI

In [the report of our 19th sprint][1], we already presented the new (at
that point in time) and shiny Trusted Boot support in YaST2 Bootloader.
So far, the only supported scenario was legacy boot (i.e. no UEFI) on
x86\_64 systems. Now, thanks to [TPM2][2], is also possible use Trusted
Boot with EFI, so we added support for it in our beloved bootloader
module.

So now YaST Bootloader looks the same in non-EFI and EFI variants, no
matter which underlying technology is actually used. Of course, YaST is
only the tip of the iceberg, booting in Trusted Boot with EFI is
possible thanks to all the tools that has recently added support for
TPM2. openSUSE developers and packagers rock!

### Configuring the NTP service in CaaSP

For a CaaSP cluster to work properly, it’s vitally important that all
nodes have their clocks in sync. So, from now on, the installer is able
to configure each node in a proper way and the administration node will
act as NTP server for the worker nodes.

To achieve that, the user will be asked to specify one or several NTP
servers to be used as time source during administration node
installation and YaST will take care of the rest (updating the
configuration and enabling the service).

If a NTP service is announced through SLP, YaST will propose
automatically.

{% include blog_img.md alt="NTP configuration in YaST"
src="ntp-300x225.png" full_img="ntp.png" %}

For worker nodes, YaST will configure the system to keep it synchronized
with the administration role.

### Storage reimplementation: improvements in the guided setup

Through the previous reports, you have been able to follow the evolution
of the renovated guided setup for the partitioning proposal. This sprint
is not different, we have improved and adjusted that new wizard even
further, making it smarter and more usable.

The new version is able to decide which steps to show depending on the
current scenario. For example, in systems with only one disk the whole
disk selection dialog will be skipped. The steps are also simplified by
disabling widgets that are not applicable to the current situation. For
example, if there is no previous Linux installation, the question about
what to do with the existing Linux partitions will be disabled.

And talking about the actions to perform on preexisting partitions, that
has also been improved. In the first guided setup version, these options
were only displaying for illustrative purposes, but now they are 100%
real and the proposal will honor their values, so the user can easily
select what to do with previous Windows or Linux partitions. We even
added a third option for other kind of partitions.

{% include blog_img.md alt="New settings in the storage proposal"
src="new_se-300x225.png" full_img="new_se.png" %}

Last but not least (regarding the guided setup), the password selection
for encryption is now more usable, allowing the user to choose a not so
strong password if really desired.

{% include blog_img.md alt="Allowing users to shoot their own feet"
src="bad_password-300x225.png" full_img="bad_password.png" %}

### Insserv removal

YaST is a complex and large piece software. It means that time to time
some pieces that used to be great and shiny become obsolete and end up
being useless. The cycle of life. :smiley:

Some time ago, it was decided it was time for `insserv` to enjoy
retirement and it was replaced by a stub. But there were still calls to
`insserv` in YaST and we decided to remove them all. There were several
reasons for that decision. Basicaly (open)SUSE has used systemd for
couple of years already, so revisiting places where the YaST code
depended on SySV was a must. As a side effect it shortened the list of
YaST dependencies and, in the end, it is another small step towards
smaller installation.

So good bye `insserv`, it was a pleasure to work with you.

### Improvements in the ZFCP Controller Configuration for zKVM on S/390

When running the installer on a mainframe in a zKVM virtual machine it
displays a warning about not detected ZFCP controllers:

{% include blog_img.md alt="ZFCP warning on S/390"
src="zFCP-300x227.png" full_img="zFCP.png" %}

However, when running in a zKVM virtual machine the disk is accessible
via the *virtio* driver, not through an emulated ZFCP controller. The
warning is pointless and confusing.

The fix was basically just an one-liner which skips the warning when the
zKVM virtualization is detected, but the YaST module for ZFCP doesn’t
usually receive too much maintenance, so we applied our [boy scout
rule][3] and improved the code a bit.

The improvements include using Rubocop for clean and unified coding
style, enabling code coverage to know how much the code is tested (in
this case it turned out to be horribly low, just about 4%), removing
unused files, etc… You can find the details in the [pull request][4].

### Storage reimplementation: improvements all around

As we reported in [our report about Hack Week 15][5], we have been
working on [an alternative way][6] to offer the power of the new storage
library to the Ruby world. The new API is finally ready for prime-time
and used in all the Ruby code.

We took the opportunity to greatly improve the developer documentation
and to revamp the yast2-storage-ng [README][7] and status page.

We also did some extra checks and added automated testing to ensure our
partitioning proposal ensure the requisites if a S/390 system using
ZFCP, so mainframe users also have a peaceful transition to the new
storage stack.

We also greatly improved the ability of the new library to work with
alternative name schemes for the devices. Up to now, only using plain
kernel device name (e.g. `/dev/sda1`) was fully supported. Now we can do
all the operations (specially generating the `/etc/fstab` file) by
device name, by UUID, by filesystem label, by device id and by device
path.

### More content already in the oven!

As you already know, at least we repeat it quite often, :smiley:
YaST was converted from YCP to Ruby some time ago. However, this conversion was
done on language basis. Some old design decisions and principles stayed, like
the usage of [SCR][8] for accessing the underlying system.

Some time ago we introduced [CFA (Config Files Api Gem)][9] as a more
powerful and flexible Ruby-powered replacement for SCR. Although we have
been using it for a while in several YaST modules, we felt the concepts
and rationales behind its operation where not that clear.

So we have invested some time improving the documentation and writing a
blog post to properly present and explain CFA to the world. We will
publish it next week, so stay tuned!

### Great news ahead!

The next sprint will be the first in which the whole YaST team will work
together integrating the new storage stack in every single part of YaST.
So we hope the next report to be full of good news about the expert
partitioner, improvements in AutoYaST’s handling of disks and so on.

Of course, that would be only a small fraction of all the stuff we plan
to work on. See you in three weeks with more news!



[1]: {{ site.baseurl }}{% post_url 2016-05-18-highlights-of-yast-development-sprint-19 %}
[2]: https://github.com/01org/tpm2.0-tools/
[3]: https://martinfowler.com/bliki/OpportunisticRefactoring.html
[4]: https://github.com/yast/yast-s390/pull/44
[5]: {{ site.baseurl }}{% post_url 2017-03-07-yast-development-during-hack-week-15 %}
[6]: https://hackweek.suse.com/projects/yast2-storage-ng-as-a-libstorage-ng-wrapper-poc
[7]: https://github.com/yast/yast-storage-ng/blob/master/README.md
[8]: https://yastgithubio.readthedocs.io/en/latest/architecture/#system-configuration-repository-scr
[9]: https://github.com/config-files-api/config_files_api
