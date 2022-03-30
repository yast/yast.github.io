---
layout: post
date: 2022-03-30 11:00:00 +00:00
title: D-Installer First Public Release
description: Announcing the first release of an installation image based on D-Installer
permalink: blog/2022-03-30/d-installer-first-public-release
tags:
- D-Installer
- Experiments
- Programming
- Systems Management
- YaST
---

It is our pleasure to announce the availability of the first installation image based on
D-Installer. Since [our initial announcement in
January](https://yast.opensuse.org/blog/2022-01-18/announcing-the-d-installer-project), we have been
working on going from a non-working proof-of-concept to something that you can actually use.

## D-Installer (kind of) works

D-Installer can install openSUSE Tumbleweed in simple scenarios. But, please, bear in mind that it
is still an experimental project, so it is better to use a virtual machine if you decide to give it
a try. After all, we do not want to be responsible for any data loss. :wink:

If you want to give it a try, just grab the [Live ISO from
OBS](https://build.opensuse.org/package/binaries/YaST:Head:D-Installer/d-installer-live/images). We
will refresh the image as often as possible to include the latest D-Installer changes. Once the ISO
boots, log into the installer using "root" as user and "linux" as password and you should see the
"Installation Summary" page.

{% include blog_img.md alt="Installation summary"
src="installation-summary-mini.png" full_img="installation-summary.png" %}

This article aims to summarize project's current status and what you can expect from the near
future. Additionally, we will dig a bit into some internal details so you have a better overview of
the path we are following.

## How D-Installer looks now

The "Installation Summary" page is the central point in the D-Installer user interface. It allows
the user to check the installation settings at a glance. You can think of this page as the
"Installatin Settings" screen in YaST. The main difference is that, in this case, it is the starting
point, so you do not need to traverse any wizard to get into it.

{% include blog_img.md alt="YaST installation overview"
src="yast-installation-settings-mini.png" full_img="yast-installation-settings.png" %}

The overview is reduced to a few sections: language and product selection, partitioning settings,
and users management.

Unsurprisingly, the language selector allows setting the language in the installed system. Bear in
mind that, at this point, the user interface is not localized yet, so it does not affect the
installer itself. Moreover, we would like to add support to change the keyboard layout in the
future.

Software selection is pretty limited by now. D-Installer allows to select which product to install,
but that's all. Picking patterns or system roles is not supported yet.

Regarding partitioning, D-Installer relies on the YaST guided proposal, although by now it only
allows selecting a device to install the system on. In the next iteration, we plan to offer most of
the settings that YaST offers in the guided partitioning (using multiple disks, choosing a file
system type, etc.).

{% include blog_img.md alt="Target selection"
src="target-selection.png" full_img="target-selection-mini.png" %}

Last but not least, D-Installer allows setting the root authentication (password or SSH public key)
and/or create a first user to log into the installed system, similar to what YaST supports.

Once you tweak the installation options, clicking `Install` button starts the installation. Sure,
the progress screen deserves more love, but it looks good enough now.

{% include blog_img.md alt="Installation progress"
src="installation-progress-mini.png" full_img="installation-progress.png" %}

## YaST, D-Bus, React and Cockpit

We promised to dig a little into the details, so here we go. When it comes to the architecture, the
approach has not changed that much from the one we described in the initial announcement. It is
is composed of three different parts: a system service, a D-Bus interface and a web user interface.

The core is the D-Installer system service, which uses YaST libraries to inspect (probe) and install
the system. We are reusing as much YaST code as possible, but at the same time we are trying to use
only the bits that we need. This service provides a D-Bus interface, so the user interface can
interact with it. We are trying to keep the D-Bus interface decoupled from the business logic,
although we do not plan to replace it for anything else.

Regarding the user interface, we decided to build a [React](https://reactjs.org/) application using
[PatternFly](https://www.patternfly.org/) components. Why PatternFly? You will understand the reason
in a minute if you keep reading. :-)

How do the components we have described talk to each other? That's an interesting question. Instead
of rolling our own solution, we decided to rely on [Cockpit](https://cockpit-project.org/). We use
Cockpit's infrastructure to connect the UI and the system service (through  D-Bus). We even use
Cockpit's webserver to expose the UI in the installation medium.

And that's actually the main reason to use Patternfly. There is a chance that we can reuse parts of
the installer UI in a Cockpit module in the future. Time will tell.

## What to expect from now

The more we think about the future, the more missing stuff we find. We have learned a lot during
this iteration, so we will use that knowledge to develop a roadmap. However, there are some areas we
would like to work on soon that should get a prominent place in such a roadmap. Let's have a look at
some of them.

### Error reporting and user interaction

Our D-Installer service can send information about its current status and the installation progress.
However, it is pretty bad at error reporting and cannot ask the user for additional information. For
instance, it does not implement any mechanism to ask for the password if it finds an encrypted disk
while analyzing the storage devices.

We consider this a critical requirement and we would like to come up with a reliable solution in the
next iteration.

### Better software handling

Selecting a product is not just picking a set of packages: it might affect the installer's
behavior. For instance, if you want to install MicroOS, the partitioning proposal needs to be
adapted to mount the root file system as read-only. Not to mention showing products' licenses or
release notes. So it is not that simple.

Moreover, we have the concept of *system roles*, which may affect the software selection,
services configuration, etc.

As there are many moving pieces, we need to define how far we are going with software handling. Of
course, licenses and release notes are a must. But do we plan to support system roles? Most likely,
yes. Which options would be supported? And what about selecting patterns or just individual
packages? Too many open questions yet.

### Full guided proposal supported

We do not plan to bring the partitioner to the web interface anytime soon. Instead, our plan is to
support all the guided partitioning options, so you can select multiple devices, choose a different
file system, enable LVM, use encryption, etc. At medium term, it looks like a fair trade.

### The User Interface

We consider the user interface good enough for a first iteration but, given that we plan to add
support for more features, we need to work with our UX experts to improve the overall approach. For
instance, using pop-ups all over the place is far from ideal.

Not to mention that, although we are using PatternFly, we try to stick to [EOS Design
System](https://www.eosdesignsystem.com/) principles, so we might need some help. 

## Asking for feedback

Now that you have something to try, it would be great if you share your opinion with us. You can
contact us through [GitHub project's page](https://github.com/yast/d-installer) or, as usual, in our
#yast channel at [Libera.chat](https://libera.chat/).

{% include blog_img.md alt="Installation finished"
src="congratulations-mini.png" full_img="congratulations.png" %}

Have a lot of fun!
