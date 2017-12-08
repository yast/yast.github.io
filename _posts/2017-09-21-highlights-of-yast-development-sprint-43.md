---
layout: post
date: 2017-09-21 14:38:56.000000000 +00:00
title: Highlights of YaST Development Sprint 43
description: The summer is about to end (in Europe) and it is time for another YaST
  Development Sprint report.
category: SCRUM
tags:
- Systems Management
- YaST
---

As usual, storage-ng has been one of the stars of the show, but new installer
features for upcoming SUSE/openSUSE versions have received a lot of attention too.
Also CaaSP 2.0 got some love from us during this sprint.

## storage-ng: Udev mapping and ARM64 support

The new storage layer is getting better everyday. After the big amount
of work that came with the re-implementation, the team is trying to
unleash the power of the new design.

### Udev Mapping is Back

The bootloader module supports using persistent device names provided by
Udev. It is a pretty useful feature that comes in handy in many
situations but it was missing in the storage-ng based version of the
module.

But fear not: this feature has been re-implemented taking advantage of
the much improved API of the new storage layer. And that’s not all: the
team also took this opportunity to clean up some code and document the
strategy for picking Udev device names in a proper way.

Do you want more details? Here you have them. Let’s start with the
scenarios we support:

* S1: Disk with the booting configuration is moved to different machine
* S2: Disk dies and its content is loaded to new disk from a backup
  (because you have a backup, right?)
* S3: Path to disk breaks and is moved to different one

Given these scenarios, let’s have a look at the strategies:

* If the device has a filesystem with its `mount_by`, do not change it.
* If the device names includes a `by-label`, just use it. This behaviour
  enables us to handle the three scenarios.
* If there is `by-uuid`, then use it. It can also handle the three
  scenarios.
* If there is `by-id`, use it. It can handle S3, but not always.
* If there is `by-path`, just use it. It is the last supported Udev
  symlink and, at least, it will prevent the name changing during boot.
* As fallback, just use the kernel name (for instance, `/dev/sda3`).

### storage-ng now works also on ARM64

For quite some time, the storage-ng code has been tested (and worked) on
*x86\_64*, *ppc64* and *s390x* architectures. Now, we have added
`aarch64` to match the list of supported architectures in SUSE Linux
Enterprise and openSUSE Leap.

## Speeding up the Service Manager Startup

As you may know, YaST includes a nice module for managing systemd
services. Compared to `systemadm`, included in the `system-ui` package,
there are some key differences:

* It displays only services, not other unit types such as sockets.
* It can enable/disable them for the next boot.
* It works, as any YaST module, in textmode (even on 80×25 terminals).

Some time ago we got a report that the presented information was
inaccurate in some corner cases. We fixed that but also made the module
a lot slower at the same time. It did not take long for that to be
reported.

We tested the following scenario: 286 services (SUSE Linux Enterprise 12
SP3 with nearly all software patterns installed) on a not very fast
virtual machine. Normally, you should have fewer services and probably a
faster system, but we wanted to fix the issue even for the worst
scenario.

After analyzing the problem, we found out the root cause: too many calls
of `systemctl`, at least 3 times per service (`show`, `is-active`,
`is-enabled`). With a couple dozen milliseconds per call, it quickly
adds up.

The fix was to combine all show calls into one and correctly
interpreting the `ActiveState` property to eliminate all of the
`is-active` calls. But you want to know the numbers, right? After the
fix, the startup time went down from 69 to 15 seconds (bear in mind that
it is a slow virtual machine).

So even if your system is not that slow or you have fewer services
installed, you may benefit of a shorter startup time for this module.

## Multi Repository Media

There are some hidden gems in YaST that are maybe not well known
although they have been there for a long time. One of those features is
support for multi repository media.

What actually is a multi repository medium? Imagine a CD or DVD with
several independent repositories. The advantage is that, if you want to
release several add-ons, you can put them all on a single DVD medium.
Really nice stuff, isn’t it?

