================
Lazy reST readme
================

Lazy reST is a `Nimrod <http://nimrod-lang.org>`_ module providing a slightly
higher level API over `Nimrod's rstgen module
<http://nimrod-lang.org/rstgen.html>`_ with some extras. The actual rstgen
module and friends are duplicated here, which allows to use the stable Nimrod
compiler version with the latest features. Some additional features are
provided with regards to Nimrod's standard library version, like embedding of
`Prism <http://prismjs.com>`_ for code block syntax highlighting.

Unlike Nimrod's standard library, this module doesn't aim to support LaTeX
generation at all. The included LaTeX bits are inherited and not maintained.
Which doesn't mean patches aren't welcome, but you may have more success
sending them `upstream to Nimrod <https://github.com/Araq/Nimrod>`_ instead of
here.


License
=======

`MIT license <LICENSE.rst>`_.
