# Travis CI Integration

## Introduction

[Travis CI](https://travis-ci.org/) provides free hosted [continuous integration
](https://en.wikipedia.org/wiki/Continuous_integration) (CI) server. It has
a nice integration with GitHub so it is very easy to use and you can see the
build results directly at GitHub, no need to check separate
pages, emails, etc...


### Advantages

- Build and tests are run automatically whenever a new change is pushed to GitHub
  repository or when a pull requested is created.

- The major advantage is that the tests are executed *before* a pull request
  is merged, the test failures can be found out very early. (Jenkins runs the tests
  usually *after* a pull request is merged to master, sometimes it required a fix up to
  a failed test.)

- Another advantage is that for example code coverage using
  [Coveralls](https://coveralls.io/) can be easily added to Travis build.

### Disadvantages

- Normally the build runs in Ubuntu 12.04 (or 14.04) LTS workers, but fortunately
  using Docker images allows to use basically any Linux distribution
  which can be started inside a container.

- The Travis workers and the CI service as a whole are out of our control, we
  cannot change anything there. If the service is down or overloaded we cannot
  do anything about that.

- The workers cannot reach the internal network, e.g. we cannot use the packages
  from the internal build service.

## Using Docker at Travis

As mentioned above, normally Travis runs the builds inside Ubuntu virtual machines
providing some quite old package versions. That makes troubles as YaST uses newer
distribution and expects newer GCC compiler, Ruby interpreter, libraries... And
in some cases the system differences between Ubuntu and (open)SUSE make some
tests fail or require specific workarounds in the code.

Fortunately Travis [allows using Docker](https://docs.travis-ci.com/user/docker/)
at the nodes. This greatly helps as we can run the build inside a Docker container
which is running an openSUSE distribution and avoid all those Ubuntu workarounds
and hacks.

Moreover the Docker images allow easily debugging and reproducing of the build
issues locally, see [below](#running-the-build-locally).

## Restarting a Build

It may happen that a Travis build fails because e.g. OBS is down and the
required packages cannot be downloaded or GitHub times out, etc...

In that case it is possible to manually re-trigger the failed build. Browse to
the failed build at Travis and you'll find a *Restart Build* button in the top
right corner for restarting the build.

Make sure you are logged using your GitHub account, it is not displayed if you
do not have permissions for the respective GitHub repository.


## Implementation

When using Docker the Travis still runs the Ubuntu VM, but instead of running
the tests directly we download a Docker image with an openSUSE based distribution
and run the tests inside.

The Docker overhead should be very small as it is a container based technology
(like chroot on steroids) rather than a full virtualization systems like
KVM, VirtualBox or others.

For each branch on the git repository a different tag of the docker image is used. E.g. the master
branch always uses the *latest* tag and the SLE12 SP2 maintenance branch uses the *sle12-sp*
tag. To see all available tags check docker image on dockerhub (more below).

### Open Build Service

The [YaST:Head](https://build.opensuse.org/project/monitor/YaST:Head) OBS project
builds the latest YaST packages from Git `master` branch. These packages are
then used in the Docker images which are then used by the Travis builds. The corresponding
subprojects under [YaST](https://build.opensuse.org/project/subprojects/YaST)
are used for the maintenance branches.

### The Docker Hub

The [Docker Hub](https://hub.docker.com/) provides a central place for publishing
the Docker images. The Docker images used at Travis are hosted there.

The YaST images are stored at the [yastdevel](https://hub.docker.com/u/yastdevel/)
Docker Hub organization.

#### Image Rebuild

The Docker images are periodically rebuilt, the rebuild is triggered by the
Jenkins jobs (e.g. [docker-trigger-yastdevel-ruby-latest](
https://ci.opensuse.org/view/Yast/job/docker-trigger-yastdevel-ruby-latest/)).
Images for the master branch are built more often than the ones corresponding
to maintenance branches.

There is also defined an upstream dependency to the base `openSUSE` repository,
the images should be rebuilt whenever the upstream is updated.

It is possible to trigger a rebuild manually - log into the Docker Hub, select the
image and in the *Build Settings* section press the *Trigger* button
for the required build tag. (See e.g. the [ruby image](
https://hub.docker.com/r/yastdevel/ruby/~/settings/automated-builds/).)

## Travis Configuration

The Travis configuration is stored in the `.travis.yml` file. For using Docker
usually only two commands are required.

1. Download and build the Docker image with the target system (`docker build`).
2. Run the build and the tests inside a Docker container using the freshly built
   image (`docker run`).

## The Docker Configuration

The `Dockerfile` defines the build steps for building the Docker image.

It defines the base image which is used and a set of commands and options
which customize the image. See the [Dockerfile reference](
https://docs.docker.com/engine/reference/builder/) for more details.

## Running the Build Locally

- First make sure the Docker is installed and running, which usually means to run
  `zypper in docker` and `systemctl start docker`. For SUSE Linux Enterprise
  you can check the [official Docker documentation](
  https://docs.docker.com/engine/installation/linux/suse/).

- Then simply run (as *root*) the `docker` commands from the `.travis.yml` file
  locally in the package Git checkout.

- If you need to debug a failure then you can run bash instead of the Travis
  script and run the build steps manually. If you need a text editor or some
  other tools you can install them using `zypper`.

## Coveralls Integration

Most YaST repositories use [Coveralls](https://coveralls.io/) to automatically
check the code coverage of unit tests in every pull request. When creating a new
repository or when working with some old repository that has not been touched
recently, it may be necessary to enable Coveralls reporting for it.

See the [Coveralls integration document](coveralls-integration.md) for detailed
instructions about configuring a Travis-enabled YaST repository to work with
Coveralls.

## Parallel Build Jobs

Travis allows using a [build matrix](
https://docs.travis-ci.com/user/build-stages/matrix-expansion/) which can define
multiple independent [build environments](
https://docs.travis-ci.com/user/environment-variables/#Defining-public-variables-in-.travis.yml
) for each commit. What is good that Travis runs these builds in parallel.

```yaml
env:
  - FOO=foo
  - FOO=bar
```

This will start two jobs, one with `FOO=foo` environment and `FOO=bar` in the
other.

This way you can split the Travis work into more smaller parts and run them
in parallel:

```yaml
env:
  - CMD=quality_check
  - CMD=security_scan
  - CMD=compile
script:
  - $CMD
```

*Note: The values needs to be quoted when a space is included.*


### YaST Example

The YaST Travis script has been adapted to allow running only a subset of the
tasks and this can be easily used in Travis:

```yaml
env:
  # only the unit tests
  - CMD='yast-travis-ruby -o tests'
  # only rubocop
  - CMD='yast-travis-ruby -o rubocop'
  # the rest (skip unit tests and rubocop),
  # -y uses more strict "rake check:doc" instead of plain "yardoc"
  - CMD='yast-travis-ruby -y -x tests -x rubocop'
script:
  - docker run -it -e TRAVIS=1 -e TRAVIS_JOB_ID="$TRAVIS_JOB_ID" yast-test-image $CMD
```

This defines three jobs: unit tests, rubocop and the rest (yardoc, package build,
...). You can split the work into less or more jobs if needed.


### Limitations

Obviously running the jobs in parallel has also some disadvantages.

- Starting a VM, downloading and building the Docker image
takes some time. That means separating a small task which takes
just few seconds to run in parallel is usually pointless.
- If Travis is under heavy load then the jobs might not start at once or there
even might be delays between the jobs. That means in the edge case running too
many small parallel jobs might be slower than running one big sequential job.

You need to find the right balance between parallel and sequential approach.
