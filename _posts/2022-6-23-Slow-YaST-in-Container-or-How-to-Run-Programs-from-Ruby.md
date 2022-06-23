---
layout: post
date: 2022-06-23T13:23:51.461Z
title: Slow YaST in Container or How to Run Programs from Ruby?
description: There are several ways how to run external commands in Ruby, some of them fast, some are slower...
comments: false
category: Programming
tags: 
- faster
- Ruby
- SCR
- Cheetah
- YaST
---


# Slow YaST in Container

We noticed that when running the YaST [services manager](
https://github.com/yast/yast-services-manager) module in a [container](
https://github.com/yast/yast-in-container) then the start of the module is about
3 times slower than running in the host system directly. It takes about a minute
to start, that is way much...

## Root vs Non-root

*This actually does not influence YaST in the end, but it is an interesting
difference and might be useful for someone.*

If you run this

```
# time -p ruby -e '10000.times { system("/bin/true") }'
real 2.90
user 2.45
sys 0.54
```

and if you run the *very same* command as `root`

```
# sudo time -p ruby -e '10000.times { system("/bin/true") }'
real 9.92
user 5.89
sys 4.16
```

it takes about triple time! :open_mouth:

But in the end it turned out that the reason is that Ruby uses the optimized
`vfork()` system call instead of the traditional `fork()`. But because of
some security implications it should not be used when running as `root`,
in that case Ruby uses the standard (and slower) `fork()` call.
See more details in the [Ruby source code](
https://github.com/ruby/ruby/blob/ruby_3_1/process.c#L4015-L4023).

So in the end it actually is not 3 times slower because running as `root`, it
is the other way round, it is 3 times faster because running as non-root.
But because we almost always run YaST as `root` then we cannot use this trick...


## Cheetah vs SCR

Ok, but why is the services manager much slower at start?

In YaST there are also other ways how to run process. You can use
the SCR component (legacy from the YCP times) or the [Cheetah Ruby gem](
https://github.com/openSUSE/cheetah).


### Cheetah

Let's try how Cheetah works when running as different users:

```
# time -p ruby -r cheetah -e '10000.times { Cheetah.run("/bin/true") }'
real 17.83
user 10.41
sys 8.73
```

```
# sudo time -p ruby -r cheetah -e '10000.times { Cheetah.run("/bin/true") }'
real 15.74
user 9.51
sys 7.47
```

The numbers are roughly the same, the reason is that Cheetah always uses the
less optimal `fork()` call so there is no difference, it does not matter who
runs the script.

*Um, maybe we could improve the Cheetah gem to use the `vfork()` trick as well...*
:thinking:

### SCR

The `.target.bash` agent in SCR also uses `fork` so it also does not matter
which user uses it.

### Benchmarking

The traditional YaST SCR component is implemented in the C++ and the call needs
to go through the YaST component system, on the other hand the Cheetah gem uses
a native Ruby code. Additionally SCR uses `system()` call which uses
intermediate shell process while Cheetah uses `exec()` which executes the
command directly.

So it would be nice to compare these two options and see how they perform. For
that we wrote a small [`cheetah_vs_scr.rb`](
https://github.com/yast/helper_scripts/blob/master/ruby/benchmarks/cheetah_vs_scr.rb)
benchmarking script. It just lists all systemd targets and runs that many times
to have more reliable results.

### Results


Running the script as `root` directly in the system:

```
# ./cheetah_vs_scr.rb
Number of calls: 1000
Cheetah   : 8.84ms per call
SCR       : 22.90ms per call
```

As you can see, even without any container involved the Cheetah gem is more than
twice faster!

So how this changes when running in a container and running the `systemctl`
command in the `/mnt` chroot?

```
yast-container # ./cheetah_vs_scr.rb
Number of calls: 1000
Cheetah   : 7.30ms per call
SCR       : 91.78ms per call
```

As you can see the SCR calls are more than 4 times slower. That corresponds to the
slowdown we can see in the services manager. But more interesting is that
the Cheetah case is actually slightly *faster* when running in a container!
And if you compare Cheetah with SCR in container then Cheetah is more than
10x faster! Wow!

So in this case the SCR calls are the bottleneck, the container environment
should affect the speed in general only slightly. Switching to Cheetah
should improve the situation a lot in this case.

*Notes: It was tested in an openSUSE Leap 15.4 system, it also heavily depends
on the hardware, you might get very different numbers for your system.*

## Summary

If you just execute other programs from an YaST module few times it probably
does not matter much which way you use.

But if you call external programs a lot (hundred times or so) then it depends
whether you are running as `root` or non-root. For non-root case it is better
to use the Ruby native calls (`system` or \`\` backticks). For the `root`
access, as usually in YaST, prefer the Cheetah gem to the YaST SCR.

In our case it means we should update the YaST service manager module to
use Cheetah, it should significantly reduce the start delay. And will improve
the start also when running in the host system directly.

