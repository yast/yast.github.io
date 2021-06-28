---
layout: post
date: 2021-06-28 06:00:00 +00:00
title: YaST Development Sprint 126 - Revamped Users Management
description: As the main highlight for this sprint, the YaST team reworked how the user management
  works under the hood in (Auto)YaST.
permalink: blog/2021-06-28/sprint-126
tags:
- Distribution
- Factory
- Programming
- Systems Management
- YaST
---

It's time for another of our periodic dispatches from the YaST trenches. But instead of the usual
collection of topics, this time we want to focus on a single feature that is finally landing in
openSUSE Tumbleweed after a couple of months of development. The fun thing is that, despite all the
hard work, it is a pretty unnoticeable feature for most end users.

## Managing Local Users is not that Simple

The fact is that historically YaST has not relied on `useradd` and similar tools to create, modify
and delete users and groups. Instead, it used to perform by itself all the changes in the system
like creating the home directories, assigning ids or modifying the files `/etc/passwd`,
`/etc/groups`, etc.

You may think management of users and groups has not changed much in Linux over time. After all, we
still use the traditional Unix approach to manage local users. But the reality is that, since the
birth of YaST, `useradd` has changed a lot:

  - It was totally rewritten in the jump from (open)SUSE 11 to (open)SUSE 12, the implementation of
  `useradd` traditionally available in the package `pwdutils` was replaced by an alternative one in the
  package `shadow`.
  - It changed the way the skeleton directories are created, with a more granular approach that
    copies files from several locations, not only the traditional `/etc/skel`.
  - It added management of subuids and subgids, a feature needed for running rootless containers.
  - It changed the location of its configuration, with some attributes removed from
  `/etc/defaults/useradd`, either moved to a different file or simply gone.

All those changes were incorporated to `useradd` and other related tools little by little without
having YaST into account, so the behavior of both tools has diverged over the years. That has caused
some problems in the past and could cause more in the future. So the YaST team decided it was time
to close the gap.

## What's new

Starting with the version of YaST just submitted to Tumbleweed this week, YaST now relies on
`useradd`, `groupadd` and other `shadow` tools when creating users and groups during installation
and also when using AutoYaST or YaST Firstboot. We also adapted the management of the `<user_defaults>`
section of the AutoYaST profile to make it consistent with recent versions of useradd. The changes
in that area imply dropping support for some attributes like `<groups>`, `<no_groups>` and `<skel>`.
See [the description of this pull request](https://github.com/SUSE/doc-sle/pull/901) for the
rationale and historic background of each change.

As some kind of developer-oriented bonus tracks, it's also worth noticing that YaST now offers a new
object-oriented API to read and manage local users (so-called `Y2Users`) and makes use of a new
mechanism to report errors to the user (`Y2Issues`, which is in process of adoption in other parts
of YaST as well).

## What Comes Next

As mentioned, the changes affect the installation process, AutoYaST and YaST Firstboot. But the old
code is still in place if you run the interactive YaST module to manage users and groups or the
(not exactly fully maintained) command line interface of YaST. We plan to connect those two with the
new implementation in the following weeks, so the user experience is fully consistent for all
possible usages of (Auto)YaST.

Of course, the new implementation opens the door for deeper changes affecting the YaST user
interface or the management of non-local users (LDAP, Samba, NIS...). But to be honest we do not
plan to go that far in the mid term. We plan to focus our firepower on other goals, now that the
threat caused by the inconsistency in the user management tools is under control.

## More News to Come

Of course we have worked in many other areas during the past sprint and we will continue doing so in
the future ones. So will be back soon with more news and likely with a more standard post covering
several topics. So stay tuned and see you in a couple of weeks!
