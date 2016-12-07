---
layout: post
date: 2016-05-02 13:03:39.000000000 +00:00
title: Highlights of YaST development sprint 18
description: The wait is over, the report of the latest Scrum sprint of the YaST Team
  is here! In the previous post we promised that after this sprint we would have much
  more to show&#8230; and now we do.
category: SCRUM
tags:
- Distribution
- Factory
- Programming
- Software Management
- Systems Management
- YaST
---

The wait is over, the report of the latest Scrum sprint of the YaST Team
is here! In the previous post we promised that after this sprint we
would have much more to show… and now we do. This sprint was quite
productive, so let’s go straight to the most interesting bits.

### More improvements in the self-update

The YaST self-update feature mentioned in the two previous blog posts
([sprint 16][1] and [sprint 17][2]) has also received a couple of
improvements.

At [this gist][3] (with screenshots) you can see some of the fixes done
when going back and forward in the work-flow after an installer
self-update.

But even more important are the improvements done in AutoYaST to
properly handle the new feature. If you want to use your own self-update
repository you have to specify it on the boot command line. This is easy
in a single installation, but if you want to install many machines using
AutoYaST then writing the possibly long URL at each installation again
sounds annoying.

In this sprint we improved handling of the custom update URL so that it
can be read from the AutoYaST XML profile. Now you need to write the
custom URL only once into the profile and it will be used automatically
in every AutoYaST installation.

There is not much to show in the UI, the log proves that the self update
was really loaded.

[![AutoYaST
self-update](../../../../images/2016-05-02/autoyast-self-update-300x225.png)](../../../../images/2016-05-02/autoyast-self-update.png)

You can find more details about specifying the URL in the profile and
evaluating the self-update repository URL at the [documentation][4].

### Goodbye perl-Bootloader

For quite some time, we have had the plan to stop using
[Perl-Bootloader][5] as library for yast2-Bootloader and finally we
managed to make it happen. There were many reasons for this change.

From the user point of view, the most visible reasons were speed and
size. Getting rid of Perl-Bootloader means that we not longer perform
hardware probing twice (one for Perl-Bootloader and another one for
`grub2-config`), making kernel updates faster. In addition, we are not
only simplifying and reducing the size of yast2-bootloader itself.
Dropping the Perl libraries and other associated dependencies, makes
possible to have a smaller minimal system, something quite relevant in
various environments and scenarios.

From the developer point of view, the main reason was to unify the used
programming languages and also reuse existing solution for file reading
and parsing. Now yast2-bootloader uses an [Augeas][6] file parser and
serializer, which does not only allow us to have less code to maintain,
but also offers smarter editing and better handling of the comments in
the configuration files.

As nice side effects, this change also leaded to the removal of a lot of
work-arounds, the simplification of the installation work-flow for
bootloader and a very visible improvement in the source code quality. In
addition, we improved the test coverage of the whole module to make sure
we didn’t break things too much. But all those would be bold statements
if we wouldn’t have some geeky numbers to prove then, so here they are.

* 2945 lines of code added, 5963 removed ([4d776…master][7])
* Unit tests coverage raised [from 69% to 81%][8]
* Code climate quality rating raised from [1.73 to 3.31][9] (where 0 is
  the worst and 4 is the best)

Of course, after such a big rewrite is not unlikely that some new bugs
will pop up, but we really believe the improvements are worth the price.

### Storage reimplementation: calculation of partition location

For the [storage-ng][10] project we made a big step towards a modern
system. We do not use geometries and cylinders for disks any longer.
Instead we only use sectors.

The advantage for the user is much better control over the size of new
partitions. Since so far the size had to be a multiple of the cylinder
size, often 7.84 MiB, it was not possible to create very small
partitions, e.g. for the [BIOS boot partition][11]. Also the size of
partitions was usually not the exact number entered in YaST, e.g. 509.88
MiB instead of 512 MiB.

Now the size of partitions is as accurate as possible with the hardware,
so usually a multiple of 512 B or 4 KiB.

