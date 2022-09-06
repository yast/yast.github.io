---
layout: post
date: 2022-09-06 06:00:00 +00:00
title: YaST Development Report - Chapter 8 of 2022
description: Another development report from the YaST Team covering YaST, Cockpit, ALP and
  everything in between
permalink: blog/2022-09-06/yast-report-2022-8
tags:
- Distribution
- Factory
- Programming
- Systems Management
- YaST
---

Time for another development report from the YaST Team including, as usual, much more than only
YaST. This time we will cover:

- The fix of an elusive YaST bug regarding the graphical interface
- Initial handling of transactional systems in YaST
- A general reflection about 1:1 management of transactional systems
- Some improvements in the metrics functionality of Cockpit

Let's take it bit by bit.

## Hunting YaST Rendering Issues Down {#rendering}

Over the last year or so, we got some reports about the graphical interface of YaST presenting
rendering issues, specially on HiDPI displays and on openQA. The reporters provided screenshots that
showed how some widgets were apparently drawn on top of the previous ones without an intermediate
cleanup, so the screen ended up displaying a mixture of old and new widgets that were very hard to
read.

We were unable to reproduce the problem and we tried to involve people from different areas (like
graphic drivers maintainers, virtualization experts or X11 developers) to track the problem down
with no luck... until now! We finally found where the bug was hiding and hunted it down.

See the [pull request](https://github.com/libyui/libyui/pull/81) that fixes the issue if you are
interested in a technical description including faulty HiDPI detection, unexpected Qt behavior and
QSS style sheets oddities. It also includes a screenshot of the described (and now fixed) problem.

## YaST on Transactional Systems {#transactional-yast}

And talking about YaST and known problems, you may remember from our [previous
post]({{site.baseurl}}/blog/2022-08-23/yast-report-2022-7) that we identified one very visible issue
with the on-demand installation of software when using YaST (containerized or not) in a transactional
system like the future ALP. Such systems prevent the installation of new packages during run-time, so
an extra reboot is always needed before using the new software.

We explored several options to make YaST work as smooth as possible in transactional systems, like
performing all the modifications, including packages installation and configuration changes, in a
single transaction with a final reboot at the end of the process. But we found it too risky since it
implies working on temporary system snapshots that are not a fully accurate representation of how
the managed system will look after the reboot.

Finally we implemented the solution that is shown in the screenshot below. For the time being, if
YaST detects it's running in a transactional system so it cannot install the missing packages and
continue, then it will simply ask the user to install the packages and reboot.

{% include blog_img.md alt="YaST requesting Bind to be installed" src="bind.png" %}

With that, YaST does not longer look broken on transactional systems (unsuccessfully trying to
install packages when it doesn't make sense) but the adopted solution is just a first approach that
we will likely improve in the future.

## Beyond YaST: On-Demand Installation on Transactional ALP {#transactional}

The described challenge with package management and transactional systems is not exclusive of
YaST. We actually have a similar problem with Cockpit and its metrics functionality. So we decided
we needed to gather some opinions to find the most adequate and consistent solution for ALP and
other transactional systems.

As starting point, we wrote [this
document](https://github.com/ancorgs/alp-system-management/blob/main/transactional.md) describing
the situation and presenting some open questions. The feedback gathered so far from members of the
ALP Steering Committee suggests we should improve YaST to go further into assisting the user in the
process of installing the packages and rebooting the transactional system. The same applies to
Cockpit, but that may be more problematic since it's not aligned with the current vision expressed
by the Cockpit developers in that regard.

We are always open to receive more comments and opinions. If you have any, you know how to reach
us. ;-)

## Better Cockpit Metrics on ALP {#metrics}

And talking about the metrics functionality of Cockpit, we also took the opportunity to polish its
behavior on ALP. And we did it by fixing nothing ourselves. :-) We just diagnosed the problems and
reported what was wrong [in the `pcp` package](https://bugzilla.suse.com/show_bug.cgi?id=1202896)
and [in Cockpit](https://github.com/cockpit-project/cockpit/issues/17693). Both issues are fixed
now by their corresponding maintainers and future ALP pre-releases will offer a more pleasant
Cockpit experience out-of-the-box.

## See You Soon {#conclusion}

We keep working on YaST, especially on the [installer security
policies]({{site.baseurl}}/blog/2022-08-23/yast-report-2022-7#policies) described on our previous
report, on improving the Cockpit and the YaST user experiences with ALP and on several other topics
we will report in the following weeks, as soon as we have tangible results to show.

Meanwhile we encourage you to get involved in openSUSE development and promotion and to stay tuned
for more news. Have a lot of fun!
