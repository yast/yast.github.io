---
layout: post
date: 2016-01-07 12:43:35.000000000 +00:00
title: Highlights of development sprint 13
description: As promised in the previous post on this blog, we&#8217;ll try to keep
  you updated about what is happening in the YaST world. Before Christmas we finished
  an specially short sprint, interrupted by another successful Hackweek.
category: SCRUM
tags:
- Distribution
- Factory
- Programming
- Systems Management
- YaST
---

As promised in the [previous post][1] on this blog, we’ll try to keep
you updated about what is happening in the YaST world. Before Christmas
we finished an specially short sprint, interrupted by [another
successful Hackweek][2]. Although we always reserve some time for bug
fixing, the last two sprints has been quite focused in looking into the
future, implementing new solutions for old problems and trying to
prepare replacements for some legacy stuff we have been carrying on for
too long. Here you are the highlights.

### SCR replacement

For low level access to the system, YaST uses its own library called
SCR, inherited from the old YCP days. It’s used to call scripts and also
to read and write files. Its design is showing its age and using it from
Ruby is unnecessary complex. We feel SCR is one of the biggest source of
confusion for newcomers to YaST development. Last but not least, SCR is
only used by YaST which means all the maintenance work fall to us.

We want to use a new approach for the future. For running scripts we
plan to use a Ruby gem called [Cheetah][3] and for accessing
configuration files we plan to rely on [Augeas][4].

Taking some improvements that were needed in YaST2-Bootloader and the
drop of perl-bootloader as starting points (or as an excuse, if you
prefer), we have used this sprint to develop all the moving parts that
will allow us to easily use Cheetah and Augeas within YaST.

For Cheetah, we have contributed two features to the upstream project:
[chroot support][5] and the ability to provide [environment
variables][6].

For Augeas we have developed an object oriented layer called [Config
Files Api][7] (shortly CFA). The idea of CFA is to provide specific
functionality by mean of plugins. Of course, the [first plugin][8] we
have developed is aimed to manipulation of all the Grub2 configuration
files.

The next step will be to integrate these new components into the next
versions of YaST2-Bootloader, hitting your Tumbleweed repositories soon.
Of course, after all the usual manual and openQA testing.

### Libstorage replacement

Another low level layer that has been a constant source of headache for
YaST developers is libstorage. We use it -specially in the installer and
the partitioner- to access disks, partitions, volumes and all that. Once
again, the original design have fundamental flaws that limit us in many
ways and we have been dreaming for quite some time about writing a
replacement for it.

To make this rewrite fit into the Scrum process, we are using the new
redesigned library (find the code [at Github][9] and the packages [at
OBS][10]) to write prototypes for the installer partitioning proposal
and for a new partitioning YaST module.

This new module is only intended as a testbed to showcase the
development of the new library and to drive its integration process.
It’s not intended for end users, but after this sprint it can already do
some things that are impossible with the current partitioner and even
shows some nice graphs really useful for debugging and verifying the
behavior of the library.

[![Libstorage Tech Preview: action
graph](../../../../images/2016-01-07/action-graph-300x219.png)](../../../../images/2016-01-07/action-graph.png)

If you don’t mind to break your system using unsupported software, you
can always fetch [the code][11] or [the packages][12].

### AutoYaST integration tests

Testing is crucial in software development. And integration tests are a
must when you are developing an installer. During the last sprints, we
have been developing and improving our own solution for testing
AutoYaST-driven installations, consisting on a set of tests and a
framework to run them.

The goal for this sprint was to de-couple the tests and the framework.
Making it possible to reuse our tests in openQA. As a side effect, we
wanted to ease the installation and usage of our testing framework.

Both goals were achieved, now you can install AutoYaST Integration Tests
(not a very original name) following [the instructions][13] available in
the repository and there is already an openQA instance directly running
[the separately available tests][14].

[![aytests-help](../../../../images/2016-01-07/aytests-help-300x78.png)](../../../../images/2016-01-07/aytests-help.png)

### Snapper development documentation

Last but not least, as a side effect of the development (and the Scrum
principles), we have improved the Snapper’s development documentation.
Enjoy it at [the usual Snapper repository][15].

That’s all folks. Next sprint starts next week and will be three weeks
long, so expect more news during the first days of February.



[1]: {{ site.baseurl }}{% post_url 2015-12-15-let-s-blog-about-yast %}
[2]: https://en.opensuse.org/Portal:Hackweek
[3]: https://github.com/openSUSE/cheetah
[4]: http://augeas.net/
[5]: https://github.com/openSUSE/cheetah/pull/33
[6]: https://github.com/openSUSE/cheetah/pull/32
[7]: https://github.com/config-files-api/config_files_api
[8]: https://github.com/config-files-api/config_files_api_grub2
[9]: https://github.com/openSUSE/libstorage-bgl-eval
[10]: https://build.opensuse.org/package/show/home:aschnell:storage-redesign/libstorage
[11]: https://github.com/aschnell/yast-storage-ng
[12]: https://build.opensuse.org/package/show/home:aschnell:storage-redesign/yast2-storage-ng
[13]: https://github.com/yast/autoyast-integration-test
[14]: https://github.com/yast/aytests-tests
[15]: https://github.com/openSUSE/snapper
