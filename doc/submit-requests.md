# Submit requests

Submit requests (SR) are handled in different ways depending on the branch. The
following table summarizes the main options, although some details will be added
through the rest of this document.

| Branch      | how to submit          | devel IBS/OBS project | IBS/OBS project    |
| ----------- | ---------------------- | --------------------- | ------------------ |
| master      | automatic (Jenkins)    | Devel:YaST:Head       | openSUSE:Factory   |
| SLE-12-SP2  | manual (`rake osc:sr`) | Devel:YaST:SLE-12-SP2 | SUSE:SLE-12-SP2:GA |
| SLE-12-SP1  | manual (`rake osc:sr`) | Devel:YaST:SLE-12-SP1 | SUSE:SLE-12-SP1:GA |
| SLE-12-GA   | manual (`rake osc:sr`) | Devel:YaST:SLE-12     | SUSE:SLE-12:Update |
| Code-11-SP? | manual (`osc`)         | manual                | manual             |

## Manual vs Automatic

The `master` branches of YaST and Libyui projects are submitted automatically
through Jenkins so the devel project (in IBS/OBS) is updated and a submit
request to `openSUSE:Factory` is performed.

Other branches should be submitted manually. Fortunately, starting on SLE 12 and
openSUSE 13.2, those tasks are unified through `yast-rake` and `libyui-rake`
packages. Those projects should have a `Rakefile` file.

For older releases, like SLE 11, and projects without a `Rakefile`, `osc` should
be used.

## Using yast-rake or libyui-rake

[yast-rake](https://github.com/yast/yast-rake) and
[libyui-rake](https://github.com/libyui/libyui-rake) offer some Rake tasks to
simplify the handling of YaST and Libyui projects, providing also setup for
[packaging tasks](http://github.com/openSUSE/packaging_tasks) (which includes
submit requests).

To find out which tasks are available, you can run `rake -T`. For example, for a
given YaST module:

    $ rake -T
    rake check:committed         # check if everything is commited to git repository
    rake check:license           # Check the copyright+license headers in files
    rake check:osc               # Check for installed osc client and its configuration
    rake check:syntax            # Check syntax of all Ruby (*.rb) files
    rake console                 # Runs console with preloaded module directories
    rake install                 # Install to system
    rake osc:build[osc_options]  # Build package locally
    rake osc:commit              # Commit package to devel project in build service if sources are cor...
    rake osc:sr                  # Create submit request from updated devel project to target project ...
    rake osc:sr:force            # Create submit request from devel project to target project without ...
    rake package                 # Prepare sources for rpm build
    rake run[client]             # Run given client
    rake tarball                 # Build tarball of git repository
    rake test:unit               # Runs unit tests
    rake version:bump            # Increase the last part of version in package/*.spec files

For example, to upload changes to the build system, `rake osc:commit` can be
used. If you want to create a submit request, just typing `rake osc:sr` will do
the trick.

However, depending on the branch, different IBS/OBS projects will be used. Each
branch should have a `Rakefile` where that configuration is specified. Let's see
how.

### Automatic

That's the preferred way. `submit_to` is simply a *helper* that will configure
the project following the
[definitions in yast-rake](https://github.com/yast/yast-rake/blob/master/data/targets.yml).

```ruby
    require "yast/rake"
    Yast::Tasks.submit_to(:sle12sp1)
```

In case of Libyui related projects, the usage is pretty similar although
[definitions differs](https://github.com/libyui/libyui-rake/blob/master/data/targets.yml):

```ruby
    require "libyui/rake"
    Libyui::Tasks.submit_to(:sle12)
```

The main advantage of using this approach is that, if some adjustment is needed,
it can be done in a centralize way.

### Manual

If needed, every parameter can be defined through the `configuration` method as
it follows:

```ruby
    require "yast/rake"
    Yast::Tasks.configuration do |conf|
      conf.obs_api = "https://api.suse.de/"
      conf.obs_target = "SLE_12"
      conf.obs_sr_project = "SUSE:SLE-12:Update"
      conf.obs_project = "Devel:YaST:SLE-12"
      # lets ignore license check for now
      conf.skip_license_check << /.*/
    end
```

Although it is not recommended, this approach is handy in case we need to
override some value:

```ruby
    require "yast/rake"
    Yast::Tasks.submit_to(:sle12sp1)
    Yast::Tasks.configuration do |conf|
      conf.obs_project = "Devel:YaST:SLE-12"
    end
```

### Environment variables

The configuration can be set using the environment variable `YAST_SUBMIT`. The
value of this variable will be passed to `submit_to` helper. Some things should
be taken into account:

* If `YAST_SUBMIT` is not specified, `factory` will be used.
* Any configuration specified in the project `Rakefile` will override this
  setting.
* In case of Libyui projects, a `LIBYUI_SUBMIT` variable is available (and it
  has precedence over `YAST_SUBMIT`).

This approach is used by Jenkins who uses the `master` branch (where no
configuration is set in projects `Rakefile`).

## Troubleshooting

* You need to install `osc` package and have a proper configuration (file `.oscrc`).
* If `osc` returns a 403 error, it's likely that you don't have permissions on the IBS/OBS projects.
* If you're trying to submit a project that relies on `yast-rake` or
`libyui-rake`, don't forget to install these packages: `rubygem-yast-rake` or
`rubygem-libyui-rake`. They're available in the
[YaST:Head project](https://build.opensuse.org/project/show/YaST:Head).
* If you encounter a problem with package submission have in mind that build
  service(s) might be down due to maintenance (see
  https://wiki.microfocus.net/index.php/SUSE/Development/OPS/Services/Policies/Maintenance_window).
