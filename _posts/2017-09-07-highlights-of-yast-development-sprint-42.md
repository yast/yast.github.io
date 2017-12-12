---
layout: post
date: 2017-09-07 12:43:15.000000000 +00:00
title: Highlights of YaST Development Sprint 42
description: 'Kids started school in Prague, and we&#8217;re energized to bring you
  news from the YaST team.'
category: SCRUM
tags:
- Systems Management
- YaST
---

This sprint we made progress in:

* selecting one of several products to present on a DVD
* adapting to the switch to the [rpm-md package metadata format][1],
  regarding licenses and the Beta notice
* notifying about not being able to support ReiserFS also in the case of
  an upgrade via AutoYaST
* not reporting missing *optional* patterns

As always, the new storage stack deserves a separate section.

* Expert partitioner has a better initial summary and it handles Btrfs
  subvolumes better.
* [Snapper][2] can create and restore snapshots now.
* A more flexible installation proposal is being developed.
* It has landed in SLE15/Leap15 already.

## Selecting the base product in the first screen

As we [reported three sprints ago][3], YaST will support having multiple
products on the same installation medium. This feature will allow to
ship several SUSE products on the same DVD asking the user which one to
install.

But, as an (open)SUSE user, you may know that the first screen of the
installer allows you to select the language/keyboard and, additionally,
it shows the product’s license. But which license should we show for
multi-product media?

After asking our UX expert, we decided to allow the selection of the
product in the welcome screen as you can see in the image below.

{% include blog_img.md alt="Selecting the base product"
src="s42-1-300x227.gif" full_img="s42-1.gif" %}

Obviously, this behavior applies only to multi-product medias. When
using a single product one, the license is shown directly in the welcome
screen.

Finally, as developers, we would like to highlight that we mainly
re-implemented the welcome screen using modern YaST techniques (like our
[object-oriented API][4] to YaST widgets), improving test coverage and
code quality.

## Getting licenses from repositories

In the [sprint 40 report][5], we announced that YaST was dropping
support for SUSE tags because the plan is to use [RPM metadata][1] and
packages to store all that information (licenses, release notes, etc.).

During this sprint (and the previous one) we focused on improving how
base product licenses are handled. Until now, licenses lived in a
tarball which was included in the installation media. But that is not
the case anymore: now YaST relies on (the awesome) libzypp to get
products licenses directly from the repositories. There are still some
rough edges: for instance, multi-language support should be improved,
but we will tackle them pretty soon.

Finally, bear in mind that only base product licenses have been adapted,
but we plan to do basically the same for modules, extensions and
add-ons.

## Updated README.BETA Support

The YaST installer supports displaying the `README.BETA` file from the
installation medium. This file is added during Beta phase so the users
know this is not the final release. This is also useful after the final
product is released if you by mistake boot the old medium.

Unfortunately the original YaST code supported only the so called
SUSE-Tags repository format which was used for the CD/DVD media.
However, the new SUSE Linux Enterprise media will use the RPM-MD format
which is something completely different.

In this sprint we have added the support for the RPM-MD format and
additionally we display the Beta warning popup also in the AutoYaST
installations. Of course, blocking AutoYaST with a popup would be a bad
idea so in the AutoYaST mode the popup is automatically closed after a
timeout. (The default is 10 seconds but can be [configured in the XML
profile][6].)

## Drop support for ReiserFS autoupgrade

The drop of ReiserFS support for manual installation was [announced in
our last post][7], and now is the turn to autoupgrades.

With SUSE Linux Enterprise 15 the autoupgrade will be blocked in case of
ReiserFS presence were detected suggesting a manual conversion to
another filesystem.

{% include blog_img.md alt="ReiserFS warning"
src="s42-2-300x225.png" full_img="s42-2.png" %}

## Software proposal does not report missing optional patterns

YaST guides you through the installation process of your system making
you a proposal based on the different selections like the product,
addons, system role, desktop etc.

This proposal contains some software patterns that are mandatory and
some that are optional but only the mandatory ones will be reported when
the proposal is shown.

During this sprint we solved a bug which reported not only missing
mandatory patterns but also optional ones.  
 
{% include blog_img.md alt="Software proposal"
src="s42-4-300x225.png" full_img="s42-4.png" %}

## The Storage Stack (storage-ng)

### Storage reimplementation: Expert Partitioner

As you probably already know, in the YaST team we are rewriting our
powerful expert partitioner tool from scratch to adapt it to the new
storage layer. Sprint by sprint we are bringing back some of the many
great features the expert partitioner offers, and this time it will not
be different.

