#!perl -w

use strict;
no strict "vars";

use Date::Calc::Object qw(:all);

# ======================================================================
#   $date = Date::Calc->gmtime([TIME]);
#   $date = Date::Calc->localtime([TIME]);
#   $date = Date::Calc->time2date([TIME]);
#   $time = $date->mktime();
#   $time = $date->date2time();
# ======================================================================

print "1..33\n";

$n = 1;

$date = Date::Calc->gmtime(0);

if ($date eq [1970,1,1,0,0,0])
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($date ne [1970,1,1,1,1,1])
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($date == [1970,1,1,1,1,1])
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$date->date_format(3);

if ("$date" eq 'Thursday, January 1st 1970 00:00:00')
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$other = Date::Calc->time2date(0);

$other->date_format(3);

if ("$other" eq 'Thursday, January 1st 1970 00:00:00')
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if ($other->date2time() == 0)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$date->localtime(0);

if ($date->is_valid())
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if ($date lt [1970,1,3])
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$time = 172800;

if ($time == 172800)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $time = $date->mktime(); };

unless ($@)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if ($time < 172800)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$date->gmtime(0x7FFFFFFF);

if ("$date" eq 'Tuesday, January 19th 2038 03:14:07')
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$other->time2date(0x7FFFFFFF);

if ("$other" eq 'Tuesday, January 19th 2038 03:14:07')
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if ($other->date2time() == 0x7FFFFFFF)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$date->localtime(0x7FFFFFFF);

if ($date->is_valid())
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if ($time < (0x7FFFFFFF - 172800))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$date->gmtime(992187750);

if ("$date" eq 'Sunday, June 10th 2001 15:42:30')
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$other->time2date(992187750);

if ("$other" eq 'Sunday, June 10th 2001 15:42:30')
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if ($other->date2time() == 992187750)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$date->localtime(992187750);

if ($date->is_valid())
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$time = 0x7FFFFFFF;

if ($time == 0x7FFFFFFF)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $time = $date->mktime(); };

unless ($@)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if (abs($time - 992187750) < 172800)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $date->gmtime(); };

unless ($@)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if ($date gt [2001,6,12,23,59,57])
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $other->time2date(); };

unless ($@)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if ($other gt [2001,6,13,17,17,18])
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $date->localtime(); };

unless ($@)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if ($date->is_valid())
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if ($date > [2001,6,12,22,48,33])
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if ($time < (992187750 + 172800))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $time = $date->mktime(); };

unless ($@)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if ($time > (992187750 + 172800))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

__END__

