---
layout: post
date: 2016-06-23
title: Highlights of YaST development sprint 21
description: Another SCRUM Sprint finished and we have a short summary about it!
category: SCRUM
tags:
- Factory
- Systems Management
- YaST
---

### Installation Video Mode

If you need to make screenshots of the installation it is useful to
influence their size. You could press `F3` in the boot menu and choose
from a menu, but that is not well suited for scripts such as openQA.

The installer now obeys an [option][1] from the boot command line:
`xvideo`.

```
xvideo=[WIDTHxHEIGHT][,DPI]
xvideo=1024x768
xvideo=1024x768,100
xvideo=,100
```
(Available in yast2-installation-3.1.195 + yast2-x11-3.1.5.
[bsc#974821][2])

### How to Install with a Self-Signed Certificate

You can now install from a repository served with HTTPS that has a
self-signed certificate. Use a [`ssl_certs=0` boot option][3].

(Available in yast2-packager-3.1.104. [bsc#982727][4])

### Installation: Local SMT Servers are Pre-filled

Last sprint ([S#20][5]) we improved the registration UI. Now we’ve made
one more improvement: pre-filling the *Register System via local SMT
Server* field.

Before, the widget was a single text field and a little helpful
`smt.example.com` was always shown (no matter what your actual domain
was).
![local-smt-server-1-before](https://cloud.githubusercontent.com/assets/102056/16152080/50519e9e-34a0-11e6-93f1-6402aa1be0d4.png)

Now, if your local [SMT][6] servers are advertised via [SLP][7] they
will be offered as choices. (Here `acme.com` stands for your domain)
![local-smt-server-2-after](https://cloud.githubusercontent.com/assets/102056/16152092/58652218-34a0-11e6-9754-a4181ec2ea20.png)

(Available in yast2-registration-3.1.176, [bsc#981633][8].)

### New Storage: ISO

We have started building an [installation ISO image][9] with the [new
storage library][10]. The first build contains all the pieces but they
don’t work together yet.

### New Storage: Boot Scenarios

We have documented the [supported scenarios][11] regarding booting in
the new storage layer.

(Tooling note: We made this with a [Markdown formatter for
RSpec][12] invoked [like this][13].)

### Network Settings are Less Eager to Restart

If you opened Network Settings to review something, made no changes, and
closed the dialog with OK, the network would be restarted. That may be
undesirable if you have an Important Application running. We originally
thought that everyone would close the dialog with Cancel, but we were
proven wrong.

Now the module properly checks whether you have made changes to the
settings, and omits the restart if appropriate.

(Available in yast2-network-3.1.155. [FATE#318787][14])

### Network in AutoYaST

Due to a problem in the AutoYaST version shipped with SLE 12 SP1 and
openSUSE Leap 42.1, the network configuration used during the first
stage was always copied to the installed system regardless the value of
`keep_install_network`.

Upcoming SLE 12 SP2 and Leap 42.2 behaves as expected and
`keep_install_network` will be set to `true` by default.

(Available in yast2-network-3.1.157 + autoyast2-3.1.133. Fixes
[bsc#984146][15].)



[1]: https://en.opensuse.org/SDB:Linuxrc#p_xvideo
[2]: https://bugzilla.suse.com/show_bug.cgi?id=974821
[3]: https://en.opensuse.org/SDB:Linuxrc#p_sslcerts
[4]: https://bugzilla.suse.com/show_bug.cgi?id=982727
[5]: {{ site.baseurl }}{% post_url 2016-06-07-highlights-of-yast-development-sprint-20 %}
[6]: https://www.suse.com/documentation/smt11/
[7]: https://en.wikipedia.org/wiki/Service_Location_Protocol
[8]: https://bugzilla.suse.com/show_bug.cgi?id=981633
[9]: http://download.opensuse.org/repositories/YaST:/storage-ng/images
[10]: https://build.opensuse.org/project/show/YaST:storage-ng
[11]: https://github.com/yast/yast-storage-ng/blob/master/doc/boot-requirements.md
[12]: https://github.com/yast/yast-storage-ng/blob/master/src/tools/md_formatter.rb
[13]: https://github.com/yast/yast-storage-ng/blob/master/rakelib/doc_bootspecs.rake
[14]: https://fate.suse.com/318787
[15]: https://bugzilla.suse.com/show_bug.cgi?id=984146
