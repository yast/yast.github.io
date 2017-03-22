---
layout: post
date: 2017-03-22 15:38:22.000000000 +01:00
title: Highlights of YaST development sprint 32
description: To make sure you didn't missed us too much, in our latest blog
  post we summarized all the YaST-related projects worked during Hack Week 15. But
  after all the fun, it was time for more fun! So let's take a look to
  what the team has delivered on this first sprint after Hack Week 15.
category: SCRUM
tags:
- Distribution
- Factory
- Miscellaneous
- Programming
- Systems Management
- Usability
- YaST
---

### Storage reimplementation: encrypted proposal without LVM

One of the known limitations of the current installer is that it’s only
able to automatically propose an encrypted schema if LVM is used. For
historical reasons, if you want to encrypt your root and/or home
partitions but not to use LVM, you would need to use the expert
partitioner… and hope for the best from the bootloader proposal.

But the new storage stack is here (well, almost here) to make all the
old limitations vanish. With [our testing ISO][2] it’s already possible
to set encryption with just one click for both partition-based and
LVM-based proposals. The best possible partition schema is correctly
created and everything is encrypted as the user would expect. We even
have continuous tests in our internal openQA instance for it.

The part of the installer managing the bootloader installation is still
not adapted, which means the resulting system would need some manual
fixing of Grub before being able to boot… but that’s something for an
upcoming sprint (likely the very next one).

### Improved add-ons listing for SLE12-SP1

The dialog in SLES-12-SP1 for selecting the add-ons after registering
the system was originally designed just for a small list of add-ons.
Unfortunately (or fortunately, depending on how you look at it), the
number of add-ons grew over the time and it exceeded the original limit
for the text mode UI.

The equivalent screen in SLE-12-SP2 is not affected by the problem
because it uses a different layout with scrollable list. But the SP1
dialog looks like this.

{% include blog_img.md alt="Broken add-ons list in SP1"
src="scc-sp1-bad-300x188.png" full_img="scc-sp1-bad.png" %}

If you look carefully at the screenshot you will see that the *Web and
Scripting Module* is missing in the list and the `Back`, `Next` and
`Abort` buttons at the bottom are also not displayed.

The fix decreased the size of the `Details` widget and allowed
displaying more items in each column. Now there is even free space for
three more add-ons.

{% include blog_img.md alt="Fixed addons list in SP1"
src="addons-sp1-good-300x188.png" full_img="addons-sp1-good.png" %}

Moreover the dialog is now dynamic and checks the current size of the
screen. If there is enough free space then the list is displayed in one
column so the labels are not truncated and the `Details` widget size is
increased back to the original size.

{% include blog_img.md alt="Add-ons list in SP1 with enough space"
src="addons-sp1-big-300x234.png" full_img="addons-sp1-big.png" %}

### Storage reimplementation: Btrfs subvolumes

The management of subvolumes is one of those features that make Btrfs
rather unique and that need special handling when compared to more
traditional file systems. That was indeed one of the several reasons to
rewrite `libstorage` – Btrfs subvolumes never fully fitted the
philosophy and data structures on the old (current) `libstorage` and
`yast2-storage`.

In this sprint we introduced support for subvolumes in `libstorage-ng`
from the ground up, taking into consideration all the specificities, use
cases and scenarios found in the past. And, hopefully, in a way that is
also prepared for whatever the future brings.

The new functionality is already working and tested and it’s included in
the latest versions of `libstorage-ng`, but is still not used in the
proposal or any other part `yast2-storage`. You will have to wait
another sprint to see more visible results. At least if “more visible”
means screenshots. Meanwhile, if you like images you can always enjoy
the graphs generated from the internal structures managed by
`libstorage-ng`.

{% include blog_img.md alt="Internal subvolumes representation in libstorage-ng"
src="subvolumes-300x57.png" full_img="subvolumes.png" %}

### Storage reimplementation: system upgrade

The new storage stack has been able to install an openSUSE system for
quite some time already. While we keep improving that area, the next
challenge was to make the upgrade from a previous openSUSE version also
possible using [our testing ISO][2].

That implies scanning the hard disks looking for previous installations,
allowing the user to select one, mounting the corresponding partitions
or LVM volumes, performing the update of every package and doing some
final tasks like updating the bootloader configuration.

Following the iterative approach encouraged by Scrum, we focused in the
first three steps, which is something that a user (or openQA, for that
matter) can test and verify. So now we are able to detect and list
pre-existing systems and start the upgrade process on the selected one.
And we have automated tests in openQA to ensure it works across all the
combinations of partition-based vs LVM-based layout and UUID-based vs
name-based `fstab` file.

### Add-ons can define new system roles

YaST is pretty customizable when it comes to adapt/modify the
installation workflow. Among other things, add-ons are allowed to adapt
the workflow (adding/removing steps), define new proposals, etc. And
starting now, they can also define new system roles.

Let’s see and example of adding a new mail server role:

