---
layout: post
date: 2018-02-09 15:04:17.000000000 +00:00
title: Highlights of YaST Development Sprint 50
description: Sprint 50 is finished and we are ready to share with you all the highlights
  of this last sprint!
category: SCRUM
tags:
- Systems Management
- YaST
---

We are close to finishing features for the new SUSE Linux Enterprise 15,
so this time we came up with a lot of information about the new storage,
partitioner, firewall enhancements, and roles, which now is also present
for the Desktop version of SUSE Linux Enterprise. Besides that, we
fought another issue regarding memory consumption in Tumbleweed
installation and once again we were able to solve it. So, let’s take a
look into details!

### Filesystem type specific default mount options in /etc/fstab are back

We reimplemented another feature that was still missing with the rewrite
of the YaST storage stack: Reasonable mount options in */etc/fstab* that
may be different for each filesystem type. For example, for an Ext4
filesystem we used to set options `data=ordered,acl,user_xattr` by
default. Of course, you can still change those options in the
partitioner if the defaults don’t work well for you.

For most filesystem types, this was straightforward: Just filling a
table with fixed default options. But for some others, most notably the
legacy Microsoft filesystem types FAT/VFAT, this involved some
not-so-trivial heuristics to figure out locale data so we could provide
reasonable values for `iocharset=...` and `codepage=...`; those are
necessary to recode filenames with non-ASCII international characters
between whatever a MS Windows system might use and Linux; otherwise, you
might not even see those files when mounted on a Linux system.

###  Resurrected sections in the Expert Partitioner 

We keep bringing the functionality from the old Partitioner back to the
Storage-ng reimplementation. During this sprint, it was the turn of the
NFS and Device Graph sections.

The NFS case is a little bit special from the technical point of view
since it’s the only section not managed directly by the Expert
Partitioner. Instead, an embedded version of `yast2-nfs-client` is
executed when visiting that section. The same approach has been followed
in this reimplementation, which means NFS is the only section in which
the old Partitioner and its Storage-ng clone will offer an absolutely
identical experience and behavior (including both features and bugs).
Just a heads-up: NFSv4 support is still not fully functional in
`libstorage-ng`, so the check-boxes about the NFS version may be ignored
until that support reaches your distribution.

{% include blog_img.md alt=""
src="nfs-300x177.png" full_img="nfs.png" %}

On the other hand, the “Device Graph” section was, as most of the new
Partitioner, rewritten from scratch. In addition to the already known
graph showing how the system is going to look after applying the
changes, it includes now a representation of the current system in a
separate tab. Both graphs are interactive, double-click on any node
takes the user to the corresponding section of the Partitioner.

{% include blog_img.md alt=""
src="device_graphs-300x177.png" full_img="device_graphs.png" %}

As you can see in the previous screenshot, the usual button to export
the graph to Graphviz format is not alone anymore. Its new friend allows
exporting the graph to the very detailed XML format used by the YaST
Team to reproduce test scenarios.

Of course, the “Device Graph” section is not available if using the
text-based ncurses interface, as you can see comparing the left part of
the following screenshot with the previous one.

{% include blog_img.md alt=""
src="exp_ncurses-300x188.png" full_img="exp_ncurses.png" %}

###  Partitioner: LVM thin provisioning 

Our new Expert Partitioner was already able to manage LVM volume groups
and logical volumes since several weeks ago. But now it also recovers
its great ability to work with LVM thin pools and volumes. LVM thin
provisioning is a powerful technology, very useful in cases where you
need to administrate storage resources for a large group of users.
Basically, thin provisioning allows you to provide more storage space
than it is actually available in the system. You can increase the real
hardware storage only when it is really required. For more information
about LVM thin provisioning, you can find a great guide in [this
link][1].

With the Expert Partitioner, you can create a thin pool over a LVM
volume group in a similar way you create a normal logical volume. You
only have to add a new logical volume and check the “Thin pool” option
in the first dialog. Once the volume group contains at least a thin
pool, you will be able to create thin volumes. Once again, the process
is exactly the same. Add a new logical volume and select “Thin volume”
option and in which pool to create it. The rest of steps are exactly the
same as for creating a normal logical volume.

{% include blog_img.md alt=""
src="exp_partitio-300x208.png" full_img="exp_partitio.png" %}

Apart from creating new thin pools and volumes, options for editing,
resizing and deleting are now also available for all kind of logical
volumes: normal volumes, thin pools and thin volumes. In the case of
resizing a thin pool, you will be warned when the resulting pool is
overcommitted. Take a look at the following screenshot.

