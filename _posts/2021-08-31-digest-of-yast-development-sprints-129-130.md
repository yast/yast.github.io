---
layout: post
date: 2021-08-31 06:00:00 +00:00
title: Digest of YaST Development Sprints 129 & 130
description: Housekeeping, learning and much more in a new report from the YaST trenches
permalink: blog/2021-08-31/sprints-129-130
tags:
- Distribution
- Factory
- Programming
- Systems Management
- YaST
---

For some people, vacation season is just the right time for housekeeping or for learning new skills.
And that's exactly what the YaST team has been doing in the latest two sprints.

- We improved some YaST internals including:
  * Management of the `Help` button in text mode
  * Unmounting of file-systems at the end of installation
  * Handling of progress bars
- Our users also made YaST better with their contributions
- The dedicated subset of the YaST Team keeps making progress regarding the Release Tools

Let's go into the details.

## Keeping the YaST Internals in Shape {#internals}

In the software development world is not uncommon to sweep the dirt under the carpet. If something
seems to work from the user point of view, just leave it as it is. But there is no carpet to hide
anything when you develop Free Software with an open spirit. And in the YaST Team we simply don't
feel comfortable when we know the pieces under the hood are not really well adjusted. Thus, we
invested some of our summer time fixing some internal issues (both real and potential), although
none of them currently have visible impact of our users.

- All YaST screens contain a `Help` button that shows an explanatory text. But, what happens if
  there is no such text? It's a theoretical problem (there is ALWAYS a help text) but the situation
  in the ncurses text mode really needed [a better
  handling](https://github.com/libyui/libyui/pull/46).
- Unmounting file-systems at the end of the installation process is another of those things that
  seem to work flawlessly... until you take a look to the YaST logs and find out it used to be an
  slightly convulted process. But we [restructured the
  component](https://github.com/yast/yast-installation/pull/975) taking care of the process and
  things now look equally good in the surface and under the hood.
- The way progress bars are handled in YaST is admitedly error-prone and could result in the user
  interface crashing in some extreme situations. We also [improved
  that](https://github.com/yast/yast-yast2/pull/1181) by making the `Yast::Progress` internal module
  more robust.

## Integrating Community Contributions {#contributions}

Another of the great things of working in an Open Source project is getting contributions from your
own users. In that regard, we recently added [support for the AFNOR
variant](https://github.com/yast/yast-country/pull/273) of the French keyboard, which was useful to
realize we haven't incorporated such layout to SUSE Linux Enterprise. We did now, so both SLE and
openSUSE got better thanks to the openSUSE community. Something that will soon happen also to the
YaST Journal module as soon as we merge [this other
contribution](https://github.com/yast/yast-country/pull/273) currently under review.

## Release Tools: We Keep Learning {#osrt}

And talking about collaboration, in our [previous
post]({{site.baseurl}}/blog/2021-07-27/sprint-127-128) we told you about our new mission of helping
with the development and maintenance of the (open)SUSE Release Tools. We keep working on that front,
although progress can only be slow when most of the people we have to interact with (and a big part
of the YaST Team itself) is on vacation. Nevertheless, we keep researching possible solutions for
the known problems, [improving the testing
infrastructure](https://github.com/openSUSE/openSUSE-release-tools/pull/2608) and using a
test-driven approach to [lower the entry
barrier](https://github.com/openSUSE/openSUSE-release-tools/pull/2617) for newcomers.

## See you soon {#closing}

The vacation season in Europe is comming to an end, so we hope to have more exciting news for
upcoming blog posts. Meanwhile, please keep helping us and having a lot of fun!
