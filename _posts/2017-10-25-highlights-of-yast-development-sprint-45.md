---
layout: post
date: 2017-10-25 12:39:44.000000000 +00:00
title: Highlights of YaST Development Sprint 45
description: 'The wait is over: finally a new YaST team report, with news about our
  45th sprint!'
category: SCRUM
tags:
- Distribution
- Programming
- Systems Management
- YaST
---

Our team is still focused on the development of the upcoming SUSE Linux
Enterprise (SLE) 15 products family and openSUSE Leap 15, which in this
sprint resulted in new dialogs to select modules and extensions, changes
for the multi-product medium, and fixes for issues that have been found
during our development phase. So let’s check out the most interesting
things that came out of our last sprint.

### New Modules/Extensions Selection

SLE has a specific dialog that allows the user to select additional
modules or extensions. When we first introduced this selection dialog,
the extensions could have only a single dependency, which resulted in a
maximum of only two levels of dependency. During this last sprint, we
implemented changes to allow a chain of dependencies. You can check on
the image below this new selection dialog in action:

{% include blog_img.md alt=""
src="New_Modules_Extensions_Selection.gif" full_img="New_Modules_Extensions_Selection.gif" %}

### Reliable Self Update for Multi Product medium

Until now, the self-update URL depends on the product which is ship in
the medium. However, as you may know, SLE 15 product family will be
shipped in a multi-product installation medium. For that reason,
sometimes self-update was failing as only a single product is defined in
SCC.  
 Now we have fixed this issue by a defining self-update identifier that
is used instead of a product name, which allows the self-update feature
to work in a reliable way.

### Welcome screen adapted for upgrading

[Some sprints ago](
{{ site.baseurl }}{% post_url 2017-09-07-highlights-of-yast-development-sprint-42 %})

we announced the addition of product selection to the initial screen for
LeanOS installer.

The welcome dialog is shared between different workflows like between
installation and upgrading. The problem is that for upgrading we need to
find the target system or root partition before selecting the product to
migrate. Now it does not require any selection if there are no products
to select, so it will work when upgrading. Besides that, we have
polished some presentation details like the dialog title and the product
selector caption.

Check out the screenshots below to see the final result:

LeanOS:

{% include blog_img.md alt="LeanOS: Welcome upgrade"
src="welcome_upgrade-300x225.png" full_img="welcome_upgrade-300x225.png" %}

{% include blog_img.md alt=""
src="upgrade_sle-12-sp2-300x225.png" full_img="upgrade_sle-12-sp2.png" %}

Tumbleweed:

{% include blog_img.md alt=""
src="tw_installation_-_missing_license-_showing_empty_products-300x225.png"
full_img="tw_installation_-_missing_license-_showing_empty_products.png" %}

{% include blog_img.md alt=""
src="upgrade_tw-300x225.png" full_img="upgrade_tw.png" %}

### Unavailable Packages in AutoYaST

AutoYaST needs to make sure that, after rebooting into the 2nd stage
(when needed), the user can access to the installation process using the
same tools that he/she used during the 1st installation stage. Apart
AutoYaST packages it self, it may need to install other additional tools
like VNC, SSH or the X.org system.

Unfortunately, as SLE 15 is split into modules, it’s not guaranteed that
the VNC, SSH or X.org packages can be installed, which resulted in
AutoYaST failing when trying to install those packages.

We have improved the package handling and now YaST displays a warning
that the packages are missing and the system (and later the installer)
could not be accessed as expected. However, the AutoYaST installation
can still proceed although you cannot watch AutoYaST running during 2nd
stage.

{% include blog_img.md alt="Unavailable AutoYaST Packages"
src="Unavailable_Packages_AutoYaST-300x225.jpg"
full_img="Unavailable_Packages_AutoYaST.jpg" %}

### Improved Handling of Multi-repository Media

We got some bug reports about the new multi-repository media handling in
YaST (mentioned in the [sprint 43 report](
{{ site.baseurl }}{% post_url 2017-09-21-highlights-of-yast-development-sprint-43 %})).
Some of the problems were delegated to the underlying libzypp library, but we got
our share of real YaST issues.

One of those problems was, for instance, the inconsistent styling of the
MultiSelectionBox widget used in that dialog, which was pretty
confusing. Fortunately, the issue has been fixed and now it looks the
same than any standard checkbox widget.

{% include blog_img.md alt="Multi repository media"
src="Multi_repository_Media-300x225.png" full_img="Multi_repository_Media.png" %}

### More to come

The 46th sprint has already started and has many new items planned to be
developed, especially for the SLE15 and openSUSE Leap 15 installer. We
are looking forward to bring these planned features to life and tell you
about all the details of this sprint. Meanwhile, have fun and stay
tuned!

