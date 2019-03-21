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

## Travis Setup


