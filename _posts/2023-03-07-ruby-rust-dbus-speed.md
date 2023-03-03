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

For D-Installer we already have a Ruby CLI that was created as a proof of concept. Then as part of
of the hackweek we created another one in Rust to learn a bit about Rust and get our hands dirty.
Now that we are familiar with both, we want to measure the overhead of calling D-Bus methods
in Rust and Ruby, to make sure that if we continue with Rust, we won't be surprised by its speed.
speed (hint: we do not expect it, but expectations and facts may be different).

## Scenario

Since we want to measure mainly overhead, we use a simple program that reads a
property from the d-bus and print it to stdout. The data structure of the property is not trivial, so the efficiency of
so the efficiency of the data marshalling is also tested. We use the D-Bus interface we have in D-Installer
and the property was a list of available base products.

The libraries used for communication with D-Bus are well known. For D-Bus we use
[rubygem-dbus] (https://github.com/mvidner/ruby-dbus) and for rust we use [zbus]
(https://docs.rs/zbus/latest/zbus/). To keep the code simple, we do not use advanced stuff from the
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

To get some reasonable numbers, we run it a hundred times and measure it with the time utility.

So here is the result for ruby:
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

As you can see, rust looks much faster. This is probably caused by Ruby's search for dbus
and other rubygems in its paths, or perhaps inefficiencies in dbus communication. In general, it
looks like we're definitely not going to have any performance regressions with rust.
