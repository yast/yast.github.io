---
layout: post
date: 2023-03-14 11:00:00 +00:00
title: Adding auto-installation support to D-Installer
description: Although it was in our minds from the beginning, we have been postpoining the support
  for auto-installation for several reason. Now the time has come and we have a plan.
permalink: blog/2023-03-14/auto-installation-support-in-d-installer
tags:
- Project
- Programming
- Systems Management
- YaST
- D-Installer
---

AutoYaST is a crucial tool for our users, including customers and partners. So it was clear from the
beginning that D-Installer should be able to install a system in an unattended manner.

This article describes the status of this feature and gives some hints about our plans. But we want
to emphasize that nothing is set in stone (yet), so constructive comments and suggestions are more
than welcome.

## The architecture

When we started to build D-Installer, one of our design goals was to keep a clear separation of
concerns between all the components. For that reason, the core of D-Installer is a D-Bus service
that is not coupled to any user interface. The web UI connects to that interface to get/set the
configuration settings.

In that regard, the *system definition* for auto-installation is another user interface. The D-Bus
service behaves the same whether the configuration is coming from a web UI or an auto-installation
profile. Let me repeat again: we want a clear separation of concerns.

Following this principle, the download, evaluation and validation of installation profiles are
performed by our [new command-line interface](https://github.com/imobachgs/dinstaller-rs). Having an
external tool to inject the profile can enable some interesting use cases, as you will discover if
you keep reading.

## Replacing XML with Jsonnet

Although you might have your own list, there are a few things we did not like about AutoYaST profiles:

* XML is an excellent language for many use cases. But, in 2023, there are more concise alternatives
  for an automated installation system.
* They are rather verbose, especially with all those type annotations and how collections are
  specified.
* Runtime validation, based on `libxml2`, is rather poor. And `Jing` is not an option for the
  installation media.

For that reason, we had a look at the landscape of declarative languages and we decided to adopt
[Jsonnet](https://jsonnet.org/), by Google. It is a superset of JSON, adding variables, functions,
imports, etc. A minimal profile looks like this:

```
{
  software: {
    product: 'ALP',
  },
  user: {
    fullName: 'Jane Doe',
    userName: 'jane.doe',
    password: '123456',
  }
}
```

But making use of Jsonnet features, we can also have dynamic profiles, replacing rules/classes or ERB
with a single and better alternative for this purpose. Let's have a look to a complex profile:

```jsonnet
local dinstaller = import 'hw.libsonnet';
local findBiggestDisk(disks) =
  local sizedDisks = std.filter(function(d) std.objectHas(d, 'size'), disks);
  local sorted = std.sort(sizedDisks, function(x) x.size);
  sorted[0].logicalname;

{
  software: {
    product: 'ALP',
  },
  user: {
    fullName: 'Jane Doe',
    userName: 'jane.doe',
    password: '123456',
  },
  // look ma, there are comments!
  localization: {
    language: 'en_US',
    keyboard: 'en_US',
  },
  storage: {
    devices: [
      {
        name: findBiggestDisk(dinstaller.disks),
      },
    ],
  },
  scripts: [
    {
      type: 'post',
      url: 'https: //myscript.org/test.sh',
    },
    {
      type: 'pre',
      source: |||
        #!/bin/bash

        echo hello
      |||,
    },
  ],
}
```

This Jsonnet file is evaluated and validated at installation time, generating a JSON profile
where the `findBiggestDisk(dinstaller.disks)` is replaced with the name of the biggest disk.

Beware that defining [the
format](https://github.com/imobachgs/dinstaller-rs/blob/main/dinstaller-lib/share/profile.schema.json)
is still a work in progress, so those examples might change in the future.

## Replacing the profile with an script

While working on the auto-installation support, we thought allowing our users to inject a script
instead of a profile might be a good idea. That script could use the command-line interface to
interact with D-Installer. Somehow, you would be able to set up your own auto-installation system.

```bash
#!/bin/bash

dinstaller config set software.product="Tumbleweed"
dinstaller config add storage.devices name=/dev/sda
dinstaller wait
dinstaller install
```

Please, bear in mind that it is just an idea, but we want to explore where it takes us.

## Better integration with other tools

Integrating AutoYaST with other tools could be tricky because it does not provide a mechanism to
report the installation progress. Again through our CLI, we plan to solve that problem by
providing such a mechanism which, to be honest, is already available in many configuration systems.

## What about backward compatibility?

In case you are wondering, we have plans to (partially) support good old AutoYaST profiles too. We
know that many users have invested heavily in their profiles and we do not want all that work to be
gone. However, not all the AutoYaST features will be present in D-Installer, so please expect some
changes and limitations.

We now have a small tool that fetches, evaluates and validates an AutoYaST profile, generating a
JSON-based one. It is far from finished, but it is a good starting point.

## Current status

Now let's answer the obvious question: which is the current status? We expect to deliver the basic
functionality in the following release of D-Installer, but with quite some limitations.

* The user interface is still needed to answer questions or watch the progress.
* Dynamic profiles are supported, but the hardware information injected in the profiles is
  incomplete.
* A mechanism for error reporting is missing.
* iSCSI and DASD are not supported in auto-installation yet.

## Closing thoughts

We hope we have addressed your main concerns about the auto-installation support in D-Installer. As
you may see, it is still a work in progress, but we expect to shape the implementation in the
upcoming releases to have 1st class support for unattended installation sooner than later.

If you have any further questions, please, let us know.
