---
layout: post
date: 2019-07-29 13:00:43.000000000 +00:00
title: Highlights of YaST Development Sprint 81
description: This sprint we were focused mainly on fixing some keyboard,
  bootloader and AutoYaST bugs.
category: SCRUM
tags:
- Systems Management
- YaST
- bootloader
- console
- keyboard
- raid
- repository
- snapper
- upgrade
---

## Contents

This sprint we were focused mainly on fixing some keyboard, bootloader
and AutoYaST bugs.

* [Console Keyboard
  Layouts](#unifying-the-console-keyboard-layouts-for-sle-and-opensuse)
* [Better Handling of Broken Bootloader Setups during
  Upgrade](#better-handling-of-broken-bootloader-setups-during-upgrade)
* AutoYaST:
  * [Repositories not containing
    Products](#exporting-user-defined-repositories-to-autoyast-configuration-file)
  * [Snapper on RAID](#old-storage-new-features)

### Unifying the Console Keyboard Layouts for SLE and openSUSE

The way of managing internationalization in Linux systems has changed
through the years, as well as the technologies used to represent the
different alphabets and characters used in every language. YaST tries to
offer a centralized way of managing the system-wide settings in that
regard. An apparently simple action like changing the language in the
YaST interface implies many aspects like setting the font and the
keyboard map to be used in the text-based consoles, doing the same for
the graphical X11 environment and keeping those fonts and keyboard maps
in sync, ensuring the compatibility between all the pieces.

For that purpose, YaST maintains a list with all the correspondences
between keyboard layouts and its corresponding \"keymap\" files living
under `/usr/share/kbd/keymaps`. Some time ago the content of that list
diverged between openSUSE and SLE-based products. During this sprint we
took the opportunity to analyze the situation and try to unify criteria
in that regard.

We analyzed the status and origin of all the keymap files used in both
families of distributions (you can see a rather comprehensive research
starting in [comment #18 of bug#1124921][1]) and we came to the
conclusions that:

* The openSUSE list needed some minor adjustments.
* Leaving that aside, the keymaps used in openSUSE were in general a
  better option because they are more modern and aligned with current
  upstream development.

So we decided to unify all systems to adopt the openSUSE approach. That
will have basically no impact for our openSUSE users but may have some
implications for users installing the upcoming SLE-15-SP2. In any case,
we hope that change will be for the better in most cases. Time will
tell.

### Exporting User Defined Repositories to AutoYaST Configuration File

With the call `yast clone_system` an AutoYaST configuration file will be
generated which reflects the state of the running system. Up to now only
SUSE Add-Ons have been defined in the AutoYaST configration module. Now
also user defined repositories will be exported in an own subsection
`<add_on_others>` of the `<add-on>` section.

```xml
<add-on>
  <add_on_others config:type="list">
    <listentry>
      <alias>yast_head</alias>
      <media_url>https://download.opensuse.org/repositories/YaST:/Head/openSUSE_Leap_15.1/</media_url>
      <name>Yast head</name>
      <priority config:type="integer">99</priority>
      <product_dir>/</product_dir>
    </listentry>
  </add_on_others>
  <add_on_products config:type="list">
    <listentry>
      <media_url>dvd:/?devices=/dev/sr1</media_url>
      <product>sle-module-desktop-applications</product>
      <product_dir>/Module-Desktop-Applications</product_dir>
    </listentry>
    <listentry>
      <media_url>dvd:/?devices=/dev/sr1</media_url>
      <product>sle-module-basesystem</product>
      <product_dir>/Module-Basesystem</product_dir>
    </listentry>
  </add_on_products>
</add-on>
```

The format of the `<add_on_others>` section is the same as the
`<add_on_products>` section.

### Better Handling of Broken Bootloader Setups during Upgrade

With the current versions of SLE and openSUSE, using the installation
media to upgrade a system which contains a badly broken GRUB2
configuration (e.g. contains references to udev links that do not longer
exist) can result in an ugly internal error during the process.

The first possible problem could arise in the summary screen. Like shown
in this screenshot.

{% include blog_img.md alt=""
src="61807675-49bd7500-ae3a-11e9-97e6-4ec7d722425e-300x225.png"
full_img="61807675-49bd7500-ae3a-11e9-97e6-4ec7d722425e.png" %}

If the error didn’t pop-up or if the user managed to recover from it, it
was possible to reach the final phase of the upgrade process. But then
the same internal error could still pop up in a different place:

{% include blog_img.md alt=""
src="61807871-a6209480-ae3a-11e9-8e6c-38cfd322d7c0-300x225.png"
full_img="61807871-a6209480-ae3a-11e9-8e6c-38cfd322d7c0.png" %}

Those errors will be fixed in the upcoming releases of SLE-12-SP5 and
SLE-15-SP2 and, of course, in the corresponding openSUSE Leap version
and in Tumbleweed. Now if such a broken setup is detected in the summary
screen, a proper warning is displayed, including the technical details
and a tip on what to do to fix the problem.

{% include blog_img.md alt=""
src="61808101-129b9380-ae3b-11e9-966e-02061f99b758-300x225.png"
full_img="61808101-129b9380-ae3b-11e9-966e-02061f99b758.png" %}

The user can ignore the problem or click on \"booting\" to fix it. In
the latter case, the usual pop-up with instructions will appear.

{% include blog_img.md alt=""
src="61808202-3f4fab00-ae3b-11e9-8e88-85c2599e56a2-300x225.png"
full_img="61808202-3f4fab00-ae3b-11e9-8e88-85c2599e56a2.png" %}

If the final stage of the upgrade process is reached without fixing the
error, the wild internal error is now replaced by an informative message
that does not interrupt the process.

{% include blog_img.md alt=""
src="61808336-7aea7500-ae3b-11e9-96fc-a49dc9fbe507-300x225.png"
full_img="61808336-7aea7500-ae3b-11e9-96fc-a49dc9fbe507.png" %}

Hopefully most of our users will never see these improvements. But users
with a broken system will likely appreciate the extra guidance.

### Old Storage, New Features   {#old-storage-new-features}

If you are an usual reader of this blog, most likely you already know
that YaST has a completely re-implemented Storage stack (a.k.a.
storage-ng). That new storage code did its debut with the SLE 15 (and
openSUSE Leap 15.0) family. And thanks to this revamped code, our
beloved users can enjoy today some new great features in YaST like
Bcache, partitionable Software RAIDs or multi-device Btrfs file system
(just to mention a few examples). But SLE 12 (openSUSE 42) products are
still alive and getting improvements with every maintenance update! Of
course, the old Storage stack is not an exception, and now on a new
installation scenario is supported.

Thanks to a [bug report][2], we realized that [Snapper][3] could not be
configured in some cases. More specifically, the reporter was trying to
install with AutoYaST over a directly formatted Software RAID by using
Btrfs for root and enabling snapper. The installation was perfectly
performed, but it turned out that snapper was not correctly enabled in
the installed system. After having a deeper look into the problem, we
discovered that this was not a bug exactly but a completely missing
feature. But no problems, YaST got down to work and now it is nicely
supported.

{% include blog_img.md alt=""
src="62031334-03bc3480-b1df-11e9-9bce-f8f45b34ebd3-300x225.png"
full_img="62031334-03bc3480-b1df-11e9-9bce-f8f45b34ebd3.png" %}



[1]: https://bugzilla.suse.com/show_bug.cgi?id=1124921#c18
[2]: https://bugzilla.suse.com/show_bug.cgi?id=1135083
[3]: http://snapper.io/
