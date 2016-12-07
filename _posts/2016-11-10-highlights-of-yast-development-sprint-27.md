---
layout: post
date: 2016-11-10 11:17:57.000000000 +00:00
title: Highlights of YaST development sprint 27
description: Another three weeks of development come to an end&#8230; and our usual
  report starts. Take a look to what we have been cooking.
category: SCRUM
tags:
- Base System
- Distribution
- Factory
- Programming
- Systems Management
- YaST
---

Another three weeks of development come to an end… and our usual report
starts. Take a look to what we have been cooking.

### Read-only proposal modules

This week, during [SUSECon 2016][1], SUSE announced an exciting upcoming
new product. SUSE CASP – a [Kubernetes][2] based Container As a Service
Platform.

That has, of course, some implications for the installer, like the need
of some products (like CASP) to specify a fixed configuration for some
subsystems. For example, an established selection of packages. The user
should not be allowed to change those fixed configurations during
installation.

We have implemented a possibility to mark some modules in the
installation proposal as read-only. These read-only modules then cannot
be started from the installer and therefore their configuration is kept
at the default initial state.

[![Software and firewall proposals as
read-only](../../../../images/2016-11-10/readonly-300x225.png)](../../../../images/2016-11-10/readonly.png)

In this sprint we have implemented a basic support in the proposal
framework, in the future we could improve the respective proposal
modules to better handle the read-only mode.

### Per product Btrfs subvolumes handling

The ability to have read-only proposals is not the only improvement we
have introduced in YaST to make SUSE CASP possible.

When Btrfs is used during the installation, YaST2 proposes a list of
subvolumes to create. Unfortunatelly, that list is hard-coded and it’s
the same for every (open)SUSE product… until now.

Starting on yast2-storage 3.1.103.1, a list of subvolumes can be defined
in the product’s control file along with additional options (check out
[SLES][3] and [openSUSE][4] examples to learn more).

```xml
<subvolumes config:type="list">
  <subvolume>
    <path>boot/grub2/i386-pc</path>
    <archs>i386,x86_64</archs>
  </subvolume>
  <subvolume>
    <path>home</path>
  </subvolume>
  <subvolume>
    <path>opt</path>
  </subvolume>
  <subvolume>
    <path>var/lib/libvirt/images</path>
    <copy_on_write config:type="boolean">false</copy_on_write>
  </subvolume>
</subvolumes>
```

This specification supports:

* Disabling copy-on-write for a given subvolume (it’s enabled by
  default).
* Enabling the creation of a subvolume only for a set of architectures.

### Improved AutoYaST Btrfs subvolumes handling

AutoYaST Btrfs subvolumes handling has been also improved. Using almost
the same syntax as for product control files, you can disable the `CoW`
behavior for a given subvolume.

Of course, if you don’t need such a feature, you won’t need to adapt
your profiles to the new syntax as it’s backward compatible. You can
also mix both of them:

```xml
<subvolumes config:type="list">
  <subvolume>home</subvolume>
  <subvolume>
    <path>var/lib/libvirt/images</path>
    <copy_on_write config:type="boolean">false</copy_on_write>
  </subvolume>
</subvolumes>
```

On the other hand, if you’re running SLES, you’ll know that a subvolume
called `@` is used as the default Btrfs subvolume. Now is possible to
turn-off such behavior in the profile’s general section.

```xml
<general>
  <btrfs_set_subvolume_default_name config:type="boolean">false</btrfs_set_subvolume_default_name>
</general>
```

### Disable installer self-update by default

We have talked many times in this blog about the new self-update
functionality for the installer. As expected, this functionality will
debut in SLE-12-SP2 but with a small change in the original plan. In
order to ensure maximum consistency in the behavior of SLE-12-SP1 and
SP2 installers, the self-update functionality will be disabled by
default. Not a big deal, since enabling it to get the latest fixes will
be just a matter of adding a boot option in the initial installation
screen.

### Storage reimplementation: adapted EFI proposal in yast2-bootloader

