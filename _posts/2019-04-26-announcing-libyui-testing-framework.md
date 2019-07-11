---
layout: post
date: 2019-04-26 19:03:23.000000000 +00:00
title: Announcing LibYUI Testing Framework
description: The LibYUI framework brings enormous advantage when you need an application
  which can be used with X and ncurses. But while for Qt, integration testing is a
  solved problem, meaning there are multiple tools available, the situation is not
  that rose-colored in case of ncurses.
category: SCRUM
tags:
- Hackweek
- X.org
- YaST
---

The LibYUI framework brings enormous advantage when you need an
application which can be used with X and ncurses. But while for Qt,
integration testing is a solved problem, meaning there are multiple
tools available, the situation is not that rose-colored in case of
ncurses. On top, using different tooling would require additional
efforts for the framework development. So everything started with
openQA, which is using screen comparison with advanced fuzzy logic. This
approach kept the costs of the tests development low, but maintenance is
still painful when UI changes.

Considering all of the above, Ladislav Slezák and Rodion Iafarov has
been working on a proper solution taking [Ladislav’s proposal for Hack
Week 15][1] as starting point. The idea is plain simple: provide an
HTTP/JSON API which allows interacting with LibYUI by reading and
setting different UI properties. Consequently, if some button was moved,
resized or got new shortcut key assigned, we do not need to adapt the
test code anymore.

Obviously, this functionality is not required in a production system, so
we have created separate packages for this purpose. Here you can find
[GitHub repository][2] containing some documentation.

### Demo time!   {#demo-time}

As cool as it sounds, it is even better when you see it in action. In
the screencast below you can see how the user can interact with YaST
Host module using *cURL* from the command line.

{% include blog_img.md alt="LibYUI Testing Framework in Action"
src="libyui-testing-framework-in-action-300x274.gif" full_img="libyui-testing-framework-in-action.gif" %}

### How to Test the New Packages   {#how-to-test-the-new-packages}

If you want to give it a try, you can use the packages we have prepared
for you. However, it is recommended to use a virtual machine to not
pollute (or accidentally break) your system. You have been warned.
:smiley:

First of all, you need to get new packages, which are currently
available in [YaST:Head project in OBS][3]. Navigate to [Repositories
tab][4] and get the repository which matches the distribution you are
running. Afterwards you should be able to install `libyui-rest-api`
package. Also, you need to update related packages and YaST2 modules
were recompiled using latest LibYUI. To do that, simply run the
following command, where `YaST:Head` is the repository added in the
previous step:

    
    zypper up --allow-vendor-change -r YaST:Head

With the required software in place, you need to start a YaST module
setting the environment variable `Y2TEST` to 1:

    
    xdg-su -c 'Y2TEST=1 YUI_HTTP_PORT=9999 yast2 host' # for Qt
    sudo Y2TEST=1 YUI_HTTP_PORT=9999 yast2 host # for ncurses

To allow remote connections you can add `YUI_HTTP_REMOTE=1`. For
security reasons, only connections from `localhost` are allowed by
default.

Now you should be able to see something like the screenshot below by
navigating with your browser to `http://localhost:9999`.

{% include blog_img.md alt="LibYUI Testing Framework Browser"
src="libyui-testing-framework-browser-300x300.png" full_img="libyui-testing-framework-browser.png" %}

### Further steps   {#further-steps}

As you can see, we have not implemented a wrapper for the POST and GET
requests to the HTTP server yet, although it will be the next step. We
are trying to to find a solution which allows us running tests locally
from the terminal, in CI using stable distribution versions, and finally
in openQA for development builds.

Other things which are coming:

* Split the package into separate ncurses and Qt parts (fewer
  dependencies, not possible to test a minimal system without X).
* Improve the plugin loading.
* Support for more widgets and attributes.
* Add [basic authentication][5] support.
* Improve security [adding support for encryption and peer verification
  via SSL][6].
* Add support for the Gtk based UI.
* Add IPv6 support ([example][7]). After all, we are already in 2019.
  :smiley:

### Security Notice   {#security-notice}

YaST is usually running with the `root` permissions, that means
everybody who can connect to the HTTP/JSON API can read the values and
send button clicks. And because there is no authentication yet, this is
a big security problem. In a nutshell: **do not use the API in
production systems! It has been designed only for testing in a secure
environment**.

### Closing Thoughts   {#closing-thoughts}

We are pretty excited about this project for several reasons. On the one
hand, because we expect it to reduce the maintenance burden of our
integration tests. On the other hand, because it is a nice example of
Hack Week benefits and cross-team collaboration.

If you are interested, we will try to keep you in the loop by posting
information regularly as part of YaST sprints reports.



[1]: https://blog.ladslezak.cz/2017/03/01/hackweek-15-yast-cucumber/
[2]: https://github.com/libyui/libyui-rest-api
[3]: https://build.opensuse.org/project/show/YaST:Head
[4]: https://build.opensuse.org/repositories/YaST:Head
[5]: https://www.gnu.org/software/libmicrohttpd/tutorial.html#Supporting-basic-authentication
[6]: https://www.gnu.org/software/libmicrohttpd/tutorial.html#Adding-a-layer-of-security
[7]: https://github.com/rboulton/libmicrohttpd/blob/master/src/examples/dual_stack_example.c
