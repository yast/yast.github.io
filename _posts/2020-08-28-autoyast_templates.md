---
layout: post
date: 2020-08-28 08:00:00 +00:00
title: Template as AutoYaST Profile
description: Brand new way how to create dynamic profiles for AutoYaST.
category: SCRUM
permalink: blog/2020-08-28/template-autoyast
tags:
- Distribution
- Factory
- AutoYaST
- Systems Management
- YaST
- ERB
- Template

---

For Leap 15.2 there are two ways to have dynamic profiles rules/classes [ TODO link ] and pre-script [ TODO link ]. For Leap 15.3 we have idea to have something more elegant and also powerful.
We do not want to reinvent wheel and increase installation requirements, so we use ruby built-in templating system ERB [TODO link]. Usage is really intuitive. Just name your profile with suffix `.erb`
and pass it as your autoyast profile. It will be expanded and used. In template can be used any ruby code. As initial support we add also helper to access output of libhd as hash in method `hardware`.

And how this ERB template can look like? Here is one example that we use for testing and trying to capture use cases that we are aware of.

```erb
<profile xmlns="http://www.suse.com/1.0/yast2ns" xmlns:config="http://www.suse.com/1.0/configns">
<%# example how to dynamic force multipath. Here it use storage model and if
    it contain case insensitive word multipath %>
  <% if hardware["storage"].any? { |s| s["model"] =~ /multipath/i } %>
    <general>
      <storage>
        <start_multipath t="boolean">true</start_multipath>
      </storage>
    </general>
  <% end %>
  <software>
    <products config:type="list">
      <product>openSUSE</product>
    </products>
  </software>
  <%# for details about values see libhd %>
  <% disks = hardware["disk"].sort_by { |d| s = d["resource"]["size"].first; s["x"]*s["y"] }.map { |d| d["dev_name"] }.reverse %>
  <partitioning t="list">
    <% disks[0..1].each do |name| %>
      <drive>
        <device>
          <%= name %>
        </device>
        <initialize t="boolean">
          true
        </initialize>
      </drive>
    <% end %>
  </partitioning>
  <%# situation: machine has two network catds. One leads to intranet and other to internet, so here we create udev
    rules to have internet one as eth0 and intranet as eth1. To distinguish in this example intranet one is not active %>
  <networking>
    <net-udev t="list">
      <rule>
        <name>eth0</name>
        <rule>ATTR{address}</rule>
        <value>
          <%= hardware["netcard"].find { |c| c["resource"]["link"].first["state"] }["resource"]["phwaddr"].first["addr"] %>
        </value>
      </rule>
      <rule>
        <name>eth1</name>
        <rule>ATTR{address}</rule>
        <value>
          <%= hardware["netcard"].find { |c| !c["resource"]["link"].first["state"] }["resource"]["phwaddr"].first["addr"] %>
        </value>
      </rule>
    </net-udev>
  </networking>
</profile>
```
