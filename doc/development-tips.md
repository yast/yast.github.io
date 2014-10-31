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
[corresponding section](http://en.opensuse.org/Linuxrc#p_driverupdate) of
the Linuxrc documentation.

When using this method with many RPM packages, it's usually convenient to use a
[Linuxrc control
file](http://doc.opensuse.org/projects/autoyast/appendix.linuxrc.html)
containing ```insecure=1``` and several ```dud``` options.

### Using a YaST update medium

A simpler alternative to driver updates are the YaST update mediums. They are
also triggered by the ```dud``` Linuxrc option and they also
allow to modify the system before the installation, but they only affect the
files located under ```/usr/share/YaST2```. More information can be found
in the [corresponding
section](http://ftp.sunet.se/pub/Linux/distributions/suse/people/hvogel/Update-Media-HOWTO/html/id_yud.html)
of the Update Media HOWTO.

### Running a shell before the installation

It's also possible to use the ```startshell=1``` in Linuxrc to start a bash
shell with full access to the installation system before running the installer
itself. In this way it's not only possible to modify any YaST file in advance
but also to configure the network or any other aspect of the system. More
information can be found in
[this Kobliha's blog
post](http://kobliha-suse.blogspot.cz/2009/10/easiest-way-how-to-modify-installation.html).

## Add a new package to the installation system

Sometimes you need to add a new RPM to the openSUSE installation system (called
_inst-sys_) or to the rescue image. The overall procedure is relatively simple.
Basically you need to modify the ```installation-images``` package and then
remaster the installation medium (or update the boot server, depending how you boot
the system). But there are some tricky parts that are explained in depth in
[this Ladislav's blog
post](http://lslezak.blogspot.cz/2013/10/adding-new-package-to-opensuse.html).
