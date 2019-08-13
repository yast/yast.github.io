# How to Create New Branches

This is a short document how to create a new maintenance branch for a released
product.

## OBS/IBS Setup

First we need to create a new development projects in the internal and external
build services.

- Create a new subproject at https://build.suse.de/project/subprojects/Devel:YaST
- Create a new subproject at https://build.opensuse.org/project/subprojects/YaST
- Add all YaST developers to the new projects, do not forget to add the
  `yast-team` user (used by Jenkins for automatic submissions)

Then we need to synchronize the OBS and IBS packages. This is done automatically
by the `yast-obs-sync-*` jobs in the [internal Jenkins](https://ci.suse.de/view/YaST/).
The jobs are defined in the [sync-jobs.yaml](
https://gitlab.suse.de/yast/infra/blob/master/jenkins/ci.suse.de/sync-jobs.yaml) file.

## The Old Docker Setup

This older Docker setup is used for the older products, from SLE-12-SP2
to SLE-15-SP1 (included). For the newer products see the instructions below.

### Define the new Docker Images

- Create a new `Dockerfile.*` in the respective Git repository (use the previous
  image as a template).
- Use the new OBS repositories (created above)
- Adapt also the `.travis.yml` file to build the new image at Travis.

#### Git Repositories

  -  https://github.com/yast/docker-yast-cpp
  -  https://github.com/yast/docker-yast-ruby
  -  https://github.com/yast/docker-libstorage-ng
  -  https://github.com/libyui/docker-devel


### Build the new Docker Images

:information_source: You need access permissions to the `yastdevel` and `libyui`
organizations at the Docker Hub.

- Update the Docker Hub configuration to build the new defined images

#### Images


- https://cloud.docker.com/u/yastdevel/repository/docker/yastdevel/cpp/builds/edit
- https://cloud.docker.com/u/yastdevel/repository/docker/yastdevel/ruby/builds/edit
- https://cloud.docker.com/u/yastdevel/repository/docker/yastdevel/libstorage-ng/builds/edit
- https://cloud.docker.com/u/libyui/repository/docker/libyui/devel/builds/edit

## The New Docker Setup

Since SLE-15-SP2 we use the new Docker images built directly in the OBS.

You need to create the `images` and the `containers` build targets in OBS and configure them
to properly build the expected result in the project config:

```
%if "%_repository" == "images"
Type: kiwi
Repotype: none
Patterntype: none
%endif

%if "%_repository" == "containers"
Type: docker
Repotype: none
Patterntype: none
%endif
```

## The Base Image

We need to create the base image for the new branch. Either reuse the TW image
or check the OBS templates for the respective Leap release version:

- https://build.opensuse.org/package/show/YaST:Head/opensuse-tumbleweed-image:docker
- https://build.opensuse.org/image_templates

Note: We should build the base image locally, the official Leap images might be dropped
or disabled at some point, SLE has much longer lifetime...

#### Git Repositories

Create the respective branch also in these repositories containing the Docker images:

- https://github.com/yast/ci-cpp-container
- https://github.com/yast/ci-ruby-container
- https://github.com/yast/ci-libstorage-ng-container

Make sure the `Rakefile` properly defines the submit target.

## Jenkins Jobs

The changes in the Git repositories above should be automatically submitted by the Jenkins jobs
to OBS. When adding a new branch we need to add a new job for it.

See the yast-ci-* jobs at https://ci.opensuse.org/view/Yast/, defined in
the [yast-jobs.yaml](https://gitlab.suse.de/yast/infra/blob/master/jenkins/ci.opensuse.org/yast-jobs.yaml)
file.

## Creating the Branches

For creating the branch and adapting the `Rakefile` and `Dockerfile` files use the
[create_maintenance_branch](
https://github.com/yast/yast-devtools/blob/master/ytools/yast2/create_maintenance_branch) script.
Run it in the Git checkout of the respective package.

Some packages might need a special adaptation for a new release, check the affected packages
[below](#modifying-specific-packages).

To get the list of the packages packages which needs to be branched you might query the IBS
like this:

```shell
(osc -A https://api.suse.de ls SUSE:SLE-15:GA; osc -A https://api.suse.de ls SUSE:SLE-15-SP1:GA) \
| grep yast | sort -u
```

Note: you need to list all previous service packs including the original GA release,
the SP repositories only contain the updated packages, the unchanged packages are inherited
from the previous releases.

### Enabling Branch Protection

The newly added branches should be protected by GitHub (to avoid force pushes, accidental
branch removal and enforce code reviews). To do this globally use the [protect_branches.rb](
https://github.com/yast/helper_scripts/blob/master/github/protect_branches/protect_branches.rb)
helper script.

## Jenkins Setup

- The sync job from IBS to OBS has to be added at https://gitlab.suse.de/yast/infra.
- See the [Jenkins Job Builder (JJB) documentation](https://docs.openstack.org/infra/jenkins-job-builder/)
- Make sure you have the JJB packages installed, run `zypper install python3-jenkins-job-builder`
  to install it
- Testing before deploying: `jenkins-jobs --conf jenkins/ci.suse.de.ini test jenkins/ci.suse.de/ '*SP5*'`
- Deploying: `jenkins-jobs --conf jenkins/ci.suse.de.ini update jenkins/ci.suse.de/ '*SP5*'`

## Modifying Specific Packages

Some packages might contain a release specific data. Ideally we should avoid that but here are listed some
exceptions which need a special care:

- The `skelcd-control-leanos` package contains the SP release version in the `<full_system_media_name>` tag
  in the [control.leanos.xml](
  https://github.com/yast/skelcd-control-leanos/blob/master/control/control.leanos.xml) file. Also check
  whether the `<full_system_download_url>` value is correct.
