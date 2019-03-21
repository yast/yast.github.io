# How to Create New Branches


## OBS/IBS Setup

First we need to create a new development projects in the internal and external
build services.

- Create a new subproject at https://build.suse.de/project/subprojects/Devel:YaST
- Create a new subproject at https://build.opensuse.org/project/subprojects/YaST
- Add all YaST developers to the new projects, do not forget to add the
  `yast-team` user (used by Jenkins)

## Jenkins Setup

- The sync job from IBS to OBS has to be added at https://gitlab.suse.de/yast/infra.

## Docker Setup

### Define the new Docker Images

- Create a new `Dockerfile.*` in the respective Git repository (use the previous
  image as a template).
- Adapt also the `.travis.yml` file to build the new image at Travis.

#### Repositories

  -  https://github.com/yast/docker-yast-cpp
  -  https://github.com/yast/docker-yast-ruby
  -  https://github.com/yast/docker-libstorage-ng
  -  https://github.com/libyui/docker-devel


### Build the new Docker Images

:information_source: You need access permissions to the `yastdevel` organization at the Docker Hub

- Update the Docker Hub configuration to build the new defined images

#### Images


- https://cloud.docker.com/u/yastdevel/repository/docker/yastdevel/cpp/builds/edit
- https://cloud.docker.com/u/yastdevel/repository/docker/yastdevel/ruby/builds/edit
- https://cloud.docker.com/u/yastdevel/repository/docker/yastdevel/libstorage-ng/builds/edit
- https://cloud.docker.com/u/libyui/repository/docker/libyui/devel/builds/edit


## Travis Setup
