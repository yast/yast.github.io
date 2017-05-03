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

### Open Build Service

The [YaST:Head](https://build.opensuse.org/project/monitor/YaST:Head) OBS project 
builds the latest YaST packages from Git `master` branch. These packages are
then used in the Docker images which are then used by the Travis builds.

### The Docker Hub

The [Docker Hub](https://hub.docker.com/) provides a central place for publishing
the Docker images. The Docker images used at Travis are hosted there.

The YaST images are stored at the [yastdevel](https://hub.docker.com/u/yastdevel/)
Docker Hub organization.

#### Image Rebuild

The Docker images are periodically rebuilt, the rebuild is triggered by the
Jenkins jobs (e.g. [docker-trigger-yastdevel-ruby](
https://ci.opensuse.org/view/Yast/job/docker-trigger-yastdevel-ruby/)).

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

- First make sure the Docker is [installed and running](
  https://docs.docker.com/engine/installation/linux/suse/).

- Then simply run (as *root*) the `docker` commands from the `.travis.yml` file
  locally in the package Git checkout.

- If you need to debug a failure then you can run bash instead of the Travis
  script and run the build steps manually. If you need a text editor or some
  other tools you can install them using `zypper`.
