---
layout: post
date: 2020-06-23 08:00:00 +00:00
title: Digest of YaST Development Sprint 102
description: It's time for another development digest from The YaST team. As usual, the range
  of topics is quite broad.
category: SCRUM
permalink: blog/2020-06-23/sprint-102
tags:
- Distribution
- Factory
- Programming
- Systems Management
- YaST
---

It's time for another development digest from The YaST team. As you can see in the following list
of highlights, the range of topics is as broad as usual.

## Summary of the (Auto)YaST Changes

- [Validation of the AutoYaST profile at the beginning of the
  installation](https://github.com/yast/yast-autoinstallation/pull/624) (see
  screenshot below).
- [More robust and complete support for AutoYaST's user
  scripts](https://github.com/yast/yast-autoinstallation/pull/612).
- Improvements in AutoYaST error handling and reporting. See the [documentation pull
  request](https://github.com/yast/yast-autoinstallation/pull/625) for details.
- [Improved handling of systemd services in some corner
  cases](https://github.com/yast/yast-yast2/pull/1059).
- [Better detection](https://github.com/yast/yast-yast2/pull/1062) and [more accurate boot
  check](https://github.com/yast/yast-storage-ng/pull/1102) for XEN guests.
- [More explanatory labels in repositories management during
  upgrade](https://github.com/yast/yast-installation/pull/863).
- [Compatibility of Snapper rollbacks with transactional
  servers](https://github.com/openSUSE/snapper/pull/540).
- [Better management of automatic text wrapping in
  LibYUI](https://github.com/libyui/libyui/pull/165).

{% include blog_img.md alt="AutoYaST profile validation"
src="autoyast-validation-300x225.png" full_img="autoyast-validation.png" %}

As you can see, we have invested quite some effort improving some areas of AutoYaST. In the process,
we found ourselves over and over typing complicated URLs in the boot parameters of the installer to
access some manually crafted AutoYaST profile. To avoid the same pain in the future to other testers
or to anyone interested in taking a quick look to AutoYaST, we are working in an easy-to-type
repository of generic AutoYaST profiles. See more details in [this
announcement](https://lists.opensuse.org/yast-devel/2020-06/msg00027.html) in the yast-devel mailing
list.

The next development sprint has already started, so we hope to see you again in approximately two
weeks with more news about (Auto)YaST... unless you are too busy celebrating the release of openSUSE
Leap 15.2, expected for July 2nd!

But before you leave, we would appreciate your feedback about this blog. As you may know, this is the
second post we do with the new digest format, in which we basically collect links to several
self-descriptive pull requests. We abandoned our traditional format (a consistent and self-contained
story illustrated with screenshots) because it implied too much work. But we are curious about the
real impact of the change and of our blog in general. So we would like to kindly ask you to answer
the following three questions (questionnaire hosted by [Formspree](https://formspree.io/), an
open-source backed service).

## YaST Blog Poll

{::nomarkdown}
<form name="input" method="POST" action="https://formspree.io/ancor@suse.de"
style="border: 1px solid #BBB; border-radius: 8px; padding: 10px; margin: 10px">
  <p>How often do you read the YaST Team reports?
  <br/>
  <select name="frequency">
    <option value="never">This is my first time</option>
    <option value="depends">When I find something interesting in the summary</option>
    <option value="often">Regularly</option>
  </select>
  </p>
  <p>How do you value the new digest format compared to our traditional blog posts?
  <br/>
  <select name="format">
    <option value="1">1 - The new format is basically useless</option>
    <option value="2">2 - I prefer the previous format</option>
    <option value="3" selected="selected">3 - Both are equally valuable to me</option>
    <option value="4">4 - I prefer the new digest format</option>
    <option value="5">5 - The new digest is the only useful format</option>
  </select>
  </p>

  <p>What's your relationship with (open)SUSE? <i>e.g. openSUSE user, SUSE partner, QA Engineer...</i><br/>
  <input type="text" name="role"><br/>

  </p>
  <center><input type="submit" value="Submit form" /></center>
  <input type="hidden" name="_subject" value="Formspree test" />
</form>
{:/nomarkdown}
