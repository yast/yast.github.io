---
layout: post
date: 2016-06-07 10:15:48.000000000 +00:00
title: Highlights of YaST development sprint 20
description: The latest Scrum sprint of the YaST team was shorter than the average
  three weeks and also a little bit &#8220;under-powered&#8221; with more people on
  vacation or sick leave than usual. The bright side of shorter sprints is that you
  don&#8217;t have to wait three full weeks to get an update on the status.
category: SCRUM
tags:
- Distribution
- Factory
- Programming
- Systems Management
- YaST
---

The latest Scrum sprint of the YaST team was shorter than the average
three weeks and also a little bit “under-powered” with more people on
vacation or sick leave than usual. The bright side of shorter sprints is
that you don’t have to wait three full weeks to get an update on the
status. Here you have it!

### Debugger in the installer

Until now debugging the YaST installation was usually done by checking
the logs. If you needed more details you would add more log calls. This
is inconvenient and takes too much time but, as every Ruby developer
know, there is a better way.

Being a fully interpreted and highly introspective language, Ruby offers
the possibility of simply intercept the execution of the program and
open a interpreter in which is not only possible to inspect the status
of the execution, but to take full control of it.

From now on, you can access those unbeatable debugging capabilities
during the installation. All you have to do is boot the installer with
`Y2DEBUGGER=1`.

[![Debugger during
installation](../../../../images/2016-06-07/debugger_session-300x225.png)](../../../../images/2016-06-07/debugger_session.png)

Moreover the same mechanism is also available when running YaST in a
installed system. Just make sure the rubygem-byebug package is installed
and start the YaST module like this:

`Y2DEBUGGER=1 yast2 <client>`

For more details see the [brand new documentation][1]. You can also see
several examples and screenshots of the debugger running in text mode,
through the network and in other scenarios in the description of [the
corresponding pull request][2].

### Interface improvements for SSH host keys importing

Most software enthusiasts and developers, specially free software
lovers, will know the mantra “*release early, release often*“. The
earlier you allow your users and contributors to put their eyes and
hands on your software, the better feedback you will get in return. And
that proved to be true one more time with YaST and the awesome openSUSE
community.

In the [previous post][3] we introduced a new functionality being added
to YaST2 – more explicit and interactive importing of SSH host keys.
Some users quickly spotted some usability problems, right in time for
the fixes to be planned for this sprint.

In the description of [this pull request][4] you can see several
screenshots of the new interface in several situations, with the new
main dialog looking like this.

[![New dialog for SSH keys
importing](../../../../images/2016-06-07/sshimport2-300x225.png)](../../../../images/2016-06-07/sshimport2.png)

Iterative development rocks when you have involved users. Keep the
constructive criticism!

### AutoYaST support for SSH host keys importing

The user interface was not the only aspect of SSH host keys importing
that got improved. For every feature we add to the interactive
installer, we always take care of making it accessible from AutoYaST as
well. Thus, an AutoYaST profile file can now contain a section like this
to control the behavior of the new functionality.  

```xml
<ssh_import>
  <import config:type="boolean">true</import>
  <copy_config config:type="boolean">true</copy_config>
  <device>/dev/sda2</device>
</ssh_import>
```

### Firewalld support in YaST2-Firewall

Another success story about collaboration in the YaST world. In the
[report about sprint 18][5] we mentioned we had received some
contributions in order to add Firewalld support to YaST2-Firewall and
that we were collaborating with the authors of those patches to get the
whole thing merged in Tumbleweed. After a couple of sprints allocating
some time to keep that ball rolling, we can happily announce that
YaST2-Firewall in Tumbleweed already supports the “classic”
SUSEFirewall2 backend and the brand new Firewalld one!

### Support for vncmanager 3

SUSE’s VNC guru Michal Srb has been working lately in improving the
ability to share and reconnect to VNC sessions. Until now, YaST always
created a new separate VNC session for every client and closed the
session when the client disconnected. There was no simple way to share
the session with additional clients or to keep it running after
disconnecting.

Now, thanks to Michal, the remote module can be set up in three
different VNC modes: disabled, xinetd and vncmanager. Check the
definition of each mode in the description [of the pull request][6].

### New registration UI

[Six sprints ago][7], the “Local User” screen got [some love][8] and the
UI was greatly improved. During this sprint, and according to [bug
#974626][9], we have improved the registration UI to make it consistent
with the “Local User” screen.

The old interface, displayed below, was pretty confusing. Although it
was not obvious at first sight, it offered three options:

1.  Register the system using scc.suse.com by introducing an e-mail and
    a registration code.
2.  Register the system using a local SMT server (no e-mail or
    registration code are used).
3.  Skip the registration step.

[![Old registration
UI](../../../../images/2016-06-07/reg-old-300x225.png)](../../../../images/2016-06-07/reg-old.png)

Options 1 and 2 are mutually exclusive but, if you look at the
interface, that fact is not clear. Moreover, we wanted this dialog to be
consistent with the new “Local User” one.

The new dialog looks like this, with the three mutually exclusive
options being directly presented to the user.

[![New Registration
UI](../../../../images/2016-06-07/reg-new-300x225.png)](../../../../images/2016-06-07/reg-new.png)

As always, redesigning a UI in YaST implies making sure it works nicely
in the NCurses interface with screens with a resolution of 80 columns
and 25 lines of text. Doesn’t it look nice (provided the reader has a
geeky aesthetic sense)?

![Text-based Registration
UI](../../../../images/2016-06-07/reg-curses.png)

### Progress in the new storage layer

As usual, progress goes steady in the rewrite of the storage layer. In
this sprint we invested some time into the partitioning proposal, which
is now able to propose a good layout in some very complex scenarios with
highly fragmented disks with limited partition schemas.

In addition, preliminary support for LVM was added although is still far
from being complete and full-featured.

### Will be back… very soon

We always finish our reports saying something like “this was just a
sample of all the work done, stay tuned for another report in three
weeks”. But the weeks ahead will be a little bit unusual. This week a
SUSE internal workshop is taking place. That means that many YaST
developers are focusing on stuff different from their daily duty. In
addition, [openSUSE Conference’16][10] and [Hackweek 14][11] are both
round the corner. As a result of all those “distractions”, next sprint
will be shorter than usual (just one week) and will not start
immediately. Expect next report at some point close to the start of
openSUSE Conference. By the way… see you there!



[1]: http://yastgithubio.readthedocs.io/en/latest/debugging/
[2]: https://github.com/yast/yast-installation/pull/379
[3]: {{ site.baseurl }}{% post_url 2016-05-18-highlights-of-yast-development-sprint-19 %}
[4]: https://github.com/yast/yast-installation/pull/382
[5]: {{ site.baseurl }}{% post_url 2016-05-02-highlights-of-yast-development-sprint-18 %}
[6]: https://github.com/yast/yast-network/pull/401
[7]: {{ site.baseurl }}{% post_url 2016-02-03-highlights-of-development-sprint-14 %}
[8]: https://github.com/yast/yast-users/pull/84
[9]: https://bugzilla.suse.com/show_bug.cgi?id=974626
[10]: https://events.opensuse.org/conference/oSC16
[11]: https://hackweek.suse.com
