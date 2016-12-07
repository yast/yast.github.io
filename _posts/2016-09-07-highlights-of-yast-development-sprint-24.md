---
layout: post
date: 2016-09-07 15:53:59.000000000 +00:00
title: Highlights of YaST development sprint 24
description: We are back to this blog after another three weeks of (mainly) bug-fixing.
  In the previous post we promised some news about the self-update functionality and
  about the LVM support in the new storage stack. We have that&#8230; and much more!
category: SCRUM
tags:
- Distribution
- Factory
- GSOC
- Programming
- Systems Management
- YaST
---

We are back to this blog after another three weeks of (mainly)
bug-fixing. In the [previous post][1] we promised some news about the
self-update functionality and about the LVM support in the new storage
stack. We have that… and much more!

So this will be a long post, but it also hides some gems. You will have
to keep reading in order to find them.

### Self-update improvements

We have already mentioned in several previous reports the new
self-update feature in YaST, which allows updating the installer itself
before performing installation of the system.

But it turned out that the initial implementation had an important
drawback. The self-update process happened after having performed some
of the installation steps. Then, after updating the installer it was
restarted and several of those steps lost their configuration or simply
did their operations twice.

After some discussions we decided to move the self-update step earlier,
at the very beginning. For downloading the updates we basically need
just working network connection and initialized package management. So
we moved the self-update step after the initial automatic network setup
(DHCP) and added package initialization to the self-update step.

![The self-update in
action](../../../../images/2016-09-07/c9d6beac-6e93-11e6-853b-62063269b7dd.gif)

As you can see the self-update step is the very first step in the
installation workflow, the language selection and the EULA dialog is
displayed *after* the self update is finished and YaST is restarted.
That means all the following steps do not need to remember their state
as they will not be called twice after the restart.

The disadvantage is that we had to drop some features. The self-update
step happens before the language selection and the optional disk
activation. That means by default the self-update progress (and
potential error messages) will be displayed in English. But you can
still use the “language” boot option and set the language manually via
*linuxrc*.

On the bright side, we fixed like half a dozen of reported bugs just by
relocating the self-update process. So we are pretty sure it’s worth the
price.

For more details see the updated [documentation][2].

### Gem one: using the `info` boot parameter

The `info` boot parameter is a pretty old *linuxrc* option but it is
probably not known well. The parameter is an URL which points to a text
file which can contain more boot options.

When we tested the updated self-update described above we needed to
build a driver update disk and pass several boot options. To avoid
repeating the same options on the boot command line and to share the
boot options across the team we created an `info.txt` file with content
like

```
insecure=1
startshell=1
dud=ftp://example.com/self_update.dud
```

Then you simply boot the installation with
`info=ftp://example.com/info.txt` and *linuxrc* will read the additional
parameters from the file. This can save you a lot of typing, especially
if you need to repeat the tests many times.

### Fixed a security bug for 7 (yes, seven) different SLE releases

Some weeks ago, during a routine code review, our security experts found
a vulnerability in YaST’s libstorage related to the way we provide the
encryption passwords to some external commands. It is debatable how
dangerous this threat really is. It was never a problem during system
installation, but it would affect admins who create encrypted partitions
(mostly encrypted LVM physical volumes) or crypto files in the installed
system.

A potential attacker with access to `/tmp` could intercept the password
in the very precise moment in which the “cryptsetup” or “losetup”
command are invoked by YaST. It’s really only a matter of milliseconds.
But we don’t want to take any risks, however small they may be.

So not only did we fix that for the current code streams, we backported
it to all the SLE releases out there that are still supported (even
though in some cases it’s just a single customer) – back to SLES-10 SP3
from late 2009. That meant backporting the fix to no less than 7 SLE
releases (for Leap, those fixes are picked automatically).

As you can imagine, this got more difficult the farther back in history
we went: In a central library like libstorage, things are constantly
changing because the tools and environment (kernel, udev, you name it)
are constantly changing. There was only a single case where the patch
applied cleanly; in all other cases, it involved massive manual work
(including testing, of course).

Was this fun? No, it certainly was not. It was a tedious and most
frustrating experience. Do we owe it to our users (paying customers as
well as community users) to fix security problems, however theoretical
they are? Yes, of course. That’s why we do those things.

### Storage reimplementation: every LVM piece in its place

As time permits, we keep adding new features to the future libstorage
replacement. During previous sprints we added support to read and
manipulate all kinds of LVM block devices (PVs, VGs and LVs) but an
important aspect was missing: deciding the order of the operations is as
important as performing them. We instructed the library about the
dependencies between operations and implemented several automated test
cases to ensure we don’t try to do not-so-smart things like removing a
physical volume from a volume group and shrinking its logical volumes
*afterwards*.

The good thing about our automated test-cases is that they generate nice
graph that are quite useful to illustrate blog posts. :simple_smile:

[![One of the several added
test-cases](../../../../images/2016-09-07/complex1-action-300x48.png)](../../../../images/2016-09-07/complex1-action.png)

