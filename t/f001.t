#!perl -w

use strict;
no strict "vars";

use Date::Calc qw( leap_year );

# ======================================================================
#   $flag = leap_year($year);
# ======================================================================

print "1..2\n";

$n = 1;
if (leap_year(1964) == 1) {print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if (leap_year(1995) == 0) {print "ok $n\n";} else {print "not ok $n\n";}

__END__

