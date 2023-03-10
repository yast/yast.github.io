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

## Small CLI Scenario

Since we want to measure mainly overhead, we use a simple program that reads a
property from the d-bus and print it to stdout. The data structure of the property is not trivial, so the efficiency of
so the efficiency of the data marshalling is also tested. We use the D-Bus interface we have in D-Installer
and the property was a list of available base products.

The libraries used for communication with D-Bus are well known. For D-Bus we use
[rubygem-dbus](https://github.com/mvidner/ruby-dbus) and for rust we use
[zbus](https://docs.rs/zbus/latest/zbus/). To keep the code simple, we do not use advanced stuff
from the libraries like creating objects/proxies, but simple direct calls.

### Ruby Code

```rb
require "dbus"

sysbus = DBus.system_bus
service   = sysbus["org.opensuse.DInstaller.Software"]
object    = service["/org/opensuse/DInstaller/Software1"]
interface = object["org.opensuse.DInstaller.Software1"]
products  = interface["AvailableBaseProducts"]
puts "output: #{products.inspect}"
```

### Rust Code

```rs
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

### Results

To get some reasonable numbers, we run it a hundred times and measure it with the time utility.

So here is the result for ruby 3.1:
```
time for i in {1..100}; do ruby dbus_measure.rb &> /dev/null; done

real	0m40.491s
user	0m18.599s
sys	0m3.823s
```

Here is the result for ruby 3.2:
```
time for i in {1..100}; do ruby dbus_measure.rb &> /dev/null; done

real	0m31.025s
user	0m16.412s
sys	0m3.441s
```

And to compare rust one built with `--release`:

```
time for i in {1..100}; do ./dbus_measure &> /dev/null; done

real	0m10.286s
user	0m0.254s
sys	0m0.188s
```

As you can see, the rust looks much faster. It is also nice to see that in Ruby3.2 the cold start has been
has been nicely improved. We also discussed this with the ruby-dbus maintainer and he mentioned that ruby
dbus calls introspection on object and there is a
[way to avoid this](https://github.com/mvidner/ruby-dbus/blob/master/examples/no-introspect/tracker-test.rb)

Overall impression is that if you want a small CLI utility that needs to call d-bus, then rust is much better for it.

## Multiple Calls Scenario

Our CLI in some cases is really just a single dbus call like when you set some DInstaller option, but
there are other cases like a long running probe that needs progress reporting, and in that case
there will be many more dbus calls. So we want to simulate the case where we need to call progress multiple
times during a single run.

### Ruby Code

```rb
require "dbus"

sysbus = DBus.system_bus
service   = sysbus["org.opensuse.DInstaller.Software"]
object    = service["/org/opensuse/DInstaller/Software1"]
interface = object["org.opensuse.DInstaller.Software1"]

100.times do
  products  = interface["AvailableBaseProducts"]
end
```

### Rust Code

```rs
use zbus::blocking::{Connection, Proxy};

fn main() {
    let connection = Connection::system().unwrap();
    let proxy = Proxy::new(&connection,
         "org.opensuse.DInstaller.Software",
          "/org/opensuse/DInstaller/Software1",
        "org.opensuse.DInstaller.Software1").unwrap();
    for _ in 1..100 {
        let _: Vec<(String,String)> = proxy.get_property("AvailableBaseProducts").unwrap();
    }
    return;
}
```

### Results

We see no difference for different Ruby versions, so we just show the times:

```
time ruby dbus_measure.rb

real	0m10.529s
user	0m0.372s
sys	0m0.039s


time ./dbus_measure

real	0m0.052s
user	0m0.005s
sys	0m0.003s
```

Here it gets even more interesting and reason reveals `busctl --system monitor org.opensuse.DInstaller.Software`.
Rust caches the property in its proxy and just does a single dbus call `GetAll` to init all its properties.
On the other hand, the ruby library calls introspection first and then calls `Get` with the property specified.
Same behaviour can be achieved in ruby too, but it is more work. So even for simple CLI that needs multiple
calls to D-Bus, rust looks fast enough. Only remaining question we need to answer is whether rust proxy
correctly detects when a property is changed (in other words, when it sends observer signals by default).

For this reason we create a simple rust program with sleep and use `d-feet` to change property.

```rs
use zbus::blocking::{Connection, Proxy};
use std::{thread, time};

fn main() {
    let connection = Connection::system().unwrap();
    let proxy = Proxy::new(&connection,
         "org.opensuse.DInstaller.Software",
          "/org/opensuse/DInstaller/Software1",
        "org.opensuse.DInstaller.Software1").unwrap();
    let second = time::Duration::from_secs(1);
    for _ in 1..100 {
        let res: String = proxy.get_property("SelectedBaseProduct").unwrap();
        println!("output {}", res);
        thread::sleep(second)
    }
    return;
}
```

And we have successfully verified that everything is working as it should in the rust.
