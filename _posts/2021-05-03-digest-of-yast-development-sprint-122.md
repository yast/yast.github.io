---
layout: post
date: 2021-05-03 06:00:00 +00:00
title: Digest of YaST Development Sprint 122
description: With the view in the mid term, we are investing our time in reorganizing some of the
  YaST internals.
permalink: blog/2021-05-03/sprint-122
tags:
- Distribution
- Factory
- Programming
- Systems Management
- YaST
---

If something is not broken, do not fix it. Following that principle, the YaST Team spent almost no
time on the latest sprint working on SUSE Linux Enterprise 15 SP3 or openSUSE Leap 15.3. But that
doesn't mean we remained idle. Quite the opposite, we invested our time reorganizing some of the
YaST internals. An effort that hopefully will pay off in the mid term and that affects topics like:

- Management of local users, specially during installation.
- Unification of the code for configuring the network.
- Error handling and reporting.
- Reorganization of our UI toolkit.

So let's take a closer look to all that.

In our previous blog post we already announced we were considering to refactor the YaST Users
modules to improve the management of local users and to reduce the risk associated to the current
complexity of the module. We can now say we are making good progress in that front. We are working
on a separate branch of the development repository that is not submitted to Tumbleweed or any other
available distribution, which means we still have nothing concrete our users can test. But we hope
to have the creation of users during installation completely rewritten by the end of next sprint,
while still remaining compatible with all other YaST components that rely on user management.

Another milestone we reached on the latest sprint regarding YaST internal organization was the
removal of the legacy network component known as `LanItems`. Everything started with the report of
[bug#1180085](https://bugzilla.suse.com/show_bug.cgi?id=1180085) that was produced because the
installer, which uses the new `Y2Network` (a.k.a. network-ng) infrastructure for most tasks, was
still relying on that legacy component for proposing the installation of the `wpa_supplicant`
package. So we took the opportunity to seek and destroy all usage of the old component all along
YaST, replacing the calls to it with the equivalent ones in the new infrastructure. Less code to
maintain in parallel, less room for bugs.

That was not the only occasion during this sprint in which we turned a bug into an opportunity to
improve YaST internals. It was also reported that using an invalid value for the `bootmode` or
`startmode` fields of a network configuration file could produce a crash in YaST. In addition to
fixing that problem, we took the opportunity to [introduce a whole new general
mechanism](https://github.com/yast/yast-yast2/pull/1156) to handle errors in YaST and report them to
the user in a structured and centralized way. Apart from the YaST Network module, that new internal
infrastructure will be adopted by several parts of YaST during subsequent sprints. In fact, it's
already being used in the rewritten management of local users mentioned at the beginning of this
post.

Last but not least, we would like to mention that we keep working to improve the new unified
[repository of LibYUI](https://github.com/libyui/). Apart from revamping the README file that serves
as landing page, we created new scripts for a more pleasant and flexible building process, we
are improving the compatibility with the Gtk backend and with libyui-mga (the extra components
developed and maintained by Mageia) and we published the [API
documentation](https://libyui.github.io/libyui/api-doc/index.html) in a central location that is now
automatically updated on every change of the repository.

Of course, during the process of implementing all the mentioned improvements, we fixed several other
bugs for SLE-15-SP3 and openSUSE Leap 15.3 and also for older releases and Tumbleweed. But, who
wants to write about boring bug fixes? We prefer to go back to work and prepare more exciting news
for our next report in two weeks from now. See you then!
