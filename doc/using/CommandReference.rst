.. program:: ghdl
.. _REF:Command:

Additional Command Reference
############################

.. HINT::
  The most common commands and options are shown in section :ref:`USING:Invoking`.
  Here the advanced and experimental features are described.

Environment variables
=====================

.. envvar:: GHDL_PREFIX

Misc commands
=============

There are a few GHDL commands which are seldom useful.

.. index:: cmd help

Help [``-h``]
-----------------

.. option:: --help, -h

Display (on the standard output) a short description of the all the
commands available.  If the help switch is followed by a command
switch, then options for that second command are displayed::

  ghdl --help
  ghdl -h
  ghdl -h command

.. index:: cmd help-options

Help [``--help-options``]
-----------------

.. option:: --help-options,

Display (on the standard output) a short description of the all the
analysis options.

  ghdl --help-options

.. index:: cmd help-warnings

Help [``--help-warnings``]
-----------------

.. option:: --help-warnings,

Display (on the standard output) a short description of the all the warnings,
and those which are enabled by default.

  ghdl --help-warnings

.. index:: cmd display configuration

Display config [``--disp-config``]
--------------------------------------

.. option:: --disp-config <[options]>

Display the program paths and options used by GHDL. This may be useful to track installation errors.

.. index:: cmd display standard
.. index:: display ``std.standard``

Display standard [``--disp-standard``]
------------------------------------------

.. option:: --disp-standard <[options]>

Display the ``std.standard`` package.

.. index:: cmd version

Version [``--version``]
---------------------------

.. option:: --version, -v

Display the GHDL version.

File commands
=============

The following commands act on one or several files.
These are not analyzed, therefore, they work even if a file has semantic errors.

.. index:: cmd file format

Format [``fmt``]
-----------------------

.. option:: fmt <file>

Format on the standard output the input file.


.. index:: vhdl to html

Pretty print [``--pp-html``]
--------------------------------

.. option:: --pp-html <[options] file...>

The files are just scanned and an html file with syntax highlighting is generated on standard output.
Since the files are not even parsed, erroneous files or incomplete designs can be pretty printed.
The style of the html file can be modified with the :option:`--format` option.

.. index:: cmd file find

Find [``-f``]
-----------------

.. option:: -f <file...>

The files are scanned, parsed and the names of design units are displayed.
Design units marked with two stars are candidates to be at the apex of a design hierarchy.

.. index:: cmd file chop

Chop [``--chop``]
---------------------

.. option:: --chop <files...>

The provided files are read, and a file is written in the current directory for every design unit.
Each filename is built according to the type:

* For an entity declaration, a package declaration, or a configuration the file name is :file:`NAME.vhdl`, where `NAME`
  is the name of the design unit.
* For a package body, the filename is :file:`NAME-body.vhdl`.
* Finally, for an architecture `ARCH` of an entity `ENTITY`, the filename is :file:`ENTITY-ARCH.vhdl`.

Since the input files are parsed, this command aborts in case of syntax error.
The command aborts too if a file to be written already exists.

Comments between design units are stored into the most adequate files.

This command may be useful to split big files, if your computer doesn't have enough memory to compile such files.
The size of the executable is reduced too.

.. index:: cmd file lines

Lines [``--lines``]
-----------------------

.. option:: --lines <files...>

Display on the standard output lines of files preceded by line number.

.. index:: cmd XML generation

XML tree generation [``--file-to-xml``]
---------------------------------------

.. option:: --file-to-xml

  Outputs an XML representation of the decorated syntax tree for the input file and its dependencies.
  It can be used for VHDL tooling using semantic information, like style checkers, documentation extraction, complexity
  estimation, etc.

.. WARNING::
   * The AST slightly changes from time to time (particularly when new nodes are added for new language features), so be
     liberal in what is allowed by your tool.
     Also, the XML can be quite large so consider it only during prototyping.
   * Note that at this time there is no XML dump of the elaborated design.

.. _gccllvm-only-programs:

GCC/LLVM only commands
======================

.. index:: cmd GCC/LLVM binding

Bind [``--bind``]
---------------------

.. option:: --bind <[options] [library.]top_unit [arch]>

Performs only the first stage of the elaboration command; the list of object files is created but the executable is not
built.
This command should be used only when the main entry point is not GHDL.

.. HINT::
   Currently, the objects generated by :option:`--bind` are created in the working directory.
   This behaviour is different from other object files generated with :option:`-a`, which are always placed in the same
   directory as the `WORK` library.
   It is possible to provide an output path with ``ghdl --bind -o path/top_unit [library.]top_unit [arch]``.
   However, ``ghdl --list-link`` will only search in the current path.

.. index:: cmd GCC/LLVM linking

Link [``--link``]
---------------------

.. option:: --link <[options] [library.]top_unit [arch]>

Performs only the second stage of the elaboration command: the executable is created by linking the files of the object
files list.
This command is available only for completeness.
The elaboration command is equivalent to the bind command followed by the link command.

.. index:: cmd GCC/LLVM list link

List link [``--list-link``]
---------------------------

.. option:: --list-link <[library.]top_unit [arch]>

This command may be used only after a bind command.
GHDL displays all the files which will be linked to create an executable and additional arguments for the linker.
This command is intended to add object files in a link of a foreign program.
This command should be used only after ``ghdl --bind``, as some files generated by it are looked for in the current path.

.. HINT::
   One of the arguments returned by ``--list-link`` is ``-Wl,--version-script=PREFIX/lib/ghdl/grt.ver``, where `PREFIX`
   is the installation path of GHDL.
   This will hide most of the symbols when the target executable binary is built.
   In some contexts, where the binary is to be loaded dynamically, the user might want additional symbols to be
   accessible.
   There are two possible approaches to have it done:

   * Filter the output of ``--list-link`` with e.g. ``sed``.
   * Provide an additional non-anonymous version script: ``-Wl,-Wl,--version-script=file.ver``.

Options
=======

.. option:: --GHDL1<=COMMAND>

Use ``COMMAND`` as the command name for the compiler.
If ``COMMAND`` is not a path, then it is searched in the path.

.. option:: --AS<=COMMAND>

Use ``COMMAND`` as the command name for the assembler.
If ``COMMAND`` is not a path, then it is searched in the path.
The default is ``as``.

.. option:: --LINK<=COMMAND>

Use ``COMMAND`` as the linker driver.
If ``COMMAND`` is not a path, then it is searched in the path.
The default is ``gcc``.

.. _passing-options-to-other-programs:

Passing options to other programs
=================================

.. WARNING:: These options are only available with GCC/LLVM.

For many commands, GHDL acts as a driver: it invokes programs to perform the command.
You can pass arbitrary options to these programs.

Both the compiler and the linker are in fact GCC programs.
See the GCC manual for details on GCC options.

.. option:: -Wc,<OPTION>

Pass `OPTION` as an option to the compiler.

.. option:: -Wa,<OPTION>

Pass `OPTION` as an option to the assembler.

.. option:: -Wl,<OPTION>

Pass `OPTION` as an option to the linker.
