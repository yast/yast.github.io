## General info

General info about WSL can be found on its [Wikipedia
page](https://en.wikipedia.org/wiki/Windows_Subsystem_for_Linux). There is also openSUSE specific
information about WSL in the [openSUSE Wiki](https://en.opensuse.org/openSUSE:WSL). In short, WSL1
is like [Wine](https://www.winehq.org/) as it emulates Linux kernel and behaves similar to a
container. However, WSL2 looks like something between a container and a full virtual machine (VM),
but it is not stable yet. We will have a closer look once is stabilized.

These are the current differences between WSL1 and a common x86_64 VM:

- [Systemd](https://systemd.io/) is installed, but does not run. Process 1 is windows
  proprietary init instead.
- Currently, no X by default as it depends on running an X server in windows. So YaST runs by default in ncurses.
- Timezone and locale settings are injected by Windows. Anyway, the yast2-country model is useless
  in this context because it uses `timedatectl` and `localectl` which are part of Systemd.
- Booted via Windows, so Linux bootloader is useless here. Similar to a container.
- Windows is always mounted under /mnt.
- `/dev` is really limited, e.g. no block devices. Tested only in VM, so not sure about USB or other
  disks which are not recognized by Windows.

## Development Tips

For development, the manual installation has to be done as described at
https://en.opensuse.org/WSL/Manual_Installation. If your console stuck for whatever reason, closing
and reopening WSL should fix the problem. Alternatively, you can open another WSL application and
kill the process from it because they share the same namespace. For better access, it is possible to
run `sshd` there, but you need to start the service manually because Systemd is not running.

## Requirements for YaST

- `yast2-firstboot` should run after the initial installation, setting the users via the
  `yast2-users` module.
- For SLE images, it should be able to register the system.
- `yast2-packager` should work as WSL allows installing anything the user has in mind.
- Modules that does not work should not be listed. YaST offers a mechanism to whitelist working
  modules by setting the `X-SuSE-YaST-WSL` keyword in the desktop file.

## Known Issues in YaST

Many YaST modules rely on Systemd, so it is expected that many of them do not work.

- `systemctl` slow failing causes a significant slowdown. This problem was mitigated in [yast2
  4.2.61](https://github.com/yast/yast-yast2/blob/bf215ca2ca3c0beb39bfb9571a300f4e763c70c2/package/yast2.changes#L25),
  which reduce list of units to query. However, it still can be a problem in other cases.
- Language, timezone, and services related modules do not work as they rely on Systemd. It includes
  many `*-server` modules.
- Network cannot run without Systemd. Probably we do not need to fix it because networking is
  provided by Windows.
- The bootloader module does not work because the storage layer does not detect the root partition.
  Anyway, we do not care as users do not need to configure the bootloader.
- The partitioner shows nothing, and writing changes is not tested. Mounting NFS could be a possible
  use case?
- `system_settings` does not work because it depends on the bootloader module. However, it is
  useless in WSL1 because it does not use a real Linux kernel.
- The journal module does not run.
