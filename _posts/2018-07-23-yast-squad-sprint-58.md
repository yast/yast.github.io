---
layout: post
date: 2018-07-23 06:20:50.000000000 +00:00
title: YaST Squad Sprint 58
description: 'In the previous post we explained the squads idea
  and said we would tell more in this report.'
category: SCRUM
tags:
- Factory
- Systems Management
- YaST
---

### Squads in the Team   {#squads-in-the-team}

We should mention that we finally did three squads for this sprint:

* The *Sockets &amp; Services Squad* working on supporting systemd
  sockets properly and other systemd related tasks (all in the YaST
  context, of course).
* The *Qt and UI Squad* working on user interface things like adding a
  new view to the package selection to show packages managed by a
  service, and also some control center improvements.
* The *Bug Fighting Squad* handling bugs that are coming in on a daily
  basis and in our backlog.

### Fixed Issues with Disks Larger than 8EiB   {#fixed-issues-with-disks-larger-than-8eib}

It’s quite unlikely that you have at home a disk storage larger than
8EiB (eight [exbibytes][1], 2<sup>63</sup>). But in enterprise or cloud
world it might be possible.

And it turned out that the YaST package manager does not handle such
large disks well. At the start you would see this false error message:

#### The Problems   {#the-problems}

{% include blog_img.md alt=""
src="sq1-3-300x230.png" full_img="sq1-3.png" %}

 There are two problems:

* There definitely is a lot of free space on the disk, the error telling
  the user the space is running out is simply lying.
* The disk sizes are displayed as wrong negative values.

It turned out that the problem was caused by using the *signed* 64-bit
integer data type which overflows for values bigger than 8EiB and the
number becomes negative.

#### The Fix   {#the-fix}

We had to fix several places, each required some different solution.

* Use *unsigned* 64-bit integers where possible, that obviously avoids
  overflow.
* The numbers from libzypp use KiB units, at some places we need to
  convert that number to MiB. But first we converted to plain bytes (by
  multiplying by 1024) and then divide by 1MiB. And this first multiply
  step might cause overflow. Instead we simply convert KiB to MiB
  directly by dividing by 1024 without risk of overflow in the middle.
* Use floating point `double` data type for converting the values to a
  human readable text or to percents. The `double` has wider range and
  in these cases we do not need exact precision so rounding in floating
  point operations does not matter.
* Ignore a negative number in the free space check. At one place the
  value goes through the YaST component system which uses *signed*
  integer and this cannot be easily changed. In that case we consider
  negative free space as enough for installing any package, more than
  8EiB free space should be enough for any package™.

{% include blog_img.md alt=""
src="sq1-4-300x173.png" full_img="sq1-4.png" %}

There is still some minor issue with the large numbers. The highest
supported unit is TiB so even very big numbers are displayed in TiB
units as on the screenshot above. The fix is planned to be released as a
maintenance update and this change would break the backward
compatibility so we will improve it later but only for the future
releases.

#### Testing   {#testing}

But the problem was how to test the behavior? You could fake some
numbers in the code but for full testing or QA validation it would be
nice to test on a real disk. But you usually do not have such a large
storage for testing…

Fortunately in Linux it is possible to fake such large file system quite
easily using [sparse files][2] and [loop devices][3]. Here is a short
how to:

```shell
# create two big sparse files
truncate -s 6E /tmp/huge_file1
truncate -s 6E /tmp/huge_file2

# create block devices via loopback
losetup -f /tmp/huge_file1
losetup -f /tmp/huge_file2

# get the loop back device names, the names might be different
# if the system already uses some other loop back devices
losetup -a
/dev/loop1: [0056]:1171324 (/tmp/huge_file2)
/dev/loop0: [0056]:1171323 (/tmp/huge_file1)

# create a btrfs file system over both "disks"
mkfs.btrfs -K /dev/loop0 /dev/loop1

# mount it on /mnt2 (or whatever else, do not use /mnt, that is ignored by libzypp!)
mkdir /mnt2
mount /dev/loop0 /mnt2

# verify the size
df -h /mnt2
Filesystem      Size  Used Avail Use% Mounted on
/dev/loop0       12E   17M   12E   1% /mnt2
# voila! you have a 12EiB file system! enjoy
```

