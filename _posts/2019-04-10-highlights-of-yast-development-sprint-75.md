---
layout: post
date: 2019-04-10 11:18:24.000000000 +00:00
title: Highlights of YaST Development Sprint 75
description: With the upcoming releases of openSUSE Leap 15.1 and SLE-15-SP1 approaching,
  the YaST Team at SUSE is investing a quite significant time in polishing details
  and fixing small (and not so small) bugs. But fortunately, that still leaves us
  enough time to also work in our mid term goals. So welcome to our usual selection
  [&#8230;]
category: SCRUM
tags:
- Distribution
- Documentation
- Factory
- Localization
- Miscellaneous
- Programming
- Systems Management
- YaST
---

With the upcoming releases of openSUSE Leap 15.1 and SLE-15-SP1
approaching, the YaST Team at SUSE is investing a quite significant time
in polishing details and fixing small (and not so small) bugs. But
fortunately, that still leaves us enough time to also work in our mid
term goals.

So welcome to our usual selection of selected bug-fixes (listing them
all would be boring) and exciting new stuff. This edition includes:

* A nice howto for reporting Snapper bugs
* Tons of fixes for right-to-left languages like Arabic
* Some adjustments and improvements in the storage area
* A sneak peak into the future of the yast2-network code
* Some contributor-oriented content: like our new pull request templates
  and revamped Docker images for testing

### Snapper Bug Reporting Howto

During this sprint we fixed a bug that was causing Snapper to crash
under very specific circumstances. The scenario was quite unusual so we
had to request quite some information from the reporter of the bug to
confirm what was happening. As a nice consequence, in addition to having
now a more robust Snapper (one bug killed) you can also enjoy [a new
page in the openSUSE wiki][1] listing the information you should attach
to Bugzilla if you find a bug in Snapper while using (open)SUSE.

Which is also a nice excuse to remind you about the equivalent \"[Report
a YaST bug][2]\" page.

### YaST around the globe… in all directions

Many of the YaST users and of our blog readers are not native English
speakers that surely appreciate the fact that YaST and (open)SUSE in
general can be used in several languages. But have you ever thought
about the implications of developing a multi-language software? Sure? In
all of them?
![😉](https://s.w.org/images/core/emoji/2.2.1/72x72/1f609.png){:
.wp-smiley style="height: 1em; max-height: 1em;"}

Human languages are so diverse as the human cultures and there are many
details to take into account, from the usage of different alphabets to
the various ways of dealing with genre or number (in English the words
have just one form for singular and another for plural, but that can be
way more complex in other languages). In today’s issue we will take a
look to one of our favorite translation issues – languages that are
written from right to left, like Arabic.

[![The installer summary in
Arabic](../../../../images/2019-04-10/39228769-ae4c125a-4857-11e8-8b3a-649e2b751e15-300x225.png)](../../../../images/2019-04-10/39228769-ae4c125a-4857-11e8-8b3a-649e2b751e15.png)

Dealing with text that is a mixture of Latin and Arabic script is
complex and sometimes we have to deal with interesting bugs. Fortunately
we have our own weapon to fight those bugs. If in Star Wars they have
protocol droids like C3PO, in the YaST team we have Martin Vidner, which
is the closer human equivalent.

He fixed all the reported bugs and even created a tool to help debugging
similar problems in the future. You can find [the source code of that
tool][3] in Github. There is even a [hosted instance][4] of the tool to
be used by translators or anyone who is curious.

Now, even complex interfaces like our Partitioner look correct enough in
right-to-left languages, so we will not have to send mirrors to all our
Arabic users.

[![The YaST Partitioner in
Arabic](../../../../images/2019-04-10/ar-partitioner-installed-system-300x227.png)](../../../../images/2019-04-10/ar-partitioner-installed-system.png)

If you want to know more about this exciting but very complex problem of
bidirectional texts, you can start with the following documents.

* [Martin’s great summary][5] of the types problems found in YaST and
  their respective solutions.
* [Wikipedia: Bi-directional text][6], an overview of the concepts
* Unicode Standard Annex #9: [Unicode Bidirectional Algorithm][7], the
  gory details, 50 pages of them
[![More Arabic
YaST](../../../../images/2019-04-10/bidi-989383-hack-300x185.png)](../../../../images/2019-04-10/bidi-989383-hack.png)

On related news, we got also some reports about some problems
visualizing bullet-points in Korean with the beta versions of the future
SLE-15-SP1. But as we could verify, all those problems are gone now.

[![SLES installer in
Korean](../../../../images/2019-04-10/korean-bullets-sles15sp1-300x194.png)](../../../../images/2019-04-10/korean-bullets-sles15sp1.png)

### Storage Fixes

