Nuvola Player 3
===============

*Nuvola Player 3 is a runtime for web-based music streaming services providing more native user
experience and integration with Linux desktop environments than usual web browsers can offer.
Nuvola Players handles multimedia keys, shows desktop notifications, integrates with various sound
menus, applets and launchers and more. Additional features include Last FM scrobling.*


Code hosting and issue tracker
------------------------------

Nuvola Player uses [Git version control system][2] for its code base and [GitHub][3] for
both code hosting and issue tracking. All official Git repositories are located under
[Tiliado organization account](https://github.com/tiliado). The code-base is divided to three parts:

 1. [Diorite library](https://github.com/tiliado/diorite): Private utility and widget library for
    Nuvola Player project based on GLib, GIO and GTK.
 2. [Nuvola Player 3](https://github.com/tiliado/nuvolaplayer): The Nuvola Player run-time without
    service integrations.
 3. Service integrations that have certain degree of independence and are maintained in separate
    [repositories](https://github.com/tiliado) named ``nuvola-app-...``.

[2]: https://github.com
[3]: http://git-scm.com/


How can I help
--------------

If you would like to contribute to Nuvola Player project development, there are two areas you can
jump in.

  * [**Core development**][4] - development of the Nuvola Player run-time that loads web app
    integrations and interacts with the Linux desktop components.
    
    *Skills:*
    [Vala](https://wiki.gnome.org/Projects/Vala),
    [GTK+ 3](http://www.gtk.org/),
    [WebKitGtk+](http://webkitgtk.org/),
    [GIT](http://git-scm.com/),
    [JavaScript](https://developer.mozilla.org/en/docs/Web/JavaScript)

  * [**Service Integrations**][5] - service integration scripts that runs in the web
    interface and communicates with Nuvola Player run-time.
    
    *Skills:*
    [JavaScript](https://developer.mozilla.org/en/docs/Web/JavaScript),
    [DOM](https://developer.mozilla.org/en-US/docs/Web/API/Document_Object_Model),
    [HTML](https://developer.mozilla.org/en-US/docs/Web/HTML).

[4]: http://tiliado.github.io/nuvolaplayer/development/core.html
[5]: http://tiliado.github.io/nuvolaplayer/development/apps.html

Build and Install
-----------------

### Dependencies

  * [Python 2](http://python.org) >= 2.7 (recommended)
    or [Python 3](http://python.org) >= 3.4 (not well tested)
  * [Vala](https://wiki.gnome.org/Projects/Vala) >= 0.22.1
  * [Diorite library](https://github.com/tiliado/diorite)
  * [glib-2.0](https://wiki.gnome.org/Projects/GLib) >= 2.38
  * [gio-2.0](https://wiki.gnome.org/Projects/GLib) >= 2.38
  * [gobject-2.0](https://wiki.gnome.org/Projects/GLib) >= 2.38
  * [gthread-2.0](https://wiki.gnome.org/Projects/GLib) >= 2.38
  * [gtk+-3.0](http://www.gtk.org/) >= 3.10
  * [gdk-3.0](http://www.gtk.org/) >= 3.10
  * [gdk-x11-3.0](http://www.gtk.org/) >= 3.10
  * [x11](http://www.x.org/wiki/) >= 0.5
  * [json-glib-1.0](https://wiki.gnome.org/Projects/JsonGlib) >= 0.7
  * [libarchive](http://www.libarchive.org/) >= 3.1
  * [webkit2gtk-3.0](http://webkitgtk.org/) >= 2.2
  * [javascriptcoregtk-3.0](http://webkitgtk.org/) >= 1.8
  * [libnotify](https://git.gnome.org/browse/libnotify/) >= 0.7
  * optional unity >= 3.0
  * optional dbusmenu-glib-0.4 >= 0.4

### Help

    $ ./waf --help

### Configure

    $ ./waf configure
    
or
    
    $ ./waf configure --with-unity
    
helpful:
    
    $ ./waf configure --prefix=/usr

### Build

    $ ./waf build

### Install

    # ./waf install
    
or
    
    # ./waf install --no-system-hooks
    # /sbin/ldconfig
    # gtk-update-icon-cache ...
    # gtk-update-icon-cache-3.0 ...
    
helpful:

    # ./waf --no-system-hooks --destdir=/whatever
