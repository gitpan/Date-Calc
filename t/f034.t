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

#          Unix epoch is Thu  1-Jan-1970 00:00:00 (GMT)
# Classic MacOS epoch is Fri  1-Jan-1904 00:00:00 (local time)
#
#  Unix time overflow is Tue 19-Jan-2038 03:14:07 (time=0x7FFFFFFF)
# MacOS time overflow is Mon  6-Feb-2040 06:28:15 (time=0xFFFFFFFF)

if ($^O eq 'MacOS')
{
    $is_MacOS = 1;

    # Epoch values:
    $Epoch_Year     = 1904;
    $Epoch_Dow      = 5;

    # "time" overflow values:
    $Overflow_Year  = 2040;
    $Overflow_Month = 2;
    $Overflow_Day   = 6;
    $Overflow_Hour  = 6;
    $Overflow_Min   = 28;
    $Overflow_Sec   = 15;
    $Overflow_Doy   = 37;
    $Overflow_Dow   = 1;

    # Values for time == 992187750:
    $Match_Year     = 1935;
    $Match_Month    = 6;
    $Match_Day      = 10;
    $Match_Hour     = 15;
    $Match_Min      = 42;
    $Match_Sec      = 30;
    $Match_Doy      = 161;
    $Match_Dow      = 1;

    # Maximum "time" value:
    $Max_Time = 0xFFFFFFFF;
}
else
{
    $is_MacOS = 0;

    # Epoch values:
    $Epoch_Year     = 1970;
    $Epoch_Dow      = 4;

    # "time" overflow values:
    $Overflow_Year  = 2038;
    $Overflow_Month = 1;
    $Overflow_Day   = 19;
    $Overflow_Hour  = 3;
    $Overflow_Min   = 14;
    $Overflow_Sec   = 7;
    $Overflow_Doy   = 19;
    $Overflow_Dow   = 2;

    # Values for time == 992187750:
    $Match_Year     = 2001;
    $Match_Month    = 6;
    $Match_Day      = 10;
    $Match_Hour     = 15;
    $Match_Min      = 42;
    $Match_Sec      = 30;
    $Match_Doy      = 161;
    $Match_Dow      = 7;

    # Maximum "time" value:
    $Max_Time = 0x7FFFFFFF;
}

print "1..259\n";

$n = 1;

($year,$month,$day, $hour,$min,$sec, $doy,$dow,$dst) =
    $is_MacOS ? Localtime(0) : Gmtime(0);

if ($year == $Epoch_Year)
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
if ($dow == $Epoch_Dow)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($dst == 0)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval
{
    ($year,$month,$day, $hour,$min,$sec, $doy,$dow,$dst) =
        $is_MacOS ? Gmtime(0) : Localtime(0);
};

unless ($@)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if ((($year == $Epoch_Year-1) and ($month == 12) and (($day == 30) or ($day == 31))) or
    (($year == $Epoch_Year)   and ($month ==  1) and (($day ==  1) or ($day ==  2) or ($day == 3))))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $time = Mktime($Epoch_Year,1,3,0,0,0); };

unless ($@)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if ($time < 5 * 86400)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

($year,$month,$day, $hour,$min,$sec, $doy,$dow,$dst) =
    $is_MacOS ? Localtime(0xFFFFFFFF) : Gmtime(0x7FFFFFFF);

if ($year == $Overflow_Year)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($month == $Overflow_Month)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($day == $Overflow_Day)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($hour == $Overflow_Hour)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($min == $Overflow_Min)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($sec == $Overflow_Sec)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($doy == $Overflow_Doy)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($dow == $Overflow_Dow)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($dst == 0)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval
{
    ($year,$month,$day, $hour,$min,$sec, $doy,$dow,$dst) =
        $is_MacOS ? Gmtime(0xFFFFFFFF) : Localtime(0x7FFFFFFF);
};

unless ($@)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if (($year == $Overflow_Year)  and ($month == $Overflow_Month) and
    ($day  >= $Overflow_Day-2) and ($day   <= $Overflow_Day+2))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

