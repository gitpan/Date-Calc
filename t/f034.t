#!perl -w

use strict;
no strict "vars";

use Date::Calc qw(:all);

# ======================================================================
#   ($year,$month,$day, $hour,$min,$sec, $doy,$dow,$dst) = Gmtime([time]);
#   ($year,$month,$day, $hour,$min,$sec, $doy,$dow,$dst) = Localtime([time]);
#   $time = Mktime($year,$month,$day, $hour,$min,$sec);
#   ($year,$month,$day, $hour,$min,$sec) = Time_to_Date([time]);
#   $time = Date_to_Time($year,$month,$day, $hour,$min,$sec);
# ======================================================================

print "1..251\n";

$n = 1;

($year,$month,$day, $hour,$min,$sec, $doy,$dow,$dst) = Gmtime(0);

if ($year == 1970)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($month == 1)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($day == 1)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($hour == 0)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($min == 0)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($sec == 0)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($doy == 1)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($dow == 4)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($dst == 0)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { ($year,$month,$day, $hour,$min,$sec, $doy,$dow,$dst) = Localtime(0); };

unless ($@)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if ((($year == 1969) and ($month == 12) and (($day == 30) or ($day == 31))) or
    (($year == 1970) and ($month ==  1) and (($day ==  1) or ($day ==  2) or ($day == 3))))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $time = Mktime(1970,1,3,0,0,0); };

unless ($@)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if ($time < 5 * 86400)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

($year,$month,$day, $hour,$min,$sec, $doy,$dow,$dst) = Gmtime(0x7FFFFFFF);

if ($year == 2038)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($month == 1)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($day == 19)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($hour == 3)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($min == 14)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($sec == 7)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($doy == 19)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($dow == 2)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($dst == 0)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { ($year,$month,$day, $hour,$min,$sec, $doy,$dow,$dst) = Localtime(0x7FFFFFFF); };

unless ($@)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if (($year == 2038) and ($month == 1) and ($day >= 17) and ($day <= 21))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

($year,$month,$day, $hour,$min,$sec, $doy,$dow,$dst) = Gmtime(992187750);

if ($year == 2001)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($month == 6)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($day == 10)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($hour == 15)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($min == 42)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($sec == 30)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($doy == 161)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($dow == 7)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($dst == 0)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { ($year,$month,$day, $hour,$min,$sec, $doy,$dow,$dst) = Localtime(992187750); };

unless ($@)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if (($year == 2001) and ($month == 6) and ($day >= 8) and ($day <= 12))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $time = Mktime($year,$month,$day, $hour,$min,$sec); };

unless ($@)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if (abs($time - 992187750) < 172800)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { ($year,$month,$day, $hour,$min,$sec, $doy,$dow,$dst) = Gmtime(); };

unless ($@)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if (($year > 2000) and ($year < 2039))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { ($year,$month,$day, $hour,$min,$sec) = Time_to_Date(); };

unless ($@)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if (($year > 2000) and ($year < 2039))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { ($year,$month,$day, $hour,$min,$sec, $doy,$dow,$dst) = Localtime(); };

unless ($@)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if (($year > 2000) and ($year < 2039))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $time = Mktime($year,$month,$day, $hour,$min,$sec); };

unless ($@)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if (($time > 992187750) and ($time < 0x7FFFFFFF))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

$now = CORE::time();

$step = int($now / 500) * 10;

@past = map $_ * $step, 1..50;

$step = int((0x7FFFFFFF - $now) / 500) * 10;

@future = map $_ * $step + $now, 1..50;

for $time (0, @past, $now, @future, 0x7FFFFFFF)
{
    @date  = Time_to_Date($time);
    @test  = (Gmtime($time))[0..5];
    $check = Date_to_Time(@date);
    if ($time == $check)
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
    if (($date[0] == $test[0]) and
        ($date[1] == $test[1]) and
        ($date[2] == $test[2]) and
        ($date[3] == $test[3]) and
        ($date[4] == $test[4]) and
        ($date[5] == $test[5]))
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
}

__END__