The previous report about the status of the storage stack
reimplementation finished with the following cliffhanger “*we have in
place all the ingredients to cook an installable ISO*“. So, as expected,
we worked during this sprint in adapting the bootloader proposal to the
new storage layer. As you can see in the following screenshot, we
succeeded and the installer can already propose a valid grub2 setup to
boot an EFI system.

[![EFI proposal with the storage-ng
ISO](../../../../images/2016-11-10/grub2efi-300x225.png)](../../../../images/2016-11-10/grub2efi.png)

Does that mean that the testing ISO for the new storage stack is already
fully installable? Unfortunately not. Why not, you ask? The reason is,
in fact, kind of fun.

The current partitioning proposal only works with MS-DOS style partition
tables because we wanted to address the most complicated case first. On
the other hand, we intentionally restricted the adaptation of the
bootloader proposal to the EFI scenario. And you know what? We found out
that combination (MS-DOS partition table + EFI) [does not currently
work][5] in Tumbleweed, so it neither does in our Tumbleweed-based
testing ISO.

We will work during the following sprint to support another scenario.
And hopefully we will not choose again an unsupported or broken one.
:wink:

### Letting libYUI run free: first visible steps

As you know, YaST has both a graphical and a textual interface. They run
on the same code thanks to an abstraction layer called LibYUI.
Originally it served YaST only, but over time other projects started
using it, notably the admin panel in Mageia. Moreover, the developers of
those projects started to contribute fixes and improvements to LibYUI…
faster than we can cope with.

Recently we decided to give the people outside the YaST team more power
in the LibYUI project. To make that possible ensuring it does not affect
YaST stability, we have been enabling more continuous integration tests.

As a first fruit of the revamped collaboration, we have merged a fix
contributed by Angelo Naselli of Mageia regarding selection of tree
items. As soon as we complete our continuous integration setup (of
course we will keep you informed), more fixes and improvements will come
for sure.

### More bug squashing and bug paleontology

In the [previous report][6] we presented our new effort to integrate the
fix of low-priority bugs into the Scrum process. During this sprint we
refined the idea a little bit more, distinguishing two separate concepts
(each of them with its own [PBI][7]) – fixing of existing bugs and
closing of too old ones.

The first one doesn’t need much explanation. We managed to fix around 25
non-critical bugs in YaST and if you are using Tumbleweed you are
probably already benefiting from the result.

The second task was not exactly about fixing bugs present in the
software, but about cleaning bugzilla from bug reports that were simply
too old to be relevant any more. Like bugs affecting very old versions
of openSUSE that cannot be reproduced in openSUSE 13.2 or Leap. We must
be realistic about releases that are already out of support and the
limited human resources we have. We closed around 80 of those ancient
bugs.

[![no\_country\_for\_old\_bugs](../../../../images/2016-11-10/no_country_for_old_bugs-300x169.jpg)](../../../../images/2016-11-10/no_country_for_old_bugs.jpg)

So overall, we cleaned up around one hundred bugs from our queue. Still
a long way to have a bug-free YaST, but undoubtedly a step in the right
direction.

### More coming

We are already working in the next sprint that will hopefully bring
several new improvements for CASP, quite relevant progress in the
storage reimplementation, several usability improvements, some bugfixes
and even some news about this blog.

To make sure you don’t get bored while waiting we are also planning to
finally publish the report about our visit to [Euruko 2016][8].

Stay tuned!



[1]: http://www.susecon.com/
[2]: http://kubernetes.io/
[3]: https://github.com/yast/skelcd-control-SLES/blob/master/control/control.SLES.xml#L190
[4]: https://github.com/yast/skelcd-control-openSUSE/blob/master/control/control.openSUSE.xml#L297
[5]: https://bugzilla.suse.com/show_bug.cgi?id=1008289
[6]: {{ site.baseurl }}{% post_url 2016-10-20-highlights-of-yast-development-sprint-26 %}
[7]: https://www.scrumalliance.org/community/articles/2007/march/glossary-of-scrum-terms#1130
[8]: http://euruko2016.org/
