---
layout: post
date: 2016-04-06 14:21:03.000000000 +00:00
title: Highlights of development sprint 17
description: This is the fifth report since we started blogging about our development
  sprints and we have to admit that is the less impressive one so far. We probably
  underestimated the impact of the combination of Easters holidays and vacations of
  some team members.
category: SCRUM
tags:
- Distribution
- Factory
- Programming
- Systems Management
- YaST
---

This is the fifth report since we started blogging about our development
sprints and we have to admit that is the less impressive one so far. We
probably underestimated the impact of the combination of Easters
holidays and vacations of some team members.

But although we were less productive than expected, we still have a
couple of cool things to show to our beloved users and fellow
developers.

### Handling of file conflicts in packages

Until now the package installation in YaST ignored possible file
conflicts in the installed packages. In contrast `zypper` already
supports that check for some time.

File conflicts happen when two packages attempt to install files with
the same name but different contents. If such conflicting packages are
installed the conflicting files will be replaced losing the previous
content. The final file content will also depend on the installation
order so some issues might look “random”. The package which file has
been overwritten is actually broken.

YaST now displays a confirmation dialog which asks whether to continue
with installation despite the conflicts or abort. Previously YaST
silently continued with the package installation which could cause
serious troubles later.

![File
conflicts](https://cloud.githubusercontent.com/assets/907998/13957750/e11da630-f04d-11e5-94a5-ee8b7a67b0ce.gif)

File conflicts should normally not happen, at least when you use the
original distribution repositories. The OBS build checks for some file
conflicts during package build and if there really is a file conflict
that it should be marked on the RPM level (so you should not be allowed
to select the conflicting packages for installation at first place).

It is up to the user to decide whether it is OK to ignore the conflict
or not. If the conflict is for example in a documentation file then
ignoring the conflict is usually no problem, but if the conflict is in a
binary file or in a system library then it is potentially risky. If you
are not sure “Abort” is the safe choice here.

In the description of [this pull request][1] you can see several
additional animations showcasing the new feature in a variety of
interfaces (Qt, NCurses, command line) and scenarios (software manager,
inline installation of extra packages).

### Improvements in the installer self-update

During this sprint, the self-update feature has received several
improvements and changes. The most important one is that now it uses
libzypp to fetch the updates, delegating signatures checking and that
kind of stuff. Obviously, it also means that installer updates will be
distributed using regular RPM repositories (instead of Driver Update
Disks).

![Self-Update installer - Unknown
GPG](../../../../images/2016-04-06/c7f519fc-fbda-11e5-9367-2e08dd186c1d.png)

On the other hand, user’s driver updates (specified through [dud][2]
option) will take precedence over installer updates. They will be
applied by Linuxrc anyway, but they’ll remain on top of installer
updates.

### Fun with Ruby and proxies

This is not exactly a new feature or fix in YaST, but something we
learned and we decided could be worth sharing in order to save headaches
to other people.

We got a report about YaST ignoring the `no_proxy` setting in
`/etc/sysconfig/proxy`. After some investigation, it turned out the
problem was not in YaST but in the underlying tools, that are also
implemented in Ruby. Looks like Ruby have an unexpected (by us, at
least) behavior dealing with proxy settings. If you are interested in
the details, don’t miss the information we collected in [this page in
the YaST2-Registration wiki][3], which includes some background and a
set of recommendations to follow when setting `no_proxy`.

### Unification of network setup during installation

As a result of the analysis about how the network settings affect
different installation modes and steps, we unified the position and
shortcuts of the “Network Setup” button. That affected three
installation steps.

A button was added to “Add On Product” to avoid going back and forth
just to setup some special configuration for some of our network
interfaces.

[![Add On
Product](../../../../images/2016-04-06/addon-300x225.png)](../../../../images/2016-04-06/addon.png)

In the “Disk Activation” step, the button was moved to the top-right
corner to be consistent with other steps.

[![Disk
Activation](../../../../images/2016-04-06/disk_activation-300x225.png)](../../../../images/2016-04-06/disk_activation.png)

And to round off consistency we also adjusted the keyboard shortcut in
the registration screen.

[![Registration](../../../../images/2016-04-06/registration-300x225.png)](../../../../images/2016-04-06/registration.png)

### New storage library keeps evolving

This time we don’t have any big headline about the development of the
new storage layer. We keep collaborating with experts in our attempt to
ensure solid solutions for all situations. In addition to booting
experts, the input from [Parted][4] guru Petr Uzel was really valuable
during this sprint. We took some important decisions about the
integration of the new libstorage and libparted and we made progress in
implementing a partitioning proposal that ensures a bootable system in
all architectures and configurations, backed with highly readable tests
and specs.

If time and bug reports permit, we’ll have much more to show after the
next sprint… but that would be in three weeks from now. Meanwhile, have
a lot of fun!



[1]: https://github.com/yast/yast-yast2/pull/452
[2]: https://en.opensuse.org/SDB:Linuxrc#p_dud
[3]: https://github.com/yast/yast-registration/wiki/Proxy-Configuration-Issues
[4]: http://www.gnu.org/software/parted/
