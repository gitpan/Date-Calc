#!perl -w

BEGIN { eval { require bytes; }; }
use strict;
no strict "vars";

use Date::Calc qw(:all);

# ======================================================================
#   ($d_y, $d_m, $d_d) = N_Delta_YMD($year1, $m1, $d1,
#                                    $year2, $m2, $d2);
# ======================================================================

$tests = 17 * 4 + 9;

print "1..$tests\n";

$n = 1;

eval { ($d_y, $d_m, $d_d) = N_Delta_YMD(0,2,28,1996,2,29); };    # 01
if ($@ =~ /not a valid date/)
{print "ok $n\n";} else {print "not ok $n\n$@\n";}
$n++;

eval { ($d_y, $d_m, $d_d) = N_Delta_YMD(1997,0,28,1996,2,29); }; # 02
if ($@ =~ /not a valid date/)
{print "ok $n\n";} else {print "not ok $n\n$@\n";}
$n++;

eval { ($d_y, $d_m, $d_d) = N_Delta_YMD(1997,2,0,1996,2,29); };  # 03
if ($@ =~ /not a valid date/)
{print "ok $n\n";} else {print "not ok $n\n$@\n";}
$n++;

eval { ($d_y, $d_m, $d_d) = N_Delta_YMD(1997,2,29,1996,2,29); }; # 04
if ($@ =~ /not a valid date/)
{print "ok $n\n";} else {print "not ok $n\n$@\n";}
$n++;

eval { ($d_y, $d_m, $d_d) = N_Delta_YMD(1996,2,29,0,2,28); };    # 05
if ($@ =~ /not a valid date/)
{print "ok $n\n";} else {print "not ok $n\n$@\n";}
$n++;

eval { ($d_y, $d_m, $d_d) = N_Delta_YMD(1996,2,29,1997,0,28); }; # 06
if ($@ =~ /not a valid date/)
{print "ok $n\n";} else {print "not ok $n\n$@\n";}
$n++;

eval { ($d_y, $d_m, $d_d) = N_Delta_YMD(1996,2,29,1997,2,0); };  # 07
if ($@ =~ /not a valid date/)
{print "ok $n\n";} else {print "not ok $n\n$@\n";}
$n++;

eval { ($d_y, $d_m, $d_d) = N_Delta_YMD(1996,2,29,1997,2,29); }; # 08
if ($@ =~ /not a valid date/)
{print "ok $n\n";} else {print "not ok $n\n$@\n";}
$n++;

eval { ($d_y, $d_m, $d_d) = N_Delta_YMD(1996,2,29,1997,2,28); }; # 09
unless ($@)
{print "ok $n\n";} else {print "not ok $n\n$@\n";}
$n++;

&try( [2008, 1, 3], [2009, 8,21], [ 1, 7,18] ); # 01
&try( [2009, 8,26], [2011, 7,27], [ 1,11, 1] ); # 02
&try( [1964, 1, 3], [2009, 8,26], [45, 7,23] ); # 03
&try( [2009, 1,31], [2009, 2,28], [ 0, 0,28] ); # 04
&try( [2009, 2,28], [2009, 3,31], [ 0, 1, 3], [0, -1,  0] ); # 05
&try( [2008, 1,31], [2009, 1, 1], [ 0,11, 1] ); # 06
&try( [2008, 2,29], [2009, 2, 1], [ 0,11, 3], [0,-11, -1] ); # 07
&try( [2008, 3,31], [2009, 3, 1], [ 0,11, 1] ); # 08
&try( [1996, 2,29], [1997, 2,28], [ 1, 0, 0], [0,-11,-28] ); # 09
&try( [2009, 1,31], [2009, 3, 2], [ 0, 0,30] ); # 10
&try( [2009, 1,30], [2009, 3, 1], [ 0, 0,30] ); # 11
&try( [2008, 1,31], [2008, 3, 1], [ 0, 0,30] ); # 12
&try( [2008, 2,15], [2008, 3,15], [ 0, 0,29] ); # 13
&try( [2009, 2,15], [2009, 3,15], [ 0, 0,28] ); # 14
&try( [2007, 2, 1], [2008, 1,31], [ 0,11,30], [0,-11,-27] ); # 15
&try( [2007, 2,28], [2008, 1, 1], [ 0,10, 4], [0,-10, -1] ); # 16
&try( [2008, 1,31], [2009, 2, 1], [ 1, 0, 1] ); # 17