{% include blog_img.md alt=""
src="resize_lvm-300x208.png" full_img="resize_lvm.png" %}

###  Adapting partitions and logical volumes sizes in AutoYaST

In older versions, when the proposed partitioning in a profile and it
did not fit in the disk, AutoYaST tried its best to reduce the biggest
partition. A typical use case was to set the root (/) partition to a
huge value, so the profile could be used in systems with different disk
sizes (as AutoYaST will take care of reducing that partition to make it
fit). To be honest, the best solution in that scenario would be to set
the size to `max`, so AutoYaST will do what’s expected.

However, if for any reason the wanted layout does not fit, AutoYaST is
now smarter about what to do: instead of blindly reducing the biggest
one, it will try to reduce all partitions in a (kind of) proportional
way, informing the user about the new sizes.

{% include blog_img.md alt=""
src="autoyast_lvm-300x225.png" full_img="autoyast_lvm.png" %}

###  Small behavior change in AutoYaST installation

Up to now, not installable packages have been ignored silently by
AutoYaST, which has been defined in the AutoYaST configuration file.
From now on, the user will be informed that these packages cannot be
installed.

### System roles for SUSE Linux Enterprise Desktop 15

SUSE Linux Enterprise uses system roles to define, during the
installation process, the packages to install on the system, so it can
have the necessary software to play its “role”. This feature was already
available for SUSE Linux Enterprise Server and now it is also available
for SUSE Linux Enterprise Desktop. In order to choose a specific role
for your system, you need to select a module or extension which contains
this role during the installation process. There are four available
roles for Desktop:

* GNOME Desktop (Wayland): available when Desktop Productivity (on SLED)
  or Workstation Extension are selected.
* GNOME Desktop (X11): available when Desktop Productivity (on SLED) or
  Workstation Extension are selected.
* GNOME Desktop (Basic): available when the Desktop Application module
  is selected.
* IceWM Desktop (Minimal): available when Basesystem module is selected.

### Firewalld enhancements

During the last sprints, our team has been working hard in the
integration of firewalld with AutoYaST and with the CWM library for
opening ports / services in our different modules (http-server, squid,
dns-server etc..). Here are some changes we did during this last sprint:

**YaST firewall module is discontinued**

As we now adopted firewalld in our distribution, there is no more
reasons to have a YaST module for the firewall. Therefore, as you may
see [here][2], we discontinued the YaST Firewall module and we recommend
to use firewall-config to configure your firewall via a user interface
or firewall-cmd for the command line.

**AutoYaST**

A new AutoYaST schema has been defined for firewalld configuration
although the features supported are very limited.

We can configure properties like the default zone, the service state,
the type of packages to be logged and zones specific configuration like
interfaces, services, ports, protocols, and sources.

For example, a SuSEFirewall2 based profile defining some interfaces,
services, and ports in the EXT zone like this one:

```xml
<firewall> 
  <enable_firewall config:type="boolean">true</enable_firewall>
  <start_firewall config:type="boolean">true</start_firewall>
  <FW_DEV_EXT>eth0</FW_DEV_EXT>
  <FW_SERVICES_EXT_TCP>443 80 8080</FW_SERVICES_EXT_TCP>
  <FW_SERVICES_EXT_UDP>21 22</FW_SERVICES_EXT_UDP>
  <FW_CONFIGURATIONS_EXT>dhcp dhcpv6 samba vnc-server</FW_CONFIGURATIONS_INT>
</firewall>
```

will be translated to something like this:

```xml    
<firewall>
  <enable_firewall config:type="boolean">true</enable_firewall>
  <start_firewall config:type="boolean">true</start_firewall>
  <default_zone>public</default_zone>
  <zones config:type="list">
    <zone>
      <name>public</name>
      <interfaces config:type="list">
        <interface>eth0</interface>
      </interfaces>
      <services config:type="list">
        <service>dhcp</service>
        <service>dhcpv6</service>
        <service>samba</service>
        <service>vnc-server</service>
      </services>
      <ports config:type="list">
        <port>21/udp</port>
        <port>22/udp</port>
        <port>80/tcp</port>
        <port>443/tcp</port>
        <port>8080/tcp</port>
      </ports>
    </zone>
  </zones>
</firewall>
```

{% include blog_img.md alt=""
src="ay_firewall-300x176.png" full_img="ay_firewall.png" %}

SuSEFirewall2 based profiles will continue working although limited to
the configuration currently supported by YaST.

