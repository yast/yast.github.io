Bug Tracking
============

YaST team is quite busy delivering new features and, of course, fixing bugs.
The main development process is driven by
[SCRUM](https://www.scrumalliance.org/) and sometimes bugs don't fit in that
process. So this document is intended to describe how bugs should be handled.

Basically, YaST team receives bug reports through [SUSE's
bugzilla](http://bugzilla.suse.com). When a new YaST bug is registered, it is
assigned to the *yast-maintainers* mailing list. Inside the YaST team, there is
a person who is responsible for taking a look at those reports and assigning
them to the right developer in order to solve them. Just as a side note, the
person in charge of this mailing list changes periodically in a rotating way.
The [list of assigned people](https://wiki.microfocus.net/index.php/YaST/yast2-maintainers_Round_Robin)
is available internally.

When a bug is assigned to a developer, he/she will be the responsible for deciding
how to handle the resolution of that issue.

* If the developer considers the bug simple or small enough, she will keep it
  assigned to themselves and will work on it outside of the main YaST development
  process. The main reason to do that is to work-around the overhead imposed by
  SCRUM for such small bugs.
* If it's deadly urgent (P1, L3 or confirmed by the PO), the developer will submit
  the bug to the current sprint to the respective Trello team board
  ([Team A board](https://trello.com/b/kEAc7bFf),
  [Team 1 board](https://trello.com/b/tM5tFlxs)) and mark the card as a *fast-track*
  and *under-waterline* item. Then it will be handled (and fixed) during the current sprint.
* If the bug is bigger but not that urgent, the developer will add the bug to
  the [*incoming board*](https://trello.com/b/aICWq7sT) so it could be fixed in
  upcoming sprints. At this point, the bug should be assigned to *yast-internal*
  until some developer starts working on it.

Finally, openSUSE could be affected by some issues that won't be fixed by YaST
team (not so critical ones). Those bugs will be assigned to *yast-community*
so any community member interested in YaST development could take care of them.
After all, [YaST is Open](http://yastgithubio.readthedocs.org/en/latest/yast_is_open/).

## Security issues

There are very few security issues in YaST (you need to be already `root` when
running it and can be used only locally), but they can happen from time to time.

In that case handle the issue with high care, especially if the issue is not publicly
announced and fixed by a released maintenance update yet.

If you are not sure about something just ask the other team members or the security team.

### Code Review for Security Fixes

Code review for unpublished security issues is a bit more complicated as opening
a usual pull request would actually announce the possible attack to public without
a fix available for the customers.

*Do not use GitHub for discussing security issues or proposing a fix!*

#### How to Discuss or Fix Security Issues

- Attach the proposed fix (a diff) to bugzilla, mark it as private (just to be sure,
  the bug should already be hidden for public). After the fix is published
  commit the fix to GitHub.

- Use the internal Git instance at https://gitlab.suse.de/, it supports
  *merge requests* which work the same way as pull requests at GitHub. After the
  fix is released just push it to the GitHub remote.


## Bugzilla Links and Tools

### Shared Bug Queries

There are several shared bug queries:

- [yast2-maintainers bugs](https://bugzilla.suse.com/buglist.cgi?cmdtype=dorem&remaction=run&namedcmd=yast2-maintainers%20bugs&sharer_id=6053) -
  All open bugs assigned to the *yast2-maintainers* account, the newly reported YaST
  bugs are by default assigned to this account.
- [yast2-maintainers not needinfo bugs](https://bugzilla.suse.com/buglist.cgi?cmdtype=dorem&remaction=run&namedcmd=yast2-maintainers%20not%20needinfo%20bugs&sharer_id=6053) -
  Similar to the previous one, but the bugs in NEEDINFO state are not displayed.
  This is useful when you want to see bugs which have not been checked yet.
- [yast-internal bugs](https://bugzilla.suse.com/buglist.cgi?cmdtype=dorem&remaction=run&namedcmd=yast2-internal%20bugs&sharer_id=6053) -
  Confirmed YaST bugs which are tracked in Trello. The URL attribute of these
  bugs should point to the relevant Trello card.
- [yast-internal reopen bugs](https://bugzilla.suse.com/buglist.cgi?cmdtype=dorem&list_id=13741375&namedcmd=YaST%20reopen&remaction=run&sharer_id=78979) -
  Similar to the previous one, but with reopen bugs only. Note that reopen bugs keep assigned
  to *yast-internal@suse.de*, so they are easily overlooked because they are not listed in
  *yast2-maintainers* searches.
- [needinfo from yast](https://bugzilla.suse.com/buglist.cgi?cmdtype=dorem&remaction=run&namedcmd=Needinfo%20from%20yast&sharer_id=78979) -
  All bugs with needinfo from *yast\** (e.g., *yast-internal*, *yast2-maintainers*,
  *autoyast-maintainers*, etc).
- [yast-team-bugs](https://bugzilla.suse.com/buglist.cgi?cmdtype=dorem&remaction=run&namedcmd=yast-team-bugs&sharer_id=6053) -
  All open bugs assigned to all YaST team members or to the generic YaST team
  accounts.

You can add these queries to your default Bugzilla footer so they can be easily used.
Go to to the [Saved Searches](https://bugzilla.suse.com/userprefs.cgi?tab=saved-searches)
configuration, search for the shared YaST queries above and check the option
*Show in Footer* option. Use the *Submit Changes* button at the very bottom to
save the changes.


### Trello Tools

You can use the [ytrello tool](https://github.com/mvidner/ytrello) for creating
the Trello cards for bugs automatically. See the [README](
https://github.com/mvidner/ytrello/blob/master/README.md) how to set it up and use it.

Alternatively you can install the [tampermonkey](https://tampermonkey.net/)
browser plugin and use [this](https://github.com/lslezak/monkey_scripts#trello-integration)
user script.