### Gem two: enjoy Google Summer of Code result

As you may know, openSUSE is one of the Free Software organizations
selected to take part in Google Summer of Code 2016. For YaST that means
we had the huge pleasure of having Joaquín Yeray as student. You can
know more about him and his experience diving into YaST and Open Source
in [his GSoC blog][3].

But the openSUSE community is not only gaining a new member, we also
have a new YaST module. The [yast2-alternatives][4] package has already
been accepted into Tumbleweed and will be also part of Leap 42.2. So we
have a new gadget in our beloved configuration Swiss Army knife!

We liked Joaquín and his module so much that we are revamping the YaST
development tutorial to be based on his module (instead of
yast2-journal). He is already working on that, so hopefully we will have
Joaquín around quite some time still. :wink:

### Unify license handling screens

We got a report about the license agreement screen in automatic
installation (AutoYaST) being different to the one showed during common
installation. So we decided to take a look to the problem and unify
them. We are in a quite late phase of the development process of both
the next SLE and the next Leap, so we decided to not unify the code but
simply adapt one dialog to look like the other. Also we are after string
freeze due to translations, so we had to use a trick and reuse another
already translated text. We also took the opportunity to fix some small
usability problems.

This is one of those cases in which some images are worth a thousand
words, so in order to understand what we did, take a look at the
description of [this pull request][5], which includes many images (too
many for this blog post).

[![The new AutoYaST license
screen](../../../../images/2016-09-07/1c218406-693c-11e6-9c81-578b7ce30864-300x230.png)](../../../../images/2016-09-07/1c218406-693c-11e6-9c81-578b7ce30864.png)

### Smarter check to avoid duplicated repositories

The openSUSE software server defines the online repositories which can
be added during installation. The openSUSE DVD also specifies its own
online repositories that are always added to the system. And these
repositories overlap.

In openSUSE 42.1 it happened that one repository was added twice, even
though there was already a check to avoid that. So we investigated why.

We found that the URLs for the problematic repository were not exactly
the same, one of them had a trailing slash. Therefore we made the URL
comparison more tolerant and if the URLs differ only by the trailing
slash, they are still considered the same.

After the fix all repositories are added only once, without any
duplicates.

### Gem three: we are looking for new teammates!

After 12 sprint reports, most readers would have already realized that
the life as a full-time YaST developer is everything but boring… and
that we are always pretty busy. The fun and the work are better when you
share them so… [we are looking for a new hero][6] to join us in our
journey.

Even if you don’t feel hacking in YaST would be your thing, maybe you
are interested in any of the other [jobs at SUSE][7].

### Improved documentation about YaST environment variables

The behaviour of YaST can be affected by several environment variables,
but not all of them are well known by everybody. During this sprint we
also decided to invest some time documenting them better. The resulting
document will be soon properly integrated in our [centralized
documentation for developers][8], but you can sneak it already
[here][9].

### Branching Tumbleweed and the upcoming stable releases

Most of the features and bug-fixes we have blogged about in the last
months were incorporated to Tumbleweed, the upcoming Leap 42.2 and the
future SLE 12-SP2, since we always try to keep those three codebases as
close as possible to each other.

Now Leap 42.2 and SLE 12-SP2 are close enough to their release date, so
we plan to be more conservative with the changes. At the end of this
sprint we decided to branch the code for Tumbleweed and for the stable
siblings. From now on, most exciting stuff will appear only in
Tumbleweed, with SLE 12-SP2 and Leap 42.2 becoming more and more boring.

### And the wheel keeps on turning

So that was a very minimal selection of the most interesting stuff from
the just finished sprint. What comes next? Another sprint, of course! We
have already planned some interesting stuff for it, like integrating the
new partitioning proposal into the installer or finishing the
[ultra-cool UI designer][10] that was started during latest Hack Week.

As always, you can follow development in a daily basis in the usual
channels ([#yast IRC channel](irc://irc.opensuse.org/yast) and the
[yast-devel][11] mailing list) or wait another three weeks for the next
sprint report. Meanwhile… have a lot of fun!



[1]: {{ site.baseurl }}{% post_url 2016-08-18-highlights-of-yast-development-sprint-23 %}
[2]: https://github.com/yast/yast-installation/blob/master/doc/SELF_UPDATE.md
[3]: https://joaquinyeray.me/
[4]: https://software.opensuse.org/package/yast2-alternatives
[5]: https://github.com/yast/yast-packager/pull/185
[6]: https://jobs.suse.com/job/nuremberg/linux-c-ruby-hero-global-location/3486/2930771
[7]: https://www.suse.com/company/careers
[8]: http://yast.github.io/documentation.html
[9]: https://github.com/yast/yast.github.io/blob/master/doc/environment-variables.md
[10]: https://hackweek.suse.com/14/projects/1522
[11]: https://lists.opensuse.org/yast-devel/
