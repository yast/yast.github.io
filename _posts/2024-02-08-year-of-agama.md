---
layout: post
date: 2024-02-08 12:00:00 +00:00
title: The Year of Agama
description: Take a look to the Agama roadmap for 2024
permalink: blog/2024-02-08/year-of-agama
tags:
- Project
- Programming
- Systems Management
- YaST
- Agama
---

At the end of 2023 we announced Agama 7 stating that version is the first protype we could consider
to be (quoting ourselves) "functional enough", covering areas such as localization, network
configuration, storage setup, authentication basis and some software selection. Now it's time to go
deeper into every area... and we have a plan for that.

## The Agama Roadmap for 2024 {#roadmap}

They say "plans are useless, but planning is indispensable". So we decided to do the indispensable
exercise of planning the first months of 2024 and we came with this useless plan.

Although we will keep delivering new versions of Agama at a relatively constant pace, we established
two milestones as check points. The first milestone is expected around mid April, the second one
is scheduled to mid July. Then we used those two milestones to group the next tasks we want to
tackle.

April's milestone should result in a revamped architecture for Agama which should not longer depend
on Cockpit and in a more comprehensive user interface for configuring the storage setup. Both
aspects are explained in depth in this blog post.

July's milestone should bring mechanisms to make Agama more adaptable and many improvements to
unattended installation, turning Agama into a worthy contender to AutoYaST.

Let's dive into the improvements expected for the first milestone.

## Arquitectural Changes {#architecture}

So far, we have built Agama on top of the infrastructure provided by the
[Cockpit project](https://cockpit-project.org/). That allowed us to bootstrap the project quickly
without having to invest too much on aspects like authentication or serving files to the web
interface. But after more than a year of Agama development we now have a clear view on how we want
to do certain things, and Cockpit is starting to feel like a limiting factor.

See more details at [this Github discussion](https://github.com/openSUSE/agama/discussions/1000),
but in short we concluded the small of amount of functionality we are getting out of Cockpit does
not justify the strong dependency, especially now that Cockpit is adopting Python as an integral
part of its runtime.

So we will invest the following months in changing a bit the approach as described in the mentioned
discussion at Github. That should unblock many paths to improve Agama in the near future.

## A More Powerful User Interface for the Storage Proposal {#storage}

The mentioned architectural changes are important for remote or unattended installation and also
regarding integration of Agama into bigger solutions, but they may not be that visible for the
casual user. That doesn't imply next months will be boring in the area of interactive installation.
Quite the opposite, we plan many improvements in the Agama's proposal page that allows to tweak the
storage configuration.

The new interface aims to be easy enough for newcomers, as you can see in the following mock-up.
But we know (open)SUSE users have big expectations in terms of customizing their setups. Thus,
we updated the [document](https://github.com/openSUSE/agama/blob/master/doc/storage_ui.md) that
describes how the new interface will work and all the possibilities it will offer for those who
decide to go beyond the initial proposal. If you want to check whether your basic needs would be
covered, don't hesitate to take a look to the document and the extended mock-ups included on it.

{% include blog_img.md alt="Storage proposal" src="storage-mini.png" full_img="storage.png" %}

If interface descriptions and mock-ups are not your cup of tea, worry not. We already started
implementing some parts of the new interface, so you will be able to try the changes for real
as they land incrementally at upcoming Agama prototypes.

## openSUSE Conference in the horizon {#conference}

If you look closely at the dates of both milestones described above, you will notice there is
something happening almost in the middle -
[openSUSE Conference 2024](https://events.opensuse.org/conferences/oSC24)!

We hope at that point in time Agama will be able to replace YaST for some scenarios and
distributions. And, as such, we would like to use the conference to chat with the community about
the possible future of Agama at openSUSE.

But, as we have mentioned in several previous occasions, the installation experience goes beyond the
installer itself. The environment in which the installer is executed is also a crucial
aspect. So apart from replacing YaST with Agama we would also need to replace the current so-called
"installation image" with some modern alternative. So far, the testing Agama Live ISO has served us
for demo purposes, but we would appreciate any help at building a system suitable for more real
installation scenarios.

If you have good ideas about reducing the size of the live image, properly integrating the
distribution repositories into it, streamlining the boot process, or any other topic... you
know where to find us.

## Stay in touch {#closing}

As said, your contributions and opinions are a key element to make sure Agama reach its goals, so
never hesitate to contact the YaST team at the [YaST Development mailing
list](https://lists.opensuse.org/archives/list/yast-devel@lists.opensuse.org/), our `#yast`
channel at [Libera.chat](https://libera.chat/) or the [Agama project at
GitHub](https://github.com/openSUSE/agama).

Help us to make 2024 the year of the new lizard!
