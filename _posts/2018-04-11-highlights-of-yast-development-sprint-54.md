---
layout: post
date: 2018-04-11 12:25:41.000000000 +00:00
title: Highlights of YaST Development Sprint 54
description: We were in the middle of <strike>rewriting</strike>,
  <strike>refactoring</strike> recompiling all of YaST into Visual Basic when we
  found that it was April 2nd already and had to scratch the entire project.
  Next year for sure.
category: SCRUM
tags:
- Factory
- Systems Management
- YaST
---

We were in the middle of <strike>rewriting</strike>, <strike>refactoring</strike>
recompiling all of YaST into Visual Basic when we
found that it was April 2nd already and had to scratch the entire project. Next
year for sure. So you are left with a report of enterprise grade stabilization
and we hope that your servers will be very bored running our software.

## Installation and Upgrade   {#installation-and-upgrade}

### Clearer Description of Migration Targets   {#clearer-description-of-migration-targets}

Life goes through various roads and it is same for SLE life. SLE15 is
now split into multiple modules and during the upgrade it can be quite
complex to pick the desired upgrade target. We have to react to this
issue as customers start complaining that the upgrade overview starts to
be hard to understand and we should improve it. So we did it and now you
can check the changes on the attached screenshots. We modified the
overview label from listing all products to just a summary with the
details displayed below as it was before. Be aware that in the future
and for some products or extensions/modules more migration targets will
be possible.

Old screenshot:
{% include blog_img.md alt=""
src="s54-1-300x225.png" full_img="s54-1.png" %}

and the new one (for a slightly different system, so it is not an exact
match for the previous screenshot):
{% include blog_img.md alt=""
src="s54-2-300x220.png" full_img="s54-2.png" %}

### Importing the SMT Server SSL Certificate at Upgrade   {#importing-the-smt-server-ssl-certificate-at-upgrade}

We are still improving and fixing bugs in the migration from the SLE11
or SLE12 products to the new SLE15 line. One issue we fixed this sprint
was importing the SSL server certificate from the old system at upgrade.

For registration you can use a local SMT server ([Subscription
Management Tool][1]) instead of the usual SCC server ([SUSE Customer
Center][2]).

The SMT servers usually use a self-signed SSL certificate to save some
money for buying a real certificate signed by a well-known certificate
authority. This self-signed certificate is imported to the system by
YaST during the initial registration so the registration process and the
repositories from the server can be properly accessed.

But during the offline upgrade to SLE15 the old system is not running,
the installer runs from the installation medium. In that case we need to
import the SSL certificate from the old system to the installer so it
can properly access the registration server and do the upgrade.

The certificate import is quite easy, we just need to be careful as
SLE11 uses a different (old) path for storing the imported certificates
than in SLE12 or SLE15.

As the result you should be now able not only to upgrade the systems
registered against the SCC server but also the systems registered
against your local SMT server.

### Many System Roles   {#many-system-roles}

Various products that we’re able to install have grown so many groups of
presets, called System Roles, that they no longer fit on the screen. We
applied some dark gray magic to make them fit in a scrollable box, at
the expense of losing the keyboard shortcuts, sorry.

{% include blog_img.md alt=""
src="s54-6-300x189.png" full_img="s54-6.png" %}

## Storage   {#storage}

### Better Message for Multipath (and other) Problems   {#better-message-for-multipath-and-other-problems}

While scanning the storage hardware, or at a later stage while
manipulating it, there is always a chance of finding problems in the
system that make it very hard to continue with the installation or the
execution of YaST. In that case, previous versions of storage-ng used to
show you a pop-up message with some technical details about what went
wrong (for example, the command that failed and its output) and with
options to abort YaST or continue despite the error.

But we found that for some situations we could do better in trying to
understand what went wrong and explain it to you, instead of directly
showing those raw technical details. One clear example is finding the
same LVM physical volume twice, something that should never happen.
Apart from double vision problems (libstorage-ng doesn’t drink alcohol),
the most likely cause is that a [multipath system][3] is not being
correctly detected and thus every one of the connections to the disk is
being detected as a different disk, duplicating the content in the eyes
of YaST.

Now such a circumstance is detected and explained to you, advising to
use `LIBSTORAGE_MULTIPATH_AUTOSTART` (see [linuxrc documentation][4]) or
the corresponding entry in the AutoYaST profile if it has not been used.
By the way, during this sprint we also instructed storage-ng about
`LIBSTORAGE_MULTIPATH_AUTOSTART`, since it used to ignore that ancient
libstorage modifier.

{% include blog_img.md alt=""
src="s54-3-300x219.png" full_img="s54-3.png" %}

