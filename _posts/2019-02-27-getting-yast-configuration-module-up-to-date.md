---
layout: post
date: 2019-02-27 16:13:35.000000000 +00:00
title: Getting YaST Configuration Module up-to-date
description: An Introduction to the YaST Configuration Management Module YaST Configuration
  Management is a relatively unknown module that was born back in 2016 during a workshop
  and was developed further during Hack Week 14. The idea was to enable AutoYaST to
  delegate part of its duties to a configuration management system like Salt or Puppet.
  Therefore, [&#8230;]
category: SCRUM
tags:
- Systems Management
- YaST
---

### An Introduction to the YaST Configuration Management Module   {#an-introduction-to-the-yast-configuration-management-module}

[YaST Configuration Management][1] is a relatively unknown module that
was born back in 2016 during a workshop and was developed further during
[Hack Week 14][2]. The idea was to enable AutoYaST to delegate part of
its duties to a configuration management system like [Salt][3] or
[Puppet][4]. Therefore, AutoYaST would take care of the initial
installation (partitioning, software installation, etc.) and it will
hand the control over to one of those systems for further configuration.

During [Hack Week 15][5] the module got support for [SUMA Salt
Parametrizable Formulas][6] and later it was adapted to  
 run during the 1st stage of the installation. Apart from that, the
module received fixes and minor updates as needed.

But by the end of 2018, we started to work on the module again in order
to:

* Update the *SUMA Salt Parametrizable Formulas* support.
* Add support for [YaST Firstboot][7]
* Improve the documentation (the [README][8] was basically rewritten).

In this article, we will review these changes including, of course, some
screenshots. If you want to try this features by yourself, you will need
to install `yast2-configuration-management 4.1.5` and `yast2-firstboot
4.1.5` (or later).

### Updating the SUMA Salt Parametrizable Formulas Support   {#updating-the-suma-salt-paramerizable-formulas-support}

Since the initial implementation of the *SUMA Salt Parametrizable
Formulas* support, the forms specification evolved quite a lot,
rendering the module outdated. Support for new data types, collections,
conditions, etc. was simply missing.

When it comes to the new UI design, the main problem we faced is that,
in YaST, we must take 80×24 interfaces into account and the support for
scrolling in our libraries is quite limited. So we needed to organize
the information minimizing the chance of getting out of space.

[![Configuring the dhcpd
formula](../../../../images/2019-02-27/yast2-configuration-management-dhcpd-300x238.png)](../../../../images/2019-02-27/yast2-configuration-management-dhcpd.png)

The screenshot above belongs to a fairly complex `dhcp` formula. At the
left side, there is a tree that you can use to browse through the
formula. At the right, YaST displays a set of form controls that you
will use to enter the formula parameters.

When dealing with collections, YaST displays the information in pop-up
dialogs as you can see below.

[![Managing
collections](../../../../images/2019-02-27/yast2-configuration-management-collection-popup-300x238.png)](../../../../images/2019-02-27/yast2-configuration-management-collection-popup.png)

Do you want to try it by yourself? No problem, but bear in mind that *it
may modify your system configuration*, so it would be wiser to do such
experiments in a virtual machine.

Having said that, the easiest way to try the module is to grab some
formulas [from OBS][9], install them and start the module from the YaST
control center by clicking on *YaST2 Configuration Management* under the
*Miscellaneous* section. If you are a console lover, you can just run
`yast2 configuration_management`.

### Adding Firstboot Support   {#adding-firstboot-support}

YaST Firstboot is a module that allows the user to configure a
pre-installed system during the first boot (hence the name). It
implements a set of [YaST clients][10] to perform different stuff like
setting the language, configuring the timezone, etc.

If you need to configure something which is not supported by YaST
Firstboot, you could write your own client having the power of YaST
under your fingers. Or, if you prefer, you could use YaST Configuration
Management to run a configuration management system. Of course, you can
combine this feature with the support for *SUMA Salt Parametrizable
Formulas* to offer a nice UI.

Now let’s see an example. YaST Firstboot configuration lives in
`/etc/YaST/firstboot.xml`. That file contains the list of clients to
use, among other settings. So if you want to use the YaST Configuration
Management module, you only need to add the
`firstboot_configuration_management` client to the workflow.

    <workflows config:type="list">
      <workflow>
        <stage>firstboot</stage>
        <label>Configuration</label>
        <mode>installation</mode>
        <modules  config:type="list">
          <!-- other modules -->
          <module>
            <label>Finish Setup</label>
            <name>firstboot_configuration_management</name>
          </module>
        </modules>
        <!-- and more modules -->
      </workflow>
    </workflows>

Additionally, you might be interested in modifying the
`firstboot_configuration_management` behaviour. In that case, you can
add a `<configuration_management/>` section with the relevant settings.
The nice thing is that it uses the same options that are supported by
AutoYaST. Let’s say that we want to run some Salt formulas:

    <configuration_management>
      <type>salt</type>
      <!-- Default Salt Formulas root directories -->
      <formulas_roots config:type="list">
        <formulas_root>/usr/share/susemanager/formulas/metadata</formulas_root>
        <formulas_root>/srv/formula_metadata</formulas_root>
      </formulas_roots>
    </configuration_management>

Or do you prefer to run Salt against a master server?

    <configuration_management>
      <type>salt</type>
      <master>linux-addc</master>
      <auth_attempts config:type="integer">5</auth_attempts>
      <auth_time_out config:type="integer">10</auth_time_out>
      <keys_url>http://keys.example.de/keys</keys_url>
    </configuration_management>

### Asking for Help   {#asking-for-help}

YaST Configuration Management has been greatly improved during these
weeks and the new SUMA formulas support opens a lot of possibilities.
However, now we need your help: if you are interested in this module,
please, check it out and try to report as many bugs as possible. We now
they are there just waiting for you to find them ;-).

Thanks!



[1]: https://github.com/yast/yast-configuration-module
[2]: https://hackweek.suse.com/14/projects/1372
[3]: https://saltstack.com
[4]: https://puppet.com/
[5]: https://hackweek.suse.com/15/projects/yast-module-for-suse-manager-salt-parametrizable-formulas
[6]: https://www.suse.com/communities/blog/forms-formula-success/
[7]: https://github.com/yast/yast-firstboot
[8]: https://github.com/yast/yast-configuration-management
[9]: https://build.opensuse.org/project/show/systemsmanagement:Uyuni:Retail
[10]: https://github.com/yast/yast-firstboot/tree/master/src/clients
