                     ====================================
                       Package "Date::Calc" Version 5.0
                     ====================================


This package is available for download either from my web site at

                  http://www.engelschall.com/u/sb/download/

or from any CPAN (= "Comprehensive Perl Archive Network") mirror server:

               http://www.perl.com/CPAN/authors/id/S/ST/STBEY/


Abstract:
---------

This package consists of a C library (intended to make life easier for C
developers) and a Perl module to access this library from Perl.

The library provides all sorts of date calculations based on the Gregorian
calendar (the one used in all western countries today), thereby complying
with all relevant norms and standards: ISO/R 2015-1971, DIN 1355 and, to
some extent, ISO 8601 (where applicable).

The package is designed as an efficient (and fast) toolbox, not a bulky
ready-made application. It provides extensive documentation and examples
of use, multi-language support and special functions for business needs.

The C library is specifically designed so that it can be used stand-alone,
without Perl.

Moreover, version 5.0 features date objects (in addition to the functional
interface) with overloaded operators, and a set of modules for calculations
which take local holidays into account (both additions in Perl only, however).


Legal issues:
-------------

This package with all its parts is

Copyright (c) 1995 - 2000 by Steffen Beyer.
All rights reserved.

This package is free software; you can use, modify and redistribute
it under the same terms as Perl itself, i.e., under the terms of
the "Artistic License" or the "GNU General Public License".

The C library at the core of this Perl module can additionally
be used, modified and redistributed under the terms of the
"GNU Library General Public License".

Please refer to the files "Artistic.txt", "GNU_GPL.txt" and
"GNU_LGPL.txt" in this distribution, respectively, for details!


Prerequisites:
--------------

Perl version 5.000 or higher, and an ANSI C compiler. (!)
                                     ^^^^^^
If you plan to use the modules "Date::Calendar" or
"Date::Calendar::Year" from this package, you will
also need the module "Bit::Vector" version 5.7 or
newer (which also needs an ANSI C compiler!).

Otherwise you may safely ignore the warning message
"Warning: prerequisite Bit::Vector 5.7 not found at ..."
when running "perl Makefile.PL".

And you can always install "Bit::Vector" later if you
change your mind.

If you compile under Windows, note that you will need
exactly the same compiler your Perl itself was compiled
with! (This is also true for Unix, but rarely a problem.)

Moreover, you usually cannot build any modules under
Windows 95/98, the Win 95/98 command shell is too dumb.
You will need the Windows NT command shell ("command.com")
or the "4DOS" shell.

Note that ActiveState provides precompiled binaries of
both modules (Date::Calc and Bit::Vector) for their
Win32 port of Perl ("ActivePerl") on their web site,
which you should be able to install simply by typing
"ppm install Bit-Vector" and "ppm install Date-Calc"
in your MS-DOS command shell. This also works under
Windows 95/98.

If your firewall prevents "ppm" from downloading these
packages, you can also download them manually from
http://www.activestate.com/ppmpackages/5.005/zips/ or
http://www.activestate.com/ppmpackages/5.6/zips/.
Follow the installation instructions included in
the "zip" archives.

Note also that a "plain Perl" version of "Date::Calc" called
"Date::Pcalc" exists (written by J. David Eisenberg); you
should be able to download it from the same place where
you found this package, or from David's web site at
http://catcode.com/date/pcalc.html.


Installation:
-------------

Please see the file "INSTALL.txt" in this distribution for instructions
on how to install this package.

It is essential that you read this file since one of the special cases
described in it might apply to you, especially if you are running Perl
under Windows.


Adding more languages:
----------------------

Please see the corresponding section in the file "INSTALL.txt" in this
distribution for detailed instructions on how to add other languages.


Changes over previous versions:
-------------------------------

Please refer to the file "CHANGES.txt" in this distribution for a detailed
version history.


Documentation:
--------------

