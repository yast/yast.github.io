---
layout: post
date: 2020-04-30 09:00:00 +00:00
title: Modernizing AutoYaST
description: AutoYaST has been around for more than 20 years and, at some extent, it is showing its age. But we have a plan!
category: Development
permalink: blog/2020-04-30/modernizing-autoyast
tags:
- Factory
- Programming
- Software Management
- Systems Management
- YaST
- AutoYaST
---

## Introduction

YaST2 is a venerable project that has been around for more than 20 years now. It keeps evolving and,
with every SUSE and openSUSE release, it takes several new features (and a couple of new bugs).
Needlessly to say that, to some extent, YaST2 is showing its age. We are aware of it, and we have
been working to tackle this problem. The successful rewrite of the storage layer, which brought many
features, is an example we can feel proud of.

Now that the development of SLE 15 SP2 and openSUSE Leap 15.2 features is mostly done, we have
started to look to AutoYaST. The purpose of this article is to present our initiative to **modernize
AutoYaST**.

First of all, let's make it clear: we do not plan to rewrite AutoYaST. What we want to do is:

- Fix several bugs and remove some known limitations.
- Improve the tooling around AutoYaST.
- Introduce a few features that can help our users.
- Work hard to improve code quality.

Although nothing is set in stone yet, this document tries to present some ideas we are considering.
But they are just that, ideas. We have identified the main areas that we want to improve, and now we
are trying to come up with a more concrete (and realistic) plan.

## Creating a profile does not need to be hard

Perhaps one of the main complaints about using AutoYaST is that writing a profile can be tricky. The
*easiest* way is to perform a manual installation and generate the profile from the command line or
using the AutoYaST UI.

If you decide to go for the command line approach, `yast2 clone_system` generates an XML file
containing all the details from the underlying system. The generated profile is quite long, and
usually you want to make it shorter by removing unimportant sections. For instance, you do not need
the full list of users (the corresponding packages creates them) or services.

The alternative is to use the AutoYaST UI, which is a tool that allows you to create and edit
profiles, although it has several bugs that we need to fix.

As part of this **modernizing AutoYaST** initiative, we would like to make things easier when it
comes to deal with profiles. We are considering a few options:

- Improve AutoYaST UI quality.
- Provide a set of templates you can base on: `minimal`, `hardening`, etc.
- Optionally, do not export the default options, making the profile shorter.
- Implement a wizard that can guide you through the process of creating a profile from scratch
  (selecting the product, the list of add-ons, the filesystem type, etc.). It could also offer a
  CLI:

```
$ yast2 autoyast_profile --product SLES-15.2 \
  --addons sle-module-basesystem,sle-module-development-tools \
  --regcode XXXX \
  --filesystem btrfs
```

## Integrated profile validation

One of the advantages of using XML is that we can rely on the existing tools to validate the
profile. The AutoYaST Guide
[documents](https://documentation.suse.com/sles/15-SP1/single-html/SLES-autoyast/#Profile-Format)
the usage of `xmllint` and `jing` for that. As part of this initiative, we would like to integrate
the validation within the installation process. So one of the first things that AutoYaST would do
is checking whether the profile is valid or not.

However, this kind of validation does not detect logical problems. Some of them are easy to find by
just analyzing the profile, and we could consider adding some additional checks. But there is
another whole category of problems that you cannot anticipate. For instance, consider that you want
to reuse a partition that does not exist. And that brings us to the next topic: error reporting.

## Better error reporting

If something unexpected happens during the installation, AutoYaST reports the issue. The user can
decide whether a problem [should stop the
installation](https://documentation.suse.com/sles/15-SP1/single-html/SLES-autoyast/#CreateProfile-Reporting)
or not depending on its severity. Obviously, in some cases, the installation is simply not possible
and AutoYaST aborts the process.

Error reporting infrastructure can be improved. For instance, it would be nice to group related
messages and show them at once, instead of stopping the installation several times. Fortunately,
during the storage layer rewrite, we introduced a mechanism that enables us to do that. Now it is a
matter of extending its API and using it in more places.

Another nice feature could be to allow filtering the messages not only by its severity but by its
module as well (e.g., partitioning warnings only), offering more control on error reporting. And the
new code would enable us to do that.

## Getting rid of the 2nd stage

Depending on the content of the profile, the installation would be finished **after** the first
reboot. In the past, SUSE and openSUSE installation took place in two phases known as *stages*,
but that it is not true anymore for the manual installation. However, AutoYaST still requires that
in some cases. For instance, if you use the `<files>` section, AutoYaST copies the files after
rebooting.

We plan to move everything we can to the 1st stage, skipping the 2nd stage entirely. We will keep
the 2nd stage, though, because third party modules could use it as an extension point. But YaST2
core modules should avoid it.

To be honest, it sounds easier than it is (there are some corner cases to consider), and we are
still checking whether it is technically possible.

## Introducing dynamic profiles

In some situations, it is desirable to modify a profile at runtime. For instance, let's consider
that you want to install several machines with different software selections. The profiles would be
almost identical, so it does not make sense to keep one for each machine.

AutoYaST already offers two mechanisms for that: [rules and
classes](https://documentation.suse.com/sles/15-SP1/single-html/SLES-autoyast/#rulesandclass) and
[pre-install
scripts](https://documentation.suse.com/sles/15-SP1/single-html/SLES-autoyast/#pre-install-scripts).

The first one is a feature that, for some reason, remains relatively unknown. It allows to combine
several XML files depending on a set of rules which are applied at runtime. Although it is quite
powerful, their specification is really verbose and the merging process [can be rather
confusing](https://documentation.suse.com/sles/15-SP1/single-html/SLES-autoyast/#merging) in some
cases.

Alternatively, pre-install scripts are widely used. You can then rely on the classical Linux tools
(sed, awk, etc.), or Python, or Perl, or Ruby... well, you cannot use Ruby, but that is something we
will fix. :sweat_smile:

However, we have been thinking about making things even easier by allowing to embed Ruby (ERB) in
AutoYaST profiles:

```rhtml
    <?xml version="1.0" encoding="utf-8"?>
    <partitioning config:type="list">
      <drive>
        <!-- vda, sda, ... -->
        <device><%= script("find_root_device.sh") %></device>
        <use>all</use>
      </drive>
    </partitioning>
    
    <%= include_file("https://example.net/profiles/software-#{node["mac"]}.xml") %>
    
    <% if arch?("s390x") -%>
    <dasd>
      <!-- dasd configuration -->
    </dasd>
    <% end -%>
```

Please, bear in mind that it is just an example, and we do not even know whether this feature makes
sense to you. Does it?

## Conclusions

After reading this document, there is a chance that you have comments or new ideas to discuss. And
we would love to hear from you! So you can reach the YaST team through the
[yast-devel](https://lists.opensuse.org/yast-devel/) or
[opensuse-autoinstall](https://lists.opensuse.org/opensuse-autoinstall/) mailing lists or, if you
prefer, we are usually at #YaST in [Freenode](https://freenode.net/).
