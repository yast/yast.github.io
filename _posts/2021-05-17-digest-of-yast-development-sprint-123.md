---
layout: post
date: 2021-05-17 06:00:00 +00:00
title: Digest of YaST Development Sprint 123
description: While polishing the final details in the upcoming 15.3 releases, the YaST team is also
  working in some interesting and varied topics.
permalink: blog/2021-05-17/sprint-123
tags:
- Distribution
- Factory
- Programming
- Systems Management
- YaST
---

Both openSUSE Leap 15.3 and SUSE Enterprise Linux 15 SP3 are already in the oven and almost ready to
be tasted. But although they smell delicious, the openSUSE volunteers and the great SUSE QA team
never give up in challenging our beloved distributions to find the corner cases that need more
polishing. Since we want to make sure each possible problem have a solution or a documented
workaround at the release date, the YaST Team invested quite some time during the last sprint
investigating and solving some problems related to AutoYaST, system migration, registration and other
tricky areas.

But we also found time to work on more blog-friendly topics like:

  - Improvements in the AutoYaST functionality to configure questions during the installation
  - Better handling of path names in Arabic and other right-to-left languages
  - Progress in the refactoring of YaST Users
  - Possibility of installing with neither NetworkManager or `wicked`

Let's dive into the details.

One of the many features offered by AutoYaST is the possibility of specifying a so-called `ask-list`,
which lets the user decide the values of some parts of the AutoYaST profile during the installation.
That allows to fine-tune the level of flexibility and interactivity, with a process that is highly
automated but still customizable on the fly. During this sprint we basically rewrote the whole
feature to make it more robust and powerful, while still being fully backwards-compatible. See more
details in [the corresponding pull request](https://github.com/yast/yast-autoinstallation/pull/754)
including technical details, before-and-after screenshots and a link to the official documentation
that explains how to use this reworked feature.

And talking about before-and-after screenshots, let's see if you can spot the differences in the
following image.

{% include blog_img.md alt="Arabic path names" src="arabic.png" full_img="arabic.png" %}

Exactly. In the upper part, the right-to-left orientation of the Arabic writing mangles the mount
points and the device names, moving the initial slash of paths like `/dev/vda` to the end. This is
just one of the many interesting software development problems you don't normally think about, but
that makes life as a YaST developer a constant learning experience. If you want to know more about
Unicode directional formatting characters and how we solved the problem, check [this pull
request](https://github.com/yast/yast-storage-ng/pull/873) at the yast2-storage-ng repository.

And talking about challenges and learning, sure you remember we are in the middle of a whole rewrite
of the YaST mechanisms to manage local users. We already have a new version of the installer that
works perfectly using the new code, including the creation of brand new users and also importing
them from a previous installation. We are now integrating that new code into AutoYaST and we will be
ready soon to discuss the best procedure and timing to introduce the revamped yast2-users into
openSUSE Tumbleweed in a way that it brings all the benefits of the rewrite to our users without any
disruptive change in the surface.

Last but not least, we would like to mention a new feature we already submitted to the Tumbleweed
installer in search for feedback from you, our beloved users. :wink: In a nutshell, it offers the
possibility to install the distribution without NetworkManager or `wicked`, for those users that
want to manually configure an alternative network manager (like `systemd-networkd`) or that simply
want a network-less operating system. Please check the [corresponding pull
request](https://github.com/yast/yast-network/pull/1215) and reach out to us to tell us what do you
think. Remember you can do that at the `yast-devel` and `factory` [mailing lists at
openSUSE](https://lists.opensuse.org/), at the `#yast` channel at Freenode IRC or directly
commenting on GitHub. 

While waiting for your input, we will keep working in polishing the upcoming releases and bringing
new features into Tumbleweed. Stay safe and have a lot of fun!
