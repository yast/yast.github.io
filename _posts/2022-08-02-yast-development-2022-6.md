---
layout: post
date: 2022-08-02 06:00:00 +00:00
title: YaST Development Report - Chapter 6 of 2022
description: As the first prototype of ALP approaches, the YaST-related work groups keep working on several aspects
permalink: blog/2022-08-02/yast-report-2022-6
tags:
- Distribution
- Factory
- Programming
- Systems Management
- YaST
---

Time for more news from the YaST-related [ALP work
groups](https://en.opensuse.org/openSUSE:ALP/Workgroups). As the first prototype of our Adaptable Linux
Platform approaches we keep working on several aspects like:

- Improving Cockpit integration and documentation
- Enhancing the containerized version of YaST
- Evolving D-Installer
- Developing and documenting Iguana

It's a quite diverse set of things, so let's take it bit by bit.

## Cockpit on ALP - the Book {#cockpit}

Cockpit has been selected as the default tool to perform 1:1 administration of ALP systems. Easing
the adoption of Cockpit on ALP is, therefore, one of the main goals of the 1:1 System Management
Work Group. Since clear documentation is key, we created [this wiki
page](https://en.opensuse.org/openSUSE:ALP/Workgroups/SysMngmnt/Cockpit#Cockpit_at_ALP) explaining
how to setup and start using Cockpit on ALP.

The document includes several so-called "development notes" presentings aspects we want to work on
in order to improve the user experience and make the process even more straightforward. So stay
tuned for more news in that regard.

## Improvements in Containerized YaST {#yast}

As you already know, Cockpit will not be the only way to administer an individual ALP system. Our
containerized version of YaST will also be an option for those looking for a more traditional
(open)SUSE approach. So we took some actions to improve the behavior of YaST on ALP.

First of all, we reduced the size of the container images as shown in the following table.

| Container | Original Size | New size | Saved Space |
|-----------|--------------:|---------:|------------:|
| ncurses   | 433MB         | 393MB    | 40MB        |
| qt        | 883MB         | 501MB    | 382MB       |
| web       | 977MB         | 650MB    | 327MB       |

We detected more opportunities to reduce the size of the container images, but in most cases they
would imply relatively deep changes in the YaST code or a reorganization of how we distribute the
YaST components into several images. So we decided to postpone those changes a bit to focus on other
aspects in the short term.

We also adapted the Bootloader and Kdump YaST modules to work containerized and we added them to the
available container images.

We took the opportunity to rework a bit how YaST handles the on-demand installation of software.
As you know, YaST sometimes asks to install a given set of packages in order to continue working or
to configure some particular settings.

{% include blog_img.md alt="YaST asking for some packages"
src="yast-install-mini.png" full_img="yast-install.png" %}

Due to some race conditions when initializing the software management stack, YaST was sometimes
checking and even installing the packages in the container instead of doing it so in the host system
that was being configured. That is fixed now and it works as expected in any system in which
immediate installation of packages is possible, no matter if YaST runs natively or in a container.
But that still leaves one open question. What to do in a transactional system in which installing
new software implies a reboot of the system? We still don't have an answer to that but we are open
to suggestions.

As you can imagine, we also invested quite some time checking the behavior of YaST containerized on
top of ALP. The good news is that, apart from the already mentioned challenge with software
installation, we found no big differences between running in a default (transactional) ALP system or
in a non-transaction version of it. The not-so-good news is that we found some issues related to
rendering of the ncurses interfaces, to `sysctl` configuration and to some other aspects. Most of
them look like relative easy to fix and we plan to work on that in the upcoming weeks.

## Designing Network Configuration for D-Installer {#network}

Working on Cockpit and our containerized YaST is not preventing us to keep evolving D-Installer.
If you have tested our next-generation installer you may have noticed it does not include an option
to configure the network. We invested some time lately researching the topic and designing how
network configuration should work in D-Installer from the architectural point of view and also
regarding the user experience.

In the short term, we have decided to cover the two simplest use cases: regular cable and WiFi
adapters. Bear in mind that Cockpit does not allow setting up WiFi adapters yet. We agreed to
directly use the D-Bus interface provided by NetworkManager. At this point, there is no need to add
our own network service. At the end of the installation, we will just copy the configuration from
the system executing D-Installer to the new system.

The implementation will not be based on the existing Cockpit components for network configuration
since they present several weaknesses we would like to avoid. Instead, we will reuse the
components of the `cockpit-wicked` extension, whose architecture is better suited for the task.

## D-Installer as a Set of Containers {#containers}

In our [previous report]({{site.baseurl}}/blog/2022-07-19/yast-report-2022-5) we announced
D-Installer 0.4 as the first version with a modular architecture. So, apart from the already
existing separation between the back-end and the two existing user interfaces (web UI and
command-line), the back-end consists now on several interconnected components.

And we also presented Iguana, a minimal boot image capable of running containers.

Sure you already guessed then what the next logical step was going to be. Exactly, D-Installer
running as a set of containers! We implemented three proofs of concept to check what was possible
and to research implications like memory consumption:

- D-Installer running as a single container that includes the back-end and the web interface.
- Splitting the system in two containers, one for the back-end and the other for the web UI.
- Running every D-Installer component (software handling, users management, etc.) in its own
  container.

It's worth mentioning that containers communicate with each other by means of D-Bus, using different
techniques on each case. The best news if that all solutions seem to work flawlessly and are able to
perform a complete installation.

And what about memory consumption? Well, it's clearly bigger than traditional SLE installation
with YaST, but that's expected at this point in which no optimizations has been performed on
D-Installer or the containers. On the other hand, we found no significant differences between the
three mentioned proofs of concept.

- Single all-in-one container:
  - RAM used at start: 230 MiB
  - RAM used to complete installation: 505 MiB
- Two containers (back-end + web UI):
  - At start: 221 MiB (191 MiB back-end + 30 MiB web UI)
  - To complete installation: 514 MiB (478 MiB back-end + 36 MiB web UI)
- Everything as a separate container:
  - At start: 272 MiB (92 MiB software + 74 MiB manager + 75 MiB users + 31 web)
  - After installation: 439 MiB (245 MiB software + 86 manager + 75 users + 33 web)

Those numbers were measured using `podman stats` while executing D-Installer in a traditional
openSUSE system. We will have more accurate numbers as soon as we are able to run the three proofs
of concepts on top of Iguana. Which take us to...

## Documentation About Testing D-Installer with Iguana {#iguana}

So far, Iguana can only execute a single container. Which means it already works with the all-in-one
D-Installer container but cannot be used yet to test the other approaches. We are currently
developing a mechanism to orchestrate several containers inspired by the one offered by GitHub
Actions.

Meanwhile, we added some [basic
documentation](https://github.com/aaannz/dracut-iguana/blob/main/README.md) to the project,
including how to use it to test D-Installer.

## Stay Tuned {#closing}

Despite the reduced presence on this blog post, we also keep working on YaST beside
containerization. Not only fixing bugs but also implementing new features and tools like our new
experimental [helper to inspect YaST logs](https://lslezak.github.io/ylogviewer/). So stay tuned to
get more updates about Cockpit, ALP, D-Installer, Iguana and, of course, YaST!
