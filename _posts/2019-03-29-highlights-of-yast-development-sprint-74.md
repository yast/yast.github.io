---
layout: post
date: 2019-03-29 14:50:11.000000000 +00:00
title: Highlights of YaST Development Sprint 74
description: It took only 73 sprints to complete all YaST features, and there are
  none left to do. That&#8217;s what you might think after reading this article, because
  we worked on no features, just bug fixes.
category: SCRUM
tags:
- Systems Management
- YaST
---

<!--
Highlights of YaST Development Sprint 74
-->

It took only 73 sprints to complete all YaST features, and there are
none left to do. That’s what you might think after reading this article,
because we worked on *no features*, just bug fixes.

It might be related to an upcoming release of SLE 15 SP1. For its
openSUSE sibling we have put together [a recap of YaST features][1] in
the upcoming openSUSE Leap 15.1 ([scheduled for May 2019][2]), since
Leap 15.0 (May 2018).

### No more locale errors during Kubic runtime   {#no-more-locale-errors-during-kubic-runtime}

Did you know that an installed [Kubic][3] (*the certified Kubernetes
distribution &amp; container-related technologies built by the openSUSE
community*) only has the American English locale (en\_US) available?
That is because it intends to be as small as possible (you can run `du
-h /usr/share/locale` if you are curious enough).

However, YaST allows you to change the language and the keyboard layout
at the very beginning of the installation process, which will be
persisted as the default locale in the installed system. This is the
reason for those locale errors mentioned above. Until now. Because we
introduced some changes during this sprint to allow that the chosen
language will be used only during the installation in case the product
needs it.

So, from now on you can go through the installation of Kubic in your
preferred language without those errors in the final system and, of
course, **preserving the selected keyboard layout**. Not bad, huh?
:sunglasses:

### Various Fixes   {#various-fixes}

Repositories for add-ons would be marked as disabled after the
installation has finished. We have fixed this [bug#1127818][4].

When registering your [SUSE Linux Enterprise][5] with the [SUSE Customer
Center][6] or its proxy such as the [SUSE Subscription Management
Tool][7], a network timeout can occur. Formerly you had to use the Back
and Next buttons to try again but we have [added a Retry button][8] for
that.

When creating a new partition or editing an existing one, the widget for
the partition type would list the types in a seemingly random order. We
have [made][9] this widget more boring.



[1]: https://en.opensuse.org/Features_15.1#YaST
[2]: https://en.opensuse.org/openSUSE:Roadmap
[3]: https://kubic.opensuse.org/
[4]: https://bugzilla.suse.com/show_bug.cgi?id=1127818
[5]: https://www.suse.com/solutions/enterprise-linux/
[6]: https://scc.suse.com
[7]: https://www.suse.com/products/subscription-management-tool/
[8]: https://github.com/yast/yast-registration/pull/428
[9]: https://github.com/yast/yast-storage-ng/pull/872
