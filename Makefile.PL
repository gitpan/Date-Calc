
###############################################################################
##                                                                           ##
##    Copyright (c) 1995, 1996, 1997, 1998 by Steffen Beyer.                 ##
##    All rights reserved.                                                   ##
##                                                                           ##
##    This package is free software; you can redistribute it                 ##
##    and/or modify it under the same terms as Perl itself.                  ##
##                                                                           ##
###############################################################################

use ExtUtils::MakeMaker;

WriteMakefile(
    'NAME'              => 'Date::Calc',
    'VERSION_FROM'      => 'Calc.pm',
    'OBJECT'            => '$(O_FILES)',
    'LIBS'              => [''],   # e.g., '-lm'
    'DEFINE'            => '',     # e.g., '-DHAVE_SOMETHING'
    'INC'               => '',     # e.g., '-I/usr/include/other'
#   'EXE_FILES'         => [ qw() ],
    'dist'              => { COMPRESS => "gzip -9", SUFFIX => "gz" }
);