Up to now YaST added all repositories found on the medium automatically
without any user interaction. In this sprint we have added a new dialog
into the workflow which asks the user to select which repositories
should be used. Of course, if there is only one repository, it does not
make sense to ask and the repository is added automatically.

{% include blog_img.md alt="Selecting which add-ons should be installed"
src="extension-and-module-selection-300x188.png"
full_img="extension-and-module-selection.png" %}

## i18n support for CaaSP 2.0

{% capture img_path %}/assets/images/blog/{{ page.date | date: "%Y-%m-%d" }}/{% endcapture %}

On June 2017, SUSE [released][1] the first version of the promising
[SUSE CaaS (Container as a Service) Platform][2]. The YaST team actively
worked on this project by adding several new features to the installer,
like the [one-dialog installation screen](
{{ img_path | append: "worker.gif" | relative_url }}).

That very first version of CaaSP was only available in English. However,
version 2.0, which is around the corner, will support more languages.
For the YaST team, it means that we needed to add the language selector
to the  
 installer, as you can see in the screenshot below, and to mark every
string in the `yast2-caasp` for translation.

{% include blog_img.md alt="YaST2 CaaSP features a language selector"
src="caasp2-language-300x221.png" full_img="caasp2-language.png" %}

Finally, if you are interested in CaaSP, maybe you would like to check
out [Kubic][3], its Tumbleweed based variant.

## More bug fixes

Apart from the new and shiny stuff, the YaST team was able to fix quite
some issues during this sprint. Let’s have a look at some of them.

### Taking Care of Small Details

{% include blog_img.md alt="Not enough space for device name"
src="yast2-bootloader-long-device-names-broken-300x196.png"
full_img="yast2-bootloader-long-device-names-broken.png" %}

Usability is a critical point for a project like YaST. From time to
time, we receive a bug report about some usability problem that needs to
be addressed and we took them very serious. In this case, the bootloader
module had a problem when showing long device names in the dialog to
change the order of disks. So we just needed to do a minor fix in order
to ensure that there is enough space.

{% include blog_img.md alt="Device name is shown properly"
src="yast2-bootloader-long-device-names-300x196.png"
full_img="yast2-bootloader-long-device-names.png" %}

Please, keep reporting usability related issue you find in order to make
YaST even better.

### Fixing the INSECURE mode

It sounds scary, but YaST supports an *insecure* mode during
installation. What does it mean? YaST is pretty flexible when it comes
to system installation. You, as a user, has the power to modify/tweak
the installer (using a Driver Update Disk), add custom repositories,
etc. And sometimes it can be useful to skip some checks.

Some time ago, *libzypp* introduced a new callback to inform about bad
(or missing) GPG signatures. This callback was properly handled by
AutoYaST but it was ignored in regular installations, so the user always
got the warning about the failing signature, even when running on
insecure mode.

Now the problem has been fixed and you can run the installer in
*insecure* mode if you want to do so.

### Learning about FCOE

YaST deals with a lot of moving parts and, although it can be daunting
for the newcomer, it also has a bright side: we regularly learn new
stuff to play with.

In this case, Martin Vidner, one of our engineers, had to deal with a
fix related to the [Fibre Channel over Ethernet][4] support in YaST. But
instead of blindly applying the patch that we already had, Martin
decided to learn more about the topic sharing [his findings][5] in its
own blog. Sure it will be a valuable resource to check in the future.



[1]: https://www.suse.com/newsroom/post/2017/suse-caas-container-as-a-service-platform-makes-applications-easy-to-run-customers-more-agile/
[2]: https://www.suse.com/products/caas-platform/
[3]: https://news.opensuse.org/2017/05/29/introducing-kubic-project-a-new-open-source-project/
[4]: https://en.wikipedia.org/wiki/Fibre_Channel_over_Ethernet
[5]: http://mvidner.blogspot.com.es/2017/09/fibre-channel-over-ethernet-basics-of-fcoe.html
