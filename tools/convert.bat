@ECHO OFF

rem ###########################################################################
rem ##                                                                       ##
rem ##    Copyright (c) 1998 by Steffen Beyer.                               ##
rem ##    All rights reserved.                                               ##
rem ##                                                                       ##
rem ##    This program is free software; you can redistribute it             ##
rem ##    and\or modify it under the same terms as Perl.                     ##
rem ##                                                                       ##
rem ###########################################################################

if exist iso2pc.exe goto warn1
    echo %0: compiling 'iso2pc.c'...
    cl -O2 -o iso2pc iso2pc.c
goto cont1
:warn1
    echo %0: skipping compilation of 'iso2pc.c': 'iso2pc.exe' exists!
:cont1

if exist pc2iso.exe goto warn2
    echo %0: compiling 'pc2iso.c'...
    cl -O2 -o pc2iso pc2iso.c
goto cont2
:warn2
    echo %0: skipping compilation of 'pc2iso.c': 'pc2iso.exe' exists!
:cont2

cd ..

if exist DateCalc.co goto warn3
    echo %0: renaming 'DateCalc.c' to 'DateCalc.co'...
    ren DateCalc.c DateCalc.co
goto cont3
:warn3
    echo %0: skipping renaming of 'DateCalc.c': 'DateCalc.co' exists!
:cont3

if exist DateCalc.ho goto warn4
    echo %0: renaming 'DateCalc.h' to 'DateCalc.ho'...
    ren DateCalc.h DateCalc.ho
goto cont4
:warn4
    echo %0: skipping renaming of 'DateCalc.h': 'DateCalc.ho' exists!
:cont4

echo %0: converting 'DateCalc.co' to 'DateCalc.c'...
tools\iso2pc.exe -win <DateCalc.co >DateCalc.c

echo %0: converting 'DateCalc.ho' to 'DateCalc.h'...
tools\iso2pc.exe -win <DateCalc.ho >DateCalc.h

cd examples

if exist age_in_days_eu.plo goto warn5
    echo %0: renaming 'age_in_days_eu.pl' to 'age_in_days_eu.plo'...
    ren age_in_days_eu.pl age_in_days_eu.plo
goto cont5
:warn5
    echo %0: skipping renaming of 'age_in_days_eu.pl': 'age_in_days_eu.plo' exists!
:cont5

if exist age_in_days_us.plo goto warn6
    echo %0: renaming 'age_in_days_us.pl' to 'age_in_days_us.plo'...
    ren age_in_days_us.pl age_in_days_us.plo
goto cont6
:warn6
    echo %0: skipping renaming of 'age_in_days_us.pl': 'age_in_days_us.plo' exists!
:cont6

echo %0: converting 'age_in_days_eu.plo' to 'age_in_days_eu.pl'...
..\tools\iso2pc.exe -win <age_in_days_eu.plo >age_in_days_eu.pl

echo %0: converting 'age_in_days_us.plo' to 'age_in_days_us.pl'...
..\tools\iso2pc.exe -win <age_in_days_us.plo >age_in_days_us.pl

cd ..\tools

