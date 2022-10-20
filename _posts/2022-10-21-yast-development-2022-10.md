---
layout: post
date: 2022-10-20 06:00:00 +00:00
title: YaST Development Report - Chapter 10 of 2022
description: Another report from the YaST Team trenches proving we fire in many directions
permalink: blog/2022-10-20/yast-report-2022-10
tags:
- Distribution
- Factory
- Programming
- Systems Management
- YaST
---

Almost one month after our latest update, here it comes a bunch of news from the YaST Team trenches. And, as usual, we fire in many directions including:

  - Several news about D-Installer
  - An update about the new Security Policies in the YaST installer
  - An effort to streamline a bit the YaST container
  - Some polishing of Podman checkpoints

So let's go into the details.

## Fueling the D-Installer Project {#dinstaller}

Some months ago [we
presented]({{site.baseurl}}/blog/2022-01-18/announcing-the-d-installer-project) our proof of concept
for a future Linux installer codenamed D-Installer. Since then, we have scattered news about it on
our blog posts. Now we decided it's the right time to invest a bit more in the project in order to
move it forward.

As a first step, we improved [the README
file](https://github.com/yast/d-installer/blob/master/README.md) that serves as landing page for the
project. Now it includes more information about the motivation and general structure of the project,
as well as some screenshots of the web interface.

We also designed the D-Bus and web interfaces for defining the storage setup. That is, the set of
partitions, LVM logical volumes and related data structures that should be created to install the
system on. We published [a
document](https://github.com/yast/d-installer/blob/master/doc/storage_ui.md) describing how it could
work and we are already implementing that behavior. So if you have questions or suggestions, please
speak up the sooner the better.

We are also making good progress in the configuration of the network, but since the feature is
not complete yet we will save those news for upcoming blog posts. ;-)

On a more technical level, we introduced type checking in the JavaScript part of D-Installer by
relying on TypeScript support for JSDoc annotations. If you don't care about software internals,
the previous sentence is just gibberish you can happily ignore. But if you are a JavaScript
developer working on a project that is growing a bit too much, you may be interested in checking
[our approach](https://github.com/yast/d-installer/pull/257) in order to take advantage of the
most important feature of TypeScript without actually changing the implementation language of the
project.

## Security Policies in the YaST Installer {#stig}

Although we envision D-Installer as the future of (open)SUSE installation, we never forget YaST is
still the present and will remain so for some years. Therefore we keep enhancing it and adapting it
to new use cases. Lately we invested some time polishing the feature about security policies we
[originally presented some posts ago]({{site.baseurl}}/blog/2022-08-23/yast-report-2022-7#policies),
based on the feedback we keep receiving about it.

As you can see in the screenshot below, now the initial scan performed in the first boot after
installation is configurable and can even be skipped in order to be run manually afterwards.
Additionally we changed the way the failing rules are presented and the way to acknowledge the
situation in order to continue with the installation anyway. Moreover we extended the help texts to
better explain the rationale and implications of each option.

{% include blog_img.md alt="The installer checking the DISA STIG"
src="stig-mini.png" full_img="stig.png" %}

You can check up-to-date information about the feature and several current screenshots (bear in mind
they are collapsed by default) at [this pull
request](https://github.com/yast/yast-security/pull/142).

## A More Container-friendly iSCSI Client {#iscsi}

The containerized version of YaST includes several modules that are known to work correctly when
executed from a container. But "correctly" does not always imply "optimally". For example, the
module for configuring iSCSI clients required some iSCSI tools to be installed both in the system to
be managed (as expected) and in the container itself. That impacted the size of the YaST container,
even for those who were not interested in executing `yast2-iscsi-client`. Moreover, while
investigating that circumstance, we found the dependencies of the package were not aligned with YaST
best practices. All that is [fixed now](https://github.com/yast/yast-iscsi-client/pull/121) and we
have a more maintainable and standardized YaST iSCSI Client and a smaller YaST container.

## Helping to Fix Problems with Cockpit and Podman Checkpoints {#criu}

Talking about system management tools, you already know our team is lately looking beyond YaST and
trying to help with the maintenance and integration of Cockpit. As a consequence of that continuous
effort, we realized the functionality for creating checkpoints for Podman containers was not working
as expected in openSUSE Tumbleweed nor in the ALP prototypes due to some problem in the package
`criu`. Fortunately we are surrounded by people smarter than us, so we contacted Takashi Iwai and
helped him to diagnose the problem. As a result, `criu` and Podman checkpoints are now working again
in both Tumbleweed and the ALP prototypes. But don't ask us for technical details, it's all
Takashi's merit.

## More to Come {#conclusion}

We keep working in all the areas related to system installation and configuration, so we hope to be
back soon with more news about D-Installer, Cockpit and, of course, YaST. Meanwhile do as chameleons
do and have a lot of fun!
