#!perl -w

use strict;
no strict "vars";

use Date::Calc qw( Date_to_Text_Long );

# ======================================================================
#   $datestr = Date_to_Text_Long($year,$mm,$dd);
# ======================================================================

print "1..2\n";

$n = 1;
if (Date_to_Text_Long(1964,1,3) eq "Friday, 3 January 1964") {print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (Date_to_Text_Long(1995,11,18) eq "Saturday, 18 November 1995") {print "ok $n\n";} else {print "not ok $n\n";}

__END__
