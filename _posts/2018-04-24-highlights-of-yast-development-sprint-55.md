---
layout: post
date: 2018-04-24 14:01:09.000000000 +00:00
title: Highlights of YaST Development Sprint 55
description: Time flies. We are almost in May and the openSUSE Conference &#8217;18
  is around the corner. So after booking your flights (if you need to) and your acommodation,
  you might want to know what happened in the YaST world during the Development Sprint
  55th.
category: SCRUM
tags:
- Distribution
- Factory
- Localization
- Systems Management
- YaST
---

The YaST team is currently polishing the upcoming release, introducing
some improvements and fixes. There are no breaking changes but still we
have a lot of things to blog about.

## Updating NFS Version Handling

Once upon a time, back in 2008 to be precise, the Large Hadron Collider
(LHC) was finally ready, Raúl Castro replaced Fidel as President of
Cuba, the TV show Phineas and Ferb was previewed… and `yast2-nfs-client`
added support to configure NFSv4 mounts. Back then, the proper way of
doing that was using “nfs4” as type for mounting the NFS share, i.e.
writing “nfs4” in the `vfstype` column of the `/etc/fstab` file. Some
time later, NFS4.1 (also known as pNFS) came out, and a new mount option
“minorversion=1” was added. Very soon it was clear that such solution
was not scaling and was not the way to go.

So at some point “nfs4” was deprecated as acceptable value for `vfstype`
and “minorversion” was ditched in favor of “nfsvers”. Since the old
deprecated way of doing things was still working, `yast2-nfs-client` was
never updated to reflect this. But starting with the upcoming Leap 15
and SLE 15, some things will change in NFSland (in fact, the change
landed in openSUSE Tumbleweed some time ago already). The type “nfs4”
will be considered identical to “nfs” and “minorversion” will be
completely ignored, so your old NFS mounts may not work as you expect
them to do it. Time to refresh `yast2-nfs-client`!

During this sprint, `yast2-nfs-client` was not only fixed internally to
produce valid entries in `/etc/fstab`, it also got a slightly revamped
form to create and edit NFS mounts that should be less confusing than
the old one and also more explanatory about how NFS versioning really
works when defining a mount.

{% include blog_img.md alt="NFS version selection"
src="yast2-nfs-client-nfsv4-300x154.png" full_img="yast2-nfs-client-nfsv4.png" %}

To ensure our users don’t get fooled by old entries that seems to be
enforcing a particular NFS version (because they use “nfs4” as mount
type, for example), but are in fact not doing it due to the new behavior
in SLE 15 and openSUSE 15, `yast2-nfs-client` is now able to detect such
circumstance, mark such entries in the list and offer a safe migration
path to users.

{% include blog_img.md alt="nfs4 warning"
src="yast2-nfs-client-nfs4-warning-300x207.png" full_img="yast2-nfs-client-nfs4-warning.png" %}

As you can infer from the screenshot above, all these improvements are
available when `yast2-nfs-client` runs standalone, as well as when it
runs embedded within the YaST Partitioner. Enjoy!

## Fixing Broken Translations

Recently we got some bug reports about YaST crashing at some points when
running in some specific locales. It turned out that the problem was
caused by broken translations.

A lot of translated texts contain placeholders like `%s`, `%{text}` or
`%1`. These tags are replaced by the real values by YaST. But that
requires that the translated text contains the same tags. If they are
missing the value will not be included and, what is even worst, if they
are invalid the Ruby interpreter throws an exception which means YaST
aborts making our users unhappy. And that’s really bad, right?

Unfortunately the Ruby gettext does not support format tags and the GNU
gettext does not support Ruby at all. As a quick solution we wrote a
script which checks whether all tags are included in the translated text
and reports broken translations.

The script found about 160 broken translations. The most common problems
were usually just typos (`s%` instead of `%s`, {% raw %}`{%foo}`{% endraw %}
instead of `%{foo}`, or extra space in `%␣1`). But some cases were not that
trivial. Translators by mistake also used the Unicode `٪` instead of the
ASCII `%` or even translated the tags, which must stay untouched
(`%{مساعدة}`).

Some translations were obviously wrong or even contained the original
English texts – we removed them. In some cases the tags were wrong but
we were not sure whether the whole translation is valid. In that case
instead of fixing the tags we removed the translated text completely. It
is better to ask the translators for translating again than have a
completely invalid translation.

