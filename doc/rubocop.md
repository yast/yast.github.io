# Coding Style and Rubocop

In order to have similar style guide accross YaST modules rubocop is used for ruby sources.
Not all modules using it, but purpose of this documentaiton is to provide guidenance how to
setup rubocop for new or existing project to increase its usage.

## How to Enable Rubocop

### Initial Configuration

Create the initial `.rubocop.yml` file which inherits the common YaST style:

```
# use the shared Yast defaults
inherit_from:
  /usr/share/YaST2/data/devtools/data/rubocop_yast_style.yml
```


### First Rubocop Run

Run `rubocop` and see how many issues Rubocop finds. If there are few issues (few
dozens ;-)) you can run `rubocop -a` to autofix the issues, then run `rubocop` again
and fix the remaining issues manually.

For easier code review please separate the automatic changes done by Rubocop and the
manual changes. The automatic changes are usually just white space or indentation
fixes where Rubocop is good at fixing them so this commit can be skipped in review.

Manual changes are usually non-trivial and there is a higher risk of regression or
potentially changing the behavior so these should be reviewed more carefully. The
reviewer could easily overlook them in the huge amount of spacing changes so commit
them separately.

### Disabling Checks

For the old code you will very likely see several hundreds, maybe even thousands
issues. In this case it's better to split the work into smaller parts and maybe even
disable some checks which would need too much work (long methods/classes) or break
the API (variable or method names).

Run `rubocop --auto-gen-config`, this will generate `.rubocop_todo.yml` file which
disables all checks which failed. Now you can append that file to the default config:

```
  cat .rubocop_todo.yml >> .rubocop.yml
```

If you run `rubocop` now it should pass.

Now you should remove the disabled checks one by one, but it's better first to just
comment it out and see the result, if you decide to keep it disabled then you can
just uncomment it back.

You should start with the checks which Rubocop is able to fix automatically, this
will avoid updating your manual changes later. Such checks are marked with `Cop
supports --auto-correct` text. Just enable the check and run `rubocop -a`.

Then manually fix the remaning issues.

It is recommended to commit each fix separately, see e.g.
https://github.com/yast/yast-yast2/pull/478/commits, mark the the manual fixes in
commit message ("Manually fixed" or something like that).


### Commit Your Hard Work

Do not forget to commit also the new `.rubocop.yml` ;-)
Then add a Rubocop job or step into the GitHub Actions to run it for every commit
and pull request.
