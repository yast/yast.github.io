---
layout: post
date: 2018-03-23 14:14:55.000000000 +00:00
title: Highlights of YaST Development Sprint 53
description: As the release dates for SUSE Linux Enterprise 15 and openSUSE Leap 15
  approach, we keep adapting YaST to make easier for our users to take advantage of
  all the new features that these rock-solid operating systems will bring.
category: SCRUM
tags:
- Distribution
- Factory
- Miscellaneous
- Programming
- Systems Management
- YaST
---

During the last two weeks that has implied, apart from regular bug
fixing that we usually don’t cover here, working on AutoYaST, improving
Storage-ng and polishing several aspects related to modules and
extensions, like their registration and licenses.

Let’s start with the rewritten Partitioner that is part of
`yast2-storage-ng`.

### Partitioner: more flexibility with the partition id

Setting the right [partition id][1] (also known as partition type) for
each partition is an important part of the system setup that is often
overlooked. Our Partitioner has always displayed in a prominent place
the widget allowing to set that id, suggesting always the best value
based on the selected role and the chosen file system type. But in many
cases, that was more than a simple suggestion. In the old Partitioner
(and in the new one until this sprint) the value of the partition id
field (Linux, swap, Linux LVM, etc.) could only be manually edited in
case the user had selected to not format the partition. When the option
“Format device” was selected, the automatically chosen value could not
be changed.

In SLE15 and openSUSE Leap 15 (and quite soon in openSUSE Tumbleweed),
it will be possible to modify the id, no matter if the partition is
going to be formatted or not. Of course, the logic to propose the best
option every time the user selects a file system type is still there,
but now it can be always overridden if the user wish. That change
resulted in a small rearrangement of the widgets in that screen, as you
can see below (remember we are trying to be very conservative with the
UI changes in the Partitioner).

{% include blog_img.md alt="UI adjustments for the partition id"
src="partition_id-300x207.png" full_img="partition_id.png" %}

### Partitioner: better support for DASD

In [our previous report][2] we explained some of the aspects in which
the Direct-access storage devices (DASD) used in s390 mainframes are
different from regular hard disks. But as you can imagine, there are
more differences… and we know our readers love to learn new stuff while
enjoying our reports. :smiley:

In short, there are two possible kinds of DASDs devices: Extended Count
Key Data (ECKD) and Fixed Block Architecture (FBA). As explained in the
previous report, the ECKD devices need to be formatted at low-level in
order to be used by the operating system and, moreover, there are two
possible low-formats for them: Compatible Disk Layout (CDL) and Linux
Disk Layout (LDL).

And now the fun – ECKD devices formatted as LDL do NOT have a partition
table. FBA devices can potentially have one, but it’s also often
skipped. To manage those DASDs without partition table, the Linux kernel
simulates an implicit single partition taking the whole disk. Of course,
working with such implicit partitions implies some restrictions, and we
have introduced several controls to make sure things stay under control
in the storage-ng Partitioner. For example, an error message is now
shown if the user tries to remove an implicit partition.

{% include blog_img.md alt="Trying to delete an implicit partition"
src="implicit-300x208.png" full_img="implicit.png" %}

For curious readers, there is more information about DASD available [in
this link][3].

### Partitioner: can’t resize a partition… but why?

In SLE15 and openSUSE Leap 15 we will report very detailed reasons why a
partition or a file system cannot be resized, as you can see in this
screenshot.

{% include blog_img.md alt="Detailed description of resizing restrictions"
src="resizing-300x187.png" full_img="resizing.png" %}

This used to be just a very simplistic message “Device cannot be
resized”. But there may be many reasons for that, and sometimes
different restrictions might contradict each other: While some type of
file system only lets you grow, not shrink (e.g. XFS), the partition
that the file system is on might not be able to grow, for example
because there is another partition right next to it. We want to minimize
user frustration that might happen when we only report the first reason,
and when the user somehow managed to fix that problem, show another one
that can’t be fixed.

As usual, this feature will be available in Tumbleweed in a matter of
days.

### Handling registration rollback in SLE15 Migration

Of course, the Partitioner was not the only YaST area to get attention
during this sprint. Several aspects related to products, modules and
extensions were also worked, with all the implications they have about
registration, migration and licenses.

For the offline migration to SLE15 we reused some parts from the online
migration which handles service pack upgrade. But it tuned out that the
reused part was not correctly integrated into the installer and in some
corner cases (registration errors) it did not behave correctly.

Moreover if the upgrade failed early then the system still contained a
SLE12 installation but was registered as a SLE15 system on the SCC
server. After booting the original SLE12 system the access to the online
repositories was broken.

This sprint we fixed that so in case of registration error or when going
back the original registration is restored. Now you can go back and
choose a different system to upgrade and it will work as expected.

Additionally we fixed some small issues with custom repositories (add-on
or driver updates) used at upgrade.

### More fun with hiding/showing beta versions in SLE15

Usual readers of our blog already know that SUSE is taking extensions
and modules to a whole new level in SLE15, making them a cornerstone of
the system installation and upgrade process. As already explained in
previous posts, that implies more complex dependencies between
extensions and modules. All those mechanisms usually work nice… except a
small problem we found out with beta versions.

