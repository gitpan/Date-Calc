#!/bin/sh

###############################################################################
##                                                                           ##
##    Copyright (c) 1998 by Steffen Beyer.                                   ##
##    All rights reserved.                                                   ##
##                                                                           ##
##    This program is free software; you can redistribute it                 ##
##    and/or modify it under the same terms as Perl.                         ##
##                                                                           ##
###############################################################################

self=`basename $0`

if [ $# = 0 ]
then
    echo "Usage:  $self  <main>.c  [  <other>.c  ...  ]"
    exit 0
fi

main=`basename $1 .c`

shift

gcc -ansi -O2 -o $main $main.c "$@"

