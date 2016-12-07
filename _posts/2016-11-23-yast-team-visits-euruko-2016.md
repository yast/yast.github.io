---
layout: post
date: 2016-11-23 16:47:54.000000000 +00:00
title: YaST Team visits Euruko 2016
description: As promised in previous posts, we want to share with you our experience
  and views from this year annual Ruby conference Euruko.
category: Events
tags:
- Programming
- Ruby
- YaST
---

As promised in previous posts, we want to share with you our experience
and views from this year annual Ruby conference [Euruko][1]. Maybe “our”
is too much to say, since we only sent one developer there. So to be
precise, these are Josef Reidinger’s experience and views on the
conference.

This year Euruko took place in Sofia, capital of Bulgaria. It turned out
to be a great conference place. Public transport works very well,
everyone speak English and even when it uses Cyrilic alphabet, almost
everything is written also in Latin one.

That being said, let’s talk about the conference content. Fortunately
all the presentations were recorded so you can [watch them yourself][2].
But since it would be quite some hours of video to go through, we have
reviewed some presentations for you including access to the
corresponding videos.

### Highlights

Let’s start with the three presentation Josef specially recommend to
watch.

**Keynote by Matz**

He speaks about how Ruby 3 will probably look in distant future. With
“distant future” meaning “for sure not in next two years”. If you cannot
wait, it’s worth mentioning that Ruby 2.4 will be released on December.

Ruby 3 will use guild membership concurrency model. The most interesting
part of the talk is digging into rationale of typed versus non-typed
languages and what can be the Ruby future in that regard.

<iframe width="500" height="281"
src="https://www.youtube.com/embed/8aHmArEq4y0?feature=oembed"
frameborder="0" allowfullscreen=""></iframe>

**Rules, Laws and Gently Guidelines by Andrew Radev**

Interesting view about common design principles, common mistakes when
applying them and looking to them from different angles. Also explaining
how to handle situations in which several design principles seem to
contradict each other.

<iframe width="500" height="281"
src="https://www.youtube.com/embed/BDXQ4pcbEBA?feature=oembed"
frameborder="0" allowfullscreen=""></iframe>

**Elixir by Jose Valim**

Interesting intro to Elixir language. What it is, why it make sense to
use it and what are its benefits. Josef’s impression was that Elixir’s
idea is similar to isolated micro-services communicating via messages,
with nice introspection and scalability.

But we have more team members with something to say about Elixir. Like
Imobach, who has been playing with Elixir (and [Phoenix][3]) for some
time now. And Imobach really likes Elixir, so he would like to add some
more bits of information for those who are interested.

For example, he would like to highlight that Elixir uses BEAM, the
Erlang virtual machine, so great support for concurrency is backed in
the platform. Concurrency sits on the concept of Erlang processes and
it’s pretty common to use them for all kind of tasks (from computation
to storing state, etc.). Imobach would like to encourage all developers
out there to take a look to [OTP (Open Telecom Platform)][4]. Who needs
micro-services at all?

Last but not least, take into account that Elixir is a functional
language, so if you have an object-oriented mindset (like most Ruby
developers) it will take some time to wrap your head around it.

<iframe width="500" height="281"
src="https://www.youtube.com/embed/xhwnHovnq_0?feature=oembed"
frameborder="0" allowfullscreen=""></iframe>

### Other presentations

**Little Snippets by Xavier Noria**

Summary of common inefficiency in small snippets. Small things that
matter, although most of them should be already known by the average
Ruby developer. ([Video][5])

Since we mention the topic, some YaST team members has found [this cheat
sheet][6] by Juanito Fatas about Ruby optimization to be quite useful.

**Rails + Kafka by Terence Lee**

Apache Kafka is yet another messaging system. This talk did not manage
to convince Josef to use it, but maybe it makes sense in some scenarios
like HPC or HA. ([Video][7])

**Graphql on Rails by Marc-Andre Giroux**

The typical REST setup is sometimes not scalable enough due to the
excess of endpoints. The Graphql language is designed to specify what
resources are needed from a server in a single query. The result is
returned as JSON and the request specification looks also similar to
JSON. Caching is done on client side. Interesting for web stuff and
already used by Facebook, Shopify and others. ([Video][8])

**Evolution of engineering on call team by Grace Chang**

How to maintain services, how to scale when the grow, preventing burnout
and so on. Specially interesting for us since there are many
similarities with YaST maintenance. Maybe the end of the talk is a bit
theoretic and idealistic. ([Video][9])

**Sprockets by Rafael Franca**

Not specially interesting intro to assets generation used by Rails.
People doing some assets generation with Rails would most likely already
know all the content. ([Video][10])

**Contribute to Ruby core by Hiroshi Shibata**

Presentation about Ruby core development infrastructure, rules, etc.
Certainly not the best talk ever. ([Video][11])

**Consequences of insightful algorithms by Carina C. Zona**

Interesting presentation about conflicts between algorithms and real
humans, especially with data-mining. Unfortunately, the second half
turned to be too emotional and not technical enough for Josef’s taste
:). ([Video][12])

**Viewing Ruby Blossom – Hamani by Anton Davydov**

Introduction to yet another Ruby web framework. Not that interesting for
us. ([Video][13])

**A Year of Ruby, Together by Andre Arko**

Introduction on how the open source community infrastructure behind
Rubygems and Bundler is ran. How they get money to improve stuff, how
they maintain their servers… Good talk about hard times keeping open
source infrastructure alive. Interesting talk for any open source
project. ([Video][14])

**What I Have Learned from Organizing Remote Internship for Ruby
Developers by Ivan Nemytchenko**

Talk describing an attempt to scale internship for a lot of students.
Josef had a small chat with the author about Google Summer of Code after
the presentation. He looked interested. ([Video][15])

**The Illusion of Stable APIs by Nick Sutterer**

Not Josef’s cup of tea. The presenter probably went a little bit too far
trying to be funny all the time. The core of the presentation was about
three examples of API that needed to be changed “just” because the rest
of the world changed. So the whole presentation can be shortened to one
sentence – your API will only remain static if the world remains static.
([Video][16])

### Conclusion

That was all from Sofia. See you again in approximately one week, just
in time for the report of our 28th Scrum sprint.



[1]: http://euruko2016.org
[2]: https://www.youtube.com/channel/UChGs1td4ViQFqT0jlvkyUJg
[3]: http://www.phoenixframework.org/
[4]: https://en.wikipedia.org/wiki/Open_Telecom_Platform
[5]: https://www.youtube.com/watch?v=mC9TyVeER_8
[6]: https://github.com/JuanitoFatas/fast-ruby
[7]: https://www.youtube.com/watch?v=yl3JmF3n2bQ
[8]: https://www.youtube.com/watch?v=_V96jduEvjY
[9]: https://www.youtube.com/watch?v=u_7wrPXaSto
[10]: https://www.youtube.com/watch?v=rbM_1wRVfeI
[11]: https://www.youtube.com/watch?v=IRfsakcZJKw
[12]: https://www.youtube.com/watch?v=bp4yFKw_1QM
[13]: https://www.youtube.com/watch?v=3L6I4UoK8xM
[14]: https://www.youtube.com/watch?v=SJddsEfvcW8
[15]: https://www.youtube.com/watch?v=H-K0ZKOclBU
[16]: https://www.youtube.com/watch?v=mvHwTtsIH8g
