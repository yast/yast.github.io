---
layout: post
date: 2017-12-07 15:00:09.000000000 +00:00
title: Highlights of YaST Development Sprint 47
description: 'On the night of December 5th, teams of three are sprinting through the
  streets of Czech towns, visiting homes: Mikuláš (the developer), čert (the scrum
  master), and anděl (the product owner).'
category: SCRUM
tags:
- Systems Management
- YaST
---

On the night of December 5th, teams of three are sprinting through the
streets of Czech towns, visiting homes: Mikuláš (the developer), čert
(the scrum master), and anděl (the product owner). If you’ve been a bad
kid, you will get pieces of coal or brown potatoes. Good kids, on the
other hand, will get new YaST features:

* Performance: adapting to jemalloc, a better Ruby memory allocator
* Replaced components: s/ntpd/chrony/g s/SUSEFirewall2/firewalld/g
* Storage: resizing partitions, resizing RAID
* Software modules and extensions: preselecting them, resolving
  dependencies automatically, creating your own installation ISO with
  mksusecd
* Security related: tarballs for reproducible builds, SSH keys for root
* AutoYaST: asking for a disk

## Performance

### Using Jemalloc Memory Allocator in Ruby

The MRI Ruby (the original C implementation) interpreter allows using
the [jemalloc][1] library for allocating the memory instead of the usual
glibc default. The advantage is better memory usage (30-40% less used
memory was reported [here][2]) and it has some extra debugging features.

But after enabling this feature in Ruby in openSUSE Factory and SLE15
many YaST packages failed to build. It turned out to be an issue caused
by dynamically loading the library by YaST. A workaround was to directly
link the YaST against libjemalloc.

Later we found out that some packages still do not build. This time the
problem was caused by a warning printed by the library on the error
output. That happened only when running the old YaST test suite which
still uses an embedded Ruby interpreter (normal YaST usage or the new
unit tests use full Ruby which does not have this problem). The fix was
just to ignore that warning when checking the error output in the tests.

If you want to check whether your Ruby uses the jemalloc feature then
run this command:

```console
ruby -r rbconfig -e "puts RbConfig::CONFIG['LIBS']"
```

If the output includes the `-ljemalloc` option then your Ruby is using
the jemalloc library.

## Replaced Components

### Switching NTP from ntpd to chrony

It was decided that it is a good time now to switch the Network Time
Protocol (NTP) implementation from ntpd to chrony as it is more secure,
nicer and [better][3]. So also YaST has to adapt and modify its NTP
client module to work with chrony. The module also shows its age and it
is a bit hairy, so we took the opportunity to do some cleaning.

The most visible change is the UI on the running system. Please note
that the UI is not final yet and it is mostly just a proof of concept.
But the goals are clear: The first goal is to be really client only, as
previously NTP also allowed to configure an NTP server, making the UI
complex and confusing for the majority of users that just want to select
a server to sync against. The second goal is to focus on the majority of
users who want a simple UI to configure a common NTP client, leaving
fine tuning for experts who modify configuration files directly.

In the installer, chrony is now called instead of ntpdate. This change
is invisible to users and it simply works the same as previously.

We also decided to drop the command-line interface (CLI) of the NTP
client module as chrony itself comes which a nice CLI `chronyc`. Instead
of duplicating the work our CLI just suggests to use `chronyc`.

Please also note that changes are not finished yet and more will come.
One of such changes is AutoYaST support, which is currently just
skipped. But let us show you some pictures to get an idea how it will
look soon in Tumbleweed and explain our decisions along the way:

The first image is from the main screen. It shows three main areas:

1.  The way the time is synchronized. It allows a pure manual run,
    synchronizing in a given interval or using the daemon that runs
    always.
2.  Configuration of sources for synchronization servers. It can be
    dynamic or static. For static, only the ones in the servers table
    (see point 3) are used. For dynamic, it also adds NTP servers from
    the network (like ones from DHCP). So when the user uses only public
    servers, the static configuration works well. But when internal NTP
    servers are used and they can change, then using the dynamic option
    makes sense.
