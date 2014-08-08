=======================
Lazy reST release steps
=======================

These are the steps to be performed for new stable releases of `Lazy reSt
<https://github.com/gradha/lazy_rest>`_. See the `README <../README.rst>`_.

* Create new milestone with version number (``vXXX``) at
  https://github.com/gradha/lazy_rest/milestones.
* Create new dummy issue `Release versionname` and assign to that milestone.
* ``git flow release start versionname`` (versionname without v).
* Update version numbers:

  * Modify `README.rst <../README.rst>`_.
  * Modify `docs/changes.rst <changes.rst>`_ with list of changes and
    version/number.
  * Modify `lazy_rest.babel <../lazy_rest.babel>`_.
  * Modify `lazy_rest.nim <../lazy_rest.nim>`_.

* ``git commit -av`` into the release branch the version number changes.
* ``git flow release finish versionname`` (the tagname is versionname without
  ``v``). When specifying the tag message, copy and paste a text version of the
  changes log into the message. Add ``*`` item markers.
* Move closed issues to the release milestone.
* ``git push origin master stable --tags``.

* Increase version numbers, ``master`` branch gets +0.0.1:

  * Modify `README.rst <../README.rst>`_.
  * Modify `lazy_rest.babel <../lazy_rest.babel>`_.
  * Modify `lazy_rest.nim <../lazy_rest.nim>`_.
  * Add to `docs/changes.rst <changes.rst>`_ development version with unknown
    date.

* ``git commit -av`` into ``master`` with *Bumps version numbers for
  development version. Refs #release issue*.

* Close the dummy release issue.
* Close the milestone on github.
* Announce at http://forum.nimrod-lang.org/.