Other area that has received some attention in this sprint is the
storage management. Three related features needed adjustments before the
upcoming (open)SUSE releases:

* Fixed the detection of the boot disk in the Partitioner warnings.
* The Guided Setup now works better when doing several attempts in
  different disks.
* AutoYaST can now install over NFS.

One of the last storage features that the YaST Team has developed is the
support for Bcache devices in the Expert Partitioner. While our QA team
was testing it, they found a bug. The Partitioner was complaining
because the boot disk did not contain a partition table, which is a
mandatory condition for a Legacy (non-UEFI) x86 system. But it was a
bogus warning, since they had actually defined a `/boot` partition in
another disk.

That’s how we found that our Partitioner gets confused if there is a
separate partition mounted at `/boot` and located in a different disk
than the root file-system. The Partitioner insisted in considering the
disk containing `/` to be the one that would be using for booting,
instead of checking the structure of the disk containing `/boot`. Now
that is fixed and the improvement will be available for the upcoming SLE
15 SP1, Leap 15.1 and, of course, openSUSE Tumbleweed.

But that was not the only storage bug fixed just in time for the
upcoming releases. Some sprints ago, the Storage Proposal algorithm for
the initial proposal was modified to try installing on each of the
individual disks. If the installation was not possible over a given
disk, even after disabling all optional configurations (e.g., snapshots
and separate `/home`), a new proposal is tried over the next disk and so
on. The problem was that the disabled options in the previous attempt
were not restored back when switching to the next disk. This caused some
ugly side effects, for example, if the swap partition was disabled when
trying over the first disk, then the proposal did not try to create a
swap when it was performing the proposal over the next disk. But now
this is also fixed and it will work as expected.

And last but not least, AutoYaST now supports to install over a Network
File System (NFS). This feature was left back when the new YaST storage
stack was re-implemented for SLE 15 GA. Actually, this is a non
documented feature. That’s why we overlooked that SUSE 12 was able to do
it using some hacks and a non-validating AutoYaST profile. But no
worries, the feature is available again and such profile will work now
in any updated SLE-15 or Leap 15.0. Of course, it will also work while
installing SLE-15-SP1 or openSUSE Leap 15.1 and Tumbleweed.

Nevertheless, we are working on a better and documented way of
supporting that scenario in the future, with no need to twist the
specification of the AutoYaST profile. Stay tuned for more information.

### Rethinking the Location of Special Boot Partitions

And now that the storage layer looks sane and healthy for the upcoming
releases, we also took some time to think about future improvements. As
you know, the storage Guided Setup always proposes to create special
boot partitions as needed on each case. That can be a BIOS BOOT (for
Legacy x86 systems with GPT), an ESP (for UEFI systems), PReP (for PPC
systems) or zipl (for S/390 systems). Strictly speaking those partitions
doesn’t have to always be in the same disk than the root partition and
in some cases having it on a separate one can have some advantages (like
sharing the ESP partition with another operating systems).

But we have been reconsidering all the cases, the expectations of most
users and of the majority of BIOS vendors and the known bugs in other
operating systems about sharing boot partitions. We have decided to be
more strict in the future about the location of those partitions.
Starting today with openSUSE Tumbleweed and in the 15.2 releases of
openSUSE Leap and SLE, the Guided Setup will always propose those
partitions in the system disk. That is, in the disk containing `/boot`
and the root filesystem.

### The future of YaST Network is here

Those who follow this blog know that we invested quite some time on the
last couple of years rewriting the part of YaST that was more buggy and
harder to modify – the storage stack. And surely you have already
noticed that since we did it we are introducing new features at a very
good pace (like bcache, more powerful Partitioner, Raspberry Pi support,
etc.) and fixing the reported bugs in a matter of days or even hours.

The next in our list of YaST areas to revamp is the networking support.
And we are happy to announce that we are starting to have some visible
results in that. There is still a very long road ahead and we will
provide more information in upcoming reports. But at least we have
already a preview of a fully rewritten management of network routes.
It’s still not available in openSUSE Tumbleweed. But for those who can’t
wait, here you can see the first screenshot. All based in new and clean
code backed by automated tests.

[![New network routing
dialog](../../../../images/2019-04-10/RoutingStandalone-300x236.png)](../../../../images/2019-04-10/RoutingStandalone.png)

###  Activating Online Repositories in openSUSE Leap 15.1

The openSUSE Tumbleweed installer asks at the beginning of the
installation whether to activate and use the online repositories when a
network connection is available.

The reason is that the installation DVD does not contain all available
packages because of the limited media size. Another advantage is that
the installer might directly install newer packages than on the media,
this avoids installing the older versions first and then upgrading them
to the latest version.

However, in some case you might not want to use the online repositories,
for example if the network connection is slow or is paid.

