#!perl -w

use strict;
no strict "vars";

use Date::Calc qw( Add_Delta_YMD );

# ======================================================================
#   ($year,$mm,$dd) = Add_Delta_YMD($year,  $mm,    $dd,
#                                           $y_offs,$m_offs,$d_offs);
# ======================================================================

print "1..18\n";

$n = 1;
eval { ($year,$mm,$dd) = Add_Delta_YMD(0,0,0,0,0,0); };
if ($@ =~ /not a valid date/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { ($year,$mm,$dd) = Add_Delta_YMD(0,2,28,0,0,0); };
if ($@ =~ /not a valid date/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { ($year,$mm,$dd) = Add_Delta_YMD(1997,0,28,0,0,0); };
if ($@ =~ /not a valid date/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { ($year,$mm,$dd) = Add_Delta_YMD(1997,2,0,0,0,0); };
if ($@ =~ /not a valid date/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { ($year,$mm,$dd) = Add_Delta_YMD(1997,2,29,0,0,0); };
if ($@ =~ /not a valid date/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if ((($year,$mm,$dd) = Add_Delta_YMD(1996,2,29,0,0,0)) &&
($year==1996) && ($mm==2) && ($dd==29))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if ((($year,$mm,$dd) = Add_Delta_YMD(1996,2,29,1,0,0)) &&
($year==1997) && ($mm==3) && ($dd==1))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if ((($year,$mm,$dd) = Add_Delta_YMD(1997,1,29,0,1,0)) &&
($year==1997) && ($mm==3) && ($dd==1))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if ((($year,$mm,$dd) = Add_Delta_YMD(1997,2,28,0,0,1)) &&
($year==1997) && ($mm==3) && ($dd==1))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { ($year,$mm,$dd) = Add_Delta_YMD(1,1,1,0,0,-1); };
if ($@ =~ /not a valid date/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { ($year,$mm,$dd) = Add_Delta_YMD(1,1,1,0,-1,0); };
if ($@ =~ /not a valid date/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

eval { ($year,$mm,$dd) = Add_Delta_YMD(1,1,1,-1,0,0); };
if ($@ =~ /not a valid date/)
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

($year,$mm,$dd) = (1997,2,26); ($y,$m,$d) = (0,-1,17);

if ((($year,$mm,$dd) = Add_Delta_YMD($year,$mm,$dd, $y,$m,$d)) &&
($year==1997) && ($mm==2) && ($dd==15))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if ((($year,$mm,$dd) = Add_Delta_YMD($year,$mm,$dd, -$y,-$m,-$d)) &&
($year==1997) && ($mm==3) && ($dd==1))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

($year,$mm,$dd) = (1997,2,15); ($y,$m,$d) = (0,1,-17);

if ((($year,$mm,$dd) = Add_Delta_YMD($year,$mm,$dd, $y,$m,$d)) &&
($year==1997) && ($mm==3) && ($dd==1))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if ((($year,$mm,$dd) = Add_Delta_YMD($year,$mm,$dd, -$y,-$m,-$d)) &&
($year==1997) && ($mm==2) && ($dd==18))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

($year,$mm,$dd) = (1997,2,15); ($y,$m,$d) = (1,-24,14);

if ((($year,$mm,$dd) = Add_Delta_YMD($year,$mm,$dd, $y,$m,$d)) &&
($year==1996) && ($mm==3) && ($dd==1))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

if ((($year,$mm,$dd) = Add_Delta_YMD($year,$mm,$dd, -$y,-$m,-$d)) &&
($year==1997) && ($mm==2) && ($dd==16))
{print "ok $n\n";} else {print "not ok $n\n";}
$n++;

__END__