The documentation of this package is included in POD format (= "Plain
Old Documentation") in the files with the extension ".pod" in this
distribution, the human-readable markup-language standard for Perl
documentation.

By building this package, this documentation will automatically be
converted into man pages, which will automatically be installed in
your Perl tree for further reference through the installation process,
where they can be accessed by the commands "man Date::Calc" (UNIX)
and "perldoc Date::Calc" (UNIX and Win32), for example.

Available man pages:

    Carp::Clan(3)
    Date::Calc(3)
    Date::Calc::Object(3)
    Date::Calendar(3)
    Date::Calendar::Profiles(3)
    Date::Calendar::Year(3)

If Perl is not available on your system, you can also read the ".pod"
files

    ./Calc.pod
    ./Calendar.pod
    ./lib/Carp/Clan.pod
    ./lib/Date/Calc/Object.pod
    ./lib/Date/Calendar/Profiles.pod
    ./lib/Date/Calendar/Year.pod

directly.


What does it do:
----------------

This package performs date calculations based on the Gregorian calendar
(the one used in all western countries today), thereby complying with
all relevant norms and standards: ISO/R 2015-1971, DIN 1355 and, to
some extent, ISO 8601 (where applicable).

See also http://www.engelschall.com/u/sb/download/Date-Calc/DIN1355/
for a scan of part of the "DIN 1355" document (in German).

The module of course handles year numbers of 2000 and above correctly
("Year 2000" or "Y2K" compliance) -- actually all year numbers from 1
to the largest positive integer representable on your system (which
is at least 32767) can be dealt with.

Note that this package projects the Gregorian calendar back until the
year 1 A.D. -- even though the Gregorian calendar was only adopted
in 1582 by most (not all) European countries, in obedience to the
corresponding decree of catholic pope Gregor I in that year.

Some (mainly protestant) countries continued to use the Julian calendar
(used until then) until as late as the beginning of the 20th century.

Therefore, do *NEVER* write something like "99" when you really mean
"1999" - or you may get wrong results!

Finally, note that this package is not intended to do everything you could
ever imagine automagically :-) for you; it is rather intended to serve as a
toolbox (in the best of UNIX spirit and tradition) which should, however,
always get you where you need and want to go.

See the section "RECIPES" at the end of the manual pages for solutions
to common problems!

If nevertheless you can't figure out how to solve a particular problem,
please let me know! (See e-mail address at the bottom of this file.)

The new module "Date::Calc::Object" adds date objects to the (functional)
"Date::Calc" module (just "use Date::Calc::Object qw(...);" INSTEAD of
"use Date::Calc qw(...);"), plus built-in operators like +,+=,++,-,-=,--,
<=>,<,<=,>,>=,==,!=,cmp,lt,le,gt,ge,eq,ne,abs(),"" and true/false
testing, as well as a number of other useful methods.

The new modules "Date::Calendar::Year" and "Date::Calendar" allow you
to create calendar objects (for a single year or arbitrary (dynamic)
ranges of years, respectively) for different countries/states/locations/
companies/individuals which know about all local holidays, and which allow
you to perform calculations based on work days (rather than just days),
like calculating the difference between two dates in terms of work days,
or adding/subtracting a number of work days to/from a date to yield a
new date. The dates in the calendar are also tagged with their names,
so that you can find out the name of a given day, or search for the
date of a given holiday.


Note to C developers:
---------------------

Note again that the C library at the core of this module can also be
used stand-alone (i.e., it contains no inter-dependencies whatsoever
with Perl).

The library itself consists of three files: "DateCalc.c", "DateCalc.h"
and "ToolBox.h".

Just compile "DateCalc.c" (which automatically includes "ToolBox.h")
and link the resulting output file "DateCalc.o" with your application,
which in turn should include "ToolBox.h" and "DateCalc.h" (in this order).


Example applications:
---------------------

Please refer to the file "EXAMPLES.txt" in this distribution for details
about the example applications in the "examples" subdirectory.


Tools:
------

Please refer to the file "TOOLS.txt" in this distribution for details
about the various tools to be found in the "tools" subdirectory.


Credits:
--------

Please refer to the file "CREDITS.txt" in this distribution for a list
of contributors.


Author's note:
--------------

If you have any questions, suggestions or need any assistance, please
let me know!

Please do send feedback, this is essential for improving this module
according to your needs!

I hope you will find this module beneficial.

Yours,
--
  Steffen Beyer <sb@engelschall.com> http://www.engelschall.com/u/sb/
  "There is enough for the need of everyone in this world, but not
   for the greed of everyone." - Mohandas Karamchand "Mahatma" Gandhi