3.  A list of synchronization servers. This specifies a statically
    defined list of NTP servers to sync against. You can use the
    familiar *Add/Edit/Delete* buttons.

{% include blog_img.md alt="Main NTP settings"
src="s47-1-300x226.png" full_img="s47-1.png" %}

The second image is from the *Edit* dialog. It was also simplified to
the most common options. The *Test* button allows a quick check if a
server is reachable and there are no typos in its address. The *Quick
Initial Sync* option is useful to synchronize time quickly when
connected to network. And *Starting Offline* is a nice chrony feature
that allows to define the server as offline during the start-up and only
when connected to the network to mark it as online and synchronize. It
greatly helps with boot time and is a good option for notebooks where
fast boot is important and the network is managed by Network Manager.

{% include blog_img.md alt="NTP Edit dialog"
src="s47-2-300x226.png" full_img="s47-2.png" %}

### Firewalld will be the default firewall in SLE15 (Installer adapted)

[Firewalld][4] has some nice advantages over *SuSEFirewall2*\: it can be
dynamically managed, permits more zones, has a separation between
runtime and permanent configuration options, it is well maintained, and
it is already supported in some applications or libraries.

These are some of the main reasons why it has been decided to replace
completely *SuSEFirewall2* with *firewalld*.

In [a past sprint report][5] we announced that yast-firewall was adapted
to support *firewalld*, but that was mainly an adaptation of the code to
supporting *both* backends.

During this sprint we have completely replaced *SuSEFirewall2* in the
installer using a new [firewalld API][6] and although the UI seems to
not have changed at all, the firewall dialogs have been completely
reimplemented using `CWM` [(our object-oriented API to YaST
widgets)][7].

{% include blog_img.md alt="Firewall proposal"
src="s47-3-300x225.png" full_img="s47-3.png" %}

{% include blog_img.md alt="Firewall/SSH settings"
src="s47-4-300x225.png" full_img="s47-4.png" %}

During next sprints we will continue adapting the *firewalld* API and
YaST modules to complete the replacement. The next target will be
supporting *firewalld* in AutoYaST.

## Storage

### Expert Partitioner: Resizing

The Expert Partitioner has regained the ability to resize partitions. A
*Resize* button is now available in the *Hard Disks* view as well as in
the view of either a particular disk or a specific partition. When you
try to resize a partition, a new dialog is shown with three options:
maximum size, minimum size and custom size.

{% include blog_img.md alt="Partitioner: Resizing"
src="s47-5-300x225.png" full_img="s47-5.png" %}

When the *Custom Size* option is selected, you have to specify manually
the new partition size, but do not worry, the Expert Partitioner will
prevent you from entering wrong sizes. Also, it will automatically align
the partitions for a better performance.

{% include blog_img.md alt="Partitioner: Resizing error"
src="s47-6-300x225.png" full_img="s47-6.png" %}

### Improvements in RAID management

As with partitions, it is now also possible to resize software RAIDs,
although in the case of RAIDs resizing is a completely different
operation performed by adding or removing devices to it. The partitioner
will ensure you have selected the minimum amount of devices necessary
for the current RAID type. Take into account that resizing a Software
RAID will be only possible for new RAIDs being created, that is, resize
action is not allowed when the RAID exists on disk.

{% include blog_img.md alt="RAID management"
src="s47-7-300x225.png" full_img="s47-7.png" %}

As you can see in that screenshot, buttons for sorting the devices
within a RAID have also been added at the right of the device list
during this sprint. Those buttons are available both when creating a new
RAID and when resizing it.

Last but not least, now it is also possible to work with BIOS RAIDs in
the same way you do with regular disks. You will find all BIOS RAIDs in
the *Hard Disks* section of the Expert Partitioner, where you could add
or remove partition to the RAID device.

## Software Modules and Extensions

### Preselecting Recommended Modules or Extensions

