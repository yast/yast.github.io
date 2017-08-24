---
layout: post
date: 2017-07-31 09:21:36.000000000 +02:00
title: Highlights of YaST development sprint 39
description: "openSUSE 42.3 is out! Do you need some reading material while you wait
  for the download of the new release to finish? Don&#8217;t worry, we have the solution
  right here &#8211; another YaST team report. :smiley:"
category: SCRUM
tags:
- Distribution
- Factory
- Packaging
- Programming
- Systems Management
- YaST
---

### Several products in one installation medium

Obviously, we stopped adding new features to SLE12-SP3 and Leap 42.3
some days ago, because everything needed to be tested properly before
the release. So now we are mainly looking into the future. And one of
the plans for that future regarding SUSE Linux Enterprise (SLE) is
offering several products packed in a single installation medium.

SUSE offers several mission-specific products based on SLE and, so far,
every product needs to be installed from its own medium (usually a DVD
or a virtual image). So if you use SLE Server, SLE Desktop and SLE
Server for SAP, you have to have three DVDs which is a bit cumbersome.

After some discussions about the technical implementation details, we
created a first prototype of the installer with an extra dialog that
allows to select one of the detected products and continues the
installation from there according to the installation workflow of the
chosen product. It is still a proof of concept, but we can at least
share screenshots showing how it looks for the time being.

{% include blog_img.md alt="The new product selection screen"
src="multi-product-300x224.png" full_img="multi-product.png" %}

So far, there are no plans to use the new feature in openSUSE, mainly
because the project does not deliver separate mission-specific products
in the same way than SUSE does with SUSE Linux Enterprise.

### Storage reimplementation: numbers after repatriating the Expert Partitioner

In the [Sprint 36 report][1] we presented the rewrite of the YaST
Partitioner and we have been informing about its evolution in subsequent
reports. We told you back then that we decided to split it in a separate
`yast2-partitioner` package. But time has proved that decision to have
too many drawbacks so we decided to bring the Partitioner back home, to
`yast2-storage-ng`. As part of the process, we got rid of an old
previous prototype of the Partitioner that was still lying in the
`yast2-storage-ng` repository and some code that was there just to
support that old prototype.

You may be asking why is all that relevant. It is because that means the
repository (and thus the package) is finally approaching the final
structure it will have when released into Tumbleweed. And that implies
that all the systems we use to automatically measure the quality and
reliability of our repositories are now providing trustworthy results…
as trustworthy as automatic quality evaluations can be.

And according to those tools:

* [93% of the code][2] in `yast2-storage-ng` is covered with automated
  unit tests in addition to openQA (this number is expected to raise in
  close future as we polish the new Partitioner),
* [Code Climate][3] reports a code quality GPA of 3.91 out of a possible
  maximum of 4
* and 76% of all the classes, modules and functions, including the
  internal ones, are properly documented (with that developer
  documentation being [available here][4], by the way).

If you wonder about the numbers for the old codebase we want to replace,
its code quality is 0.94 and only a 31% of it is covered by unit tests.
A perfect example of legacy code.

### Storage reimplementation: Btrfs subvolumes in AutoYaST

As reported in previous posts, the new storage stack can already process
AutoYaST profiles including partitions, LVM and MD arrays, but some
details are still missing. The first of those details we wanted to
address was the definition and creation of subvolumes in a Btrfs
file-system.

Now it works according to the official documentation – both syntaxes for
the `<subvolumes>` section are supported, it never creates subvolumes
that would be shadowed by any other mounted file-system and it uses the
list in `control.xml` as fallback for the root partition if Btrfs is
used but subvolumes are not specified.

All that, as usual in the re-implemented stack, with fully tested and
documented code.

{% include blog_img.md alt="Btrfs subvolumes support in AutoYaST"
src="autoyast-subvolumes-300x224.png" full_img="autoyast-subvolumes.png" %}

### Storage reimplementation: handle multipath I/O in the proposal

In the [previous report][5] we showed you how the support for [Multipath
I/O][6] looked at the library level, which usually means just geeky
graphs. During this sprint, we have taught the installer to use that new
library feature, so we now have real screenshots to show!

