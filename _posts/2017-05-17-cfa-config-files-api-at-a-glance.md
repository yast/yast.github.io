---
layout: post
date: 2017-05-17 10:46:53.000000000 +02:00
author: Michal Filka
title: CFA (Config Files API) at a glance
description: In our latest sprint report, we promised you an extra post about the
  technology we have been using lately to manipulate configuration files.
category: Programming
tags:
- Programming
- Systems Management
- YaST
---

In [our latest sprint report][1], we promised you an extra post about
the technology we have been using lately to manipulate configuration
files. The wait is over! Here is the fine text by [Michal Filka][2]
explaining everything you need to know to get started with CFA.

## Welcome to CFA

As you should know if you follow our blog (we make sure to repeat it
once in a while :wink:), YaST was converted some time ago from a custom
programming language called YCP to Ruby. However, this conversion was done on
language basis. Some old design decisions and principles stayed, like the usage
of [SCR][3] for accessing the underlying system.

SCR was designed together with YaST. It uses concept of “agents” for
accessing configuration files. These agents contains a description of
configuration file using their own format. Moreover SCR offers location
transparency. You can e.g. work with a file in the execution system or
in a chrooted environment. However, this piece of code is proprietary
and limited by the inconsistent quality level of the agents. In
addition, is written in C++, developed only within SUSE and, sadly, not
very well designed. You cannot easily use just the parser or the
location transparency functionality. You always have to go through the
complete SCR stack when parsing an input. Similarly, when using location
transparency (setting a new location), all subsequent SCR calls are
influenced by this. For this and some other reasons we decided to
replace the proprietary SCR with something else. That’s how we started
to develop and use “Configuration files API”

[Configuration files API][4] (CFA) is a library written in ruby intended
for accessing various configuration files. You can download it from
[rubygems.org][5]. It is also available as [a set of RPM packages for
OpenSUSE 42.3 in the build service][6]. It is structured into several
layers and creates an internal abstraction of configuration file. It has
been designed and developed in SUSE’s YaST team. However this time it
uses (or can use) third party parsers. CFA provides location
transparency for the parser on the bottom layer and unified API for
application on the top one. Location transparency is achieved by a well
known File interface, so you can use any piece of code which implements
that interface. Implementing support for a new parser is a bit more
complicated. In the worst case you may need to implement a ruby
bindings. However, once you have a bindings, implementing other pieces
which are needed to get things working in the CFA’s stack is simple.

Lets go through the layers in details.

## Bottom layer: File access

Is responsible for the direct access to the configuration files. In the
simplest case it accesses local configuration files using the [Ruby’s
File class][7], but it can be adapted to access remote, chrooted or
memory files too. The developer simply needs to provide a file handler
implementing the corresponding `read` and `write` methods. Handlers for
files in memory and in a chrooted environment are already provided by
the common CFA framework.

## Middle layer: Parser

This layer parses the configuration file which was loaded by the
underlying layer. It knows the structure of the file and transforms it
into an abstract representation. The library typically uses external
tool for parsing, like [Augeas][8]. So, if the external tools has
specific requirements, they have to be satisfied to get things working.
For example if Augeas is used, you need to provide a proper lens (Augeas
jargon for a file format descriptor) to parse the particular
configuration file.

## Top layer: Configuration file model

The last layer creates a model of the configuration file – an
semantically meaningful API for accessing the configuration from an
application. It basically creates “an abstraction on top of another
abstraction”. It means that it unifies the usage of the various tools
that can be used for accessing and parsing the configuration files.

## Limitations

The model described above has some handicaps, mainly affecting the
developers but visible sometimes for the users as well.

### Feed the beast

If you are a developer planning to use CFA to manipulate a given
configuration file, you must take into account that you will need to
provide the parser and satisfy all its requirements. So, you at least
have to know which parser is used for each file and what is needed in
order to make the parser work with the file of your interest.

This is especially important in case of nonstandard / custom
configuration files. It may require some previous work to evaluate the
available options.

### Beat the beast

There are also limitations coming from the fact that the library and/or
parsers on the second layer provides an abstraction on top of the
configuration file. This abstraction transform a configuration file into
a more convenient and meaningful model and establishes a relation
between the file and the model.

But the problem is that with most parsers (specially with Augeas) this
relation is not bijective. That means some irrelevant pieces of the
configuration file are not represented in the model. For example some
spaces can be left out if they are not needed from a syntactic point of
view. That can lead to loss of custom padding.

Another example can be comments. You can often see that, if your file
uses e.g. `#` as a comment mark, then some parsers can squash lines full
of these marks (which some developers use as a kind of delimiter) to
just one `#`.

As a more concrete example, some Augeas lenses do not store initial
comment marks in the model. That’s specially common in lenses for files
where several different comment marks are allowed. However, some lenses
return the comments including their mark at the beginning, so extra
handling is needed at an upper layer of CFA or at application level.

Last but not least, some parsers use the concept of default values when
adding new key with not defined value. This can of course lead to some
inconsistencies in configuration file’s look if not handled by an upper
layer.

## Practical example

As already mentioned, CFA is being used as a replacement for the old
fashioned SCR in YaST. So we can really take a look to the result of
that replacement in several parts, like the handling of `/etc/hosts` in
yast2-network. Leaving aside a fact that the code is now much better
readable, we gathered also some performance numbers.

The test was run using an example `/etc/hosts` file with 10.000 entries
(believe it or not, the experiment is based in a real life use case
reported by a user). The test was done using YaST’s command line
interface and measured using the good old `time` utility. Since the
command line interface doesn’t currently support entering hosts entries,
only reading operations were tested.

| time | SCR       | CFA       |
| :--- | :-------- | :-------- |
| real | 1m15.735s | 0m19.079s |
| user | 1m15.076s | 0m18.348s |
| sys  |  0m0.164s |  0m0.244s |

As you can see, this part of code is now approximately four times faster
than before, so the practical results look very promising. Moreover, the
CFA’s code is better designed and much better covered by automated
tests.

That’s why the YaST team is investing into both sides of the same coin –
CFA development and conversion of YaST’s code from SCR to CFA.


[1]: {{ site.baseurl }}{% post_url 2017-05-03-highlights-of-yast-development-sprint-34 %}
[2]: https://github.com/mchf
[3]: https://yastgithubio.readthedocs.io/en/latest/architecture/#system-configuration-repository-scr
[4]: https://github.com/config-files-api/config_files_api
[5]: https://rubygems.org/gems/cfa
[6]: https://build.opensuse.org/package/show/openSUSE:Leap:42.3/rubygem-cfa
[7]: https://ruby-doc.org/core-2.2.0/File.html
[8]: http://augeas.net/
