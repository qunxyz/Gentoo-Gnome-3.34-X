Unofficial Gentoo Gnome 3.34 overlay
--------------------------------------------

Versions
--------

 - Gnome 3.34 (stable)

General information
-------------------

 - All ebuilds are keyworded amd64
 - Portions taken from the hhfeuer Gnome overlay

Usage
-----

## via local overlays

Create a `/etc/portage/repos.conf/Gnome-3.34-X.conf` file containing

```
[Gnome-3-34-X]
location = /usr/local/portage/Gnome-3-34-X
sync-type = git
sync-uri = https://github.com/qunxyz/Gentoo-Gnome-3.34-X.git
priority=9999
[DEFAULT]
eclass-overrides = Gnome-3-34-X
```

Then run emerge --sync

## via layman

Add via layman:

	layman -o https://raw.github.com/qunxyz/Gentoo-Gnome-3.34-X/master/repositories.xml -f -a Gnome-3-34-X

Then run layman -s Gnome-3-34-X


