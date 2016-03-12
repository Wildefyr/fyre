Fyre
====

Strict POSIX compliant shell scripts using wmutils to form a
memory-lightweight and minimal X11 window environment.

Installation
------------

#### Manual Installation:

This repo relies on the installation of:

- [wmutils/core](https://github.com/wmutils/core)
- [wmutils/opt](https://github.com/wmutils/opt)

Dependencies that I would consider are essential:

- dash - Become one with the POSIX.
- [sxhkd](https://github.com/baskerville/sxhkd) - To bind scripts to hotkeys.
- xorg-xprop - Environment information.
- xorg-xinput - Enabling/Disabling input devices.

Optional dependencies that are important for forming a more 'complete'
environment:

- [dmenu](http://tools.suckless.org/dmenu/) - Suckless menu for launching programs.
- [lemonbar](https://github.com/baskerville/bar) - An excellent statusbar program with clickable support.
- [hsetroot](https://github.com/elmiko/hsetroot) - Minimal background setter with clean options compared to feh.

Install these separately depending on your distribution, but I recommend
grabbing from source wherever possible (especially for suckless tools).
My personal configuration for these can be found in my
[dotfiles](https://github.com/wildefyr/dotfiles) and
[scripts](https://github.com/wildefyr/bin) repositories.

Once done, I recommend system linking the scripts to somewhere on your path, i.e:

```bash
ln -s /builds/fyre/*.sh /usr/local/bin/
```

That way you can make changes to my original repository or maintain your own
fork with any changes you make being reflected immediately. Alternatively you
can use the Makefile I have provided to install the scripts.

Example scrots:
---------------

![Example Desktop1](https://github.com/Wildefyr/dotfiles/blob/master/screenshots/bladerunnerblues.png)
![Example Desktop2](https://github.com/Wildefyr/dotfiles/blob/master/screenshots/clean.png)

Authors
-------

Authors for specific scripts are listed in the files where they have
contributed ideas or code. Many thanks to the original wmutils authors:
dcat & z3bra.

Shameless Plug
--------------

If you want to contact me about anything, my website can be found
[here](http://wildefyr.net) and I can also be found on the Freenode IRC under
the nick 'Wildefyr' where I am often found in #crux and #6c37. If you're
feeling particularly kind of heart, star this repository and/or follow me.
