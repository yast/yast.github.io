---
layout: post
date: 2017-10-11 15:17:49.000000000 +00:00
title: Highlights of YaST Development Sprint 44
description: Here is the YaST team again with a new report from the trenches, this
  time with a small delay over the usual two weeks.
category: SCRUM
tags:
- Systems Management
- YaST
---

Most of the team keeps focused on the development of the upcoming SUSE Linux
Enterprise 15 products family, including openSUSE Leap 15. That means finishing and
polishing the new storage stack, implementing the new rich ecosystem of
products, modules, extensions and roles (one of the biggest highlights
of the SLE15 family) and much more. So let’s dive into the most
interesting bits coming out of the sprint.

### Hostname configuration during installation

And let’s start with one of those stories that illustrate the complexity
hidden below the user-oriented YaST surface. During installation is very
common to assign a *hostname* to the machine being installed to identify
it clearly and unequivocally in the future.

Usually it is a fixed hostname (stored in `/etc/hostname`) but in some
circumstances is preferable to set it dynamically by DHCP. Since some
time ago (as you read in [a previous report][1] and is shown in the
image below) YaST allows to set the hostname selecting a concrete
interface or with a system-wide variable named `DHCLIENT_SET_HOSTNAME`
which is defined in `/etc/sysconfig/network/dhcp`. The value to be set
for such variable during installation can be optionally read from the
distribution [control file][2]. Last but not least, as you already know,
[Linuxrc][3] can also be used to enforce a particular network
configuration.

{% include blog_img.md alt="YaST DHCP configuration with several network interfaces"
src="yast-dhcp-ifaces-300x225.png" full_img="yast-dhcp-ifaces.png" %}

Most users have a simple setup that works flawlessly, but we recently
got a bug report about a wrong network configuration after installing
the system if the hostname configuration was set via Linuxrc. After some
research we found that the value of `DHCLIENT_SET_HOSTNAME` coming from
the control file was overwriting the Linuxrc configuration at the end of
the installation. Now it’s fixed and the global variable will be set by
the [linuxrc sethostname option][4] if provided or loaded from the
control file if not. And all that happens now at the very beginning of
the installation to give the user to chance to modify it and to ensure
the user’s choice is respected at the end.

{% include blog_img.md alt="Setting hostname in Linuxrc"
src="linuxrc-network-300x225.png" full_img="linuxrc-network.png" %}

Take into account that with multiple DHCP interfaces the resulting value
for `DHCLIENT_SET_HOSTNAME` is not fully predictable. Hence, in that
scenario we recommend to explicitly select the interface which is
expected/allowed to modify the hostname.

### Extending the installation process via RPM packages

As we have mentioned (a couple of times) during latest reports, we are
implementing multi-product support for the installer. It means that SUSE
will ship several products on a single installation media.

One interesting feature is that products, modules and extensions can
define its own installation roles. For instance, if you select the
desktop extension, you will be able to select GNOME as system role.

During this sprint, we have improved roles definitions handling,
displaying a different list of roles depending on which product was
selected.

As a side effect, we added support for sorting roles assigning them a
display order.

### Getting Release Notes from the Installation Repository

As part of our effort to drop SUSE tags from the installation media, we
improved the way in which release notes are handled during installation.

Release notes are downloaded from openSUSE or SUSE websites in order to
show always the latest version. Of course, the installation media
includes a copy of them, which may be outdated, to be used when there is
no network connection.

From now on, instead using some additional files, this offline copy of
release notes will be retrieved from the release-notes package which
lives in the packages repository. So we do not need to ship additional
files containing release notes in the installation media anymore.

Moreover, although the old approach worked just fine in almost all
cases, there was an uncovered scenario. Let’s consider a system which
have access to an updated packages repository but is not connected to
Internet. That could be the case, for instance, if you are using SUSE
Subscription Management Tool (SMT). With the new approach, the installer
will get release notes from that repository instead of displaying the
(potentially outdated) ones included in the installation media.

Additionally, we refactored and clean-up a lot of old code, improving
also test coverage.

### Storage reimplementation: bringing more features back

We are also working hard to make sure the brand new `yast2-storage-ng`
includes all the features from `yast2-storage`, in addition to the new
ones. That means that, after this 44th sprint, SLE15 is already able to
perform the following operations using the new module.

* Creating [MD software RAID devices][5] in the expert partitioner. This
  feature is specially relevant for many openQA tests that rely on it.
* Displaying the compact description of the partitioning proposal in the
  one-click-installer screen used by SUSE CaaSP and openSUSE Kubic
* Importing users and SSH system keys from a previous (open)SUSE
  installation.

{% include blog_img.md alt="One-click-installer view on SUSE CaaSP 4.0 (yast2-storage-ng)"
src="casp-4.0-overview-300x187.png" full_img="casp-4.0-overview.png" %}

### Rethinking LVM thin provisioning

When trying to create a thin-pool using all free space the metadata has
to be accounted for. In contrast to linear LVs the metadata for
thin-pool uses space of the VG. For instance, if there are 2048 GiB free
in the VG, the metadata for a maximal size thin-pool is about 128 MiB
and the pool can be about 2047.9 GiB big.

Additionally LVM creates a spare metadata with the same size. This spare
metadata is shared between all pools and thus has the size of the
biggest pool metadata. The spare metadata can be deleted manually and
all pool metadata can also be resized.

When starting with an empty VG it is relative easy to account for the
metadata. But how to handle this with an already existing volume group?
Also take into account a volume group containing e.g. RAID LVs or cache
pools (which also have metadata).

We finally decided that, during probing, YaST will check how much free
space the VG has and then it will calculate “reserved” value for the
volume group:

    
    reserved = total size - used by LVs the library handles - free

So when calculating available space for a normal or thin pool, it will
take the “reserved” into account:

    
    max size = total size - reserved - used by LVs the library handles

The only drawback is that the maximal size for the pool can be smaller
than actually possible since e.g. the spare metadata might be shared
with an already existing thin pool.

### More to come

The 45th sprint has already started and you can expect more and more
work in the installer for SLE15 and openSUSE Leap 15 and more news
regarding the revamped storage stack. Meanwhile, don’t forget to have a
lot of fun!



[1]: {{ site.baseurl }}{% post_url 2016-12-02-highlights-of-yast-development-sprint-28 %}
[2]: https://github.com/yast/yast-installation/blob/master/doc/control-file.md
[3]: https://en.opensuse.org/SDB:Linuxrc
[4]: https://github.com/openSUSE/linuxrc/blob/54b5069f5edccfd895526c0469a81f765457e3ab/linuxrc_yast_interface.txt#L140
[5]: https://en.wikipedia.org/wiki/Mdadm
