---
layout: post
date: 2019-07-19 11:35:29.000000000 +00:00
title: Highlights of YaST Development Sprint 80
description: 'After our (really long) sprint report, which featured information from
  3 different sprints together, we are back to our regular schedule of publishing
  a blog post after each sprint.'
category: SCRUM
tags:
- Architectures
- Factory
- Systems Management
- YaST
---

After our (really long) [sprint report][1], which featured information
from 3 different sprints together, we are back to our regular schedule
of publishing a blog post after each sprint.

In a nutshell, these are the highlights from the previous one:

* A new version of yast2-network will be submitted to Tumbleweed
  shortly, including quite some internal changes as part of the
  refactoring effort.
* The support for offline installation of SUSE Linux Enterprise products
  has been improved to handle modules and extensions dependencies
  automatically, among other goodies.
* The partitioning proposal has been adapted to support SUSE Manager
  special needs.
* The guided partitioning ignores now the `adjust_by_ram` parameter in
  IBM z Systems, where it is basically useless.
* Some (open)SUSE 15 features have been backported to 5th Service Pack
  of SUSE Linux Enterprise.

And last but not least, we have some words to say about the feedback we
get from you (that we really appreciate!) and the future of YaST.

### Shipping Another Round of Network Refactored Code

One of the problems we wanted to avoid while refactoring yast2-network
is diverging too much from the version shipped in Tumbleweed. As we
mentioned in our last report, we have done quite some work, especially
when it comes to the internals of the user interface, and codebases are
starting to look quite different.

For that reason, we decided to merge the new code into the master branch
so it can be included in Tumbleweed shortly. We are talking about a pull
request which contains more than 340 commits, adds 9000 lines, removes
5000 and modifies 197 files. So, what could possibly go wrong? To be
honest we did quite some testing but there is a chance that you can find
some issues. In that case, please, open a bug report and we will happily
fix it.

About the technical details, we put most of our efforts into drawing a
clear line between the user interface and the business logic. In
parallel, we are still working on the new data model which enables us to
read/write the network configuration using different backends, although
at this time we are only supporting `sysconfig`. We have made some
progress during this sprint (you can check the [pull request][2] if you
are interested), but we will not merge this code into our master branch
yet. You can find more details in the [updated documentation][3].

After reading this status update about the yast2-network refactoring,
you might be wondering about our plans. Basically, we would like to
finish the support to read/write network interfaces configuration and
start using it through all the code, killing some rather old and buggy
modules like [LanItems][4].

### Offline Media Support

For SUSE Linux Enterprise 15 products, there are two installation media:

* The installer media, which contains only basic packages for a minimal
  system.
* The so-called Packages DVD, which contains several modules and
  extensions, like the *Development Tools Module* or the *Server
  Application Module*.

The main use case of the Packages DVD is allowing to install the systems
without an Internet connection. However, YaST support for such a
scenario is pretty simplistic. For instance, dependencies between
modules are not evaluated and the user has to select them manually. This
approach is error-prone and user-unfriendly.

Fortunately, these shortcomings will be addressed in SLE 15 SP2. YaST is
now able to solve modules and extensions dependencies, so the user does
not have to worry about them anymore. For instance, if you select the
*Web and Scripting Module*, the *Basesystem Module* and *Server
Application Module* will be automatically selected.

At first, solving dependencies through the 25 repositories which are
included in the Packages DVD might be time-consuming, but the current
implementation takes advantage of [libsolv][5] to reduce it to about 2
seconds in our testing machine.

{% include blog_img.md alt="Improved Extensions and Modules Selection"
src="extensions-and-modules-selection-300x225.png"
full_img="extensions-and-modules-selection.png" %}

Additionally, other improvements have been included, like displaying
additional information about each module/extension or filtering out base
products from the list.

### SUSE Manager and the Partitioning Guided Setup

As you know, YaST is a very flexible Linux installer. The creators of
each (open)SUSE product or role can define the particular sequence of
steps presented to the user and configure many of the options on each of
those step. But that was still not enough for the maintainers of [SUSE
Manager][6], the purpose-specific distribution to manage
software-defined infrastructures.

SUSE Manager follows a pretty specific approach regarding the management
of the storage devices. So we had to add some extra configuration
options to our partitioning guided proposal to fulfill their needs. We
felt the topic deserved its own separate blog post. So follow the link
and enjoy the love story of [SUSE Manager and the Partitioning Guided
Setup][7].

### Taking care of IBM z Systems

For many reasons, IBM z System architecture (s390) is one of those
special cases where YaST flexibility is crucial. One of the many options
that YaST offers to products and roles creators is called
`adjust_by_ram`, which instructs YaST to make sure that a given volume
size is, at least, as big as the RAM of the system. Obviously, this
option is especially useful for the swap volume when we want to be able
to suspend the system to disk.

However, on the 64-bits s390 architecture, resuming from a swap device
is not supported, which renders this option useless. For that reason,
YaST will take this situation into account, and it will not enlarge the
swap volume bye default for s390 machines, even if `adjust_by_ram` was
set in the control file. Of course, the user will be able to enlarge the
volume by activating the corresponding checkbox in the Guided Setup
options.

{% include blog_img.md alt="Guided Partitioning Filesystem Options"
src="guided-partitioning-filesystem-options-300x225.png"
full_img="guided-partitioning-filesystem-options.png" %}

### Backporting Stuff to SLE 12 SP5

Although most of the development effort is focused on SLE 15 SP2 and
openSUSE Leap 15.2, we do not forget about SLE 12. SUSE is working on
the 5th Service Pack of this release and the YaST team is no exception.

During this sprint, SLE 12 got two interesting features that were
backported from SLE 15. The first one is the ability to specify kernel
mitigations settings, as you already can do in Tumbleweed. And the
second one is the support for PMEM devices, that you can see in the
screenshot below.

{% include blog_img.md alt="YaST2 Partitioner PMEM Support"
src="yast2-partitioner-pmem-support-1-300x173.png"
full_img="yast2-partitioner-pmem-support-1.png" %}

Recently, there was an interesting [discussion about the openSUSE
installer on Reddit][8], continued as a [thread on our yast-devel
mailing list][9].

This is just a quick heads-up to confirm that we hear you. Some of the
issues discussed there were already known to be sore points, some others
may need more clarification on why and how things are as they are.

We are taking your feedback and criticism seriously. But we also have to
consider all the requirements, and we try to avoid making unrealistic
promises. So please bear with us until we had some further discussions
first about what we can do and in what time frame.

### Conclusions

In addition to what we have described in this report, we have been
working on fixing bugs and making other small improvements here and
there. And sprint 81th will not be different: part of the team will keep
working on yast2-network while the rest squashes as many bugs as
possible.



[1]: {{ site.baseurl }}{% post_url 2019-06-25-highlights-of-the-latest-yast-development-sprints %}
[2]: https://github.com/yast/yast-network/pull/875
[3]: https://github.com/yast/yast-network/blob/ea1faacb9ef08ec83d53471cc0220df8245ae9c0/doc/network-ng.md
[4]: https://github.com/yast/yast-network/blob/568aadcd71671bd24715f36396968d7cbbc89277/src/modules/LanItems.rb
[5]: https://github.com/openSUSE/libsolv
[6]: https://www.suse.com/products/suse-manager/
[7]: {{ site.baseurl }}{% post_url 2019-07-16-suse-manager-and-the-partitioning-guided-setup %}
[8]: https://www.reddit.com/r/openSUSE/comments/cbp2c7/
[9]: https://lists.opensuse.org/yast-devel/2019-07/msg00021.html
