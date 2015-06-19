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

When a bug is assigned to a developer, she will be the responsible for deciding
how to handle the resolution of that issue.

* If the developer considers the bug simple or small enough, she will keep it
  assigned to themselves and will work on it outside of the main YaST development
  process. The main reason to do that is to work-around the overhead imposed by
  SCRUM for such small bugs.
* If it's deadly urgent, the developer will submit the bug to the *product
  backlog* as a _fast-track_ item and, hopefully, it will be handled (and fixed)
  during the current sprint.
* If the bug is bigger but not that urgent, the developer will add the bug to
  the *incoming board* so it could be fixed in upcoming sprints. At this point,
  the bug should be assigned to *yast-internal* until some developer
  starts working on it.

Finally, openSUSE could be affected for some issues that won't be fixed by YaST
team (not so critical ones). Those bugs will be assigned to *yast-community*
so any community member interested in YaST development could take care of them.
After all, [YaST is Open](http://yastgithubio.readthedocs.org/en/latest/yast_is_open/).
