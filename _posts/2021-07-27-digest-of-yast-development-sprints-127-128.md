---
layout: post
date: 2021-07-27 06:00:00 +00:00
title: Digest of YaST Development Sprints 127 & 128
description: Another update from the YaST Team including news that go beyond the scope of YaST
permalink: blog/2021-07-27/sprint-127-128
tags:
- Distribution
- Factory
- Programming
- Systems Management
- YaST
---

It's summer in Europe and that means vacations for most members of the YaST Team at SUSE. Although
that may imply less frequent blogging, we have some news to share with you today, like:

- Taking over the development of the (open)SUSE Release Tools
- Improvements in the new `check-profile` command
- Finished migration from Travis CI to GitHub Actions
- Several interesting bug fixes

Let's go into some details

## Release Tools: YaST Team to the Rescue! {#osrt}

As you all know, developing and maintaining complex software distributions like openSUSE Leap,
Tumbleweed or SUSE Linux Enterprise is not an easy task. Specially since we want to ensure all of
them stay independent but at the same time closely related, and since they keep evolving in new
directions like Kubic, MicroOS and SLE Micro.

Our beloved [Open Build Service](https://openbuildservice.org/) is the key component that makes all
that possible. But some extra tools are needed in addition to OBS in order to manage the complexity
of the (open)SUSE distributions. Those extra tools are hosted and developed in a GitHub repository
simply called [openSUSE-release-tools](https://github.com/openSUSE/openSUSE-release-tools). For
years, the development process of those tools has been highly unstructured (not to say "slightly
chaotic"), with more than 60 contributors but no clear mid-term strategy. Although that is not
necessarily bad, some sustained and directed development is needed to solve some of the challenges
we have ahead of us and to fix some pitfalls in the current development process of the openSUSE and
SUSE products and distributions.

The YaST Team was chosen for such a task, so we will steadily take over development and maintenance
of the tools in that repository. As first steps, we improved a lot the documenation. That includes
extending the [README
file](https://github.com/openSUSE/openSUSE-release-tools/blob/master/README.md) and adding new
documents like [an inventory of
tools](https://github.com/openSUSE/openSUSE-release-tools/blob/master/CONTENTS.md) and a [summary of
the processes](https://github.com/openSUSE/openSUSE-release-tools/blob/master/docs/processes.md) in
which those tools are involved. We also extended and updated the automated tests and implemented
an easy new check in the `factory-auto` bot.

We have way more ambitious plans for the future, but we are still learning and discovering new stuff
in that repository every day.

## Improvements in the AutoYaST Profile Validation {#check-profile}

As you may know, we recently [introduced]({{site.baseurl}}/blog/2021-06-01/sprint-124) a YaST client
to validate complex profiles that include Embedded Ruby, rules and classes and/or scripts.
Generally, such a validation could be done without root permissions, but there are some situations
where superuser privileges are required.

To mitigate the implications, we introduced several improvements in the `check-profile` tool. You
can see the details in the description of the [corresponding pull
request](https://github.com/yast/yast-autoinstallation/pull/773).

## From Travis CI to GitHub Actions - Migration Completed {#gh-actions}

Some months ago, we started switching the continuous integration on all YaST repositories from using
[Travis CI](https://travis-ci.com/) to [GitHub Actions](https://github.com/features/actions). The
main reason was that GitHub Actions are directly integrated in GitHub so it is easier to use - no
need for extra account, less problems with authentication or permissions...

The transition is finished now. It was easy because both services are quite similar, although
support for Docker is more straightforward in GitHub Actions. In this service, the actions are
defined in YAML files in the `.github/workflows` subdirectory. We created [several
templates](https://github.com/yast/.github/tree/master/workflow-templates) for the YaST packages.

If you want to know more, read the [GitHub Actions
documentation](https://docs.github.com/en/actions).

## Interesting bug fixes {#bugfixes}

Although we spend a significant time of our sprints fixing bugs, we usually don't blog about that
part of the job because we understand is not the most exciting one. But this time we would like to
highlight some pull request you may find interesting for several reasons. Including better handling
of [failures while analyzing the system](https://github.com/yast/yast-users/pull/317), of [variables
in repository urls](https://github.com/yast/yast-yast2/pull/1183) and of [SSH authorized
keys](https://github.com/yast/yast-users/pull/320).

## We keep working {#closing}

As mentioned before, the YaST Team is not at full speed due to the vacation season. But we hope to
keep delivering interesting stuff in many fronts and we will try to keep you all updated. Meanwhile,
do as we do and have a lot of fun!
