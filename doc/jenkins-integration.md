# Jenkins Integration

## Description

Currently we use [GitHub Actions](https://docs.github.com/en/actions) and
[Jenkins](https://ci.opensuse.org/view/Yast/) for CI. The GitHub Actions build
the pushed commits and Pull Requests at GitHub. They also run some additional checks
like Rubocop or sends the code coverage to [coveralls.io](https://coveralls.io/).
Jenkins jobs build the `master` packages and submits them to YaST:Head OBS project
and optionally creates SR to Factory.

## OBS Setup

By default the packages from the
[YaST:HEAD](https://build.opensuse.org/project/show/YaST:Head) OBS repository
are used. (As configured in the `Rakefile` in Git repositories.)

For building the older versions the different project is used, e.g.
[YaST:SLE-12:SP1](https://build.opensuse.org/project/show/YaST:SLE-12:SP1).


## Automatic Package Submission

When a commit is checked in to one of the YaST Git repositories on GitHub
(usually via a pull request on GitHub), in most cases a package is
automatically submitted to the openSUSE Build Service (OBS).

For more details, see [automatic package submission](auto-pkg-submission.md).

## Troubleshooting

### Restarting a Build

If a Jenkins build fails for some temporary reason (e.g. OBS down, network
issues, ...) you can restart it by clicking the "Retry" button in the job details.
You need to be logged in, the credentials are stored in the [internal wiki
page](https://wiki.suse.net/index.php?title=YaST/jenkins#SUSE_.28internal.29).

### No Space Left at the Worker

In some rare cases the disk space at the Jenkins worker might be used up. If you
see some strange failures (cannot write files, strange crashes) they might be caused
by insufficient disk space.

There is an automatic clean up job configured which is executed automatically
at some precofigured interval to prevent from these issues. See the
[yast-jenkins-worker-cleanup](
https://ci.opensuse.org/view/Yast/job/yast-jenkins-worker-cleanup/) job.

- You can run the clean up job manually, just log into Jenkins and trigger the job.
  The disk space should be freed by deleting some caches.
- If that does not help you can use the [SSH access](
  https://wiki.suse.net/index.php?title=YaST/jenkins#Jenkins_Instances) and check
  the details.