We got a bug report that this question was missing in the Leap 15.1. It
turned out that the `control.xml` file which drives the installer did
not contain this step. After adding few lines into the file you can now
enjoy the online repositories also in Leap 15.1!

[![Online repositories in Leap
15.1](../../../../images/2019-04-10/55151188-f23e1f80-514d-11e9-8dc3-8fe5ab2f93df-300x225.png)](../../../../images/2019-04-10/55151188-f23e1f80-514d-11e9-8dc3-8fe5ab2f93df.png)

Why are we writing about this? The reason for the missing step in the
Leap 15.1 was a bit surprising. Normally all YaST packages are developed
in the Git `master` branch for both Tumbleweed and Leap. However, in
this case the Leap 15.1 has been already branched and was developed
separately, the changes in the `master` went only to the Tumbleweed. And
we overlooked that small difference when adding this step.

To avoid this in the future we added a [pull request template with a
reminder][8] which informs the developers about this difference in the
Git setup when opening a pull request.

If your project also has some unusual setup then the [pull request
template][9] might a good reminder for you as well.

### Building the Docker Images in OBS

But the reminders about the correct branches and procedures is not the
only news we have for YaST contributors and main developers. As you may
remember, few years ago we switched to [using Docker at Travis][10].
That works well but we found some disadvantages of that initial setup.

* You need extra account at the Docker Hub to manage the images.
* There is no link between OBS and the Docker Hub, we cannot easily
  trigger image rebuild when a package is updated in OBS.
* We only blindly triggered the rebuild every 2 hours (in some cases the
  rebuild is not necessary, in some cases it took too much time).
* The Docker Hub can use the new OBS packages only after they are
  published by OBS.
* The build at the Docker Hub is quite slow (~20 minutes in our case),
  if an image is currently being built the build is added into the queue
  and it will start after the previous builds are finished.

The result is that a new package can be available in Travis several
hours after merging the pull request. And even after triggering the
build manually it still might take more than one hour.

We needed a faster cycle and the solution, as usually happens, was in
the openSUSE ecosystem. As you may know, the Open Build Service is able
of much more than just building packages. So we decided to make use of
the OBS capacity of building Docker images.

Building both our packages and our Docker images in OBS comes with many
advantages:

* The image build is started immediately when the new packages are
  built, it does not wait for publishing the packages and does not wait
  for full rebuild (only for the needed packages).
* No extra accounts/permissions (just use your OBS account).
* The build in OBS is faster (6-7 minutes).
* No need for extra Jenkins jobs periodically triggering the image
  rebuilds.

This means the new packages should be available in the Docker image in
about 10-15 minutes after merging a pull request (for leaf packages,
changing a core package which triggers a complete YaST rebuild will of
course take more time).

If you want to learn more about this topic, take a look to the following
links:

* The [OBS Image templates][11] – examples of Docker images
* The [OBS Docker registry][12] – the built Docker images are published
  here
* The [sources for the YaST Ruby][13] container and the respective OBS
  [ci-ruby-container][14] package
* The [sources for the YaST C++][15] container and the respective OBS
  [ci-cpp-container][16] package

### And that was not all!

As usual, the content of this report is just a small subset of all the
work the YaST Team does in two weeks. In this sprint, most of that work
went to fixing all kind of bugs in preparation for the next releases.
Big bugs, small ones, hidden bugs and embarrassingly obvious ones.
Hopefully, you got a fix for your reported bug. If not, you can always
stay tuned for more news after the next sprint. And don’t forget to have
a lot of fun!



[1]: https://en.opensuse.org/openSUSE:Bugreport_Snapper
[2]: https://en.opensuse.org/openSUSE:Report_a_YaST_bug
[3]: https://github.com/mvidner/bidi-debugger
[4]: https://bidi-debugger.herokuapp.com/
[5]: https://gist.github.com/mvidner/e96ac917d9a54e09d9730220a34b0d24#file-bidi-problems-md
[6]: https://en.wikipedia.org/wiki/Bi-directional_text
[7]: http://www.unicode.org/reports/tr9/
[8]: https://github.com/yast/skelcd-control-openSUSE/pull/180/files
[9]: https://help.github.com/en/articles/creating-a-pull-request-template-for-your-repository
[10]: https://lizards.opensuse.org/2017/02/03/highlights-of-yast-development-sprint-30/
[11]: https://build.opensuse.org/image_templates
[12]: https://registry.opensuse.org
[13]: https://github.com/yast/ci-ruby-container
[14]: https://build.opensuse.org/package/show/YaST:Head/ci-ruby-container
[15]: https://github.com/yast/ci-cpp-container
[16]: https://build.opensuse.org/package/show/YaST:Head/ci-cpp-container
