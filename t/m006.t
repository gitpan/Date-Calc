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

#          Unix epoch is Thu  1-Jan-1970 00:00:00 (GMT)
# Classic MacOS epoch is Fri  1-Jan-1904 00:00:00 (local time)
#
#  Unix time overflow is Tue 19-Jan-2038 03:14:07 (time=0x7FFFFFFF)
# MacOS time overflow is Mon  6-Feb-2040 06:28:15 (time=0xFFFFFFFF)

if ($^O eq 'MacOS')
{
    $is_MacOS = 1;
    $epoch_vec = [1904,1,1,0,0,0];
    $wrong_epoch_vec = [1904,1,1,1,1,1];
    $epoch_string = 'Friday, January 1st 1904 00:00:00';
    $cmp_date_vec = [1904,1,3];
    $max_time = 0xFFFFFFFF;
    $max_epoch_str = 'Monday, February 6th 2040 06:28:15';
    $match_date_str = 'Monday, June 10th 1935 15:42:30';
}
else
{
    $is_MacOS = 0;
    $epoch_vec = [1970,1,1,0,0,0];
    $wrong_epoch_vec = [1970,1,1,1,1,1];
    $epoch_string = 'Thursday, January 1st 1970 00:00:00';
    $cmp_date_vec = [1970,1,3];
    $max_time = 0x7FFFFFFF;
    $max_epoch_str = 'Tuesday, January 19th 2038 03:14:07';
    $match_date_str = 'Sunday, June 10th 2001 15:42:30';
}

print "1..33\n";

$n = 1;

$date = $is_MacOS ? Date::Calc->localtime(0) : Date::Calc->gmtime(0);

if ($date eq $epoch_vec)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($date ne $wrong_epoch_vec)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($date == $wrong_epoch_vec)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$date->date_format(3);

if ("$date" eq $epoch_string)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$other = Date::Calc->time2date(0);

$other->date_format(3);

if ("$other" eq $epoch_string)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if ($other->date2time() == 0)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$date->localtime(0);

if ($date->is_valid())
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if ($date lt $cmp_date_vec)
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

$is_MacOS ? $date->localtime($max_time) : $date->gmtime($max_time);

if ("$date" eq $max_epoch_str)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$other->time2date($max_time);

if ("$other" eq $max_epoch_str)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if ($other->date2time() == $max_time)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$date->localtime($max_time);

if ($date->is_valid())
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if ($time < ($max_time - 172800))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$is_MacOS ? $date->localtime(992187750) : $date->gmtime(992187750);

if ("$date" eq $match_date_str)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$other->time2date(992187750);

if ("$other" eq $match_date_str)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if ($other->date2time() == 992187750)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$date->localtime(992187750);

if ($date->is_valid())
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$time = $max_time;

if ($time == $max_time)
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