Now, when entering to the expert partitioner, all available storage
devices are presented in an initial summary. Moreover, in this first
screen you could find an option to rescan your devices, which allows the
expert partitioner to be aware about the changes in your system, for
example when you plug in a USB stick.

{% include blog_img.md alt="Expert Partitioner"
src="s42-3-300x225.png" full_img="s42-3.png" %}

The management of Btrfs subvolumes was also improved during this sprint.
Now, you will be alerted when a new subvolume is shadowed by an existing
mount point. Moreover, some subvolumes could be automatically deleted or
created when a mount point changes in the system.

### Snapper can snap again

We reintroduced one of the most important features about using Btrfs:
Being able to create snapshots, so you can go back to a previous state
of the system if anything went wrong during a package upgrade or when
you changed anything about your system configuration. This means we are
now again setting up and configuring [snapper][2] correctly, installing
everything into a subvolume and creating an initial snapshot when the
installation is complete.

Why install into a subvolume in the first place? When snapshots are made
in the future (e.g., during package upgrade or installation) and at some
point you decide to roll back to one of those snapshots, you might want
to delete previous snapshots to save disk space. If we didn’t install
into a subvolume, the initial files would always be left over and
consume disk space, so there would be a considerable resource leak.

### Twisting the storage proposal

As you should know, one important part of the rewritten storage stack is
the partitioning proposal. The old one was designed with a rather narrow
scope in mind. Targeting desktops and old-school servers, it always
proposes a root file-system, a swap volume and an optional separate
`/home`. That’s not the most useful schema for new innovative products
with a different focus like [SUSE CaaS Platform][8], [openSUSE
Kubic][9], [SUSE Manager][10], etc.

As we remind quite often, all the products supported by YaST (SLES,
SLED, Leap, Tumbleweed, Kubic, CaaSP, SUSE Manager, [SLES4SAP][11], you
name it) share an identical installer. That installer is fully
configurable using the file control.xml that is included in the media
and that allows to define the sequence of installer steps, the default
values and much more.

One of the goals of the new storage proposal is to give product creators
and release managers more freedom and flexibility configuring the
behavior of the guided setup. And for that we need a better format for
control.xml, so they can express themselves with fewer limitations.

Of course, that new format is not something for the YaST team do decide
on its own, but something being designed openly in collaboration with
all the involved parties. To make easier for anyone to jump into the
subject we have prepared [this detailed document][12] which includes all
the present and historical information to understand the topic, as well
as an explanation of the new format with several examples based on
existing or hypothetical use cases.

As everything in YaST, that document is alive and expected to continue
changing and evolving based on everybody’s feedback and contributions.
So feel free to take a look and suggest improvements or future use cases
we may have overlooked.

### The storage stack is dead, long live the storage stack

In our [previous sprint report][7] we told you we were working to
integrate the new storage stack into the future SLE15 and openSUSE Leap
15 codebase. Now the submission process is over and the preliminary
images of both future distributions are fully based on libstorage-ng.
For openSUSE Tumbleweed, that is [the Staging:E project][13]. That means
we now have many more eyes looking into it, finding bugs, pointing what
is missing and providing feedback about the new behavior. Of course,
every couple of eyes comes with a little bit more of pressure for the
YaST Team to get things done as soon as possible, but also with a pair
of hands to help us getting there.



[1]: https://en.opensuse.org/openSUSE:Standards_Rpm_Metadata
[2]: http://snapper.io/
[3]: {{ site.baseurl }}{% post_url 2017-07-31-highlights-of-yast-development-sprint-39 %}
[4]: https://github.com/yast/yast-yast2/tree/master/library/cwm/examples
[5]: {{ site.baseurl }}{% post_url 2017-08-10-highlights-of-yast-development-sprint-40 %}
[6]: https://www.suse.com/documentation/sles-12/singlehtml/book_autoyast/book_autoyast.html#CreateProfile.Reporting
[7]: {{ site.baseurl }}{% post_url 2017-08-24-highlights-of-yast-development-sprint-41 %}
[8]: https://www.suse.com/products/caas-platform/
[9]: https://news.opensuse.org/2017/05/29/introducing-kubic-project-a-new-open-source-project/
[10]: https://www.suse.com/products/suse-manager/
[11]: https://www.suse.com/products/sles-for-sap/
[12]: https://github.com/yast/yast-storage-ng/blob/master/doc/old_and_new_proposal.md
[13]: https://build.opensuse.org/project/show/openSUSE:Factory:Staging:E
