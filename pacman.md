---
title: pacman
category: Linux
layout: 2017/sheet
tags: []
updated: 2018-02-16
weight: -10
intro: |
  pacman. More information [here](https://wiki.archlinux.org/index.php/Pacman/Tips_and_tricks)
---

Pacman
------
{: .-three-column}

### Remove a package and its deps not required by any other packages:

    pacman -Rs package_name

### Remove a package and its deps and all the packages that depend on the target package:

    pacman -Rsc package_name

### Search for already installed packages:

    pacman -Qs string1 string2 ...

### Search for package file names in remote packages:

    pacman -Fs string1 string2 ...

### Show extensive information about a given package:

    pacman -Si package_name

### Show information about a local package:

    pacman -Qi package_name
    pacman -Qii package_name (also list of backup files and their modification states)

### Which remote package a file belongs to

    pacman -Fo /path/to/file

### All packages no longer required (orphans)

    pacman -Qdt

### List dependency tree

    pactree package_name

### Who needs a package

    pactree -r package_name

### Clean the package cache

    pacman -Sc