Note: Obviously even if you have a 12EiB filesystem you cannot save
there more data than in the real file system below (in `/tmp` in this
case). If you try you will get write errors, there is no prepetuum
mobile…

### Speeding Up Unit Tests and Travis Builds in yast2-storage-ng   {#speeding-up-unit-tests-and-travis-builds-in-yast2-storage-ng}

The new yast2-storage-ng package has a quite large set of unit tests.
That’s good, it allows to have less buggy code and make sure the
features work as expected.

On the other hand the drawback is that running the tests take too much
time. If you have to wait for 3 or 4 minutes after any small change in
the code then either you waste too much time or you do not run the tests
at all. So we looked into speeding up the tests.

#### Running Tests in Parallel   {#running-tests-in-parallel}

The main problem was that all tests were executed sequentially one by
one. Even if you have a multi CPU system only one processor was used. It
turned out that using the [parallel\_test][4] Ruby gem allows easily
running the tests in parallel utilizing all available processors.

The only possible problem is that there must not be any dependencies or
conflicts between the tests otherwise running them in parallel would
fail. Fortunately there was only one small issue in the yast2-storage-ng
tests and we could enable the parallel tests without much work.

#### Running Travis Jobs in Parallel   {#running-travis-jobs-in-parallel}

Also the Travis job took quite a lot of time. Running the tests in
parallel helped a bit at Travis but still was not good enough.

Fortunately Travis allows running multiple jobs in parallel. Therefore
we split the single CI job which runs the tests, builds the package,
runs syntax check, etc… into three independent groups which can be
started in parallel.

#### Documentation   {#documentation}

If you are interested in details you might check our updated [Travis
documentation][5] and the [Parallel tests documentation][6]. Or check
the [announcement][7] on the YaST mailing list.

#### Results   {#results}

Here are some real numbers to see the speedup:

* Running the test suite locally (`rake test:unit`): from 2:44 to 0:38
  (4.3x speed up on a quad core CPU with hyper-threading enabled)
* Building the package locally (`rake osc:build`): from 137s to 49s
  (with cached RPM packages but includes chroot installation)
* Package build in OBS: from 323s-505s to 102s-235s (it highly depends
  on the speed of the used worker)
* Travis speed up: from 8-10 minutes to 3-4minutes (using both parallel
  Travis jobs and parallel tests)

This allows us to continue with adding even more tests into the package.
:smiley:

### What Packages are Provided by a Product Extension/Module?   {#what-packages-are-provided-by-a-product-extensionmodule}

In the Software Management module we have a Repositories view where you
can see the packages grouped by the repository that provides them. But
this is not really helpful if you want to see what is delivered with a
product *Extension* or *Module*, because each product module is composed
of several repositories: the originally released packages, the updates,
the sources, the debuginfos.

Fortunately, the repositories for each product module are grouped
together in a repository Service, and we have added a *Services* filter
to Software Management.

Qt Service filter:
{% include blog_img.md alt=""
src="sq1-1-300x223.png" full_img="sq1-1.png" %}

ncurses Service filter:
{% include blog_img.md alt=""
src="sq1-2-300x161.png" full_img="sq1-2.png" %}

(Reference: [Feature #320573][8])



[1]: https://en.wikipedia.org/wiki/Exbibyte
[2]: https://en.wikipedia.org/wiki/Sparse_file
[3]: https://en.wikipedia.org/wiki/Loop_device
[4]: https://github.com/grosser/parallel_tests
[5]: http://yastgithubio.readthedocs.io/en/latest/travis-integration/#parallel-build-jobs
[6]: http://yastgithubio.readthedocs.io/en/latest/how-to-write-tests/#parallel-tests
[7]: https://lists.opensuse.org/yast-devel/2018-06/msg00024.html
[8]: https://fate.suse.com/320573
