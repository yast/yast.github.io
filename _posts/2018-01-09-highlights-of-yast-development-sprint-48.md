---
layout: post
date: 2018-01-09 09:55:23.000000000 +00:00
title: Highlights of YaST Development Sprint 48
description: The YaST team finished its 47th Sprint right before the Christmas break
  but, sadly, we had not published the corresponding report&#8230; until now. The
  last sprint of the year brought some interesting changes, like Chrony support for
  AutoYaST, better multi-products medium handling, etc. So let's recap those
  changes. 
category: SCRUM
tags:
- Software Management
- Systems Management
- Uncategorized
- YaST
---

### Chrony support in AutoYaST

As part of our effort to support [Chrony][1] as the default NTP service
for (open)SUSE, we have revamped how AutoYaST handles the configuration
of such a service. The first noticeable change is that we have
redesigned the schema which, instead of containing low level
configuration options, is now composed of a set of high level ones that
are applied on top of the default settings.

And here is how the new (and nicer) configuration looks like:

```xml    
<ntp-client>
  <ntp_policy>auto</ntp_policy>
  <ntp_servers config:type="list">
    <ntp_server>
      <iburst config:type="boolean">false</iburst>
      <address>cz.pool.ntp.org</address>
      <offline config:type="boolean">true</offline>
    </ntp_server>
  </ntp_servers>
  <ntp_sync>15</ntp_sync>
</ntp-client>
```

### Updating the Remote Administration Capabilities

During this sprint, the remote administration client has been deeply
modified. To begin with, as `xinetd` is being replaced by `systemd
sockets`, we have dropped that dependency (adjusting the code
accordingly).

Additionally the VNC handling have been improved too. Until now, YaST
offered the possibility to connect through a web browser using a Java
applet. Now YaST allows the user to enable/disable this feature (check
the screenshot below to see how it looks now). It is worth to mention
that Michal Srb has replaced the old viewer with [novnc][2], a
JavaScript based one. Thanks a lot for that, Michal!

{% include blog_img.md alt=""
src="yast2-remote-300x215.png" full_img="yast2-remote.png" %}

And last but not least, we have seized the occasion to do some code
cleaning, reimplementing some dialogs using [the Common Widget
Manipulation object oriented API][3].

### Modifying AutoYaST Profile During Installation

AutoYaST offers a cool feature that allows the profile to be modified
during the initial stages of the installation using an user script. So
you can run a script which adjusts the profile and AutoYaST will read it
again. If you are interested in such a feature, you could find more
information in the [official documentation][4].

On the other hand, in our [previous report][5], we mentioned that
AutoYaST was able again to use multipath devices using the new storage
stack. But we didn’t count that it was possible to modify the profile on
runtime so the initialization happened too early.

Now the bug is fixed so you can again adjust any storage setting using
the aforementioned feature.

### Properly Handling Selected Modules

As you may know, some time ago we added a support for the multi-product
media (DVDs which contain more than one repository/product in separate
subdirectories). This time we fixed some issues regarding this
functionality.

Originally after selecting several products only one of them was
actually selected to install and only one product was displayed in the
installation proposal. Fortunately, those issues have been addressed
now.

{% include blog_img.md alt=""
src="yast2-multi-product-medium-300x225.png" full_img="yast2-multi-product-medium.png" %}

#### Unified Look &amp; Feel for Multi-Product Selection Dialog

For the multi-product DVD media we used this selection dialog:

{% include blog_img.md alt=""
src="yast2-multi-product-selection-old-300x225.png" full_img="yast2-multi-product-selection-old.png" %}

The functionality is very similar to the on-line product selection
dialog displayed after registering the system:

{% include blog_img.md alt=""
src="yast2-registration-add-on-selection-300x225.png"
full_img="yast2-registration-add-on-selection.png" %}

As you can see the look &amp; feel is quite different, but from the
usability point of view the dialogs should look the same regardless
whether the products are added from a DVD medium or from an on-line
source (a registration server).

This sprint we improved the DVD media dialog to better match the
registration dialog:

{% include blog_img.md alt=""
src="yast2-multi-product-selection-new-300x225.png"
full_img="yast2-multi-product-selection-new.png" %}

The dialog is still not exactly the same, but now it looks more similar
so users should feel more familiar with it. There is also displayed an
additional note about not handling the product dependencies
automatically. This note was already present in the help text but that
is hidden by default. As we got quite a lot of bug reports about this
issue we decided to make this fact more prominent.

(Note: The dialogs actually cannot look the very same as the DVD media
currently lack some information like the dependencies, beta status,
detailed descriptions…).

### Dropping SYSTEMCTL\_OPTIONS Variable Support

We have been using the environment variable called `SYSTEMCTL_OPTIONS`
(which is SUSE-specific) in our systemd services to prevent locks in
dependencies. As this hack will not be necessary for upcoming the
(open)SUSE 15 version, it will be dropped from systemd and, therefore,
we already removed it from our systemd services.

### Unifying Disklabel Handling in AutoYaST

When specifying an AutoYaST partitioning schema, you can select which
partition type you want to use for each device (MSDOS, GPT, DASD, etc.).
In the past, AutoYaST implemented its own logic to select which one to
use in case that it was not specified by the user. After this sprint,
AutoYaST relies on the new storage stack in order to decide which option
fits better when the user does not specify one.

### Bonus: Automatically Checking the Defined Systemd States

Some time ago we had serious issues with service management in YaST (see
[bug#1012047][6] and [bug#1017166][7]). The problem was caused by
introducing a new systemd service state which was not expected by YaST.
We fixed the problem by correctly handling the new state.

But the main problem was that we (as the YaST developers) were not
notified about this major system change and we found this change later
after we got bug reports in Bugzilla. To avoid this problem again in the
future we decided to implement a script which would regularly check the
defined systemd states notifying us if a unknown state was detected.

To implement the regular check we use the [Travis cron job feature][8]
which allows running continuous integration builds not only after a
change is pushed into the repository but also in regular intervals, even
when there is no change in the code.

Alternatively you can use any CI service, but we chose Travis because it
is easy to use and we already use Docker for normal CI jobs which allows
us to run the latest systemd from openSUSE Tumbleweed in an easy way.

In this case we could possibly run the script in OBS when building the
`yast2-services-manager` package, but that would need adding systemd to
`BuildRequires` which does not sound as a good idea…

So if you also need to run some check scripts regularly you can see more
details in [this pull request][9].

### Conclusion

2017 was an exciting year with a lot of interesting stuff: a new storage
layer, multi-product installation medium, integration of new components
(firewalld, chrony, etc.). And it looks like 2018 will not be different
and we will have a lot of fun.

Thanks for your support and happy new year!



[1]: https://chrony.tuxfamily.org/
[2]: https://github.com/novnc/noVNC
[3]: https://github.com/yast/yast-yast2/tree/master/library/cwm/examples
[4]: https://www.suse.com/documentation/sles-12/singlehtml/book_autoyast/book_autoyast.html#pre-install.scripts
[5]: {{ site.baseurl }}{% post_url 2017-12-07-highlights-of-yast-development-sprint-47 %}
[6]: https://bugzilla.suse.com/show_bug.cgi?id=1012047
[7]: https://bugzilla.suse.com/show_bug.cgi?id=1017166
[8]: https://docs.travis-ci.com/user/cron-jobs/
[9]: https://github.com/yast/yast-services-manager/pull/135
