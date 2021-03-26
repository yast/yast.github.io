---
layout: post
date: 2021-03-26T12:18:41.367Z
title: Hackweek project: UCMT
description: Presentation of one of the hackweek project.
comments: true
category: Hackweek
tags: 
- Ruby
---


## Project Description

In SUSE was popular event Hackweek when every developer can do work on things he find the most useful. And one of such project is UCMT ( pronounce it like if you open beer bottle ).
Project aim to help with content management tools like salt or ansible. You can use tool to do local changes and manage with it your machine and then easily reproduce changes on more machines.
Goal is also to be distro agnostic and also CM tool agnostic, so user is not limited.

### Potential Usage

The project can be used in various situations. It can be used to have easy way to get into CM world by generating initial configuration with small changes. 
It can be used as backend for web service that allows you to generate configuration management files based on user input.
It can be used to help with machine migration with discovery of current state and apply it on different machine.
It can be used by gui for local management.

### Live Demo

Here is ucmt in action. At first it shows result of creating ucmt config with users command. Then it will generate salt configuration and apply it to create new user. At the end it removes this user and use ansible for it.

![Gif support missing](https://raw.githubusercontent.com/jreidinger/ucmt/main/images/ucmt.gif)

### Feedback

Future of project can affect anyone, so if you are interested try it yourself and provide feedback on project issues,mailing list or any other way you prefer.
To try it simple install via `sudo gem install --no-format-executable ucmt` and see what it can with `ucmt --help`.
Project page is at https://github.com/jreidinger/ucmt
