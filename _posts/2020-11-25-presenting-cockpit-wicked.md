---
layout: post
date: 2020-11-25 09:00:00 +00:00
title: Presenting Cockpit Wicked
description: A module to manage Wicked configuration through Cockpit
category: Releases
permalink: blog/2020-11-25/presenting-cockpit-wicked
tags:
- Distribution
- Factory
- Systems Management
- Cockpit
---

## What is Cockpit?

If you are into systems management, you most likely have heard about
[Cockpit](https://cockpit-project.org/) at some point. In a nutshell, it offers a good looking
web-based interface to perform system tasks like inspecting the logs, applying system updates,
configuring the network, managing services, and so on. If you want to give it a try, you can install
Cockpit in openSUSE Tumbleweed just by typing `zypper in cockpit`.

## And Cockpit Wicked?

Recently, the YaST team got informed that [MicroOS](https://microos.opensuse.org/) developers wanted
to offer Cockpit as an option for system management tasks. Unfortunately, Cockpit does not have
support for [Wicked](https://en.opensuse.org/Portal:Wicked), a network configuration framework
included in SUSE-based distributions.

As we are experts in systems management, we were given the task of building a Cockpit module to
handle network configuration using Wicked instead of NetworkManager. And today we are presenting the
first version of such a module. It is still a work in progress, but it already supports some basic
use cases:

* Inspect interfaces configuration.
* Configure common IPv4/IPv6 settings.
* Set up wireless devices, although only WEP and WPA-PSK authentication mechanisms are supported.
* Set up bridges, bonding and VLAN devices.
* Manage routes (work in progress).
* Set basic DNS settings, like the policy, the search list or the list of static name servers.

## Why a new module?

Cockpit already features a nice module to configure the network so you might be wondering why
not extending the original instead of creating a new one. The module shipped with Cockpit 
is specific to NetworkManager and adapting it to a different backend can be hard.

In our case, we are trying to build something that could be adapted in the future to support more
backends, but we are not sure how realistic this idea is.

## See It In Action

Before giving it a try, we guess you would like to see some screenshots, right? So here you are.
Below you can see the list of interfaces and some details about their configurations. It features a
switch to activate/deactivate each device and a button to wipe the configuration. You can change the
configuration by clicking on the links.

{% include blog_img.md alt="Interfaces List"
src="cockpit-wicked-interfaces-list-mini.png" full_img="cockpit-wicked-interfaces-list.png" %}

While applying the changes, Cockpit Wicked tries to keep you informed by updating the user interface
as soon as possible. And, if something goes wrong, you will get an error message. Sure, we need to
improve those messages, but you have something to look into it.

{% include blog_img.md alt="Error Reporting"
src="cockpit-wicked-error-reporting-mini.png" full_img="cockpit-wicked-error-reporting.png" %}

At this point, WEP and WPA-PSK authentication is supported by wireless devices, and we plan to
expand the support for the same mechanisms that are already supported by YaST.

{% include blog_img.md alt="Configuring a Wireless Device"
src="cockpit-wicked-wifi-scanning-mini.png" full_img="cockpit-wicked-wifi-scanning.png" %}

Another interesting feature is the support for some virtual devices like bridges, bonding and VLAN.

{% include blog_img.md alt="Setting Up a Bridge"
src="cockpit-wicked-add-bridge-mini.png" full_img="cockpit-wicked-add-bridge.png" %}

And last but not least, support for routes management or DNS configuration is rather simple but
already functional.

{% include blog_img.md alt="Inspecting DNS Settings"
src="cockpit-wicked-dns-mini.png" full_img="cockpit-wicked-dns.png" %}

## Installation

The module [has started its way](https://build.opensuse.org/request/show/850538) to Tumbleweed. But,
if you are interested in giving it a try, you can grab the RPM from the [GitHub release
page](https://github.com/openSUSE/cockpit-wicked/releases/tag/1).

If you are already using Wicked, we recommend you to take a backup of your network configuration
just in case something goes wrong. Just copying the `/etc/sysconfig/network` directory is enough. In
case you are using NetworkManager but you are curious enough to give this module a try, you can
easily switch to Wicked using the YaST2 network module.`YaST2 Network`

Bear in mind that this module will replace the one included by default in Cockpit. If you want the
original module back, you need to uninstall the `cockpit-wicked` package.

## What's Next?

Apart from polishing what we already have and fixing bugs, there are many things to do. In the short
term, we are focused on:

* Submitting the strings for translation so you can enjoy the module in your preferred language.
* Improving the UX according to our usability experts.
* Filtering out interfaces that are not managed by Wicked (like `virbr0`).

But before deciding our next steps, we would love to hear from you. So please, if you have some time
and you are interested, give the module a try and tell us what you think.

## Additional Links

* GitHub repository: https://github.com/openSUSE/cockpit-wicked
* Development tips: https://github.com/openSUSE/cockpit-wicked/blob/master/DEVELOPMENT.md
