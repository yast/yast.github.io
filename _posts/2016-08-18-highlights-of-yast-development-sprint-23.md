---
layout: post
date: 2016-08-18
title: Highlights of YaST development sprint 23
description: As already mentioned in our previous blog post, with Leap 42.2 in
  Alpha phase and SLE12-SP2 in Beta phase, the YaST Team is concentrating the
  firepower in fixing bugs in the installer. We fixed more than 40 bugs in
  three weeks!
category: SCRUM
tags:
- Distribution
- Documentation
- Factory
- Programming
- Systems Management
- YaST
---

We fixed more than 40 bugs in three weeks! The dark side is that most bug fixes
are not juicy enough for writing a blog post… but there is always some
interesting stuff to report.

### Integration of installer self-update with SCC and SMT

The installer self-update feature integrates now with [SUSE Customer
Center (SCC)][1] and [Subscription Management Tool (SMT)][2] servers.
Until now, there were three different mechanisms to get the URL of the
installer updates repository:

* User defined (using the `SelfUpdate` boot option).
* Using an AutoYaST profile.
* The default one, specified in the `control.xml` which is shipped in
  the media.

Now YaST2 is able to ask for the repository URL to SCC/SMT servers. The
details of how the URL is determined are [documented in the
repository][3].

### Fixes and enhanced usability in dialogs with timeout

As you may know, it’s possible to install (open)SUSE in an automatic,
even completely unattended, basis using AutoYaST. AutoYaST can be
configured to display custom configuration dialogs to the user and wait
for the reply a certain amount of time before automatically selecting
the default options. Until now, the only way for the user to stop that
countdown was to start editing some of the fields in the dialog.

We got a bug report because that functionality was not working exactly
as expected in some cases so, in addition to fixing the problem, we
decided to revamp the user interface a little bit to improve usability.
Now there are more user interactions that are taken into account to stop
the counter, specially we added a new “stop” button displaying the
remaining seconds. You can see an example of the result below.

[![New layout for dialogs with
timeout](../../../../images/2016-08-18/06449188-55a9-11e6-9461-dfc352fff8d8-300x199.png)](../../../../images/2016-08-18/06449188-55a9-11e6-9461-dfc352fff8d8.png)

Following, as usual, the Boy Scout Rule we also took the opportunity to
add automated tests to make that part of YaST more robust for the
future.

### Automatically integrating add-on repositories during installation

Sometimes you want to extend the regular installation media by adding
just a few extra packages or provide a number of fixed packages along
with the media.

For this purpose, the installer can automatically register an add-on
repository. All you have to do is to put the repository on the
installation medium and to add a file `/add_on_products.xml` that points
to this repository.

The file looks like this:

```xml
<?xml version="1.0"?>
<add_on_products xmlns="http://www.suse.com/1.0/yast2ns"
    xmlns:config="http://www.suse.com/1.0/configns">
    <product_items config:type="list">
        <product_item>
            <name>My Add-on</name>
            <url>relurl://myaddon?alias=MyAddon</url>
            <priority config:type="integer">70</priority>
            <ask_user config:type="boolean">false</ask_user>
            <selected config:type="boolean">true</selected>
            <check_name config:type="boolean">false</check_name>
        </product_item>
    </product_items>
</add_on_products>
```

You can define the following elements:

* `<name>` is the name of your repository
* `<url>` points the the repository location; you’ll likely want to use
  the `relurl` scheme here that gives the location relative to the main
  installation repository
* `<priority>` is the repository priority (lesser number means higher
  priority, the main installation repository has priority 99)
* `<ask_user>`\: should the user be asked about adding the repository?
* `<selected>`\: should the repository be automatically selected?
* `<check_name>`\: should the repository’s actual name be matched
  against the value of the `<name>` element?

You can of course list several repositories in this file.

If you’re too lazy to remember all this, [mksusecd][4] can do all this
for you.

For example, if you have a set of new kernel packages you would like to
use, do:

```
mksusecd --create new.iso --addon kernel-*.rpm --addon-name 'my kernel' sles12-sp2.iso
```

This creates a new iso based on `sles12-sp2.iso` that will install your
new kernel packages instead.

### Storage reimplementation: small steps for the code, giant leap for continuous integration

During bug squashing we managed to find some time to keep the storage
stack reimplementation rolling… slow and steady. The customized
Tumbleweed images (labeled as NewStorage) in the [storage-ng OBS
repository][5] are already able to analyze most systems, creating a
representation of the system storage devices in memory that will be used
to manipulate the disks and propose a partitioning schema.
Unfortunately, this representation is only visible in the YaST logs
since fixing installer bugs was more urgent than representing that
information in the UI.

This turned to be an important milestone, not because of the
functionality itself or the value of the code (we just added a couple of
lines of Ruby code), but because for the first time the dependencies in
some packages were switched from libstorage to libstorage-ng. That had
important implications for the code organization and for our continuous
integration infrastructure, specially the [Travis CI][6] integration,
which implies the generation of .deb packages. We can now say that our
continuous delivery workflow (from Github to OBS, passing through
Jenkins, Travis, Coveralls and Code Climate) is free of any trace of the
old storage code.

In addition, we also did some good progress in LVM support in the new
library, being able to recognize and manipulate in memory all kind of
LVM structures.

### The joy of openness: updating the SUSE Linux Enterprise documentation

An important part of our job, specially as a new release date
approaches, is helping to shape the SUSE Linux Enterprise (SLE)
documentation. One of the strongest points of SUSE products is the
awesome SUSE’s documentation team which, as the rest of the company,
have open source in their genes. Suggesting improvements and updates for
the documentation is as straightforward as creating a pull request in
the completely open [documentation repository at Github][7]… and anybody
can do it!

The documentation team uses Docbook, but they would accept contributions
in other formats (e.g. Markdown) and transform it themselves into
Docbook… just because they are that cool. :smiley:

### Better support for ARM systems using EFI

The world is getting full of cool ARM64 devices and both SUSE and
openSUSE are actively working in supporting as many of them as possible.
We took another small step during this sprint improving the installer’s
partitioning proposal for ARM systems that use EFI.

### That’s not all, folks

As we always say, this was just the small portion of the work done that
we consider exciting enough to be part of our development reports, since
we don’t want to bore you with details about every single fixed bug.
During this installer bug-fixing phase, this is more true than ever and
the next sprint, which is already planned, will be similar to this in
that regard. Nevertheless, in the next report we expect to have some
interesting news about the installer self-update functionality and about
the LVM support in the new storage stack. Stay tuned.



[1]: https://scc.suse.com
[2]: https://www.suse.com/products/subscription-management-tool
[3]: https://github.com/yast/yast-installation/blob/master/doc/SELF_UPDATE.md#where-to-find-the-updates
[4]: https://software.opensuse.org/package/mksusecd
[5]: http://download.opensuse.org/repositories/YaST:/storage-ng/images/iso/
[6]: https://travis-ci.org/
[7]: https://github.com/SUSE/doc-sle/
