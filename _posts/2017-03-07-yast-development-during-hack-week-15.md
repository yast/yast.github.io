---
layout: post
date: 2017-03-07 12:13:22.000000000 +01:00
title: YaST development during Hack Week 15
description: During this Hack Week, some of our team members invested quite some time
  working in YaST related projects. But, what's even better, some people from
  outside the team worked also in YaST projects.
category: Hackweek
tags:
- AppArmor
- Desktop
- Hackweek
- YaST
---

During this Hack Week, some of our team members invested quite some time
working in YaST related projects. But, what’s even better, some people
from outside the team worked also in YaST projects. Thank you guys!

So let’s summarize those projects and also some extra ones from our team
members.

### Let’s Encrypt made easy in openSUSE

Daniel Molkentin enjoyed his first Hack Week working together with Klaas
Freitag to bring [Let’s Encrypt][1] integration to openSUSE. Although
they didn’t had experience with YaST development, they followed the
[YaST tutorial][2] and created a new brand yast-acme module. It’s still
a work in progress, but it looks promising.

{% include blog_img.md alt="Managing certificates" src="yast-acme-300x146.png"
full_img="yast-acme.png" %}

You can get more details reading the [Daniel Molkentin’s blog post][3]
about the project.

### Removing perl-apparmor dependency

Goldwyn Rodrigues worked to remove the dependency of yast-apparmor on
(now obsolete) perl-apparmor. There’s quite some work to do, but he’s
heading in the right direction.

Find out more about the project in the [Hack Week page][4] and in
[Goldwyn’s fork.][5]

### gfxboot for grub2

Steffen Winterfeldt was working in *gfxboot2*, an attempt to provide a
graphical user interface for grub2. Although it’s still a work in
progress, it looks really good: module works for *grub2-legacy* and
*grub2-efi*, basic font rendering is in place, language primitives are
partly implemented, the integrated debugger already works…

{% include blog_img.md alt="gfxboot2" src="gfxboot2_debug-300x225.png"
full_img="gfxboot2_debug.png" %}

You can find further information in the [projects page][6].

### YaST Integration Tests using Cucumber

The YaST team is always trying to improve their testing tools so
Ladislav Slezák has been working in a proof of concept to use
[Cucumber][7] to run YaST integration tests and the results are pretty
impressive. The prototype is able to test YaST in an installed system,
during installation and it can be used even for plain libyui
applications outside YaST.

{% include blog_img.md alt="Test adding repository" src="add_repo-300x298.gif"
full_img="add_repo.gif" %}

Check out the details at [project’s page][8] and at [Ladislav’s
blog][9].

### Keep working on libstorage-ng

If you follow YaST development, you know that the team is making good
progress towards replacing the old *libstorage*. And even during Hack
Week, *libstorage-ng* got some love from our hackers.

Arvin Schnell implemented support [for more filesystems in
libstorage-ng][10]\: ext2, ext3, ReiserFS, ISO 9660, UDF and basic
support for NFS.

Iván López invested his first Hack Week improving
[yast2-storage-ng][11]. Read this [description][12] to find out more
information about the changes.

And last but not least, apart from helping Iván with his project, Ancor
González worked in a [new approach for *yast2-storage-ng*][13]\: instead
of just extending the API offered by *libstorage-ng*, the idea is to
wrap the library so the Ruby code using *yast2-storage-ng* does not have
direct visibility on the *libstorage-ng* classes and methods.

### More Ruby in YaST

Josef Reidinger is trying to reduce the amount of code in other
languages different than Ruby. He successfully replaced the binary
*y2base* with a Ruby version (not merged yet) and reduced the amount of
Perl code in the *yast2* package.

You can check the progress in [yast-ruby-bindings#191][14] and
[yast-yast2#540][15] pull requests.

### Support for Salt parametrizable formulas

[YaST2 CM][16] was born in 2016 as a proof of concept to somehow
integrate AutoYaST with Software Configuration Management systems like
Salt or Puppet.

During this Hack Week, Duncan Mac Vicar and Imobach González were
working to implement support for Salt parametrizable formulas. You can
find out more information in this [post at Imobach’s blog][17].

### Other non-YaST projects

Hack Week allows us to work in any project we want, so there’re also
some non-YaST related projects that we would like to mention.

#### Improved QDirStat

QDirStat is a Qt-based tool which offers directory statistics. His
author, Stefan Hundhammer,implemented some new features (like a better
behavior when hovering over a tree map or improved logging) and fixed
some bugs. Find out more details in the [project’s README][18] and the
[version 1.3 release notes]().

He also wrote an [article][19] about how to use the application in
headless systems (no X server, no Xlibs).

Current version is already available at [software.opensuse.org][20] so
you could consider giving it a try.

#### Learning new things

Hack Week is a great opportunity to play with new stuff. With that idea
in mind, Martin Vidner learned about Android development and wrote
detailed instructions for starting with that: [Getting Started in
Android Development: Part 1: Building the First App][21], [Part 2:
Publishing the First App][22] and [Part 3: Reducing Bloat][23].

Knut Anderssen decided to try also some mobile development and enjoyed
playing around with the [Ionic][24].

And that’s all! After Hack Week, we’re back to SCRUM and we’re now
working sprint 32. We’ll give you additional details in our next
“Highlights of YaST development” report.

Stay tunned!



[1]: https://letsencrypt.org/
[2]: https://ancorgs.github.io/yast-journalctl-tutorial/
[3]: https://daniel.molkentin.net/2017/02/28/letsencrypt-support-for-opensuse/
[4]: https://hackweek.suse.com/projects/get-rid-of-perl-apparmor
[5]: https://github.com/goldwynr/yast-apparmor
[6]: https://hackweek.suse.com/15/projects/gfxboot-for-grub2
[7]: http://cucumber.io/
[8]: https://hackweek.suse.com/projects/yast-integration-tests-using-cucumber
[9]: http://blog.ladslezak.cz/2017/03/01/hackweek-15-yast-cucumber/
[10]: https://hackweek.suse.com/15/projects/implement-more-all-missing-filesystems-in-libstorage-ng
[11]: https://hackweek.suse.com/15/projects/yast-storage-ng-improvements
[12]: https://gist.github.com/joseivanlopez/4b1f1091d212b10b0970cdd691ea2f2e
[13]: https://hackweek.suse.com/projects/yast2-storage-ng-as-a-libstorage-ng-wrapper-poc
[14]: https://github.com/yast/yast-ruby-bindings/pull/191
[15]: https://github.com/yast/yast-yast2/pull/540
[16]: https://github.com/imobachgs/yast-cm
[17]: https://imobachgs.github.io/yast/2017/03/01/yast2-cm-gets-support-for-salt-parametrizable-formulas.html
[18]: https://github.com/shundhammer/qdirstat#current-development-status
[19]: https://github.com/shundhammer/qdirstat/blob/master/doc/QDirStat-for-Servers.md
[20]: http://software.opensuse.org/package/qdirstat?search_term=qdirstat
[21]: http://mvidner.blogspot.cz/2017/02/getting-started-in-android-development.html
[22]: http://mvidner.blogspot.cz/2017/02/publishing-the-first-app.html
[23]: http://mvidner.blogspot.cz/2017/03/reducing-android-bloat.html
[24]: https://ionicframework.com/
