---
layout: post
date: 2021-03-30 12:00:00
title: Echoes of Hack Week 20
description: 20th SUSE Hack Week is over and we would like to share some of the projects our team
  has been working on during this week.
permalink: blog/2021-03-30/hack-week-20
tags:
- HackWeek
- SUSE
- Programming
---

Last week, we celebrated the 20th edition of Hack Week. During this time, we are meant to invest our
working hours in any project we want: it can be related to your daily duties, something you want to
learn or just a crazy experiment. It is up to you. But the idea is to foster collaboration and
innovation. And it is not limited to SUSE; the openSUSE community is welcome to join us.

In this blog post, we would like to share some of the projects the YaST team members were working
on, even if they are not related to YaST (and some of them aren't). We encourage you to join the
discussion if you are interested in any of them.

## YaST Rake Tasks: Run GitHub Actions Locally

Let's start presenting something that is actually related to YaST. Ladislav Slezak brought some cool
stuff to [Yast::Rake][yast-rake], a package that provides YaST developers with useful helpers for
our daily tasks like running test suites, submitting new package versions and so on.

Now, containers are first class citizens for `Yast::Rake`, so it is possible to run YaST client
directly on containers and, even better, run [GitHub actions][github-actions] locally. If you are
interested, you should readh [Ladislav's announcement][yast-rake-announcement] on the mailing list.

[yast-rake]: https://github.com/yast/yast-rake/ "Yast::Rake"
[yast-rake-announcement]: https://lists.opensuse.org/archives/list/yast-devel@lists.opensuse.org/thread/UI5Q7STQ5DTUVT34JEL647ZPQP2H6UOK/
                          "Yast::Rake Changes Announcement"
[github-actions]: https://github.com/features/actions "GitHub Actions"

## Type Check YaST with Sorbet

Martin Vidner has been working for some time to bring type checking to YaST using [Sorbet][sorbet],
a gradual type checker for Ruby. YaST is a rather big and old project, and given the dynamic nature
of Ruby, we routinely get bug reports caused by typos, wrong method names, and so on.

At this point, we can check a big part of `yast2-ruby-bindings.rpm` and a small portion of
`yast2.rpm`, which is a significant step forward. But if you want to know more about this promising
project, do not hesitate to have a look at the [project's page'][sorbet-yast].

[sorbet]: https://sorbet.org/ "Sorbet"
[sorbet-yast]: https://hackweek.suse.com/20/projects/type-check-yast-with-sorbet "Type Check YaST with Sorbet"

## QDirStat: Finding Files that are Shadowed by a Mount

[QDirStat][qdirstat] is a pretty neat application that helps you to know how your disk space is
used, so you can keep your file system clean and tidy. Stefan Hundhammer, author and maintainer of
QDirStat, has done extensive research to find files that are shadowed by a mount. The problem with
those files is that they will occupy disk space, although they are not accessible.

As a result, Stefan has written [a detailed document][shadowed-doc] about that matter, including a
[nice script][shadowed-script] to help you in your quest for shadowed files.

[QDirStat]: https://github.com/shundhammer/qdirstat "QDirStat Repository"
[shadowed-doc]: https://github.com/shundhammer/qdirstat/blob/master/doc/Shadowed-by-Mount.md
"Shadowed by Mount"
[shadowed-script]: https://github.com/shundhammer/qdirstat/blob/2e78d47b10cf2157217bb015f63284de3c915a53/scripts/shadowed/unshadow-mount-points
"Script to Find Shadowed Files"

## gfxboot2: a graphical interface to bootloaders

Steffen Winterfeldt is one of our experts when it comes to system booting (and [stack-based
languages][stack] :wink:). During this Hack Week, he decided to work in [gfxboot2][gfxboot2], a
rework of the original [gfxboot](https://github.com/openSUSE/gfxboot) that he maintains but written
in C. In case you do not know, *gfxboot* is the software behind the graphical menu that you get when
you boot an openSUSE installation medium.

If you are interested, read the [project's README][gfxboot2-readme] because it contains useful
information and a cat picture. :smiley:

{% include blog_img.md alt="gfxboot2" src="gfxboot2-mini.png" full_img="gfxboot2.png" %}

[gfxboot2]: https://github.com/wfeldt/gfxboot2
[gfxboot]: https://github.com/openSUSE/gfxboot
[stack]: https://en.wikipedia.org/wiki/Stack-oriented_programming
[gfxboot2-readme]: https://github.com/wfeldt/gfxboot2/blob/main/README.adoc

## UCMT: Unified Config Management Tool

Josef Reidinger has been exploring an interesting concept: the Unified Config Management Tool. The
idea is that you configure your system using any tool you like and, after that, you can easily
export, adapt and apply the configuration locally or on several machines.

Wait a minute, it sounds like another [configuration management][scm] tool, isn't it? Well, not
really. *UCMT* sits on top of those tools, and it is able to write the configuration in a way that
can be used by [Salt][salt], [Ansible][ansible], and so on. Moreover, the plan is to provide
additional features like a good-looking user interface and a plugins system.

Do you want to know more? Then, check the [project's repository][ucmt] because it contains many
ideas, use cases and even a screencast. You know, a picture is worth a thousand words.

{% include blog_img.md alt="UCMT in action" src="ucmt.gif" full_img="ucmt.gif" %}

[scm]: https://en.wikipedia.org/wiki/Software_configuration_management "Software Configuration Management"
[ucmt]: https://github.com/jreidinger/ucmt "UCMT Repository"
[salt]: https://saltproject.io/ "Salt Project"
[ansible]: https://www.ansible.com/ "Ansible"

## Tracking Horses

Perhaps this is the most original project. Michal Filka started to work on a low-power GPS tracker
for animals, although he targets horses at this point. He has identified several problems with
the current solutions, so he decided to work on an alternative.

The project is still in the research phase, but it is worth reading [his notes][horses-tracker].
Initially, he thought about using RFID, but lately, he decided to go for an Arduino-based solution
adding a GPS or GPRS chip. Even an Android application is on his roadmap!

Even if most of us do not own any horse :smiley:, we cannot wait to see how this project evolves in
the future.

[horses-tracker]: https://github.com/mchf/slides/blob/master/public/animal-tracked.md
                  "Animals GPS tracker notes"

## Playing with WebAssembly

Finally, the rest of the team (Áncor González, David Díaz, Imobach González, Jose Iván López and
Knut Andersen), decided to spent the Hack Week playing around with [WebAssembly][wasm], [the Rust
programming language][rust] and [JavaScript][javascript].

The [project's][wasm-project] main goal was to see whether the WebAssembly's promise of using
the same compiled code in multiple environments was true. For that matter, they decided to write a
simplified data model representing the network configuration, compile it to WebAssembly and try to
use it from both environments.

They learned that things are not that straightforward, and you need to keep separate bindings for
each platform. So, in the end, it might be better to use JavaScript bindings for the web and FFI
based ones for the local system.

By the way, they took the opportunity to [play][y3network-ui] with [Glimmer][glimmer], an
interesting DSL framework for writing GUI applications in Ruby.

[wasm]: https://webassembly.org/ "WebAssembly"
[rust]: https://rust-lang.org/ "Rust Programming Language"
[javascript]: https://developer.mozilla.org/en-US/docs/Web/javascript "MDN Web Docs: JavaScript"
[wasm-project]: https://hackweek.suse.com/20/projects/sharing-logic-between-desktop-and-web-based-applications-through-wasm
                "Sharing Logic Between Desktop and Web-Based Applications through WASM"
[y3network]: https://gitlab.com/imobachgs/y3network "Y3Network Repository"
[y3network-ui]: https://github.com/ancorgs/y3network-ruby-ui "Y3Network Ruby UI Experiments"
[glimmer]: https://github.com/AndyObtiva/glimmer "Glimmer"

## Closing Words

We are sure that this Hack Week was rather challenging for the organizers, as they needed to
work-around the limitations imposed by the COVID-19 mess. But we think they did a great job! We had
a lot of fun meeting our colleagues in [Work Adventure][workadventure], we enjoyed the *social
hours*, learned a lot with the [Rust Bootcamp][rust-bootcamp] and we managed to share our projects
and collaborate with each other.

So thanks a lot to everyone involved!

[workadventure]: https://workadventu.re/
[rust-bootcamp]: https://hackweek.suse.com/20/projects/rust-bootcamp
