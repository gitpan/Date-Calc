#!/bin/sh

###############################################################################
##                                                                           ##
##    Copyright (c) 1998 - 2000 by Steffen Beyer.                            ##
##    All rights reserved.                                                   ##
##                                                                           ##
##    This program is free software; you can redistribute it                 ##
##    and/or modify it under the same terms as Perl.                         ##
##                                                                           ##
###############################################################################

self=`basename $0`

compile ()
{
    target=$1
    source="${target}.c"
    if [ -f "$target" ]
    then
        echo "$self: skipping compilation of '$source': '$target' exists!" >&2
    else
        echo "$self: compiling '$source'..."
        gcc -ansi -O2 -o $target $source
        if [ "$?" != "0" ]
        then
            echo "$self: unable to compile '$source'!" >&2
            echo "Please fix problem (or compile manually) and re-run $self.">&2
            exit 1
        fi
    fi
}

convert ()
{
    source=$1
    target="${source}_"
    if [ -f "$target" ]
    then
        echo "$self: skipping renaming of '$source': '$target' exists!" >&2
    else
        echo "$self: renaming '$source' to '$target'..."
        mv $source $target
    fi
    echo "$self: converting '$target' to '$source'..."
    ./iso2pc -dos <$target >$source
}

compile 'iso2pc'
compile 'pc2iso'

convert '../Calc.pm'
convert '../DateCalc.c'
convert '../DateCalc.h'
convert '../examples/age_in_days_eu.pl'
convert '../examples/age_in_days_us.pl'