Like in the past we also takes care of optimal partition alignment to
avoid performance loss due to read-modify-write cycles.

### Snapper: much better cleanup rules

[Snapper][12] is a great tool, but the current default configuration
usually causes it to be a little bit too greedy with disk space. During
this sprint a new set of cleanup rules was implemented, allowing a much
more reasonable usage of the disk.

The feature is already developed, submitted to Factory and even
integrated into the next version of SUSE Enterprise that is right now
being cooked. But, as you all know, the testing work-flow of openSUSE
Tumbleweed (staging projects, openQA and so on) can sometimes cause some
delay until the new feature appears in the distribution. As soon as the
new feature reaches Tumbleweed, a blog post explaining the new
functionality will be published at [snapper.io][12]. Stay tuned!

### Improved password protection for bootloader

The password protection widget in YaST2-Bootloader had not been changed
since the GRUB1 times, but GRUB2 allows more fine tunning of the
password settings. In fact, it contains a whole user management system
with multiple users that can have different permissions and different
passwords. For YaST we like to keep things simple, so we support only
password for “root” user. That was confusing for some people, so we
decided to improve the user experience by adjusting some labels… and
fixing some typos in the process. :wink:

Two pictures are worth a thousand words, so here you can see how the
dialog looked before the change

[![BEFORE: boot password
dialog](../../../../images/2016-05-02/boot-password-old-300x202.png)](../../../../images/2016-05-02/boot-password-old.png)

and below the new appearance, which adds more explanation to the
password specification. Of course, the help text (not displayed in the
screenshots) was also improved to reflect the changes.

[![AFTER: boot password
dialog](../../../../images/2016-05-02/boot-password-new-300x203.png)](../../../../images/2016-05-02/boot-password-new.png)

### Handling of default product patterns

The YaST installer implements several possibilities how the default
patterns for the installed product should be specified. One of them is
using `Recommends` RPM dependencies for the product package. (The other
possibilities include `control.xml` file or the `content` file on the
medium.)

The installer by default installs the recommended packages so the
default patterns are automatically installed in the initial
installation.

However, this approach makes troubles during system upgrade. If you
remove some packages or patterns which are installed by default and then
you do a system upgrade the installer will (silently) add the removed
packages or patterns back as the `Recommends` dependencies will pull
them in again.

The solution is to provide another mechanism for selecting the default
patterns. The new implementation allows using a specific `Provides` RPM
package tag which specifies the default pattern name for the product.

The new tag is `defaultpattern(pattern)` where “pattern” is the name of
the default pattern. YaST looks for these specific tags and collects the
pattern names for all installed or updated products. This step is
skipped during package based system upgrade so this should avoid adding
unnecessary packages in system upgrade.

Obviously it depends on the products themselves to switch from the RPM
dependencies to this new style. So far it is supported only by the
*SLES12 SP2 High Availability* addon.

