@ECHO OFF

rem ###########################################################################
rem ##                                                                       ##
rem ##    Copyright (c) 1998 - 2000 by Steffen Beyer.                        ##
rem ##    All rights reserved.                                               ##
rem ##                                                                       ##
rem ##    This program is free software; you can redistribute it             ##
rem ##    and/or modify it under the same terms as Perl.                     ##
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

if exist Calc.pm_ goto warn3
    echo %0: renaming 'Calc.pm' to 'Calc.pm_'...
    ren Calc.pm Calc.pm_
goto cont3
:warn3
    echo %0: skipping renaming of 'Calc.pm': 'Calc.pm_' exists!
:cont3

if exist DateCalc.c_ goto warn4
    echo %0: renaming 'DateCalc.c' to 'DateCalc.c_'...
    ren DateCalc.c DateCalc.c_
goto cont4
:warn4
    echo %0: skipping renaming of 'DateCalc.c': 'DateCalc.c_' exists!
:cont4

if exist DateCalc.h_ goto warn5
    echo %0: renaming 'DateCalc.h' to 'DateCalc.h_'...
    ren DateCalc.h DateCalc.h_
goto cont5
:warn5
    echo %0: skipping renaming of 'DateCalc.h': 'DateCalc.h_' exists!
:cont5

echo %0: converting 'Calc.pm_' to 'Calc.pm'...
tools\iso2pc.exe -win <Calc.pm_ >Calc.pm

echo %0: converting 'DateCalc.c_' to 'DateCalc.c'...
tools\iso2pc.exe -win <DateCalc.c_ >DateCalc.c

echo %0: converting 'DateCalc.h_' to 'DateCalc.h'...
tools\iso2pc.exe -win <DateCalc.h_ >DateCalc.h

cd examples

if exist age_in_days_eu.pl_ goto warn6
    echo %0: renaming 'age_in_days_eu.pl' to 'age_in_days_eu.pl_'...
    ren age_in_days_eu.pl age_in_days_eu.pl_
goto cont6
:warn6
    echo %0: skipping renaming of 'age_in_days_eu.pl': 'age_in_days_eu.pl_' exists!
:cont6

if exist age_in_days_us.pl_ goto warn7
    echo %0: renaming 'age_in_days_us.pl' to 'age_in_days_us.pl_'...
    ren age_in_days_us.pl age_in_days_us.pl_
goto cont7
:warn7
    echo %0: skipping renaming of 'age_in_days_us.pl': 'age_in_days_us.pl_' exists!
:cont7

echo %0: converting 'age_in_days_eu.pl_' to 'age_in_days_eu.pl'...
..\tools\iso2pc.exe -win <age_in_days_eu.pl_ >age_in_days_eu.pl

echo %0: converting 'age_in_days_us.pl_' to 'age_in_days_us.pl'...
..\tools\iso2pc.exe -win <age_in_days_us.pl_ >age_in_days_us.pl

cd ..\tools

