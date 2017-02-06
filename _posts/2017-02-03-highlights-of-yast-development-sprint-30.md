---
layout: post
date: 2017-02-03 14:28:28.000000000 +00:00
title: Highlights of YaST development sprint 30
description: This is our first post in 2017 and looks like we must start apologizing.
category: SCRUM
tags:
- Distribution
- Factory
- Programming
- Systems Management
- Usability
- YaST
---

In our [previous post][1] we promised news about this blog, but the
administrative part slowed us down and the surprise is still not ready.
On the bright side, we have quite some news about YaST. So let’s go for
it!

### One-click system installation for CaaSP

As you may know, SUSE has been working on making containers easier, with
SUSE Container as a Service Platform. We have referred to it in several
previous posts using the CASP acronym, although nowadays the correct one
is CaaSP (maybe we could sell the new “a” as a shiny feature :wink: ).

Part of this upcoming product is also an interactive installation option
using the good old YaST. CaaSP uses a limited subset of the SLE
possibilities and we wanted to make the installation simpler to reflect
that. So we reduced the number of dialogs you have to click through… to
one!

{% include blog_img.md alt="One-click installation in CaaSP"
src="one-click-installation-300x234.png" full_img="one-click-installation.png" %}

As you can see, it is at the expense of stuffing the screen with more
widgets than usual. Still, the only part where you must make a decision
is the root password.

We expect that most of the CaaSP installations will actually not use
this, because they will be done automatically with AutoYaST. But still
this should be useful when you are only getting started.

### Refining the read-only installation proposals

It was possible to make a proposal “read-only” [for some time
already][2]. However, its black-and-white logic was not sufficient for
some use cases. So, it was redesigned and you can mark a proposal hard
read-only or soft read-only. The difference is that users will never be
able to change hard read-only proposal. However their will be able to
modify a soft read-only proposal if the proposal reports an error. It
can be useful e.g. for error recovery in software proposal. It has been
implemented originally for CaaSP, but it will be available for
SLE-12-SP3 and Leap 42.3 too.

### Installing directly from a repomd repository

When you install (open)SUSE you have up to now needed a specially
prepared install repository. In addition to the repository with the RPM
packages, it needed a bunch of specially prepared files containing the
installation system and our beloved YaST installer.

That’s all gone now!

You can now point the installer to any plain repomd repository. For this
to work you have to point the installer to the repomd repository **and**
to the installation system (they can be completely separate now).

For example:

    
    install=http://download.opensuse.org/tumbleweed/repo/oss instsys=disk:/boot/x86_64/root

In that example, we install Tumbleweed from the openSUSE website and use
the installer from some local media (maybe the NET iso).

To make things even easier there is now a regular package
(`tftpboot-installation-openSUSE`) that contains the installation system
and some sample config files.

Check out [this linuxrc documentation][3] for technical details.

### Storage reimplementation: removing stones from the installation path

In our [latest post][1], we presented the dedicated openQA instance
contantly testing the new storage layer implementation. It still doesn’t
run exactly the same tests than [openQA.opensuse.org][4] because not all
technologies and operations are supported yet in the new yast2-storage.
But now we are a couple of steps closer to run the full-blown tests also
in our dedicated instance.

During this sprint, the partitioning proposal gained the ability to deal
with disks not containing a partition table in advance (it always
proposes to create a GPT one in that scenario) and the software
selection proposal learned how to use the new storage API, so it can
properly inspect the system and the associated error pop-ups are gone
from the installation workflow.

### More power to the system roles

We keep extending the capabilities of the system roles, now with the
ability to specify some systemd services to enable. As the roles can
define which software gets installed in the system, it made sense for
them to also be able to specify the desired status for the services
included in that software

For example, it would be possible for a given product (let’s say a
customized openSUSE) to define a “static web server” role. Choosing that
role during installation would result in a system with a HTTP server
already installed and enabled, so the user just need to copy the files
to be served into the right directory.

### Expert partitioner is now less restrictive with encryption

Setting up an encrypted LVM was always pretty easy when using the
automated storage proposal – simply select “encrypted LVM” at the
proposal settings and you are done.

But doing that manually was almost impossible: The expert partitioner
wouldn’t allow any of the system mount points (“/”, “/usr”, “/var”, …)
on any encrypted partition, and it also wouldn’t allow to encrypt, but
not format a partition of type “LVM” for use as an LVM physical volume.

Both restrictions are now lifted; you can now create an LVM physical
volume with encryption, or you can do the encryption layer on the
logical volume if you prefer. And you can create an encrypted plain
partition with a filesystem directly on it without LVM.

Over the years, Grub2 learned how to do that, so you don’t even need a
/boot partition anymore. For the time being, you’ll need to enter the
encryption password twice, though: once at the Grub2 prompt and once
later at the graphical console so systemd can mount those filesystems.
Our base system developers are working on a secure solution to avoid
that.

### Migrate Travis CI to Docker

That’s actually not a change in YaST itself, but in its development
infrastructure. Still, we believe it would be interesting for the
average reader of our blog.

So far we used Travis CI for building and testing the commits and pull
requests at GitHub. But the problem was that by default Travis runs
Ubuntu 12.04 or 14.04 at the build workers. That had several drawbacks
for us, since compiling and testing YaST on Ubuntu is not trivial and
the result is not always 100% equivalent to openSUSE. All this meant
extra maintenance work for us.

Fortunately Travis allows using Docker containers at the workers and
that allows using basically any Linux distribution. This sprint we spent
some time converting the Travis configuration to use a *dockerized*
openSUSE Tumbleweed at Travis.