See more details at
[https://github.com/yast/yast-packager/wiki/Selecting-the-default-product-patterns][13].

### Storage reimplementation: another step closer to the perfect booting layout

A [couple of reports ago][1] we made public our intention to squeeze
some booting experts brains in order to create Ruby classes capable of
always proposing a sensible partitioning schema. The delicious result is
finally [at the repository][14], accompanied with a rather complete
[document explaining the logic][15] behind the code.

If reading Ruby code is not your thing but you are geeky enough, you can
also review the [output generated by the RSpec unit tests][16], which
shows how the new partitioning proposal will behave in all scenarios
from the booting requirements point of view.

### Storage reimplementation: other improvements in the new proposal

Apart from the already mentioned improvements in setting the
boot-related partitions, the brand new partitioning proposal gained the
ability of *shrinking Windows partitions* when needed (in a sensible and
gentle way) and *reusing partitions that can be shared* with other
installed systems, like swap of PReP. Even when sharing a swap partition
is not possible and the proposal needs to delete an existing swap
partitions to create a different one, it will take care of reusing the
old label and UUID, so other systems in the same computer can still find
a suitable swap for them even after changing the partitioning layout.
Because we all can be better citizens…

In addition, we took the first steps to develop a smarter way of
proposing a solid partitioning schema when the free space is split over
several different disks or disk chunks. Is still a work in progress, but
you can trust that in the future (open)SUSE will do a nice job when
looking for a home for itself in your sparse hard disk space.

### Prevent wrong usage of LDL DASD disks in S/390 mainframes

The management of storage devices in a Linux system running in a S/390
mainframe is a tricky topic full of corner cases. Depending on the type
of disk, its format and other factors, some apparently simple operations
(like creating partitions) are not possible. If you are interested in
the subject and want to learn a lot of weird acronyms, we would
recommend [this article][17].

We realized that the expert partitioner allowed the user to specify some
operations that were actually not supported, which resulted in the
installation being aborted at a subsequent step. To avoid that
situation, we improved the expert partitioner to detect those
unsupported S/390 configurations and alert the user, like it’s shown in
the screenshot below.

![LDL DADS popup](../../../../images/2016-05-02/ldl_popup.png)

### AutoYaST: moving network device renaming to first stage of installation

We refactored the network module to unify the handling of device naming.
Now AutoYaST assigns the naming udev rules in the 1st stage of the
installation already. (yast2-network-3.1.147, autoyast2-3.1.121)

### New toys for the team

We got a new server to run integration tests via openQA and
[AutoYaST][18].

The AutoYaST tests now used to take 8 hours but now finish in 1.5 hours.

### Collaboration with other (open)SUSE Teams

Even though we call ourselves “the YaST team” we are happy to share the
project with other teams in the company and people in the community.
During this sprint, we had a chance to review code for two significant
features.

The authentication client module, dealing with LDAP, Kerberos, Active
Directory, NSS, PAM, and SSSD, got a big upgrade
(yast2-auth-client-3.3.7).

Since a couple of months, Tumbleweed has had a package for
[firewalld][19] (see [FATE#318356][20] ). Work is underway to make YaST
aware of it but it has not been merged yet. If you are interested you
will have to find it in the [git repo][21].

### In closing

Definitely, this was a very productive sprint and, as usual, this report
is just a sample of the total work delivered by the team. To be precise
and to please number lovers, the features and fixes covered by this
report represent 85 Scrum story points out of a total of 124 delivered
ones. Hopefully enough to keep you entertained until the next report in
about three weeks. See you then!



[1]: {{ site.baseurl }}{% post_url 2016-03-15-highlights-of-development-sprint-16 %}
[2]: {{ site.baseurl }}{% post_url 2016-04-06-highlights-of-development-sprint-17 %}
[3]: https://gist.github.com/teclator/7bab6f4037992e66b1461e0696cf7f0a
[4]: https://github.com/yast/yast-installation/blob/master/doc/SELF_UPDATE.md#where-to-find-the-updates
[5]: https://build.opensuse.org/package/show/openSUSE:Factory/perl-Bootloader
[6]: http://augeas.net/
[7]: https://github.com/yast/yast-bootloader/compare/4d776...master
[8]: https://coveralls.io/github/yast/yast-bootloader
[9]: https://codeclimate.com/github/yast/yast-bootloader/trends
[10]: https://build.opensuse.org/project/show/YaST:storage-ng
[11]: https://en.wikipedia.org/wiki/BIOS_boot_partition
[12]: http://snapper.io/
[13]: https://github.com/yast/yast-packager/wiki/Selecting-the-default-product-patterns
[14]: https://github.com/yast/yast-storage-ng/tree/master/src/lib/storage/boot_requirements_strategies
[15]: https://github.com/yast/yast-storage-ng/blob/master/doc/boot-partition.md
[16]: http://paste.opensuse.org/78272293
[17]: http://rhinstaller.github.io/blivet/blog/2015/06/s390/
[18]: https://github.com/yast/autoyast-integration-test
[19]: http://www.firewalld.org/
[20]: https://features.opensuse.org/318356
[21]: https://github.com/yast/yast-yast2
