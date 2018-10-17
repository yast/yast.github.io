---
layout: post
date: 2018-08-29 08:53:18.000000000 +00:00
title: YaST Squad Sprint 61
description: We have to admit that lately we have not been exactly regular and reliable
  in delivering our blog posts. But with the vacation season coming to an end, we
  are determined to recover the good pace. Since the proof is in the pudding, here
  is our latest report, just one week after the previous one.
category: SCRUM
tags:
- Distribution
- Factory
- Miscellaneous
- Programming
- Systems Management
- YaST
---

### Improving the user experience in the Services Manager

And talking about [the previous report][1], we presented there several
improvements in the YaST Services Manager module, including the new
“Apply” and “Show Log” buttons. With the “Apply” button, all changes
performed over the services are applied without closing the Services
Manager, which allows you to continue using it and to inspect the logs
of a service without relaunching the Services Manager again. But this
new “Apply” button only makes sense when there is something to save, so
during this sprint we have improved the UI to disable the button when
nothing has been changed yet. In addition, now it is easier to know what
we have edited so far in the Services Manager. For every change over a
service, the new value is explicitly highlighted by using the special
mark `(*)`. For example, when you change the start mode of a service
from “On boot” to “On demand”, you will see “`(*) On Demand`” in the
corresponding column, see example.

{% include blog_img.md alt="Services"
src="services-mark-300x224.png" full_img="services-mark.png" %}

The list of services and the changes performed on them can be quite
long. So in addition to the new mark, now a confirmation popup is shown
up when using the “Apply” or “OK” button. This popup will present a
summary with all changes that will be applied, that is, what services
will be started or stopped, what services will change its start mode to
“on boot”, “on demand” or “manually”, and even which will be the new
default Systemd Target in case you have modified it. See an example in
the following screenshot.

{% include blog_img.md alt="New summary of changes in the Services Manager"
src="services-popup-300x224.png" full_img="services-popup.png" %}

These improvements will reach openSUSE Tumbleweed soon and will be
available in the upcoming versions of SLE (SLE-15-SP1) and openSUSE Leap
(15.1).

### Yast2 Systemd classes reorganized

Related to the changes in the Service Manager and in a more
developer-oriented note. Yast2 Systemd (the set of YaST components that
handle Systemd units under the hood) also has been completely
reorganized in a more Ruby compliant way. Moving from YCP-style modules
to a set of classes that behave like nice citizens of the Ruby ecosystem
in their own proper namespace.

### AutoYaST support for Xen virtual partitions

And to continue with refinements over the features introduced in the
previous sprint, we have also improved the support for the so-called Xen
virtual partitions that we presented in our previous post. As explained
there, the old storage stack used to represent the Xen devices like
`/dev/xvda1` as partitions of a non-existing `/dev/xvda` hard disk. In
the new stack, those devices are treated as they deserve, as independent
block devices on themselves with no made-up disks coming from nowhere.

But AutoYaST profiles from a SLE-12 or Leap 42.x still pretend there are
hard disks grouping the Xen virtual partitions. So in addition to the
fixes introduced in the Partitioner during the previous sprint, we also
had to teach the new storage stack how to handle fanciful AutoYaST
`<drive>` sections like this, used to describe groups of Xen devices
(`xvda1` and `xvda2` really exist in the system, `xvda` doesn’t).

```xml
<drive>
  <device>/dev/xvda</device>

  <partition>
    <partition_nr>1</partition_nr>
    ...information about /dev/xvda1...
  </partition>

  <partition>
    <partition_nr>2</partition_nr>
    ...information about /dev/xvda2...
  </partition>
</drive>
```

The fix will be released as an installer self-update patch so users
installing SLE-15 (with access to a self-update repository) can take
advantage of it. In the mid term we will have to come up with a more
realistic format to represent such devices in the AutoYaST profiles, but
so far the limitations of the current AutoYaST format enforces us to
keep the current approach.

### Ignoring inactive RAID arrays

But that’s not the only new skill of Storage-ng for this sprint. It also
learned how to better manage inactive RAID arrays. MD RAID arrays are
built to handle failures of the underlying physical devices. When some
of the devices fail, the RAID becomes “degraded” which means the data is
still accessible but it’s time to fix things. When too many devices
suffer a fault, the RAID becomes inactive and it cannot operate any
longer until it’s repaired. Our Partitioner was not handling this
situation well, popping up a generic “unexpected situation” error
message.

{% include blog_img.md alt="Generic error message in Storage-ng"
src="unexpected-error.png" full_img="unexpected-error.png" %}

We have fixed that, and the storage stack doesn’t go nuts any longer if
an inactive RAID array is found. Even more, it now shows an “Active:
Yes/No” field under the RAID heading to inform the user in case the RAID
is in such bad shape.

{% include blog_img.md alt="Partitioner displaying an inactive RAID array"
src="inactive-raid-300x225.png" full_img="inactive-raid.png" %}

All that will be soon available as a maintenance update for SLE-15 and
Leap 15.0. So far, no mechanisms have been introduced to stop the user
from modifying an inactive RAID array with the Partitioner. That will
come in the future, together with other MD RAID improvements in
Storage-ng targeting future releases of SLE and openSUSE Leap.

### Media support in the Installation Server module

It’s quite embarrassing but it turned out that the Installation Server
YaST module in SLE15 and openSUSE Leap 15.0 is not able to add the
SLE15/Leap15 installation media. The reason is that the new media use a
different repository format and the Installation Server module crashed
when trying to add a new repository.

Fortunately the fix was small and allows adding the new media correctly.
We plan to release a maintenance update for SLE15, openSUSE Leap 15.0
and SLE12-SP3. It turned out that the code in SLE11-SP4 is more robust
and does not crash so we do not need an update there.

### Improved help text for system roles

We recently got a bug report about how hard was to read the help text in
the installation screen explaining the system roles. So we took it as an
opportunity to try how flexible our help text system is. Adding some
richtext format made it look much better in graphical mode and also
surprisingly well text mode. Let’s see some screenshots from Leap 15.0,
although the fix applies to as well to openSUSE Tumbleweed and the SLE15
family.

This is how it looked before the fix.

{% include blog_img.md alt="The poorly formatted help of the System Roles screen"
src="roles-prefix-300x226.png" full_img="roles-prefix.png" %}

And that how it looks now, in both Qt and Ncurses, with the new format.

{% include blog_img.md alt="The properly formatted text of the System Roles screen"
src="roles-qt-300x225.png" full_img="roles-qt.png" %}

{% include blog_img.md alt="Proper format even in text mode"
src="roles-ncurses-300x224.png" full_img="roles-ncurses.png" %}

### Fixed PHP support in the YaST HTTP server module

The YaST HTTP server module allows enabling the PHP support in the
Apache web server configuration. However, as the module is not actively
developed it turned out that the PHP support was broken. YaST wanted to
install the `apache2-mod_php5` package which is not available in
openSUSE Leap 15.0 or SLE15, there is a newer `apache2-mod_php7`
package.

After checking the other required packages it turned out that a similar
problem exists for some other Apache modules. To avoid this issue in the
future again we have added an additional test which checks the
availability of all potentially installed packages. If there is a new
version or a package is dropped we should be notified earlier by
continuous integration instead of an user bug report later.

### Stay tuned

Of course, in addition to the mentioned highlights we have fixed several
small and medium bugs. And we plan to continue improving YaST in many
ways… and to keep you punctually updated. So don’t go too far away.



[1]: {{ site.baseurl }}{% post_url 2018-08-22-yast-squad-sprint-59-60 %}