In the future we plan to improve these checks, so the tags are properly
handled by Ruby and/or GNU gettext directly and we do not need a
separate script for that.

## Installing Over VNC Using the Browser

You are surely accustomed to remote administration using SSH. And, as
you may know, the (open)SUSE installation can be done over SSH too. But,
additionally, YaST also have support for installing over [VNC][1]{:
rel="nofollow"}.

When using VNC for installation, you can choose between using a native
VNC viewer or a web browser based one. The cool thing about the second
option, is that you can follow the installation just pointing your
browser to `http://IP-ADDRESS:5801`.

Until now, YaST was using a Java applet based implementation, which is
no longer supported in browsers. But during this sprint, we have
completed the switch to a JavaScript based solution.

Unfortunately, that has resulted in losing an encryption layer: the HTTP
connection on port 5801 is unencrypted, but the typical VNC port (5901)
continues to be encrypted.

## Asking Once About Equivalent Licenses

After splitting SUSE Linux Enterprise in several modules, it was pretty
common that the user had to accept a couple of equivalent licenses
during the installation process. Given that the content for those
licenses was pretty much the same, it was quite confusing. Actually, we
got a bug report about the installation process being stuck asking the
user to accept the license over and over (it was just the same license
being shown for different modules).

In order to make our users happy, YaST is now able to decide whether two
licenses are the same and, in that case, it will only ask once for
acceptance. For the time being, YaST applies a hash function to license
contents and compare the result, but most likely this mechanism will be
refined in the future.

## License Confirmation in CaaSP 3.0

And talking about licenses, another small change about how they are
handled was introduced in CaaSP 3.0. As you know, CaaSP features a One
Dialog Installer and there was no room for the license to be shown. Now,
before proceeding with the installation, YaST will show the license in
the confirmation screen if needed.

{% include blog_img.md alt="CaaSP 3.0 License Confirmation Popup"
src="caasp-3-license-confirmation-300x188.png" full_img="caasp-3-license-confirmation.png" %}

## Improving the `addon` Boot Option Handling

Back in February, we [improved the `addon` boot option][2]{:
rel="nofollow"} to handle the SUSE Linux Packages DVD properly. However,
during testing, we found out that if you are using a system which only
has one DVD drive, the installation DVD will be automatically used as an
`addon`.

In order to fix this conflict, if the installation media and the
Packages DVD are going to use the same drive, YaST will ask the user to
change the DVD before using it as an addon.

Additionally, we improved the [documentation of the addon boot
option][3]{: rel="nofollow"} adding new examples to clarify how the
`dvd:///` URLs are handled.

## Echoes of Winter: White Text on a White Background

These days we fixed a bug that only allowed clairvoyant users to finish
the installation of [openSUSE Kubic][4]{: rel="nofollow"}.

The bug is pretty unremarkable but may we draw your attention to the
related CSS styling engine? It powers the high-contrast color mode that
you can select with F3 or with [Y2STYLE][5]{: rel="nofollow"}\:

{% include blog_img.md alt="Linuxrc Color Mode Selection"
src="linuxrc-color-mode-selection-150x150.png" full_img="linuxrc-color-mode-selection.png" %}

{% include blog_img.md alt="Installer in High Contrast Mode"
src="installer-high-contrast-150x150.png" full_img="installer-high-contrast.png" %}

and if you press Ctrl-Alt-Shift-S (for **s**tyle) you can change the
styling on the fly, as in this example of changing the background color:

{% include blog_img.md alt="Installer Stylesheet Editor"
src="installer-stylesheet-editor-300x233.png"
full_img="installer-stylesheet-editor.png" %}

## Conclusions   {#conclusions}

openSUSE Leap 15.0 release is approaching and, as usual, we need help
from our dear users to give testing versions a try and report bugs.
Thanks in advance!



[1]: https://en.wikipedia.org/wiki/Virtual_Network_Computing
[2]: https://lizards.opensuse.org/2018/02/22/highlights-of-yast-development-sprint-51/#made-the-addon-linuxrc-option-work-well-with-the-packages-dvd
[3]: https://en.opensuse.org/SDB:Linuxrc#p_addon
[4]: https://en.opensuse.org/Portal:Kubic
[5]: https://en.opensuse.org/SDB:YaST_tricks