```xml
<update>
  <system_roles>
    <insert_system_roles config:type="list">
      <insert_system_role>
        <system_roles config:type="list">
          <system_role>
            <id>mail_role</id>
            <software>
              <default_patterns>base Minimal mail_server</default_patterns>
            </software>
          </system_role>
        </system_roles>
      </insert_system_role>
    </insert_system_roles>
  </system_roles>
</update>

<!-- Don't forget to add the texts -->
<texts>
  <mail_role>
    <label>Mail Server</label>
  </mail_role>
  <mail_role_description>
    <label>• Software needed to set up a mail server
• No production ready yet!</label>
  </mail_role_description>
</texts>
```

And now let’s see how it looks:

{% include blog_img.md alt="A role added by an addon"
src="addons-adding-roles-300x225.png" full_img="addons-adding-roles.png" %}

Which leads us to the next section…

### The list of roles becomes responsive in text mode

A really nice thing about YaST is that it’s able to run in textmode, so
you don’t need a graphical interface to install or configure your
system. As a consequence, YaST developers need to keep certain
limitations in mind when working in the user interface.

Now that add-ons can add new system roles, we noticed a potential
problem in the dialog selection screen: we eventually will get out of
space if more than one system role is added. So we decided to improve
how system roles are displayed to make them fit in a 80×25 mode (that
is, only 25 lines of text). Let’s see the changes with some examples.

This is how the screen looks by default, with a reasonably small set of
roles.

{% include blog_img.md alt="Default system roles list"
src="roles-fit-300x167.png" full_img="roles-fit.png" %}

If the system detects there is no space to present all the information
in such a convenient way, it removes all the spaces so at least the
information is all there, even if it looks a little bit packed.

{% include blog_img.md alt="Roles list with no extra space"
src="roles-packed-300x167.png" full_img="roles-packed.png" %}

If even that is not enough, the extra descriptions are omitted, which
gives us way more room.

{% include blog_img.md alt="Compact roles list"
src="roles-dontfit-300x167.png" full_img="roles-dontfit.png" %}

If roles don’t fit even without the descriptions, the introductory text
will be also omitted which means we can present up to eighteen (yes,
18!) roles in the screen.

### Storage reimplementation: guided setup mock-up

As explained in several previous reports, we are collaborating closely
with SUSE UX experts to design the revamped interfaces of the
installer’s partitioning proposal and the expert partitioner. We already
showed you the document we used as a base to discuss the partitioning
proposal, including the conclusions, and the first very simple prototype
of the so-called Guided Setup.

During this sprint, that collaborative effort focused on defining
exactly how every step of that wizard should work and look like. The
goal was to get some interface mock-ups to be used as starting point for
the upcoming sprint. More than ever, a picture (well, four of them) is
worth a thousand words.

{% include blog_img.md alt="First step of the guided partitioning setup mock-up"
src="guided1-300x224.png" full_img="guided1.png" %}

{% include blog_img.md alt="Second step of the guided partitioning setup mock-up"
src="guided2-300x224.png" full_img="guided2.png" %}

{% include blog_img.md alt="Third step of the guided partitioning setup mock-up"
src="guided3-300x225.png" full_img="guided3.png" %}

{% include blog_img.md alt="Fourth step of the guided partitioning setup mock-up"
src="guided4-300x226.png" full_img="guided4.png" %}

### Prevent the installation of CaaSP if Btrfs snapshots are not possible

CaaSP is a single purpose system, and having snapshots enabled is
essential. So there’s now a check in place that will simply prevent you
from going on with the installation if snapshots are disabled (for
example, if the disk is too small).

{% include blog_img.md alt="Blocked CaaSP installation"
src="snapshots-blocker-300x225.png" full_img="snapshots-blocker.png" %}

### Storage reimplementation: better handling of /etc/fstab and /etc/cryptab

For the new storage stack, we refactored the classes to handle
`/etc/fstab`. While this would normally not be anything to write much
about, we included intelligent handling for existing comments based on
[this standalone GitHub project][3].

This means that existing comment blocks at the start and at the end of
the file remain untouched, and comments before any content entry remain
attached to that entry; i.e. when that entry is moved around in the file
(e.g. because of mount dependencies), that comment is moving along with
the entry it belongs to. While this is not 100% fool proof, it is much
better than the usual strategy to simply discard such comments when the
file is rewritten.

### Quite some adaptations and bugfixes for CaaSP

As you already know from previous reports and other sources, a
considerable part of SUSE’s development firepower is focused on building
the upcoming CaaSP. As part of that heavy development process, the YaST
team invested a significant part of the sprint adapting YaST for CaaSP
and fixing bugs introduced by previous adaptations. A large collection
of changes here and there that are hard to summarize here but that help
CaaSP to be a couple of steps closer to the final goal.

### Keep it rolling!

We have already planned our next sprint which will hopefully bring more
features to the new storage stack, CaaSP-related improvements, a
surprise about AutoYaST and more stuff. And, of course, it will be
followed by its corresponding report.

So see you in three weeks. Stay tuned and have a lot of fun!


[1]: {{ site.baseurl }}{% post_url 2017-03-07-yast-development-during-hack-week-15 %}
[2]: http://download.opensuse.org/repositories/YaST:/storage-ng/images/iso/
[3]: https://github.com/shundhammer/commented-config-file
