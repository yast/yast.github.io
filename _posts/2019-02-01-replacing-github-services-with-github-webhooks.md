---
layout: post
date: 2019-02-01
title: Replacing Github Services with GitHub Webhooks
description: The GitHub team announced some time ago that the so
  called GitHub Services will be obsolete and will be replaced
  with the GitHub web hooks.
category: YaST
tags:
- YaST
---

The GitHub team <a href="https://developer.github.com/changes/2018-11-05-github-services-brownout/">announced</a> some time ago that the so called GitHub Services will be obsolete and <a href="https://developer.github.com/v3/guides/replacing-github-services/">will be replaced</a> with the GitHub web hooks.

We use the GitHub Services quite a lot in the YaST Team and, as [we
promised][1], we will try to summarize how replaced them.

### Travis   {#travis}

[Travis][2] should add the new web hook automatically, just check if you
can see a `https://notify.travis-ci.org` webhook configured for your
repository. If it is missing then the easiest way to add them is just
disabling the Travis builds for the repository and enabling it back.
Doing this should add the new Travis web hook automatically.

### Weblate   {#weblate}

If your project uses [Weblate][3] for managing the translations then use
the `https://<weblate_server>/hooks/github/` webhook URL. If you use the
[openSUSE Weblate instance][4], then use the
`https://l10n.opensuse.org/hooks/github/` URL for the web hook.

See the [Weblate documentation][5] for more details.

### RubyDoc.info   {#rubydoc}

The [RubyDoc.info][6] service can be replaced by adding the
`https://www.rubydoc.info/checkout` web hook (leave the other web hook
options unchanged).

### Read the Docs   {#read-the-docs}

The [Readthedocs][7] service uses unique web hook URL for each GitHub
repository. You need to log into the Read the Docs site, select your
project in the dashboard and in the `Admin` section select option
`Integrations`. Then press `Add integration` and select the `GitHub
incoming webhook` option. This will generate an URL address which can be
used at GitHub as the web hook URL (again, leave the other options
unchanged).

### Email GitHub Service   {#email}

The email service is automatically converted by GitHub to the new email
notification setting so you should not need to do any change. If the
notification emails are not delivered then check the `Notifications`
section in the repository settings. In order to do that, you need the
admin permission, see the [GitHub documentation][8].

### Bye GitHub Services!   {#bye-github-services}

Github Services has served well for quite some time but moving to a
webhooks based approach looks like the correct decision. We have already
completed the transition in all of our repositories. Kudos to Ladislav
Slezak for taking care!



[1]: https://lizards.opensuse.org/2019/01/31/highlights-of-yast-development-sprint-6970/#closing-thoughts
[2]: https://travis-ci.org/
[3]: https://weblate.org
[4]: https://l10n.opensuse.org/
[5]: https://docs.weblate.org/en/latest/admin/continuous.html#automatically-receiving-changes-from-github
[6]: https://www.rubydoc.info/
[7]: https://readthedocs.org
[8]: https://help.github.com/articles/about-email-notifications-for-pushes-to-your-repository/
