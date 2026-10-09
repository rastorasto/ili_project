# ILI — Local YUM Repository (Bash)

A script that sets up a self-hosted RHEL/CentOS package repository end to end.

- Creates a 200 MB ext4 loop-device image mounted under the Apache root
- Downloads packages with `yum --downloadonly` and runs `createrepo`
- Writes the `.repo` config and fstab entry, fixes SELinux contexts
- Serves the repository over Apache

Run as root on a RHEL-style system. ILI sysadmin coursework.
