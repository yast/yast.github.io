---
layout: post
date: 2022-01-18 15:15:00 +00:00
title: Announcing the D-Installer Project
description: Building a web-based installer on top of YaST
permalink: blog/2022-01-18/announcing-the-d-installer-project
tags:
- Project
- Programming
- Systems Management
- YaST
---

# Rethinking the Installer

As you may know, YaST is not only a control center for (open)SUSE Linux
distributions, but it is also the installer. And, in that regard, we think it
is a competent installer. However, time goes by, and YaST shows its age in a
few aspects.

During summer 2021, the team discussed how YaST should look in the near
future. We considered many ideas, but let's focus on these:

* Shortening the installation process.
* Decoupling the user interface from YaST internals.
* Adding a web-based interface. We had
  [WebYaST](https://webyast.github.io/webyast/) in the past, but it was not meant to work as installer.

We played around with these ideas (e.g., see
[$INSTALLER:80](https://github.com/imobachgs/installer-80) and
[making openSUSE installer shorter](https://gist.github.com/dgdavid/7ce871674d02032bf953dec77550f556)), but we
never had a concrete plan.

Fast-forward to December: before the holidays, we decided to resume our research
and build a proof of concept of a web-based installer. We
[created](https://github.com/yast/the-installer) something simple enough that,
to be honest, does not even work at all. But after discussing the overall
approach at a team meeting in January, we thought it might be a good idea to
invest more time into it.

However, before jumping into coding just "something", we want to take our time to
define the project in the right way, build a plan and ask for feedback.

## It is not just about the user interface

Providing an alternative web-based interface is just the tip of the iceberg.
Before doing that, we need to make many internal changes, like decoupling the
user interface code or adding a D-Bus interface.

Fortunately, we already have improved YaST internals in several vital areas
(storage, networking, etc.). However, we are not there yet: a lot of work
remains to be done.

The diagram below outlines the main components of the idea. Of course, it might
change as the project evolves, but it looks good as a starting point.

{% include blog_img.md alt="D-Installer Overview" src="d-installer-overview.png" %}

## Benefits

Following this approach, we can foresee many benefits for YaST. To
name a few:

* **A better user interface:** [libYUI](http://libyui.sourceforge.net/) has served
  us well. However, it imposes some limitations that we would love to overcome.
* **Reusability:** YaST contains a lot of helpful logic that would be available
  to other tools.
* **Better integration:** It should be easier to integrate pieces of YaST in your
  own workflows by providing a D-Bus interface.
* **Multi-language:** Eventually, using D-Bus might allow us to use other
  programming languages.
* **Contributors:** We expect more people to contribute to the project by
  making the code more accessible and using widely-known technologies.

## Q&A

We expect you have questions, right? So let's try to anticipate some of them.

### Are you deprecating the current user interface?

No. We just want to offer an alternative and somehow simplified interface.
Actually, we do not expect the web-based UI to be as powerful as the current one
in the short term.

### Which modules would get the new interface?

At this point, we are limiting to the installer. We do not plan to add a
web-based interface to any other module.

### What about AutoYaST?

Regarding AutoYaST, the idea is to use the same codebase as the standard
installation while keeping the backward compatibility. So you could reuse
your AutoYaST profiles with no significant issues.

### Are you moving from Ruby to another language?

No. We just thought that, in the future, it might be possible to reimplement
parts of YaST (or write new pieces) in a different language. But we do not plan
to replace Ruby in the short term.

### When will it be released?

We do not know yet.

### Isn't precisely that what Anaconda developers are doing?

Mostly yes. We were glad to read [their
announcement](https://communityblog.fedoraproject.org/anaconda-is-getting-a-new-suit/)
because it somehow validates our point of view about the future. But, of course,
[Anaconda](https://fedoraproject.org/wiki/Anaconda) is in a better position
(e.g., it already features a D-Bus interface).

### Would you rely on Cockpit?

We do not know yet, but... why not? Cockpit is a really nice project and we
have already [released a module](https://github.com/openSUSE/cockpit-wicked/)
for [Wicked](https://github.com/openSUSE/wicked). So perhaps we could seek some
collaboration.

### Why is called *D-Installer*?

Well, it is just a play on words. We named the repository as "yast/the-installer"
and, given that it is a service-based installer, it evolved to *d-installer*.
Of course, not even the name of the project is set in stone, so we are open to
better proposals. :wink:


## Conclusion

We are in the early stages of an exciting project that should take us to
redefine the future of YaST. And, of course, we would love to hear from you.
So, please, do not hesitate to [contact us](https://yast.opensuse.org/contact)
if you have any comments or questions.

Have a lot of fun!
