---
layout: post
date: 2016-02-25 11:49:55.000000000 +00:00
title: Highlights of development sprint 15
description: We know you have missed the usual summary from the YaST trenches. But
  don&#8217;t panic, here you got it! As usual, we will only cover some highlights.
category: SCRUM
tags:
- Distribution
- Factory
- Programming
- Systems Management
- YaST
---

We know you have missed the usual summary from the YaST trenches. But
don’t panic, here you got it! As usual, we will only cover some
highlights, saving you from the gory details of the not so exciting
regular bugfixing.

### Package notifications

libzypp has a nice feature that enables packages to display
notifications when they’re installed/upgraded. Zypper takes advantages
of this feature and shows that information when a package is
installed/upgraded. For example, if you install `mariadb` package,
Zypper will inform you about setting up a database root password and so
on.

If you installed any of those packages with YaST, you missed that piece
of information… until now! Starting on `yast2 3.1.175` YaST will show
packages notifications.

![installation-messages-qt](https://cloud.githubusercontent.com/assets/15836/13257232/e7e23058-da45-11e5-8e7d-b116f47c686c.png)

![installation-messages-ncurses](https://cloud.githubusercontent.com/assets/15836/13257235/ea6ecade-da45-11e5-91ff-579cb257b859.png)

The only exception is when doing a regular installation (or
autoinstallation), as we want to show as few dialogs as possible.

### Registration Codes from a USB Stick

During the installation of a SUSE Linux Enterprise product, you are
asked for a registration code. Previously you had to remember it and
type it by hand. Now the code can be read from USB storage.

![regcode-from-usb](https://cloud.githubusercontent.com/assets/102056/13245125/4e0bf5de-da0b-11e5-839a-9d8d70052149.png)

![regcode-from-usb-extensions](https://cloud.githubusercontent.com/assets/102056/13255345/127cc83c-da46-11e5-97b5-bc6365361cfd.png)

Insert a USB stick at installation boot time or at the latest before you
proceed from the first installation screen (Language, Keyboard and
License Agreement). That stick should contain the registration codes
either at `/regcodes.txt` or at `/regcodes.xml`. In the registration
dialogs, the input fields will be prefilled.

The syntax of the files is as follows. In the file identify the product
with the name quoted by `zypper search --type product` or `SUSEConnect
--list-extensions` (without the /version/architecture part).

regcodes.txt:

```
SLES    cc36aae1
SLED    309105d4

sle-we  5eedd26a
sle-live-patching 8c541494
```

regcodes.xml: (xml wins if both xml and txt are present)

```xml
<?xml version="1.0"?>
<profile xmlns="http://www.suse.com/1.0/yast2ns" xmlns:config="http://www.suse.com/1.0/configns">
  <suse_register>
    <!-- See https://www.suse.com/documentation/sles-12/singlehtml/book_autoyast/book_autoyast.html#CreateProfile.Register.Extension -->
    <addons config:type="list">
      <addon>
        <!-- Name of add-on as listed by "zypper search --type product" -->
        <name>sle-we</name>
        <reg_code>5eedd26a</reg_code>
      </addon>
      <addon>
        <name>sle-live-patching</name>
        <reg_code>8c541494</reg_code>
      </addon>
      <addon>
        <!-- SLES is not an add-on but listing it here allows for combining
             several base product registration codes in a single file -->
        <name>SLES</name>
        <reg_code>cc36aae1</reg_code>
      </addon>
      <addon>
        <name>SLED</name>
        <reg_code>309105d4</reg_code>
      </addon>
    </addons>
  </suse_register>
</profile>
```

### Lot of Btrfs-related improvements in the expert partitioner

We also invested quite some time improving the support for Btrfs in the
expert partitioner. Implementing one requested feature and closing five
bugs.

The following animation shows the feature #320296 (user friendly
handling of subvolumes) in action, together with the fix to 965279
(Btrfs settings always overridden with default values).

![subvolumes-opt](../../../../images/2016-02-25/subvolumes-opt.gif)

But we have even more screenshots and animations for the improvements in
the expert partitioner. In the description of [this pull request][1],
you have screenshots displaying the new dialog that was implemented to
fix bug#928641. And in [this other pull request][2], you can see in
action the fixes for bug#944252 (snapshots were offered for partitions
other than root) and for bug#954691 (fstab options being forgotten for
Btrfs partitions).

### Improving testability of the new storage code

In recent posts, we reported how we are about to refactor the storage
subsystem of YaST. The improved partition proposal for installation
[presented in the previous summary][3] performs a lot of operations –
like analyzing what disks are there and what is on each one of them,
checking if there already is enough free space and making a best guess
on what partitions may be candidates to be removed to make space for a
new Linux installation.

If there are many disks with many partitions, this can get complicated
really quickly. So we need a reliable way to test it. Thus, we created a
testing framework to build fake storage hardware (disks) with fake
partitions and file systems. Although it’s fake hardware (we can’t
create hard disks out of thin air… yet), it enables us to do unit tests
without setting up virtual machines. With those tests we can cover a lot
more scenarios that would otherwise be really difficult to test, with
one or many disks, with many partitions of different kinds, with a
previously existing RAID array or whatever.

One nice thing about the new libstorage is that it operates on “device
graphs” that can be transformed into the GraphViz format for easy
visualization. Here you have a nice diagram generated by libstorage
based on some fake hardware created from [this YAML specification][4].

[![fake-devicegraphs](../../../../images/2016-02-25/fake-devicegraphs-300x136.png)](../../../../images/2016-02-25/fake-devicegraphs.png)

### Better handling of wrong registration code for extensions

We also spent some time improving the usability of the section for
registration of extensions and modules. Now if the user selects several
modules and the registration of some of them fails, the user will be
kindly redirected back to the same dialog but only with inputs for the
unregistered ones. From there, they can go back to unselect the failing
extensions or retry with different (or even with the same) codes.

### Say goodbye to the “receive system mail” checkbox

As the last step of the improvements done to the user creation dialog
(see the [previous post][5] for more details). We removed the long-ago
meaningless checkbox titled “Receive System Mail”. That leaded to the
removal of quite some code… and removing code is usually a good thing. :smiley:

### Many other things

As usual, this is just a short summary with some highlights. Many other
stuff was implemented and several other bugs were fixed but, you know,
we cannot blog about everything if we want to invest some time in
debugging and coding. :smiley:

See you in the highlights for next sprint, in around three weeks.

PS.- If you want to be part of the fun, take a look to the YaST-related
summer projects we have on the [openSUSE mentoring page][6].



[1]: https://github.com/yast/yast-storage/pull/190
[2]: https://github.com/yast/yast-storage/pull/186
[3]: {{ site.baseurl }}{% post_url 2016-02-03-highlights-of-development-sprint-14 %}
[4]: https://gist.github.com/ancorgs/014c34c3c74b9949f3a2
[5]: {{ site.baseurl }}{% post_url 2016-02-03-highlights-of-development-sprint-14 %}
[6]: http://101.opensuse.org/