If a given extension was in beta phase and some of its dependencies were
also in beta, if the “Hide Beta Versions” checkbox was unchecked the
system was displaying only the extension selected by the user, but not
the auto-selected dependent beta extensions. Our SLE testers found that
quite confusing. So to make everyone’s life easier, we fixed the
behavior as shown in the following screenshot.

{% include blog_img.md alt="Displaying selected and auto-selected beta extensions"
src="beta_extensions-300x227.png" full_img="beta_extensions.png" %}

### A look into the future: analyzing how we display licenses

Currently there are many different ways to handle and display licenses.
That can happen during the installation or upgrade process, while adding
additional products to an installed system and, last but not least,
while using YaST2 Firstboot to perform additional installation steps on
the first system execution.

Additional there are 3 different locations from which these licenses
come from. They can be provided by the SUSE Customer Center, be provided
by libzypp or come from a repository using a legacy approach.

To simplify and unify all that in a close future, the first step was
researching all those possibilities and how they are handled in
(Auto)YaST. The result of such research can be found [in this document
hosted on Github][4].

### AutoYaST product selection and installer update improvements

As you probably already know, starting with SLE-15, all products are
distributed using one medium and you need to choose explicitly which
product to install. Of course, if the medium only contains one product
that would not be needed.

In AutoYaST profile the product is selected using the
`/software/products/product` XML node:

```xml
    <software>
      <products config:type="list">
        <product>SLED</product>
      </products>
    </software>
```

Due to a bug, the cloned system exported the product `short_name`
instead of the `name`, resulting in an internal error reported by the
installer update and a later error during the auto-installation which
aborted it because no product was selected.

So, during this sprint we have made improvements for both scenarios.

1.  The installer update will not rely in the product selection at all
    (the installer is the same for all the products) but will use the
    `self_update_id` from the control file and the `version` and
    `architecture` from the first product available on the media. The
    [installer update documentation][5] has been also updated according
    the last changes and it is probably the best place for knowing more
    about its behavior.
2.  The wrong product selection error reported was not very useful and
    it was decided to provide more information about the list of
    available products from the media. Just see the image below with the
    latest implementation:

{% include blog_img.md alt="Warning about wrong product in AutoYaST"
src="wrong_product-300x189.png" full_img="wrong_product.png" %}

### Document main differences in AutoYaST profiles between SLE12 and SLE15

The need to select a product is not the only relevant change affecting
AutoYaST profiles for SLE15. There are many other significant changes in
SLE15 compared to SLE12. Like the new modules concept, replacing
`SuSEfirewall2` with `firewalld`, replacing `ntp` with `Chrony`… Users
wanting to reuse existing SLE12 profiles with SLE-15, will probably need
to adjust them.

We have created [this summary][6] describing some of the most important
changes in order to help with the conversion.

That document is just a preliminary and temporary work that is currently
being reviewed and improved by the awesome documentation team at SUSE.
Very soon (probably already done at the time you are reading this) the
content will be merged and a new section titled “Main differences
between SLES 12 and 15 profiles” will be available in the [current guide
for AutoYaST][7]. Have we ever mentioned how much the doc team rocks? So
please, use that last link as final reference instead of our temporary
summary.

### Cron config for NTP client

It is possible to setup the YaST-ntp-client module to sync the system
clock at regular intervals. If that feature is used, YaST writes the
needed configuration to a cron.d config file. We were still using
“novell” as part of the name of such file, which was reported as a bug.
It turned to be a good opportunity to take a look to a module that, as
you can guess from that bug, we don’t update very often. :smiley:

First of all, we made sure that newly written files will have a more
up-to-date name. Straightforward and easy.

The second part was to provide an upgrade path if the file already
existed. We integrated that with the existing `ntp` to `chrony`
conversion. That means the existing configuration is updated when a new
version of the `yast2-ntp-client` package is installed, so the user does
not need to run the module again to start using `chrony` with an
existing configuration.

Last but not least, the third part was to adapt the package to be a
better citizen in the RPM world, marking that file as ghost file in RPM
spec. Now this command can recognize that `yast2-ntp-client` is
responsible for that configuration file.

```console    
      rpm -qf <file>
```

### Two months… and counting

Only two months of countdown until the release date of openSUSE Leap 15!
That means a lot of hard work ahead of us, so stay tuned for more
updates.



[1]: https://en.wikipedia.org/wiki/Partition_type
[2]: https://lizards.opensuse.org/2018/03/09/highlights-of-yast-development-sprint-52/
[3]: https://www.ibm.com/support/knowledgecenter/ssw_aix_61/com.ibm.aix.kernextc/serial_direct_storage.htm
[4]: https://github.com/yast/yast-packager/blob/master/doc/license_code_cleanup.md
[5]: https://github.com/yast/yast-installation/blob/master/doc/SELF_UPDATE.md
[6]: https://github.com/yast/yast-autoinstallation/blob/master/doc/profile_changes_SLE15.md
[7]: https://susedoc.github.io/doc-sle/develop/SLES-autoyast/html/
