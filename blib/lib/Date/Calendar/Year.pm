
###############################################################################
##                                                                           ##
##    Copyright (c) 2000 by Steffen Beyer.                                   ##
##    All rights reserved.                                                   ##
##                                                                           ##
##    This package is free software; you can redistribute it                 ##
##    and/or modify it under the same terms as Perl itself.                  ##
##                                                                           ##
###############################################################################

package Date::Calendar::Year;

use strict;
use vars qw( @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS $VERSION );

require Exporter;

@ISA = qw(Exporter);

@EXPORT = qw();

@EXPORT_OK = qw( check_year empty_period );

%EXPORT_TAGS = (all => [@EXPORT_OK]);

$VERSION = '5.0';

use Bit::Vector;
use Carp::Clan qw(^Date::);
use Date::Calc::Object qw(:all);

sub check_year
{
    my($year);

    if (ref($_[0]) and ref($_[0]) !~ /^[A-Z]+$/) { $year = $_[0]->year(); }
    else                                         { $year = $_[0]; }

    if (($year < 1583) || ($year > 2299))
    {
        croak("given year ($year) out of range [1583,2299]");
    }
}

sub empty_period
{
    carp("empty time period selected") if ($^W);
}

sub _invalid_
{
    my($item,$name) = @_;

    croak("date '$item' for day '$name' is invalid");
}

sub _check_init_date_
{
    my($item,$name,$year,$yy,$mm,$dd) = @_;

    &_invalid_($item,$name)
        unless (($year == $yy) && (check_date($yy,$mm,$dd)));
}

sub _check_callback_date_
{
    my($name,$year,$yy,$mm,$dd) = @_;

    croak("callback function for day '$name' returned invalid date")
        unless (($year == $yy) && (check_date($yy,$mm,$dd)));
}

sub _set_date_
{
    my($self,$name,$yy,$mm,$dd,$flag) = @_;
    my($index);

    $flag ||= '';
    $index = $self->date2index($yy,$mm,$dd);
    if ($flag ne '#')
    {
        if ($flag eq ':') { ${$self}{'HALF'}->Bit_On( $index ); }
        else              { ${$self}{'FULL'}->Bit_On( $index ); }
    }
    $self->{'TAGS'}{$index}{$name} = 1;
}

sub _set_fixed_date_
{
    my($self) = shift;
    my($item) = shift;
    my($name) = shift;
    my($year) = shift;

    if ($_[1] =~ /^[a-zA-Z]+$/)
    {
        &_invalid_($item,$name) unless ($_[1] = Decode_Month($_[1]));
    }
    &_check_init_date_($item,$name,$year,@_);
    &_set_date_($self,$name,@_);
}

sub date2index
{
    my($self) = shift;
    my($yy,$mm,$dd,$year,$index);

    if (ref($_[0]) and ref($_[0]) !~ /^[A-Z]+$/) { ($yy,$mm,$dd) = $_[0]->date(); }
    else                                         { ($yy,$mm,$dd) = @_; }

    $year = ${$self}{'YEAR'};
    if ($yy != $year)
    {
        croak("given year ($yy) != object's year ($year)");
    }
    if ((check_date($yy,$mm,$dd)) &&
        (($index = (Date_to_Days($yy,$mm,$dd) - ${$self}{'BASE'})) >= 0) &&
        ($index < ${$self}{'DAYS'}))
    {
        return $index;
    }
    else { croak("invalid date ($yy,$mm,$dd)"); }
}

sub index2date
{
    my($self,$index) = @_;
    my($year,$yy,$mm,$dd);

    $year = ${$self}{'YEAR'};
    $yy = $year;
    $mm = 1;
    $dd = 1;
    if (($index == 0) ||
        (($index > 0) &&
         ($index < ${$self}{'DAYS'}) &&
         (($yy,$mm,$dd) = Add_Delta_Days($year,1,1, $index)) &&
         ($yy == $year)))
    {
        return Date::Calc->new($yy,$mm,$dd);
    }
    else { croak("invalid index ($index)"); }
}

sub new
{
    my($class) = shift;
    my($year,$profile);
    my($self);

    if (ref($_[0]) and ref($_[0]) !~ /^[A-Z]+$/) { $year = $_[0]->year(); }
    else                                         { $year = $_[0]; }
    $profile = $_[1];

    &check_year($year);
    $self = { };
    $class = ref($class) || $class || __PACKAGE__;
    bless($self, $class);
    $self->init($year,$profile);
    return $self;
}