The technical details are still available under the \"Details\" button,
as you can see below. They are simply not displayed at first sight,
which should make the whole experience less daunting for
less-experienced users. That change applies to all the severe errors
found during the three critical phases of storage-ng: hardware
activation, system probing, and commit (when the partitions and other
devices are created).

{% include blog_img.md alt=""
src="s54-4-300x217.png" full_img="s54-4.png" %}

Of course, the new pop-up messages have full support for AutoYaST. The
most appropriate default option (continue or abort) is automatically
selected depending on which one of the mentioned phases is being
executed and, if AutoYaST is configured to display pop-ups, the usual
countdown is displayed before doing such selection. See below the new
generic error (for a different, unidentified problem) in action in
AutoYaST.

{% include blog_img.md alt=""
src="s54-5-300x228.png" full_img="s54-5.png" %}

### AutoYaST is now Able to Reuse Encrypted Devices   {#autoyast-is-now-able-to-reuse-encrypted-devices}

As you may know, AutoYaST is quite flexible when it comes to
partitioning, so we are still writing the final bits of the adaptation
with the new storage layer. And this time, we were working on teaching
AutoYaST how to reuse encrypted devices properly.

However, the implementation was not that straightforward, as the
hardware probing occurs even before the partitioning section of the
profile has been analyzed. And, in some scenarios, it is not clear which
key should be used to unlock a device (for instance, this can happen
when more than one encryption key is defined). To solve this problem,
AutoYaST will try all defined keys on all encrypted devices until a
working key is found.

Of course, this behavior is properly documented now in the AutoYaST
handbook.

## Miscellaneous   {#miscellaneous}

### Fixed AutoYaST profiles validation issues {#fixed-autoyast-profiles-validation-issues}

In our previous [blog entry][5] we already mentioned that there are
significant changes between SLE12 and SLE15 profiles which have been
documented in this [appendix][6].

It is very common to adapt the profiles by hand which is error-prone and
sometimes it is also hard to identify where the errors are just running
an installation and looking deeply into the logs. That is why profiles
validation using `xmllint` or `jing` is recommended (more info
[here][7]).

During this sprint we have fixed some errors with the cloned profiles
after installation which were not validating.

### Translation Issues   {#translation-issues}

We are receiving quite a lot of bugs regarding the translations. The
usual problem is that some text is not translated at all and the
original English text is displayed. This sprint we fixed several issues
in this area, two of them are worth sharing in the blog.

#### The XSL File Format   {#the-xsl-file-format}

The first problem was reported for missing translations in the role
descriptions in the SLES4SAP product. The SLES4SAP installation
basically behaves like the standard SLES installation just with changed
few defaults. To avoid the duplication and make the SLES4SAP maintenance
easier we simply take the original SLES XML control file, which
describes the installer behavior and the defaults, and change just few
values using a [XSL transformation][8] into the resulting SLES4SAP
installer control file.

It turned out that the roles with missing translations were located in
that XSL file. And unfortunately YaST did not support extracting the
translatable strings from XSL files. However, we support translations in
XML files and because a XSL file is actually a valid XML file we could
easily extend the translation support in YaST to also cover the XSL
files. So now the SLES4SAP roles are correctly translated.

#### Missing `textdomain` Call   {#missing-textdomain-call}

We fixed several bugs with missing translations which were caused by
missing `textdomain` call in the code. This call defines which POT file
should be loaded and searched for the translations. If the YaST code
does not use this call then obviously no text can be translated as YaST
does not know which POT file should be used and it *silently* used the
original untranslated text.

That means it was quite difficult to find why some text was not
translated. And because that was quite common bug we had a nice idea to
improve the situation by logging a warning into the YaST log with the
exact message which could not be translated. And more importantly the
log now also contains the location of the code which was trying to use
the translation wrongly. See the [pull request][9] for more details.

With the openQA team we discussed also the possibility to add a new
check to openQA which would scan the YaST log for this particular
warning and report a problem. Which means we should not overlook this
quite important warning in the future.



[1]: https://www.suse.com/products/subscription-management-tool/
[2]: https://scc.suse.com
[3]: https://en.wikipedia.org/wiki/Multipath_I/O
[4]: https://en.opensuse.org/SDB:Linuxrc#Special_parameters_not_handled_by_Linuxrc_itself
[5]: {{ site.baseurl }}{% post_url 2018-03-23-highlights-of-yast-development-sprint-53 %}
[6]: https://susedoc.github.io/doc-sle/develop/SLES-autoyast/html/appendix.ay_12vs15.html
[7]: https://susedoc.github.io/doc-sle/develop/SLES-autoyast/html/Profile.html
[8]: https://en.wikipedia.org/wiki/XSLT
[9]: https://github.com/yast/yast-ruby-bindings/pull/214
