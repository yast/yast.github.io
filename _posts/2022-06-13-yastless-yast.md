---
layout: post
date: 2022-06-13 06:00:00 +00:00
title: YaST in a YaST-less system
description: Learn how you can take advantage of YaST capabilities in any system thanks to
  containers
permalink: blog/2022-06-13/yastless-yast
tags:
- Distribution
- Factory
- Programming
- Systems Management
- YaST
---

The fifth chapter for 2022 of the regular development reports from the YaST Team is on its way. We
are just ironing up some details while we wait for the videos of the recent [openSUSE Conference
2022](https://events.opensuse.org/conferences/oSC22) to be online. But fear not, we will not
meanwhile abandon you into boredom. Quite the opposite, we have exciting news to share with you all!

## Enjoy YaST Without Installing it {#intro}

We all know how awesome YaST can be for administering your (open)SUSE system. From managing the
software repositories and the installed software to adjusting the systemd services and sockets. From
creating LVM logical volumes to configuring Kdump (or `fadump`). From inspecting the systemd journal
to fine-tuning the boot loader. From configuring network interfaces to adjusting the mitigations for
CPU vulnerabilities. From setting the firewall configuration to managing your subscriptions to the
different SUSE products... and so much more!

But all that comes with a pretty obvious price. You must install YaST and all its dependencies in
the system you want to manage. Those dependencies include the Ruby runtime, either `ncurses` or `Qt`
(depending if you want the text-based or the fully graphical interface) and some other packages or
libraries depending on what you want to achieve. For example, you need `libzypp` to install software
or to manage the repositories.

What if you don't want to pay that price? Well, we have an special offer for you! Now you can use
YaST to administer your system without installing YaST or any of its dependencies. Ideal for lovers
of minimal systems like the [MicroOS](https://en.opensuse.org/Portal:MicroOS) variants of SUSE and
openSUSE. All you need is a container engine like Docker or Podman... and you are using one anyways
if you are using MicroOS, isn't it?

## How does it Work?

Another great news is that there is no black magic involved, just a bit of shell scripting. You can
check the technical details at the [yast-in-container
repository](https://github.com/yast/yast-in-container). That tool only depends on Podman (or
alternatively Docker) and offers a series of commands that are equivalent to the corresponding
`yast` and `yast2` command. The main difference is that those new commands grab YaST and run it in a
container that will be transparently used to administer the host system. For example, the following
commands would open the corresponding YaST module to manage repositories. The first in text mode and
the second command with the full Qt graphical interface:

```
$ yast_container repositories
$ yast2_container repositories
```

As you would expect, if the commands are executed without specifying any argument they will open the
corresponding version of the YaST control center, displaying only the modules that are currently
expected to work in a container (more about that below).

Let's imagine a pretty extreme example:

* You start with a minimal system with no YaST, no Ruby, no zypper or libzypp... not even with the
  `rpm` command being available! All you have is Podman and internet access.
* You can execute `yast_container` and it will download (if needed) and launch your containerized
  version of YaST, so you can enjoy all the usual YaST features to manage repositories and their GPG
  keys, to install and uninstall software, etc.
* When you are done, you just quit the contanerized YaST and you are back to your minimal system
  without a trace of YaST or zypper, but with all software packages and repositories configured
  at your will.

## Remote Access Through SSH, X11... or a Web Browser!

You can of course use this nice YaST-in-a-box to manage your local system. If you install
the `yast-in-container` package in a system with graphical interface you will even get a nice icon
to launch it.

{% include blog_img.md alt="YaST container menu item (in SLES Gnome)"
src="icon.png" %}

But what about remote administration? Of course, you can do it in the usual YaST way. That is, using
the great text-based interface through SSH or even opening a remote graphical session with X11 or
VNC. But those solutions require you to have some specific software installed in the device you are
going to use for the remote access. But, if you don't need to install YaST in the system to be managed,
why would you need to install something on the other edge? The good news is that you don't really
need to - you only need a web browser!

Alongside the already mentioned commands to run YaST containerized on text and graphical modes, the
package also includes a third one called `yast2_web_container` that will run YaST in a web session
that you can later access by simply pointing your browser to the port 4984 of the system to be
managed.

{% include blog_img.md alt="YaST control center running in a web browser"
src="browser-mini.png" full_img="browser.png" %}

Ok, is not a modern mobile-first web interface but rather the graphical version of YaST running
inside a browser window. But that should be enough for many cases. Authentication and certificates
can be easily configured to secure that YaST instance.

## What can I do?

By now you may be wondering - can this containerized version of YaST do everything a regular
installed YaST can do? The answer is - _not yet_. As mentioned, the YaST control center in the
container displays only the supported modules. Alternatively you can run `yast2_container -l` to
list the supported modules.

The good news is that we plan to adapt more modules to be able to work in such an environment. And
the even better news is that we expect most of them to be really easy to adapt.  Basically all the
YaST pieces that are used during a regular installation should be fairly easy to adapt. That
includes the Partitioner, boot loader configuration, kdump, CPU mitigations and many more.

On the other hand, we don't plan to adapt every single YaST module out there. For example, modules
to administer services like Samba, an iSCSI target or the DHCP server will likely not be adapted
unless we detect a real need for any of them.

## Future plans

As mentioned, we are already adapting more YaST components to be able to run containerized. But
that's not the only plan we have to move this nice project forward. We also want to reduce the size
of the images downloaded and used by the containers, improve how VNC is used internally to provide
the web access, rely on [SLE BCI](https://www.suse.com/products/base-container-images/) to build the
whole system... there is plenty of room to keep having fun!

In addition, we have mentioned the MicroOS variants as possible candidates to make use of a
containerized version of YaST. But the transactional nature of such distributions may challenge how
some YaST modules work, no matter whether they run containerized or directly in the system.
For example, the way to install software packages is completely different. So, in addition to the
mentioned improvements to our containerized YaST, we are considering to adapt some parts of YaST
as a whole to better handle the administration of transactional systems.

And, of course, we will keep you updated on all the steps through our usual channels. So stay tuned!