The SLE15 products were split into several repositories and the
installation medium contains only the minimal set of packages required
to boot the system. If you want to have something more then you have to
either register the system or use an additional medium.

To make that easier for users the registration module now pre-selects
the recommended modules or extensions. However, if you for some reason
really need a minimal system you can still deselect the pre-selected
items.

The list of recommended addons is maintained at the server side
([SCC][8]) so it is possible to change that without updating the YaST
installer.

### Adding Modules and Extensions in AutoYaST

The list of available modules and extensions for SLE15 is already quite
long as the base SLE15 products have been split into several modules.
That makes adding the modules from the registration server more
complicated compared to SLE12.

Originally the AutoYaST registered the addons in the XML profile exactly
in the specified order. And that made troubles because SCC requires the
dependent modules to be registered first. Writing the modules in the
correct registration order in the profile was not easy for SLE15.

To make it easier AutoYaST now automatically reorders the modules
according to their dependencies and even registers the dependent modules
which are missing in the profile. Obviously that works well only if the
missing module does not require a registration key.

### mksusecd and linuxrc Supporting the New Media Layout

Starting with SLE15 the installation media have a slightly different
layout. In short: the `content` file that was holding information about
the product and a list of checksums is gone and has been replaced by
`.treeinfo` and `CHECKSUMS`. Also, the package repository is now a
repomd repository.

Also, SLE15 has been split into several so-called modules. The
installation medium itself contains only a minimal set of packages. You
have to register during the installation process to access other modules
or use a separate medium containing them.

To save you from carrying several USB sticks around, [`mksusecd`][9]
lets you build your own customized installation medium.

First, check what is on the media. The installation iso has just the
base product:

```console
# mksusecd --list-repos SLE-15-Installer.iso
Repositories:
  SLES15 [15-0]
```
and you need an extra image for the modules:

```console
# mksusecd --list-repos SLE-15-Packages.iso 
Repositories:
  Basesystem-Module [15-0]
  Desktop-Productivity-Module [15-0]
  Desktop-Applications-Module [15-0]
  Development-Tools-Module [15-0]
  HA-Module [15-0]
  HPC-Module [15-0]
  Legacy-Module [15-0]
  Public-Cloud-Module [15-0]
  SAP-Applications-Module [15-0]
  Server-Applications-Module [15-0]
```
Then pick the modules you want to add to the installation medium:
```console
# mksusecd --create new.iso \
  --include-repos Basesystem-Module,Legacy-Module \
  SLE-15-Installer.iso SLE-15-Packages.iso
Repositories:
  SLES15 [15-0]
  Basesystem-Module [15-0]
  Legacy-Module [15-0]
assuming repo-md sources
El-Torito legacy bootable (x86_64)
El-Torito UEFI bootable (x86_64)
building: 100%
calculating sha256...
```
Now use `new.iso` to start an installation.

## Security / Development

### Creating Reproducible Tarballs

We automatically submit the YaST packages from the Git repositories to
the OBS projects using Jenkins. We use two Jenkins instances, the
[public Jenkins][10] submits to openSUSE Factory/Tumbleweed, the
internal Jenkins submits the same packages to SLE15.

The OBS compares the SLE15 packages with the openSUSE version to make
sure the same packages are built in both projects. But this check
compares only the file checksums, not the archive content.

The problem was that the internal and external Jenkins created a tarball
with different checksum although the files inside were exactly same. If
you run simple `tar cfjv archive.tar.bz2 files` you will find out that
the tarball checksum is different for each run. So how to create a
tarball in a reproducible way?

To build a reproducible tarball we use these `tar` options:

* `--owner=root --group=root` – to make sure the file owner and the
  group is always the same, it does not matter who builds the tarball or
  who owns the files on the system
* `--mtime=<timestamp>` – to have constant file time stamps, it does not
  matter when you downloaded the source files. Having fixed time stamps
  (like `0`) is not a good idea as you do not know how the files are old
  actually, but using the current time makes the tarball not
  reproducible. So we use the date of the last commit in the Git
  repository (`git show -s --format=%ci`), it is stable across multiple
  runs and still describes how old the files are.
