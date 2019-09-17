---
layout: post
date: 2019-09-16 15:09:29.000000000 +00:00
title: Highlights of YaST Development Sprint 84
description: The YaST Team finished yet another development sprint last week and we
  want to take the opportunity to let you all glance over the engine room to see
  what's going on.
category: SCRUM
tags:
- Distribution
- Factory
- Programming
- Systems Management
- YaST
---

The YaST Team finished yet another development sprint last week and we
want to take the opportunity to let you all glance over the engine room
to see what’s going on.

Today we will confess an uncomfortable truth about how we manage the Qt
user interface, will show you how we organize our work (or at least, how
we try to keep the administrative part of that under control) and will
give you a sneak peak on some upcoming YaST features and improvements.

Let’s go for it!

### There Be Dragons: YaST Qt UI Event Handling

The YaST Qt UI is different in the way that it uses Qt. Normal Qt
applications are centered around a short main program that after
initializing widgets passes control to the Qt event loop. Not so YaST:
it is primarily an interpreter for the scripts (today in Ruby, in former
times in YCP) that are executed for the business logic. Those scripts,
among other things, also create and destroy widget trees. But the
control flow is in the script, not in a Qt event loop. So YaST uses
different execution threads to handle both sides: graphic’s system
events for Qt widgets and the control flow from the scripts.

This was always quite nonstandard, and we always needed to do weird
things to make it happen. We always kind of misused Qt to hammer it into
shape for that. And we always feared that it might break with the next
Qt release, and that we might have a hard time to make it work again.

This time has now come with [bug#1139967][1], but we were lucky enough
to find a Qt call to bring it back to life; a `QEventLoop::wakeUp()`
call fixed it. We don’t quite know (yet) why, though. Any hint, anyone?.

Should we even tell you that? Well, we think you deserve to know. After
all, it worked well for about 20 years (!)… and now it’s working again.

### The Refactoring of YaST Network Keeps Going

What is still not working that fine is the revamped network management.
We have been working on it during the latest sprint, but it will take at
least another one before it’s stable enough to be submitted to openSUSE
Tumbleweed.

On which parts have we be working during the this sprint? Glad you
asked! :wink: We are cleaning the
current mess in wireless configuration. Soon that part will be more
intuitive and consistent with other types of network. We are also making
sure we propose meaningful defaults for the new cards added to the
network configuration (all types of cards, not only wireless). The
functionality to configure udev in order to enjoy stable names for the
network interfaces has also received some love. The new version is more
stable and flexible. And last but not least, we are improving the device
activation in s390 systems for it to be more straightforward in the code
and more clear in the user interface.

If everything goes as planned, by the end of the next sprint we will be
ready to submit the improved YaST Network to Tumbleweed. That will be
the right time for a dedicated blog post with screenshots and further
explanations of all the changes.

### Enhancing the Partitioner Experience with Encrypted Devices

And talking about ongoing work, we are currently working to broaden the
set of technologies and use-cases the Partitioner supports when it comes
to data encryption. As with the network area, the big headlines in that
regard will have to wait for future blog posts. But if you look close
enough to the user interface of the Partitioner available in Tumbleweed
you can start spotting some small changes that anticipate the upcoming
new features.

The first change is very subtle. When visualizing the details of an
encrypted device, next to the previously existing “Encrypted: Yes” text
you will now be able to see the concrete type of encryption. For all
devices encrypted using YaST, that type will always be LUKS1 since
that’s the only format that YaST has supported… so far. :wink:

{% include blog_img.md alt="Partitioner: show the type of encryption"
src="enc-part1-300x120.png" full_img="enc-part1.png" %}

Some other small changes are visible when editing an encrypted device.
If such a device was not originally encrypted in the system, nothing
changes apart from minor adjustments in the labels. The user simply sees
a form with an empty field to enter the password.

{% include blog_img.md alt="Encrypting a plain device"
src="part-new-crypt-300x188.png" full_img="part-new-crypt.png" %}

When editing for a second time a device that was already marked for
encryption during the current execution of the Partitioner, the form is
already prefilled with the password entered before. In the past, the
previous encryption layer was ditched (so it’s password and other
arguments were forgotten) and the user had to define the encryption
again from scratch. That will become even more relevant soon, when the
form for encryption becomes more than just a password field. Stay tuned
for news in that regard.

{% include blog_img.md alt="Editing an encrypted device"
src="part-edit-crypt-300x188.png" full_img="part-edit-crypt.png" %}

Moreover, when editing a device that is already encrypted in the system,
an option is offered to just use the existing encryption layer instead
of replacing it with a (likely more limited) encryption created by the
Partitioner.

{% include blog_img.md alt="Keeping the previous encryption layer"
src="part-reencrypt-300x189.png" full_img="part-reencrypt.png" %}

Apart from opening the door for more powerful and relevant changes in
the area of encryption, these changes represent an important usability
improvement by themselves.

### Tidying up the YaST Team’s Trello Board

As you can see in this report and in all the previous ones, the YaST
Team works constantly on many different areas like installation, network
management, storage technologies… you name it. We use [Trello][2] to
organize all that work. For each bug in Bugzilla or feature in Jira
there is a corresponding Trello card. As it happens, sometimes when a
bug is closed its Trello card is forgotten to be updated.

A check with [ytrello][3] revealed that, out of a total of 900-something
cards, about 500 were outdated and could be closed. More than the half!
Why so many?

We found that quite a number of these cards were open cards in closed
(archived) lists. So when you archive a list, don’t forget to archive
its cards before. We have just learned that Trello does not do this
automatically. That’s exactly why there’s a menu item `Archive All Cards
in This List...` besides `Archive This List` in the Trello user
interface.

### Back to work!

This has been a summer of promises on our side. We told you we are
working to improve our user interface library (libYUI), revamping the
code to manage the network configuration, extending the support for
encryption… which means we have a lot work to be finished.

So let us go back to work while you do your part – having a lot of fun!



[1]: https://bugzilla.opensuse.org/show_bug.cgi?id=1139967
[2]: https://trello.com
[3]: https://github.com/mvidner/ytrello