{% include blog_img.md alt="From Github to Travis thanks to Docker"
src="gh-tv-dck.png" %}

The work was successful, we switched all YaST modules to use this new
builds and the result is already paying off at several levels, although
it took us [over 100 pull requests][5] (all of them manually tweaked and
reviewed) to make it happen.

The current solution [is documented][6] and we had also a short internal
presentation about this change. The notes from the presentation are
[available here][7].

### Improved continuous integration for Snapper

We also enabled Travis integration with Docker for [Snapper][8]. As you
may know, Snapper is a portable software that has always offered
packages for many Linux distributions in the [filesystems:snapper][9]
OBS repository.

So we took the continuous integration one step further and enabled
Travis builds on more distributions, currently we build for openSUSE
Tumbleweed, openSUSE Leap 42.2, Fedora 25, Debian 8 and Ubuntu 16.10.
You can see an [example build here][10] or more details in the
[documentation][11].

{% include blog_img.md alt="Example build result of Snapper at Travis" 
src="snapper-travis-300x256.png" full_img="snapper-travis.png" %}

That means we can ensure that the package still builds on all these
distributions even before merging a pull request!

### Better integration with systemd for YaST Services

Systemd recognizes many possible states for a service beyond the classic
Unix enabled/disabled and running/stopped, and that list of possible
states grows with every systemd release. In the past YaST have had some
issues displaying the services status.

Now the problems are fixed by delegating to systemd the conversion from
the concrete state to the good old known Unix equivalent. So the user
now gets more precise information about all services running on the
system.

### Storage reimplementation: redesigning the installation user experience

In the latest post we showed you the document we were using as a base to
discuss the new expert partitioner UI with usability experts. Now it was
turn for the proposal settings dialog. We collected the current state,
had a very productive discussion and ended up with a proposal for a new
interface. You can check [the resulting document][12] covering all that.

As mentioned, the SUSE UX experts will use that document as a starting
point to design the final interface. But we want the process to be as
open as everything around YaST, so feel free to provide feedback.

### Reading product renaming information from libzypp

When performing an upgrade, YaST needs to know whether a product is
renamed or replaced by a another one. For example, in the past, the
*Subscription Manager Tool* (SMT) lived in its own product but it’s
included in SUSE Linux Enterprise 12. So YaST needs to know that the
`suse-smt` product was just replaced by `sles`.

This information is usually provided by the SUSE Customer Center (SCC).
But what happens if, for example, we are performing an offline upgrade?
Until now, YaST used a [hard-coded fallback list][13].

From now on, before falling back to such a list, YaST will ask libzypp
for that information so, hopefully, it will avoid some problems while
upgrading extensions and it will reduce the hassle of maintaining a
hard-coded list.

### Storage reimplementation: Making sure to install storage-related packages

The YaST storage subsystem has been taking care about storage-related
software packages for a long time. For example, when a specific
filesystem type like Btrfs or XFS is used by the system, we need to make
sure that necessary support packages like `btrfsprogs` or `xfsprogs` are
installed.

Figuring out what features are used is now done by the new libstorage.
In this sprint, we created one [Ruby class][14] that maps those features
to respective packages and [one class][15] that handles package
installation itself. One interesting technical aspect is how Ruby
introspection capacities are used to avoid duplicating the list of
defined features from the C++ part (i.e. libstorage).

### Power the chameleon

Apart from all those changes in YaST, and many more we have not included
in this summary, we have something else to celebrate. On February 1st
the YaST Team at SUSE has grown with the addition of a new member, Iván,
who will allow the project to evolve even faster and better… and that
will not be the last announcement in that direction, so stay tuned.

But don’t forget you can also help YaST, and openSUSE in general, to
keep moving. This week we added several ideas for [Google Summer of
Code][16] projects to the [openSUSE mentoring page][17], including one
idea to contribute to YaST. Do you have a better plan for this summer?

See you in less than three weeks, since the next sprint will be slightly
shorter due to [Hack Week 15][17].



[1]: {{ site.baseurl }}{% post_url 2016-12-22-highlights-of-yast-development-sprint-29 %}
[2]: {{ site.baseurl }}{% post_url 2016-11-10-highlights-of-yast-development-sprint-27 %}
[3]: https://github.com/openSUSE/linuxrc/blob/master/linuxrc_repo.md
[4]: https://openqa.opensuse.org
[5]: https://github.com/pulls?utf8=%E2%9C%93&amp;q=is%3Apr+user%3Ayast+docker+updated%3A%3E2017-01-12
[6]: http://yastgithubio.readthedocs.io/en/latest/travis-integration/
[7]: https://gist.github.com/lslezak/ebf13dbf584685b6b86f5f3cc57ab9e7
[8]: http://snapper.io/
[9]: https://build.opensuse.org/package/show/filesystems:snapper/snapper
[10]: https://travis-ci.org/openSUSE/snapper/builds/191720299
[11]: https://github.com/openSUSE/snapper/blob/master/README.Travis.md
[12]: https://github.com/yast/yast-storage-ng/blob/master/doc/designing-proposal-settings-ui.md
[13]: https://github.com/yast/yast-packager/blob/27e42b1a0b0f4f05eda241fe3a71610c18dd05aa/src/modules/AddOnProduct.rb#L139
[14]: https://github.com/shundhammer/yast-storage-ng/blob/master/src/lib/y2storage/used_storage_features.rb
[15]: https://github.com/shundhammer/yast-storage-ng/blob/master/src/lib/y2storage/package_handler.rb
[16]: https://summerofcode.withgoogle.com/
[17]: http://101.opensuse.org/
