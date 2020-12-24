---
layout: post
date: 2020-12-24 07:30:00 +00:00
title: Result of the Modernizing AutoYaST initiative
description: Let's have a look at the changes that 2020 brought to AutoYaST
permalink: blog/2020-12-24/modernizing-autoyast-result
tags:
- Programming
- Systems Management
- YaST
---

In April, we announced the [Modernizing AutoYaST initiative](/blog/2020-04-30/modernizing-autoyast).
The idea was not to rewrite AutoYaST but just introduce a few new features, remove some limitations
and improve the code quality.

Although they were not set in stone, we had some ideas about what changes we wanted to introduce.
However, as soon as we started to work, it became clear that we needed to adapt our roadmap. So if
you compare our initial announcement with the result, you can spot many differences.

This article describes the most relevant changes. If you want to try any of these features, they are
already available in openSUSE Tumbleweed.

## Reducing profiles size

When AutoYaST generates a profile from an existing system, it includes a lot of information to
reproduce the installation. As a consequence, those profiles are rather long, which makes working
with them quite annoying.

However, it is not always clear when it is safe to omit some information from the profile without
compromising the final result. To address this problem, we decided to introduce the concept of
*target*. Thus, when generating a profile, you can ask AutoYaST to generate a more compact profile.

```
# yast2 clone_system modules target=compact filename=autoinst-compact.xml
```

In my current machine, the size of the profile is reduced from 2201 lines to just 834. But which
information is omitted? Let's enumerate a few items:

- System users and groups.
- Not modified firewall zones.
- System services which preset has not been changed.
- Printer settings if the `cups` service is disabled.

Note that not all YaST modules implement support for this flag. Actually, in some cases, it does not make any
sense.

## Making easier to write dynamic profiles

When dealing with the installation of multiple systems, it might be useful to use a single profile
that adapts to the system being installed at runtime. AutoYaST already offered two mechanisms to
implement this behavior: [rules and
classes](https://doc.opensuse.org/documentation/leap/autoyast/html/book-autoyast/rulesandclass.html)
and [pre-install
scripts](https://doc.opensuse.org/documentation/leap/autoyast/html/book-autoyast/cha-configuration-installation-options.html#pre-install-scripts).

However, we though that it might be easier if you could embed Ruby (ERB) code in your profiles. The
idea is to provide a set of helper functions that you can use to inspect the system and adjust the
profile by setting values, adding or skipping sections, etc. It sounds cool, right? Let's see a
simple example.

The code below finds the largest disk by sorting them size and sets the value of the `device`
element.

```xml
<partitioning t="list">
  <drive>
    <% disk = disks.sort_by { |d| d[:size] }.last %> <!-- find the largest disk -->
    <device><%= disk[:device] %></device> <!-- print the disk device name -->
    <initialize t="boolean">true</initialize>
    <use>all</use>
  </drive>
</partitioning>
```

Of course, apart from a set of helpers (`disks`, `network_cards`, `os_release` or `hardware`), you
have the power of Ruby in your fingertips. What about retrieving a whole section from a remote
location? At some extent, it could replace the classes and rules feature.

```erb
<bootloader>
  <% require "open-uri" %>
  <%= URI.open("http://192.168.1.1/profiles/bootloader-common.xml").read %>
</bootloader>
```

Unfortunately, the documentation of this feature is still [a work in
progress](https://github.com/SUSE/doc-sle/pull/658). However, we expect to have it ready in the
upcoming weeks.

## Improved scripting support

Apart from introducing support for ERB, as described in the previous section, we improved script
handling. Until now, Shell, Perl and Python were the only supported scripting languages. We removed
this limitation and now you can use any interpreter available at installation time. Moreover, it is
possible to pass custom options to the interpreter.

```xml
<intepreter>/usr/bin/bash -x</interpreter>
```

Additionally, we fixed a few issues and extended the error handling to inform the user when the
script did not run successfully.


## Validating the profile

Building and tweaking your profile can be a time-consuming task. AutoYaST offers [XML-based
validation](https://doc.opensuse.org/documentation/leap/autoyast/html/book-autoyast/cha-autoyast-create-control-file.html#CreateProfile-Manual),
but the sort of errors you can detect is rather limited.

To make your life easier, we introduced these new features to leverage profile validation:

- Automatic profile validation at runtime.
- A new `check-profile` command to detect errors without running the installer.

When AutoYaST fetches the profile, it automatically performs the XML-based validation, reporting any
error found. It works even if you are using features like *Rules and classes* or *Dynamic profiles*.
However, it can be easily disabled by setting the `YAST_SKIP_XML_VALIDATION` parameter to `1` when
booting the installer.

Regarding the `check-profile`, it basically uses part of the code that runs during
AutoYaST initialization. It includes:

- Profile fetching (even from a remote location).
- XML-based validation.
- Support for dynamic profiles: rules and classes, ERB and pre-installation scripts (optional).
- Optionally, detection of problems during profile import.

Needlessly to say that you should run this command with caution. Bear in mind that ERB and
pre-installation scripts can run any arbitrary code. In fact, we are working with our security experts to
make this command safer. See [bsc#1177123](https://bugzilla.suse.com/show_bug.cgi?id=1177123) for
further details.

## Reducing the second stage

Unlike a normal installation, AutoYaST still uses two phases, which are known as *stages*. The first
stage is responsible for most of the installation tasks: partitioning, registration, software
installation, network configuration, etc. Depending on the content of the profile, the second
stage comes into play after the first reboot. It takes care of additional configuration processes,
like setting the firewall rules, enabling/disabling services, etc.

To reduce the need for a *second stage*, we moved the processing of several sections to the *first
stage*. At this point, these sections are processed during this stage: `bootloader`,
`configuration_management`, `files`, `firewall`, `host`, `kdump`, `keyboard`, `language`,
`networking`, `partitioning`, `runlevel`, `scripts` (except `post-scripts` and `init-scripts`, which
are processed during the *second stage*), `security`, `services-manager`, `software`, `ssh_import`,
`suse_register`, `timezone` and `users`. Thus if your profile does not contain any other section,
you can happily disable the *second stage*.

```xml
<general>
  <mode>
    <second_stage t="boolean">false</second_stage>
  </mode>
 </general>
```

## A better UI to define the partitioning section

The user interface offered by AutoYaST to define the partitioning section was confusing, buggy and
rather limited. Therefore we took the chance to, basically, rewrite the whole thing.

{% include blog_img.md alt="AutoYaST UI for the partitioning section"
src="autoyast-storage-ui-mini.png" full_img="autoyast-storage-ui.png" %}

It is still a work in progress, but it is already much better than the old one. For
instance, in addition to disks and LVM, it supports defining sections for RAID, bcache and
multi-device Btrfs file systems.

It should be noted that these changes are already available in openSUSE 15.2 and SUSE Linux
Enterprise 15 SP2, so you do not need to wait until 15.3 or SP3 to enjoy them.

## Conclusion

New features and bug fixes are the most visible changes. However, as part of this process, we
refactored a lot of code, improved code coverage, extended the documentation, etc. In general, we
feel that we improved AutoYaST quality in a sensible way. And we hope you have that impression too
in the future.
