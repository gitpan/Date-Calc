#!perl

###############################################################################
##                                                                           ##
##    Copyright (c) 1998 - 2000 by Steffen Beyer.                            ##
##    All rights reserved.                                                   ##
##                                                                           ##
##    This program is free software; you can redistribute it                 ##
##    and/or modify it under the same terms as Perl itself.                  ##
##                                                                           ##
###############################################################################

$self = $0;
$self =~ s!^.*/!!;

use Config;

$cc = $Config{'cc'};
$flags = $Config{'ccflags'};
$charset = ($Config{'archname'} =~ /MSWin32/i) ? "-win" : "-dos";

&compile('iso2pc.c');
&compile('pc2iso.c');

&convert('../Calc.pm');
&convert('../DateCalc.c');
&convert('../DateCalc.h');
&convert('../examples/age_in_days_eu.pl');
&convert('../examples/age_in_days_us.pl');

exit;

sub compile
{
    my($source) = @_;
    my($target);

    $target = $source;
    $target =~ s!\.c$!!;
    if ((-f $target) || (-f "$target.exe"))
    {
        warn "$self: skipping compilation of '$source': '$target' exists!\n";
    }
    else
    {
        print "$self: compiling '$source'...\n";
        $rc = system("$cc $flags -o $target $source");
        if ($rc >> 8)
        {
            warn "$self: unable to compile '$source'!\n";
            die  "Please fix problem (or compile manually) and re-run $self.\n";
        }
    }
}

sub convert
{
    my($source) = @_;
    my($target);

    $target = $source;
    $target .= '_';

    if (-f $target)
    {
        warn "$self: skipping renaming of '$source': '$target' exists!\n";
    }
    else
    {
        print "$self: renaming '$source' to '$target'...\n";
        unless (rename($source,$target))
        {
            warn "$self: unable to rename '$source' to '$target'!\n";
            return;
        }
    }
    print "$self: converting '$target' to '$source'...\n";
    $rc = system("./iso2pc $charset <$target >$source");
    if ($rc >> 8)
    {
        warn "$self: unable to convert '$target' to '$source'!\n";
    }
}

__END__