* `--format=gnu` – use the GNU tar format, the default POSIX format
  contains some archive time stamps
* `--null --files-from -` – this tells tar to read the file names from
  standard input, we use this options together with `find ... -print0 |
  LC_ALL=C sort -z` to sort the files to always have the very same file
  order.

Note: it also depends which compression method you use for compressing
the tarball. For example `gzip` by default also adds some time stamps to
the archive, `bzip2` does not. If you want to use `gzip` then use the
`-n` option.

See the [tarball Rake task][11] for the implementation details.

### AutoYaST supports root SSH Authorized Keys deployment

From a [security][12] point of view, it is recommended to use SSH for
logging into a remote machine instead of user and password in plain text
format. But having to memorize the user and password specially if you
try to use a strong non predictable password is also hard and hard to
maintain.

For that reason SSH provides authentication based on [public key
cryptography][13] and [AutoYaST supports][14] the deployment of SSH
Authorized keys for normal users since [SLE-12-SP2][15] but it was not
working for the `root` user.

We have fixed this issue in SLES-12-SP3 allowing to deploy the SSH
authorized keys also for the `root` user and exporting them into the
cloned system profile.

## AutoYaST keeps improving

The storage-ng based AutoYaST version has received a couple of
improvements like, for instance, an improved resizing handling
(supporting logical volumes) or multipath support. Additionally, we’ve
squashed some bugs, like [setting size=max for LVs (bsc#1070131)][16] or
some problems when not defining any partition ([bsc#1070790][17] and
[bsc#1065061][18]).

But even more interesting is the fact that we have brought back a hidden
(and undocumented) feature. Did you know that if you set the `<device/>`
element to `ask`, AutoYaST will ask you about which device to use for
installation? Cool, right? This feature will continue working in
(open)SUSE 15 and now it is documented!

{% include blog_img.md alt=""
src="s47-8-300x225.png" full_img="s47-8.png" %}

## Conclusion

My colleagues are telling me that practicing Scrum may be getting just
ever so slightly on my nerves because I have several bugs in my
description of the St. Nicholas tradition. Surely they are wrong. Stay
tuned for the next report from a new and improved Scrum team: Ježíšek,
Santa, und das Christkind.



[1]: http://jemalloc.net/
[2]: https://medium.com/@adrienjarthon/ruby-jemalloc-results-for-updown-io-d3fb2d32f67f
[3]: https://chrony.tuxfamily.org/comparison.html
[4]: http://www.firewalld.org/
[5]: {{ site.baseurl }}{% post_url 2016-06-07-highlights-of-yast-development-sprint-20 %}
[6]: https://github.com/yast/yast-yast2/tree/master/library/network/src/lib/y2firewall
[7]: https://github.com/yast/yast-yast2/tree/master/library/cwm/examples
[8]: https://scc.suse.com/
[9]: https://github.com/openSUSE/mksusecd
[10]: https://ci.opensuse.org/view/Yast/
[11]: https://github.com/openSUSE/packaging_rake_tasks/blob/404c8c35371ac53daa9f0a64619bd7798080e50a/lib/tasks/tarball.rake#L100-L115
[12]: https://www.suse.com/documentation/sles-12/book_security/data/cha_ssh.html
[13]: https://www.suse.com/documentation/sles-12/book_security/data/sec_ssh_authentic.html
[14]: https://www.suse.com/documentation/sles-12/singlehtml/book_autoyast/book_autoyast.html#Configuration.Security.users
[15]: {{ site.baseurl }}{% post_url 2016-09-28-highlights-of-yast-development-sprint-25 %}
[16]: https://bugzilla.suse.com/show_bug.cgi?id=1070131
[17]: https://bugzilla.suse.com/show_bug.cgi?id=1070790
[18]: https://bugzilla.suse.com/show_bug.cgi?id=1065061
