#!perl

###############################################################################
##                                                                           ##
##    Copyright (c) 1998 by Steffen Beyer.                                   ##
##    All rights reserved.                                                   ##
##                                                                           ##
##    This program is free software; you can redistribute it                 ##
##    and/or modify it under the same terms as Perl itself.                  ##
##                                                                           ##
###############################################################################

use strict;
no strict "vars";

$self = $0;
$self =~  s!^.*/!!;

use Date::Calc qw( Decode_Day_of_Week Decode_Month Nth_Weekday_of_Month_Year
                   Day_of_Week_to_Text Month_to_Text Date_to_Text_Long );

if (@ARGV != 4)
{
    die "Usage:  $self  <nth>  <weekday>  <month>  <year>\n";
}

$n = $ARGV[0];

$temp = $ARGV[1];

unless ($wday = Decode_Day_of_Week($temp)) { $wday = $temp; }

$temp = $ARGV[2];

unless ($month = Decode_Month($temp)) { $month = $temp; }

$year = $ARGV[3];

%ordinal = ( 1 => '1st', 2 => '2nd', 3 => '3rd' );

$nth = $ordinal{$n} || $n . "th";

eval { ($yy,$mm,$dd) = Nth_Weekday_of_Month_Year($year,$month,$wday,$n); };

if ($@)
{
    if ($@ =~ /^(.+?)\s*at\s/)
    {
        print "$1!\n";
    }
    else { print $@; }
}
else
{
    print "\nThe $nth ", Day_of_Week_to_Text($wday),
        " in ", Month_to_Text($month), " $year ";
    if (defined $yy)
    {
        print "is ", Date_to_Text_Long($yy,$mm,$dd), ".\n\n";
    }
    else
    {
        print "does not exist!\n\n";
    }
}

__END__

