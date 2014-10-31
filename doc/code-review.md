Code Review
===========
First of all, thank you for contributing to YaST! Anyway, there are some rules
that anyone needs to follow while doing so...

Every single change in code (including bugfix, new feature, etc.) needs to go
through a code [review](http://en.wikipedia.org/wiki/Code_review) using
a [Pull Request](https://help.github.com/articles/using-pull-requests)

Why Code Review?
----------------
Because we want to make sure that the new code fulfills our expectations. In
general, all these question below should be answered with 'yes':

* Does the code make sense?
* Does the change fix the given problem / implement the required functionality?
* Does the change make the code better?

Code Review Workflow
--------------------
1. Open a new pull request (PR) with description containing enough useful
   information about the proposed change (such as 'why' or 'what' including
   [bugzilla](https://bugzilla.suse.com) or GitHub issue reference)
2. (optional) Ask someone to do a code review for you. If the reviewer doesn't
   have time for that or your reach a time-out, ask someone else.
   If you can't find a reviewer, try to fish outside the YaST team - for
   instance, ask experts on the given field.
3. Reviewers use three levels of their comments: Required, Nice to Have,
   Nitpicking.
4. Before merging the PR
   4.1. All serious (Required) issues found have to be addressed
   4.2. At least one "LGTM" from a reviewer is required

Code Review Rules
-----------------
There are three levels of comments: Required, Nice to Have, Nitpicking. These
items come from our experience with reviewing YaST code.

Obviously, what is Required or Nice to Have can slightly change depending on
the current phase of development. During global refactoring, we are more
focused on the code beauty and understandability. During a hot phase, we focus
on the code robustness.

Reqired (REQ):
* Code quality needs to be at least the same or even better
* Changelog entry if applicable (describe change from user's POV)
* Test case (if possible)
* Comments for "strange code"
* Understandable method / function names (expressing what they do and how)
* Do not break anything that works (implicit requirement)
* Travis build is green

Nice to Have (NTH):
* All tests have to be green (`rake osc:build` before submitting)
* No Builtins.* or Ops.* unless really necessary in new code
* Function documentation (function description, arguments, return values)
* Following the [Ruby style guide](https://github.com/SUSE/style-guides/blob/master/Ruby.md)
* Understandable variable names
* Good test quality
* Build has to be green (`rake osc:build` before submitting)
* Explanatory Class description

Nitpicking (NP):
* Adding code to already big method
* Full coverage of test case (of the changes)
* Removing empty lines
* Fix all empty spaces
* Correct spelling in code
* Correct spelling in comments
* Online article/info reference
* Refactoring the whole piece of code or whole function when changing any line in it