During the installation, now multipath hardware is detected and the user
is asked for activation.

{% include blog_img.md alt="Popup for activating Multipath I/O"
src="multipath-popup-300x221.png" full_img="multipath-popup.png" %}

If the user agrees, the installer will never use the individual disk
devices to propose a partitioning layout and it will not offer them as
an option during the guided setup. The installer always works on the
final (compound) multipath device, proposing the correct names for the
partitions and so on (which, being a devicemapper device, follows a  
 different pattern when compared to raw devices).

 {% include blog_img.md alt="Suggested partitioning with multipath"
 src="multipath_proposal-300x225.png" full_img="multipath_proposal.png" %}

The resulting system is still not fully bootable because
`yast2-bootloader` has still not been adapted to this scenario. Very
likely, something for the upcoming sprint, so stay tuned.

### Support for Ruby 2.4

The world changes every day and we are always adapting YaST to remain
shiny. The 2.4 version of Ruby is about to land in openSUSE Tumbleweed
and is expected to be the default Ruby for SUSE Linux Enterprise 15 and
openSUSE Leap 15. We found that some of the YaST packages were not fully
ready for this new Ruby, so it was time for some tweaking.

After dealing with quite some details too technical and boring for this
blog (but feel free to ask if you want the gory bits), YaST is shining
again in Factory, which means we are no longer blocking the adoption of
Ruby 2.4 in Tumbleweed.

### Add-on Creator and Product Creator

As our team keeps always developing new features, solving bugs, and
receiving feedback, we always evaluate our priorities and product.
Sometimes, during this evaluation, we see that some YaST modules do not
bring enough value or do not shine enough as part of our standard
package.

After some evaluation, we come to announce that the modules **Add-on
Creator** and **Product Creator** will no longer be part of YaST. These
packages use Kiwi as backend and we have high competition on UI sides –
SUSE Studio and Open Build Service. So it no longer makes sense to have
these packages and we recommend for users of these modules to use one of
the alternatives or Kiwi directly if you already have an XML definition
file for Kiwi.

### Adapting YaST to accept 12 digits Service Request Number

As Service Request Numbers can be now composed of 11 or 12 digits,
instead of only 11 digits as before, we had to adapt YaST to handle this
change. YaST module Support can now accept 11 or 12 digit service
request numbers. We implemented such a change for all products dating
back from SLE 10 SP3 until the most recent SUSE Linux versions. Updates
with this change will be soon released.

### Network Setup in the 1st Stage of Autoinstallation

The YaST installation used to have two stages, separated by a reboot.
Starting with SLE 12 and openSUSE Leap 42.1 we have eliminated the  
 second stage. But it was still needed for AutoYaST, controlled by the
setting

```xml
<profile><general><mode><second_stage>true | false</...>
```

We have fixed those parts of the networking setup and now you can
explicitly set AutoYaST to not use a second stage anymore.

### User settings in AutoYaST

An issue that we have found out is that GDM has problems with the system
when different users have the same UIDs. If it happens, GDM does not
start properly. As a solution, we decided that either UIDs will be
defined in the AutoYaST configuration file for **ALL** users or this tag
will not be used at all for **ALL** users since a mix of both can result
into duplicate UIDs.

### And we just keep YaSTing!

We hope you liked our report as much as we loved to build all of that.
We’ll continue YaSTing so we can reach you again in two weeks with much
more cool stuff to show.

By now, enjoy your openSUSE 42.3 and all the cool features that came
with it!



[1]: {{ site.baseurl }}{% post_url 2017-06-16-highlights-of-yast-development-sprint-36 %}
[2]: https://coveralls.io/github/yast/yast-storage-ng
[3]: https://codeclimate.com/github/yast/yast-storage-ng
[4]: http://www.rubydoc.info/github/yast/yast-storage-ng/master
[5]: {{ site.baseurl }}{% post_url 2017-07-14-highlights-of-yast-development-sprint-38 %}
[6]: https://en.wikipedia.org/wiki/Multipath_I/O
