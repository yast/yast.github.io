# CI Integration

## Introduction

The [GitHub Actions](https://github.com/features/actions) provide free hosted
[continuous integration](https://en.wikipedia.org/wiki/Continuous_integration)
(CI) service.

It is directly integrated into GitHub so it is very easy to use and you can see
the build results directly in the pull requests, no need to check separate
pages, emails, etc...


### Advantages

- Build and tests are run automatically whenever a new change is pushed to GitHub
  repository or when a pull requested is created.

- The major advantage is that the tests are executed *before* a pull request
  is merged, the test failures can be found out very early. (Our [Jenkins integration]
  (https://yastgithubio.readthedocs.io/en/latest/jenkins-integration.html) runs the tests
  *after* a pull request is merged to `master`, sometimes it required a fix up to
  a failed test.)

- Another advantage is that for example code coverage using
  [Coveralls](https://coveralls.io/) can be easily added to CI.

### Disadvantages

- Normally the build runs in an Ubuntu LTS workers, but fortunately
  using Docker images allows to use basically any Linux distribution
  which can be started inside a container.

- The CI workers and the CI service as a whole are out of our control, we
  cannot change anything there. If the service is down or overloaded we cannot
  do anything about that.

- The workers cannot reach the internal network, e.g. we cannot use the packages
  from the internal build service.

## Using Docker

As mentioned above, normally GitHub Actioins run the builds inside Ubuntu virtual
machines. That makes troubles as YaST uses another distribution and expects
different GCC compiler, Ruby interpreter, libraries... And
in some cases the system differences between Ubuntu and (open)SUSE make some
tests fail or require specific workarounds in the code.

Fortunately GitHub Actions [allows using Docker images](
https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions#jobsjob_idcontainer
) at the workers. This greatly helps as we can run the build inside an openSUSE
container and avoid any Ubuntu workarounds and hacks.

Moreover the Docker images allow easily debugging and reproducing of the build
issues locally, see [below](#running-the-build-locally).

## Restarting a Build

It may happen that a build fails because e.g. OBS is down and the
required packages cannot be downloaded or GitHub times out, etc...

In that case it is possible to manually re-trigger the failed build. Browse to
the failed build and use the *Re-run jobs* button in the top
right corner for restarting the build.

Make sure you are logged at GitHub account and have push permissions, otherwise
the restart button it is not displayed.


## Implementation

When using Docker images the GitHub Actions still run inside an Ubuntu VM,
but instead of running the tests directly there the Actions download the
specified Docker image and start a new container using that image.

The Docker overhead should be very small as it is a container based technology
(like chroot on steroids) rather than a full virtualization systems like
KVM, VirtualBox or others.

### Open Build Service

The [YaST:Head](https://build.opensuse.org/project/monitor/YaST:Head) OBS project
builds the latest YaST packages from Git `master` branch. These packages are
then used in the Docker images which are then used by the CI builds. The corresponding
subprojects under [YaST](https://build.opensuse.org/project/subprojects/YaST)
are used for the maintenance branches.

To see all available images check the [registry.opensuse.org](
https://registry.opensuse.org/cgi-bin/cooverview?srch_term=project%3D%5EYaST%3A
) list.


### registry.opensuse.org

Since April 2019 the Docker images are built in the OBS
([ruby](https://build.opensuse.org/package/show/YaST:Head/ci-ruby-container)
and
[cpp](https://build.opensuse.org/package/show/YaST:Head/ci-cpp-container))
and are used in CI for the master branch. The sources are located 
at GitHub ([ruby](https://github.com/yast/ci-ruby-container/) and
[cpp](https://github.com/yast/ci-cpp-container/) images).

#### Image Rebuild

The Docker images in the OBS are rebuild automatically whenever any used package
is updated, just like with regular RPMs.

### The Docker Hub (Obsolete)

In the past we used the [Docker Hub](https://hub.docker.com/) for building and
publishing the Docker images. It is still used for some old distributions.

The YaST images are stored at the [yastdevel](https://hub.docker.com/u/yastdevel/)
Docker Hub organization.

#### Image Rebuild

The Docker images on Docker Hub are periodically rebuilt, the rebuild is triggered by the
Jenkins jobs (e.g. [docker-trigger-yastdevel-ruby-sle15-sp1](
https://ci.opensuse.org/view/Yast/job/docker-trigger-yastdevel-ruby-sle15-sp1/)).

There is also defined an upstream dependency to the base `openSUSE` repository,
the images should be rebuilt whenever the upstream is updated.

It is possible to trigger a rebuild manually - log into the Docker Hub, select the
image and in the *Build Settings* section press the *Trigger* button
for the required build tag. (See e.g. the [ruby image](
https://hub.docker.com/r/yastdevel/ruby/~/settings/automated-builds/).)

## Configuring GitHub Actions

The GitHub Actions configuration is stored in the YAML files stored in the
`.github/workflows` directory in Git.

To use a Docker image just specify the [`container/image`](
https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions#jobsjob_idcontainerimage
) value. See more details in the [documentation](
https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions).

You can check the templates for the YaST [Ruby](
https://github.com/yast/.github/blob/master/workflow-templates/ci-ruby.yml)
and [C++](https://github.com/yast/.github/blob/master/workflow-templates/ci-cpp.yml)
packages.

## Running the Build Locally

- First make sure the Docker is installed and running, which usually means to run
  `zypper in docker` and `systemctl start docker`. For SUSE Linux Enterprise
  you can check the [official Docker documentation](
  https://docs.docker.com/engine/install/sles/).

- Then use the [`rake actions:run`](https://github.com/yast/yast-rake#actionsrunjob)
  Rake task.

- Alternatively you can run the build manually using the `docker run` command
  and then executing the steps inside the container.

## Coveralls Integration

Most YaST repositories use [Coveralls](https://coveralls.io/) to automatically
check the code coverage of unit tests in every pull request. When creating a new
repository or when working with some old repository that has not been touched
recently, it may be necessary to enable Coveralls reporting for it.

See the [Coveralls integration document](coveralls-integration.md) for detailed
instructions about configuring an YaST repository to work with Coveralls.

## Parallel CI Jobs

The GitHub Actions define jobs and each job consists of separate steps.
The steps in each job run sequentially, the jobs run in parallel in a separate
worker.

![GitHub Action Jobs](https://docs.github.com/assets/images/help/images/overview-actions-design.png)

So to make the CI runs faster you can split the independent parts into separate
jobs and run them in parallel.

### YaST Example

See the [Ruby CI template](https://github.com/yast/.github/blob/master/workflow-templates/ci-ruby.yml)
how define several parallel jobs.


### Limitations

Obviously running the jobs in parallel has also some disadvantages.

- Starting a VM, downloading the Docker image, installing needed packages, etc...
takes some time. That means separating a small task which takes
just few seconds to run in parallel is usually pointless.

- If CI is under a heavy load then the jobs might not start at once or there
even might be delays between starting the jobs. That means in theory running too
many small parallel jobs might be slower than running one big sequential job.

You need to find the right balance between parallel and sequential approach.
