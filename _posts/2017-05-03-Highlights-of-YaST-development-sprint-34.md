---
layout: post
date: 2017-05-03
title: Highlights of YaST development sprint 34
description: Another SCRUM sprint has just passed...
comments: false
category: SCRUM
tags: 
- Documentation
- Factory
- Miscellaneous
- openSUSE
- Programming
- Ruby
- Systems Management
- YaST
---

## Introduction

### Just a Template

- This is just a template file for collecting the text for the
  [team blog](https://lizards.opensuse.org/).
- Whenever you finish something worth mentioning in the blog just add a new entry
- The text will be reviewed and polished before publishing, this is just to collect
  the input from the developers. So be focused on the technical side, the wording,
  grammar, etc... will be improved later :wink:

### How to Write

- Adapt the YAML header as needed. See the [list of already used tags](http://yast.github.io/blog/tags),
  but feel free to add a new one if needed.
- See the [documentation](https://yast.github.io/blog/how_to_write) for more details.
- It is a good idea to add a link to Trello card, bugzilla or a GitHub PR for the reference
  (it will not be published in the final text but it will make the review or changes
  easier).

### Preview

- You can check the preview [here (TODO)], please note that currently we are still
  using the [lizards.o.o](https://lizards.opensuse.org/) site for the blog,
  the text will be copied and published there in the end.

---

## The Blog

> - [PBI](https://trello.com/c/UhSXj62J/926-2-skip-zfcp-controller-configuration-proposal-on-zkvm)
> - [PR](https://github.com/yast/yast-s390/pull/44)

### Fixed the ZFCP Controller Configuration in zKVM on S390, CI (Continuous Improvements)

When runing the installer on a mainframe in a zKVM virtual machine it displayes
a warning about not detected ZFCP controllers:

{% include blog_img.md alt="ZFCP Warning" src="zfcp_warning.png" attr=".thumbnail" %}

However, when running in a zKVM virtual machine the disk is accessible via
the *virtio* driver, not through an emulated ZFCP controller. The warning
is pointless and confusing.

The fix was basically just an one-liner which skips the warning when the zKVM
virtualization is detected, but the module received low maintenance so far so we
applied our [boy scout rule](https://martinfowler.com/bliki/OpportunisticRefactoring.html)
and improved the code a bit.

The improvements include using Rubocop for clean and unified coding style,
enabling code coverage to know how much the code is tested (in this case it
turned out to be horribly low, just about 4%), removing unused files, etc...
You can find the details in the [pull request](https://github.com/yast/yast-s390/pull/44).


