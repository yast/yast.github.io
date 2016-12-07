---
layout: post
date: 2016-10-07 08:25:36.000000000 +00:00
title: Improving low-vision accessibility of the installer
description: In our latest report, we promised you would not have to wait another
  three weeks to hear (or read) from us. And here we are again, but not with any of
  the anticipated topics, but with a call for help in a topic that could really
  make a difference.
category: Improvement
tags:
- Accessibility
- Distribution
- Systems Management
- Usability
- YaST
---

In our [latest report][1], we promised you would not have to wait
another three weeks to hear (or read) from us. And here we are again,
but not with any of the anticipated topics (build time reduction and
Euruko 2016), but with a call for help in a topic that could really make
a difference for (open)SUSE.

Nowadays, YaST team is trying to fix a long-standing issue in the
installer: [low-vision accessibility][2]. In the past, a user could get
a high-contrast mode just pressing shift+F4 during installation.
Unfortunately, that feature does not work anymore and, to be honest,
changing to a high-contrast palette is not enough. Other adjustments,
like setting better font sizes, should be taken into account.

Another option is to use the textmode installation and set some obscure
variable (`Y2NCURSES_COLOR_THEME`) to get the high-contrast mode. But it
sounds like the opposite to *user friendly*.

Some days ago, the team fired up the [discussion][3] in the
opensuse-factory mailing list but we would like to reach as many people
as we can to gather information and feedback about this topic. Getting
some affected people involved in the process would be really awesome!

For the time being we’re already working on some improvements:

* Adding a Linuxrc option so the user can set the high-contrast mode
  from the very beginning.
* Fixing [shift+F4 support][4].
* Improving the high-contrast mode appearance. Below you can see a
  screenshot of the work in progress.

[![First prototype of the new high contrast
mode](../../../../images/2016-10-07/lowvision-300x225.png)](../../../../images/2016-10-07/lowvision.png)

But we would like to hear from you. You can raise your voice in the
already mentioned [thread at the opensuse-factory mailing list][3] or
leave a comment in the related [pull request][5] at Github. If you
prefer to have a chat, we’re also available on [the #yast IRC
channel](irc://irc.opensuse.org/yast) at Freenode… and we love to see
people there. :wink:

Please, join us to make YaST even better!



[1]: {{ site.baseurl }}{% post_url 2016-09-28-highlights-of-yast-development-sprint-25 %}
[2]: https://bugzilla.suse.com/show_bug.cgi?id=780621
[3]: https://lists.opensuse.org/opensuse-factory/2016-09/msg00593.html
[4]: http://bugzilla.novell.com/show_bug.cgi?id=768112
[5]: https://github.com/libyui/libyui-qt/pull/60
