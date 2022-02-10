# YaST development tips & tricks

## Changing the root location for agents

When testing the code, it's useful to _chroot_ the agents so SCR operations take
place in a safe environment. This can be performed with the following code.

```ruby
check_version = false
path = '/tmp/chroot'
descriptor = Yast::WFM.SCROpen("chroot=#{path}:scr", check_version)
raise "Error creating the chrooted scr instance" if descriptor < 0
Yast::WFM.SCRSetDefault(descriptor)
```

The descriptor needs to be closed afterwards running

```ruby
Yast::WFM.SCRClose(descriptor)
```

## Change YaST during installation

It's usually necessary to run the installation process with a modified version
of the YaST code. Since Ruby is an interpreted language, YaST offers several
alternative ways to alter the running installer.

### Using driver updates

Driver updates are a mechanism that allows to modify the system before starting
the installation by providing a set of rpm packages. A driver update can be
triggered by the ```dud``` option in the Linuxrc command line. More information
about this approach can be found in the
[corresponding section](https://en.opensuse.org/Linuxrc#p_driverupdate) of
the Linuxrc documentation.

When using this method with many RPM packages, it's usually convenient to use a
[Linuxrc control
file](https://doc.opensuse.org/projects/autoyast/#ay-cmd-parameters)
containing ```insecure=1``` and several ```dud``` options.

### Using a YaST update medium

A simpler alternative to driver updates are the YaST update mediums. They are
also triggered by the ```dud``` Linuxrc option and they also
allow to modify the system before the installation, but they only affect the
files located under ```/usr/share/YaST2```. More information can be found
in the [corresponding
section](ftp://ftp.suse.de/pub/people/hvogel/Update-Media-HOWTO/html/id_yud.html)
of the Update Media HOWTO.

### Running a shell before the installation

It's also possible to use the ```startshell=1``` in Linuxrc to start a bash
shell with full access to the installation system before running the installer
itself. In this way it's not only possible to modify any YaST file in advance
but also to configure the network or any other aspect of the system. More
information can be found in
[this Kobliha's blog
post](https://kobliha-suse.blogspot.cz/2009/10/easiest-way-how-to-modify-installation.html).

## Add a new package to the installation system

Sometimes you need to add a new RPM to the openSUSE installation system (called
_inst-sys_). The ```installation-images``` package, which builds the
installation system, evaluates the package dependencies and automatically adds
the required packages. Simply add the needed packages as a ```Requires``` dependency
to the respective package and that's it.

If you need to add a completely new YaST package to the installer then add it
as a dependency to the ```skelcd-control-<product>``` package. See [the
openSUSE example](
https://github.com/yast/skelcd-control-openSUSE/blob/master/package/skelcd-control-openSUSE.spec#L43).

Note: This works since openSUSE-13.1 and SLE12, if you need to update older
systems, already released product or the rescue image then you need to modify
the ```installation-images``` package and then remaster the installation medium
(or update the boot server, depending how you boot the system). But there are
some tricky parts that are explained in depth in [this Ladislav's blog
post](https://lslezak.blogspot.cz/2013/10/adding-new-package-to-opensuse.html).

## Running yast2-storage-ng with test data

Both for development purposes and to investigate reported bugs, it's often
useful to run some YaST components with test data, without really interacting
with the underlying system. The yast2-storage-ng package provides the
`storage_testing` YaST client which takes as input a file containing a
devicegraph in XML or Yaml format. A devicegraph is a description of the storage
devices and file-systems available on a given system. Files containing
devicegraphs can be found in the yast2-storage-ng repository and also as part
of the YaST logs of any system.

The `storage_testing` client can be used:

  - to test the Partitioner
    - `yast2 storage_testing partitioner /path/to/devicegraph.xml`
  - to test the regular proposal
    - `yast2 storage_testing proposal /the/devicegraph.xml [/the/control_file.xml]`
  - to test the AutoYaST proposal
    - `yast2 storage_testing autoinst /the/devicegraph.xml /the/profile.xml`
