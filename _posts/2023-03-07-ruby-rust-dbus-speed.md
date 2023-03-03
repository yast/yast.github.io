---
layout: post
date: 2023-03-07 12:00:00 +00:00
title: Compare Calling D-Bus in Ruby and Rust
description: Do some measurement of execution speed for rust and ruby when communicate with D-Bus
permalink: blog/2023-03-07/ruby-rust-dbus-speed
tags:
- Project
- Programming
- Ruby
- Rust
- D-Bus
- D-Installer
---

For D-Installer we have already ruby CLI that was created as Proof of Concept. Then as part
of hackweek we create another one in rust to learn a bit about rust and gets hands dirty.
Now when we are familiar with both we would like to measure overhead of callind D-Bus methods
in rust and in ruby to be sure that if we continue with rust we won't be surprised by its
speed ( hint: we do not expect it, but expactations and facts can be different ).

## Scenario

As we want to measure mainly overhead, we use for that purpose simple program that reads one
property from D-Bus and print it to stdout. The property data structure is not trivial, so
effectivity of data marshaling is also tested. We use dbus interface we have in D-Installer
and property was list of available base products.

The libraries used for communication with D-Bus is well known ones. For D-Bus we use 
[rubygem-dbus](https://github.com/mvidner/ruby-dbus) and for rust we use [zbus]
(https://docs.rs/zbus/latest/zbus/). To make code simple we do not use advanced stuff from
libraries like creating objects/proxies, but simple direct calls.

### Ruby Code

```
require "dbus"

sysbus = DBus.system_bus
service   = sysbus["org.opensuse.DInstaller.Software"]
object    = service["/org/opensuse/DInstaller/Software1"]
interface = object["org.opensuse.DInstaller.Software1"]
products  = interface["AvailableBaseProducts"]
puts "output: #{products.inspect}"
```

### Rust Code

```
use zbus::blocking::{Connection, Proxy};

fn main() {
    let connection = Connection::system().unwrap();
    let proxy = Proxy::new(&connection,
         "org.opensuse.DInstaller.Software",
          "/org/opensuse/DInstaller/Software1",
        "org.opensuse.DInstaller.Software1").unwrap();
    let res: Vec<(String,String)> = proxy.get_property("AvailableBaseProducts").unwrap();
    println!("output: {:?}", res);
    return;
}
```

## Results

To get some reasonable numbers we run it hundred times and measure it with time utility.

So here is result for ruby:

```
time for i in {1..100}; do ruby dbus_measure.rb &> /dev/null; done

real	0m40.491s
user	0m18.599s
sys	0m3.823s
```

And to compare rust one built with `--release`:

```
time for i in {1..100}; do ./dbus_measure &> /dev/null; done

real	0m10.286s
user	0m0.254s
sys	0m0.188s
```

So as can be seen rust looks significantly faster. It is probably caused by ruby search for dbus
and other rubygems in its paths or maybe by ineffeciency in dbus communication. In general it
looks like with rust we definitively won't have any performance regressions.
