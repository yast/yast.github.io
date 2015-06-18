Bug Tracking
============

YaST team is quite busy delivering new features and, of course, fixing bugs.
The main development process is driven by SCRUM and sometimes bugs don't fit in
that process. So this document is intended to describe how bugs should be
handled.

Basically, YaST team receives bug reports through [SUSE's
bugzilla](http://bugzilla.suse.com). When a new YaST bug is registered, it is
assigned to the <em>yast-maintainers</em> mailing list. Inside the YaST team, a
developer is responsible for taking a look at those reports and assigning them
to the right person in order to solve them. Just as a side note, the person in
charge of this mailing list changes periodically in a rotating way.

That assignee will be the responsible for deciding how to handle the resolution
of that bug.

* If the developer considers the bug simple or small enough, he will keep it
  assigned to himself and will work on it outside of the main YaST development
  process. The main reason to do that is to work-around the overhead imposed by
  SCRUM for such small bugs.
* If it's bigger and deadly urgent, the developer will submit the bug to the
  product backlog as a _fast-track_ item and, hopefully, it will be handled (and fixed)
  during the current sprint.
* If the bug is bigger but not that urgent, the developer will add the bug to
  the product backlog so it could be fixed in upcoming sprints. At this point,
  the bug should be assigned to *TBD-mailing-list* until a some developer
  starts working on it.

Finally, there are some bugs that won't be fixed by YaST team (not so important
ones). Those bugs are assigned to *yast-community* so any community member
interested in YaST development could take care of them. After all, [YaST is
Open](http://yastgithubio.readthedocs.org/en/latest/yast_is_open/).
