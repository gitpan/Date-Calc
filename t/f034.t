#!perl -w

use strict;
no strict "vars";

eval { require Bit::Vector; };

if ($@)
{
    print "1..0\n";
    exit 0;
}

require Date::Calendar;
require Date::Calendar::Year;
require Date::Calendar::Profiles;

Date::Calendar::Profiles->import( qw( $Profiles ) );

# ======================================================================
#   $item = Date::Calendar::Year->new($year,$prof);
# ======================================================================

$k = scalar(keys %{$Profiles});

print "1..$k\n";

$n = 1;
foreach $key (keys %{$Profiles})
{
    eval
    {
        $cal  = Date::Calendar->new( ${$Profiles}{$key} );
        $year = $cal->year( 2000 );
        $year = Date::Calendar::Year->new( 1999, ${$Profiles}{$key} );
    };
    unless ($@)
    {print "ok $n\n";} else {print "not ok $n\n";}
    $n++;
}

__END__

