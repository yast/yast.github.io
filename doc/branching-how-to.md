# How to Create New Branches


## OBS/IBS Setup

First we need to create a new development projects in the internal and external
build services.

- Create a new subproject at https://build.suse.de/project/subprojects/Devel:YaST
- Create a new subproject at https://build.opensuse.org/project/subprojects/YaST
- Add all YaST developers to the new projects, do not forget to add the
  `yast-team` user (used by Jenkins)

## Docker Setup

### Define the new Docker Images

- Create a new `Dockerfile.*` in the respective Git repository (use the previous
  image as a template).
- Use the new OBS repositories (created above)
- Adapt also the `.travis.yml` file to build the new image at Travis.

#### Repositories

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


## Creating the Branches

For creating the branch and adapting the `Rakefile` and `Dockerfile` files use the
[create_maintenance_branch](
https://github.com/yast/yast-devtools/blob/master/ytools/yast2/create_maintenance_branch).
Run it in the Git checkout of the respective package.

Get list of packages from the Jenkins autosubmission jobs:

```shell
jenkins-jobs --conf jenkins/ci.suse.de.ini test jenkins/ci.suse.de/ '*-master' \
2> /dev/stdout > /dev/null | sed -e "s/INFO:jenkins_jobs.builder:Job name:  yast-\(.*\)-master/\1/"
```

(Run in the https://gitlab.suse.de/yast/infra/ checkout.)

### Enabling Branch Protection

The newly added branches should be protected by GitHub (to avoid force pushes, accidental
branch removal and enforce code reviews). To do this globally use the [protect_branches.rb](
https://github.com/yast/helper_scripts/blob/master/github/protect_branches/protect_branches.rb)
helper script.

## Jenkins Setup

- The sync job from IBS to OBS has to be added at https://gitlab.suse.de/yast/infra.
- See the [Jenkins Job Builder documentation](https://docs.openstack.org/infra/jenkins-job-builder/)
- Testing before deploying: `jenkins-jobs --conf jenkins/ci.suse.de.ini test jenkins/ci.suse.de/ '*SP5*'`
- Deploying: `jenkins-jobs --conf jenkins/ci.suse.de.ini update jenkins/ci.suse.de/ '*SP5*'`
