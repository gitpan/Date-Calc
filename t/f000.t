#!perl -w

use strict;
no strict "vars";

use Date::Calc 4.3;

# ======================================================================
#   $version = Date::Calc::Version();
#   $version = $Date::Calc::VERSION;
# ======================================================================

print "1..2\n";

$n = 1;
if (Date::Calc::Version() eq "4.3")
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($Date::Calc::VERSION eq "4.3")
{print "ok $n\n";} else {print "not ok $n\n";}

__END__

