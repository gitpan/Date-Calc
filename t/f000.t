#!perl -w

use strict;
no strict "vars";

use Date::Calc 4.2;

# ======================================================================
#   $version = Date::Calc::Version();
#   $version = $Date::Calc::VERSION;
# ======================================================================

print "1..2\n";

$n = 1;
if (Date::Calc::Version() eq "4.2")
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($Date::Calc::VERSION eq "4.2")
{print "ok $n\n";} else {print "not ok $n\n";}

__END__