During the autoinstallation, an error will be shown if the profile has
some property not supported, however, we will able to continue with the
installation and also a warning will be shown suggesting the use of the
new schema even when all the properties are translatable.

**Opening ports / services in zones through interfaces selection**

In YaST, CWMFirewallInterfaces module provides a set of widget
definitions for opening services in zones through a selection of
interfaces (each interface belongs to a ZONE).

{% include blog_img.md alt=""
src="CWMFirewallInterfaces-300x44.png" full_img="CWMFirewallInterfaces.png" %}

{% include blog_img.md alt=""
src="CWMFirewallInterfaces_-300x156.png" full_img="CWMFirewallInterfaces_.png"
%}

The module has been adapted to work properly with the new firewalld API.

If a *firewalld service* is not defined (probably because the package
shipping the service definition has not been adapted yet), then the
*CWMFirewallInterfaces* widget will show a list of missing services
suggesting to deploy them to be able to configure the firewall.

### Move from Xinetd to Systemd sockets

As requested by our friends from packages, now the future of starting
service on demand is systemd sockets instead of xinetd. There are
multiple reasons for that, but for us the most important one is that we
can concentrate in one thing and do it properly.

It’s hard to support different ways to start services on demand and
especially to handle such a situation when a user can set it up with
sockets. Our old approach to make it happen was to set up the start of
services on demand with xinetd. However, this approach is really hard to
debug. Besides this problem, we also would like to unify our approach
with the one suggested by packagers people.

So what have we done in this last sprint? The goal was to do some
research, to create a proof of concept on one specific module and to
find potential obstacles when unifying approaches to start services on
demand. We found out that the conversion from xinetd to systemd sockets
is quite easy, but also cannot be done automatically. Basically, what we
need to do is to use systemctl call (which we already support) to
activate the socket that is provided by the package instead of our old
approach, which is to write a file into /etc/xinetd.d/ and to reload
xinetd. Such a change will make our life much easier than previously.

The hardest part is that xinetd configuration file also often contains
the service configuration that YaST can and would like to modify. This
is no longer possible with systemd sockets and it is also the reason
that we cannot automate this conversion.

So how will we proceed with the conversion of the YaST modules? We first
checked all modules that use xinetd and we verified that, for the
majority, the conversion is straight-forward. YaST also has a module for
inetd configuration, which no longer makes sense, so the plan is to drop
it in the near future and to allow socket activation in services manager
module.

A problematic module is ftp-server, which supports two backends: vsftp
and pure-ftp. This is problematic because pure-ftp does not support
systemd-sockets, only xinetd. We plan to discuss how to handle it, as we
are also not happy that we support two backends, because it makes the
life of our users harder when they just want to quickly configure a ftp
server. For SLE users we already support only vstftp, so if we agree on
it, we will probably also support only this server in YaST. But right
now nothing is set in stone.

### Memory eating strikes again

Once again we have to mention our battle with memory consumption. This
time the problem happened within the NET iso for Tumbleweed, which
should need no more than 1 GiB of memory during the installation
process.

In the beginning of our research, we had no suspicious code to look at,
we just knew that it could be related to the fact that the NET iso was
using the whole repository of Tumbleweed (over 60k packages) while the
DVD iso uses only a subset of packages.

So which technique did we use to find the problematic part of the code?
We changed logging in order to append the memory status of the whole
process to each log line. By using this approach we quickly identified
the problematic part of the code. This problematic code was responsible
only for logging, but as it was searching for all packages and loading
all packages properties, it was consuming a huge amount of data and
causing this memory issue.

As a hotfix, we removed this logging from packages and kept it only for
patterns and products, which is more important for us and has low memory
consumption. We also looked into all code that searches through all
packages properties and we reduced it as much as we could. Finally, we
forced the Ruby garbage collector to run before the processes of disk
preparation and rpm installation, reducing the chances that the memory
consumption of the installation process goes up.

Once again we had a happy end and we are now able to install the NET iso
with 1 GiB of memory when using the graphical installer.

### Concluding

As we’re getting closer to finish SLES 15, we’re getting busier and
busier with features and bugs to finish. Therefore, YaST team is already
working hard on Sprint 51 and we’re looking forward to come back to you
in two weeks with much more cool stuffs that we’re doing. Meanwhile,
have fun and stay tuned!



[1]: https://storageapis.wordpress.com/2016/06/24/lvm-thin-provisioning
[2]: https://github.com/yast/yast-firewall/blob/master/README.md
