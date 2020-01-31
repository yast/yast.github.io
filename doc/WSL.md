## General info

General info about WSL can be found on its wiki page: https://en.wikipedia.org/wiki/Windows_Subsystem_for_Linux
Ther is also openSUSE specific information about WSL: opensuse specific: https://en.opensuse.org/openSUSE:WSL
In short WSL1 is like "wine" as it emulates linux kernel and behave kind of docker. WSL2 is not stable yet, but
looks like something between docker and full VM. Need closer look when it will be more stable.

Current differences in WSL1 compared to common x86_64 run on VM.
- Systemd is installed, but does not run. Instead process 1 is windows proprietary init.
- Currently no X by default as it depends on running X server in windows. So YaST runs by default in ncurses.
- Timezone and locale injected by windows. But it is not big issue as YaST module for it is useless as it use timedatectl and
  localectl which depends on systemd.
- Booted via windows, so linux bootloader is useless here. Similar like docker.
- There are always windows mounted under /mnt from start.
- /dev is really limited e.g. no block device seen. Tested only in VM, so not sure about USB or other disks not recognized by windows.

## Development Tips

For development usually the manual installation have to be done as described at https://en.opensuse.org/WSL/Manual_Installation
If your console stuck for whatever reason closing WSL and reopening fix it or
opening another wsl app as they share namespace and kill process from it.
For nicer access it is possible to run sshd there, but need to be start manually as systemd does not run.
(Internal only) On pong server runs VM with windows configured to run WSL.

## Requirements for YaST

It runs yast2-firstboot after initial installation. It sets user via yast2-users.
For SLE images it should also register via yast2-registration.
Another useful module is yast2 packager as WSL allows to install anything user has in mind.
As list of modules is limited, for WSL new whitelist flag in desktop file is created
called `X-SuSE-YaST-WSL` which has to be set to `true` for modules
that should be offered in control center.

## Known Issues in YaST:

- systemctl slowly failing, which cause slowdown. General slowdown is solved in https://github.com/yast/yast-yast2/pull/1018
  which reduce list of units to query. But can still be problem in other cases.
- language module does not work at all, as localectl is systemd dependent and failing.
- services module is empty because systemd does not run
- network as without systemd it cannot run. But probably need not to be fixed
  as networking is provided by windows.
- bootloader does not work because storage does not detect root partition.
  Also there is no configuration as system is booted via windows.
  We need not care as user does not need to configure bootloader.
- partitioner shows nothing, writting not tested. Possible use cases can be mounting NFS?
- *-server because it cannot start service without systemd
- system_settings as it depends on bootloader which failing. Also useless in WSL1 as it is not real kernel.
- journal as it does not run.