sub init
{
    my($self) = shift;
    my($year,$profile);
    my($days,$dow,$name,$item,$flag,$temp,$n);
    my(@easter,@date);

    if (ref($_[0]) and ref($_[0]) !~ /^[A-Z]+$/) { $year = $_[0]->year(); }
    else                                         { $year = $_[0]; }
    $profile = $_[1];

    &check_year($year);
    croak("given profile is not a HASH ref") unless (ref($profile) eq 'HASH');
    $days = Days_in_Year($year,12);
    ${$self}{'YEAR'} = $year;
    ${$self}{'DAYS'} = $days;
    ${$self}{'BASE'} = Date_to_Days($year,1,1);
    ${$self}{'TAGS'} = { };
    ${$self}{'HALF'} = Bit::Vector->new($days);
    ${$self}{'FULL'} = Bit::Vector->new($days);
    ${$self}{'WORK'} = Bit::Vector->new($days);
    $dow = Day_of_Week($year,1,1);
    $dow = 7 - $dow if ($dow != 7);
    $dow--;
    while ($dow < $days)
    {
        ${$self}{'FULL'}->Bit_On( $dow );                     # Saturday
        ${$self}{'FULL'}->Bit_On( $dow ) if (++$dow < $days); # Sunday
        $dow += 6;
    }
    @easter = Easter_Sunday($year);
    foreach $name (keys %{$profile})
    {
        @date = ();
        $item = ${$profile}{$name};
        if (ref($item))
        {
            if (ref($item) eq 'CODE')
            {
                if (@date = &$item($year,$name))
                {
                    &_check_callback_date_($name,$year,@date);
                    &_set_date_($self,$name,@date);
                }
            }
            else { croak("value for day '$name' is not a CODE ref"); }
        }
        elsif ($item =~ /^ ([#:]?) ([+-]\d+) $/x)
        {
            $flag = $1;
            $temp = $2;
            if ($temp == 0) { @date = @easter; }
            else            { @date = Add_Delta_Days(@easter, $temp); }
            &_check_init_date_($item,$name,$year,@date);
            &_set_date_($self,$name,@date,$flag);
        }
        elsif (($item =~ /^ ([#:]?) (\d+) \.  (\d+)       \.? $/x) ||
               ($item =~ /^ ([#:]?) (\d+) \.? ([a-zA-Z]+) \.? $/x))
        {
            $flag = $1;
            @date = ($year,$3,$2);
            &_set_fixed_date_($self,$item,$name,$year,@date,$flag);
        }
        elsif (($item =~ /^ ([#:]?) (\d+)       \/  (\d+) $/x) ||
               ($item =~ /^ ([#:]?) ([a-zA-Z]+) \/? (\d+) $/x))
        {
            $flag = $1;
            @date = ($year,$2,$3);
            &_set_fixed_date_($self,$item,$name,$year,@date,$flag);
        }
        elsif (($item =~ /^ ([#:]?) ([1-5])          ([a-zA-Z]+)    (\d+)           $/x) ||
               ($item =~ /^ ([#:]?) ([1-5]) \/ ([1-7]|[a-zA-Z]+) \/ (\d+|[a-zA-Z]+) $/x))
        {
            $flag = $1;
            $n    = $2;
            $dow  = $3;
            $temp = $4;
            if ($dow =~ /^[a-zA-Z]+$/)
            {
                &_invalid_($item,$name) unless ($dow = Decode_Day_of_Week($dow));
            }
            if ($temp =~ /^[a-zA-Z]+$/)
            {
                &_invalid_($item,$name) unless ($temp = Decode_Month($temp));
            }
            else
            {
                &_invalid_($item,$name) unless (($temp > 0) && ($temp < 13));
            }
            unless (@date = Nth_Weekday_of_Month_Year($year,$temp,$dow,$n))
            {
                if ($n == 5)
                {
                    &_invalid_($item,$name)
                        unless (@date = Nth_Weekday_of_Month_Year($year,$temp,$dow,4));
                }
                else { &_invalid_($item,$name); }
            }
            &_set_date_($self,$name,@date,$flag);
        }
        else
        {
            croak("unrecognized date '$item' for day '$name'");
        }
    }
    ${$self}{'HALF'}->AndNot( ${$self}{'HALF'}, ${$self}{'FULL'} );
}

sub vec_full # full holidays
{
    my($self) = @_;

    return ${$self}{'FULL'};
}

sub vec_half # half holidays
{
    my($self) = @_;

    return ${$self}{'HALF'};
}

sub vec_work # work space
{
    my($self) = @_;

    return ${$self}{'WORK'};
}

sub labels
{
    my($self) = shift;
    my($index);
    my(%result);

    if (@_)
    {
        $index = $self->date2index(@_);
        if (defined $self->{'TAGS'}{$index})
        {
            if (defined wantarray and wantarray)
            {
                return
                (
                    Day_of_Week_to_Text(Day_of_Week(@_)),
                    keys(%{$self->{'TAGS'}{$index}})
                );
            }
            else
            {
                return 1 + scalar( keys(%{$self->{'TAGS'}{$index}}) );
            }
        }
        else
        {
            if (defined wantarray and wantarray)
            {
                return( Day_of_Week_to_Text(Day_of_Week(@_)) );
            }
            else
            {
                return 1;
            }
        }
    }
    else
    {
        local($_);
        %result = ();
        foreach $index (keys %{$self->{'TAGS'}})
        {
            grep( $result{$_} = 0, keys(%{$self->{'TAGS'}{$index}}) );
        }
        if (defined wantarray and wantarray)
        {
            return( keys %result );
        }
        else
        {
            return scalar( keys %result );
        }
    }
}

sub search
{
    my($self,$pattern) = @_;
    my($index,$label,$upper);
    my(@result);

    local($_);
    @result = ();
    $pattern = ISO_UC($pattern);
    foreach $index (keys %{$self->{'TAGS'}})
    {
        LABEL:
        foreach $label (keys %{$self->{'TAGS'}{$index}})
        {
            $upper = ISO_UC($label);
            if (index($upper,$pattern) >= $[)
            {
                push( @result, $index );
                last LABEL;
            }
        }
    }
    return( map( $self->index2date($_), sort {$a<=>$b} @result ) );
}

sub _delta_workdays_
{
    my($self,$lower_index,$upper_index,$include_lower,$include_upper) = @_;
    my($days);

    $days = ${$self}{'DAYS'};
    if (($lower_index < 0) || ($lower_index >= $days))
    {
        croak("invalid lower index ($lower_index)");
    }
    if (($upper_index < 0) || ($upper_index >= $days))
    {
        croak("invalid upper index ($upper_index)");
    }
    if ($lower_index > $upper_index)
    {
        croak("lower index ($lower_index) > upper index ($upper_index)");
    }
    $lower_index++ unless ($include_lower);
    $upper_index-- unless ($include_upper);
    if (($upper_index < 0) ||
        ($lower_index >= $days) ||
        ($lower_index > $upper_index))
    {
        &empty_period();
        return 0;
    }
    ${$self}{'WORK'}->Empty();
    ${$self}{'WORK'}->Interval_Fill($lower_index,$upper_index);
    ${$self}{'WORK'}->AndNot( ${$self}{'WORK'}, ${$self}{'FULL'} );
    $days = ${$self}{'WORK'}->Norm();
    ${$self}{'WORK'}->And( ${$self}{'WORK'}, ${$self}{'HALF'} );
    $days -= ${$self}{'WORK'}->Norm() * 0.5;
    return $days;
}

sub delta_workdays
{
    my($self) = shift;
    my($yy1,$mm1,$dd1,$yy2,$mm2,$dd2,$including1,$including2);
    my($index1,$index2);

    if (ref($_[0]) and ref($_[0]) !~ /^[A-Z]+$/) { ($yy1,$mm1,$dd1) = shift->date(); }
    else                                         { ($yy1,$mm1,$dd1) = (shift,shift,shift); }
    if (ref($_[0]) and ref($_[0]) !~ /^[A-Z]+$/) { ($yy2,$mm2,$dd2) = shift->date(); }
    else                                         { ($yy2,$mm2,$dd2) = (shift,shift,shift); }
    ($including1,$including2) = (shift,shift);

    $index1 = $self->date2index($yy1,$mm1,$dd1);
    $index2 = $self->date2index($yy2,$mm2,$dd2);
    if ($index1 > $index2)
    {
        return -$self->_delta_workdays_(
            $index2,$index1,$including2,$including1);
    }
    else
    {
        return $self->_delta_workdays_(
            $index1,$index2,$including1,$including2);
    }
}

sub add_delta_workdays
{
    my($self) = shift;
    my($yy,$mm,$dd,$days);
    my($index,$limit,$forward,$lower,$upper,$diff);

    if (ref($_[0]) and ref($_[0]) !~ /^[A-Z]+$/) { ($yy,$mm,$dd) = shift->date(); }
    else                                         { ($yy,$mm,$dd) = (shift,shift,shift); }
    $days = shift;

    $index = $self->date2index($yy,$mm,$dd);
    return(Date::Calc->new($yy,$mm,$dd),0) if ($days == 0);
    $limit = ${$self}{'DAYS'} - 1;
    if ($days > 0)
    {
        $forward = 1;
        $lower = $index;
        $upper = $limit;
    }
    else # ($days < 0)
    {
        $forward = 0;
        $days = -$days;
        $lower = 0;
        $upper = $index;
    }
    ${$self}{'WORK'}->Empty();
    ${$self}{'WORK'}->Interval_Fill($lower,$upper);
    ${$self}{'WORK'}->AndNot( ${$self}{'WORK'}, ${$self}{'FULL'} );
    $diff = ${$self}{'WORK'}->Norm();
    ${$self}{'WORK'}->And( ${$self}{'WORK'}, ${$self}{'HALF'} );
    $diff -= ${$self}{'WORK'}->Norm() * 0.5;
    if ($forward)
    {
        if ($days >= $diff)
        {
            $days -= $diff;
            return(Date::Calc->new(++$yy,1,1),$days);
        }
        # else ($days < $diff)
        $lower = $index;
        $upper = $index + int(($days * ($limit-$index+1) / $diff) + 0.5);
        $upper = $limit if ($upper > $limit);
    }
    else # backward
    {
        if ($days >= $diff)
        {
            $days -= $diff;
            return(Date::Calc->new(--$yy,12,31),-$days);
        }
        # else ($days < $diff)
        $upper = $index;
        $lower = $index - int(($days * ($index+1) / $diff) + 0.5);
        $lower = 0 if ($lower < 0);
    }
    ${$self}{'WORK'}->Empty();
    ${$self}{'WORK'}->Interval_Fill($lower,$upper);
    ${$self}{'WORK'}->AndNot( ${$self}{'WORK'}, ${$self}{'FULL'} );
    $diff = ${$self}{'WORK'}->Norm();
    ${$self}{'WORK'}->And( ${$self}{'WORK'}, ${$self}{'HALF'} );
    $diff -= ${$self}{'WORK'}->Norm() * 0.5;
    while ( abs( $days - $diff ) > 0.5 )
    {
        if ($forward)
        {
            if ($days > $diff) # continue in same direction
            {
                $upper++;
                $upper++ while (${$self}{'FULL'}->bit_test($upper));
                if (${$self}{'HALF'}->bit_test($upper)) { $diff += 0.5; }
                else                                    { $diff++; }
            }
            else # ($days < $diff) # reverse gear
            {
                $upper--;
                $upper-- while (${$self}{'FULL'}->bit_test($upper));
                if (${$self}{'HALF'}->bit_test($upper)) { $diff -= 0.5; }
                else                                    { $diff--; }
            }
        }
        else # backward
        {
            if ($days > $diff) # continue in same direction
            {
                $lower--;
                $lower-- while (${$self}{'FULL'}->bit_test($lower));
                if (${$self}{'HALF'}->bit_test($lower)) { $diff += 0.5; }
                else                                    { $diff++; }
            }
            else # ($days < $diff) # reverse gear
            {
                $lower++;
                $lower++ while (${$self}{'FULL'}->bit_test($lower));
                if (${$self}{'HALF'}->bit_test($lower)) { $diff -= 0.5; }
                else                                    { $diff--; }
            }
        }
    }
    $days -= $diff;
    if ($forward)
    {
        return($self->index2date($upper),$days);
    }
    else # backward
    {
        return($self->index2date($lower),-$days);
    }
}

1;

__END__