($year,$month,$day, $hour,$min,$sec, $doy,$dow,$dst) =
    $is_MacOS ? Localtime(992187750) : Gmtime(992187750);

if ($year == $Match_Year)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($month == $Match_Month)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($day == $Match_Day)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($hour == $Match_Hour)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($min == $Match_Min)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($sec == $Match_Sec)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($doy == $Match_Doy)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($dow == $Match_Dow)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;
if ($dst == 0)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval
{
    ($year,$month,$day, $hour,$min,$sec, $doy,$dow,$dst) =
        $is_MacOS ? Gmtime(992187750) : Localtime(992187750);
};

unless ($@)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if (($year == $Match_Year)  and ($month == $Match_Month) and
    ($day  >= $Match_Day-2) and ($day   <= $Match_Day+2))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $time = Mktime($year,$month,$day, $hour,$min,$sec); };

unless ($@)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if (abs($time - 992187750) < 172800)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval
{
    ($year,$month,$day, $hour,$min,$sec, $doy,$dow,$dst) =
        $is_MacOS ? Localtime() : Gmtime();
};

unless ($@)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if (($year > 2000) and ($year < $Overflow_Year+1))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { ($year,$month,$day, $hour,$min,$sec) = Time_to_Date(); };

unless ($@)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if (($year > 2000) and ($year < $Overflow_Year+1))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval
{
    ($year,$month,$day, $hour,$min,$sec, $doy,$dow,$dst) =
        $is_MacOS ? Gmtime() : Localtime();
};

unless ($@)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if (($year > 2000) and ($year < $Overflow_Year+1))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { $time = Mktime($year,$month,$day, $hour,$min,$sec); };

unless ($@)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if (($time > 992187750) and ($time < $Max_Time))
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
    @test  = $is_MacOS ? (Localtime($time))[0..5] : (Gmtime($time))[0..5];
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

eval
{
    $secs = Mktime($Overflow_Year,$Overflow_Month,$Overflow_Day,
                   $Overflow_Hour,$Overflow_Min,$Overflow_Sec);
};
unless ($@)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if ( ($secs <= $Max_Time) and ($secs >= $Max_Time-86400) )
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval
{
    $secs = Mktime($Overflow_Year,$Overflow_Month,$Overflow_Day,
                   $Overflow_Hour,$Overflow_Min,$Overflow_Sec+1);
};
if ($@ =~ /\bDate::Calc::Mktime\(\): date out of range\b/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval
{
    $secs = Mktime($Overflow_Year,$Overflow_Month,$Overflow_Day,
                   $Overflow_Hour,$Overflow_Min+1,$Overflow_Sec);
};
if ($@ =~ /\bDate::Calc::Mktime\(\): date out of range\b/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval
{
    $secs = Mktime($Overflow_Year,$Overflow_Month,$Overflow_Day,
                   $Overflow_Hour+1,$Overflow_Min,$Overflow_Sec);
};
if ($@ =~ /\bDate::Calc::Mktime\(\): date out of range\b/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval
{
    $secs = Mktime($Overflow_Year,$Overflow_Month,$Overflow_Day+1,
                   $Overflow_Hour,$Overflow_Min,$Overflow_Sec);
};
if ($@ =~ /\bDate::Calc::Mktime\(\): date out of range\b/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval
{
    $secs = Mktime($Overflow_Year,$Overflow_Month+1,$Overflow_Day,
                   $Overflow_Hour,$Overflow_Min,$Overflow_Sec);
};
if ($@ =~ /\bDate::Calc::Mktime\(\): date out of range\b/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval
{
    $secs = Mktime($Overflow_Year+1,$Overflow_Month,$Overflow_Day,
                   $Overflow_Hour,$Overflow_Min,$Overflow_Sec);
};
if ($@ =~ /\bDate::Calc::Mktime\(\): date out of range\b/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

__END__