sub try
{
    my($d1) = shift;
    my($d2) = shift;
    my($dd) = shift;
    my(@tt,@cc);

#print "&try( [", join(',',@$d1), "], [", join(',',@$d2), "], [", join(',',@$dd), "] );\n";
    @tt = N_Delta_YMD(@$d1,@$d2);
#print "diff: (", join(',',@tt), ")\n";
    @cc = Add_Delta_Days( Add_Delta_YM(@$d1,@tt[0,1]), $tt[2] );
#print "check: (", join(',',@cc), ")\n";
    if (($tt[0] == $dd->[0]) and
        ($tt[1] == $dd->[1]) and
        ($tt[2] == $dd->[2]))
    {print "ok $n\n";} else {print "not ok $n\n($tt[0],$tt[1],$tt[2]) != ($dd->[0],$dd->[1],$dd->[2])\n";} # 01
    $n++;
    if (($cc[0] == $d2->[0]) and
        ($cc[1] == $d2->[1]) and
        ($cc[2] == $d2->[2]))
    {print "ok $n\n";} else {print "not ok $n\n($cc[0],$cc[1],$cc[2]) != ($d2->[0],$d2->[1],$d2->[2])\n";} # 02
    $n++;
    if (@_ > 0) { $dd = shift; }
    else
    {
        $dd->[0] = -$dd->[0];
        $dd->[1] = -$dd->[1];
        $dd->[2] = -$dd->[2];
    }
    @tt = N_Delta_YMD(@$d2,@$d1);
#print "diff: (", join(',',@tt), ")\n";
#   @cc = Add_Delta_YM(@$d2,@tt[0,1]);
#print "check: (", join(',',@cc), ")\n";
#   @cc = Add_Delta_Days( @cc, $tt[2] );
    @cc = Add_Delta_Days( Add_Delta_YM(@$d2,@tt[0,1]), $tt[2] );
#print "check: (", join(',',@cc), ")\n";
    if (($tt[0] == $dd->[0]) and
        ($tt[1] == $dd->[1]) and
        ($tt[2] == $dd->[2]))
    {print "ok $n\n";} else {print "not ok $n\n($tt[0],$tt[1],$tt[2]) != ($dd->[0],$dd->[1],$dd->[2])\n";} # 03
    $n++;
    if (($cc[0] == $d1->[0]) and
        ($cc[1] == $d1->[1]) and
        ($cc[2] == $d1->[2]))
    {print "ok $n\n";} else {print "not ok $n\n($cc[0],$cc[1],$cc[2]) != ($d1->[0],$d1->[1],$d1->[2])\n";} # 04
    $n++;
}

sub Norm_Delta_YMD
{
    die "Usage: Date::Calc::Norm_Delta_YMD(year1, month1, day1, year2, month2, day2)" if (scalar(@_) != 6);
    die "not a valid date" unless (check_date(@_[0..2]));
    die "not a valid date" unless (check_date(@_[3..5]));
    my(@delta) = (0,0,Delta_Days(@_));
    if (abs($delta[2]) > 30)
    {
        $delta[0] = $_[3] - $_[0];
        $delta[1] = $_[4] - $_[1];
        $delta[2] = Delta_Days(Add_Delta_YM(@_[0..2],@delta[0,1]),@_[3..5]);
        if (!(($delta[0] >= 0 and $delta[1] >= 0 and $delta[2] >= 0) or
              ($delta[0] <= 0 and $delta[1] <= 0 and $delta[2] <= 0)))
        {
#print "delta = ( ", join(',', @delta), " )\n";
            if    ($delta[0] < 0 and $delta[1] > 0) { $delta[0]++; $delta[1] -= 12; }
            elsif ($delta[0] > 0 and $delta[1] < 0) { $delta[0]--; $delta[1] += 12; }
#print "delta = ( ", join(',', @delta), " )\n";
            if    ($delta[1] < 0 and $delta[2] > 0) { $delta[1]++; $delta[2] = Delta_Days(Add_Delta_YM(@_[0..2],@delta[0,1]),@_[3..5]); }
            elsif ($delta[1] > 0 and $delta[2] < 0) { $delta[1]--; $delta[2] = Delta_Days(Add_Delta_YM(@_[0..2],@delta[0,1]),@_[3..5]); }
#print "delta = ( ", join(',', @delta), " )\n";
            if    ($delta[0] < 0 and $delta[2] > 0) { $delta[0]++; $delta[1] -= 12; }
            elsif ($delta[0] > 0 and $delta[2] < 0) { $delta[0]--; $delta[1] += 12; }
#print "delta = ( ", join(',', @delta), " )\n";
            if    ($delta[1] < 0 and $delta[2] > 0) { $delta[1]++; $delta[2] = Delta_Days(Add_Delta_YM(@_[0..2],@delta[0,1]),@_[3..5]); }
            elsif ($delta[1] > 0 and $delta[2] < 0) { $delta[1]--; $delta[2] = Delta_Days(Add_Delta_YM(@_[0..2],@delta[0,1]),@_[3..5]); }
#print "delta = ( ", join(',', @delta), " )\n";
        }
    }
    return(@delta);
}

__END__

