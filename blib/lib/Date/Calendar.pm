
###############################################################################
##                                                                           ##
##    Copyright (c) 2000 by Steffen Beyer.                                   ##
##    All rights reserved.                                                   ##
##                                                                           ##
##    This package is free software; you can redistribute it                 ##
##    and/or modify it under the same terms as Perl itself.                  ##
##                                                                           ##
###############################################################################

package Date::Calendar;

use strict;
use vars qw( @ISA @EXPORT @EXPORT_OK $VERSION );

require Exporter;

@ISA = qw(Exporter);

@EXPORT = qw();

@EXPORT_OK = qw();

$VERSION = '5.0';

#use Bit::Vector;
#use Date::Calc::Object qw(:all);
use Carp::Clan qw(^Date::);
use Date::Calendar::Year qw( check_year empty_period );

sub new
{
    my($class,$profile) = @_;
    my($self);

    $self = [ ];
    $class = ref($class) || $class || __PACKAGE__;
    bless($self, $class);
    $self->[0] = $profile;
    $self->[1] = { };
    return $self;
}

sub year
{
    my($self) = shift;
    my($year);

    if (ref($_[0]) and ref($_[0]) !~ /^[A-Z]+$/) { $year = $_[0]->year(); }
    else                                         { $year = $_[0]; }

    &check_year($year);
    unless (defined $self->[1]{$year})
    {
        $self->[1]{$year} =
            Date::Calendar::Year->new( $year, $self->[0] );
    }
    return $self->[1]{$year};
}

sub date2index
{
    my($self) = shift;

    @_ = $_[0]->date() if (ref($_[0]) and ref($_[0]) !~ /^[A-Z]+$/);

    return $self->year($_[0])->date2index(@_);
}

sub labels
{
    my($self) = shift;
    my($year);
    my(%result);

    if (@_)
    {
        @_ = $_[0]->date() if (ref($_[0]) and ref($_[0]) !~ /^[A-Z]+$/);
        return $self->year($_[0])->labels(@_);
    }
    else
    {
        local($_);
        %result = ();
        foreach $year (keys(%{$self->[1]}))
        {
            grep( $result{$_} = 0, $self->year($year)->labels() );
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
    my($year);
    my(@result);

    @result = ();
    foreach $year (sort {$a<=>$b} keys(%{$self->[1]}))
    {
        push( @result, $self->year($year)->search($pattern) );
    }
    if (defined wantarray and wantarray)
    {
        return(@result);
    }
    else
    {
        return scalar(@result);
    }
}

sub delta_workdays
{
    my($self) = shift;
    my($yy1,$mm1,$dd1,$yy2,$mm2,$dd2,$including1,$including2);
    my($days,$empty,$year);

    if (ref($_[0]) and ref($_[0]) !~ /^[A-Z]+$/) { ($yy1,$mm1,$dd1) = shift->date(); }
    else                                         { ($yy1,$mm1,$dd1) = (shift,shift,shift); }
    if (ref($_[0]) and ref($_[0]) !~ /^[A-Z]+$/) { ($yy2,$mm2,$dd2) = shift->date(); }
    else                                         { ($yy2,$mm2,$dd2) = (shift,shift,shift); }
    ($including1,$including2) = (shift,shift);

    $days = 0;
    $empty = 1;
    if ($yy1 == $yy2)
    {
        return $self->year($yy1)->delta_workdays(
            $yy1,$mm1,$dd1, $yy2,$mm2,$dd2, $including1,$including2);
    }
    elsif ($yy1 < $yy2)
    {
        unless (($mm1 == 12) && ($dd1 == 31) && (!$including1))
        {
            $days += $self->year($yy1)->delta_workdays(
                $yy1,$mm1,$dd1, $yy1,12,31, $including1,1);
            $empty = 0;
        }
        unless (($mm2 ==  1) && ($dd2 ==  1) && (!$including2))
        {
            $days += $self->year($yy2)->delta_workdays(
                $yy2, 1, 1, $yy2,$mm2,$dd2, 1,$including2);
            $empty = 0;
        }
        for ( $year = $yy1 + 1; $year < $yy2; $year++ )
        {
            $days += $self->year($year)->delta_workdays(
                $year,1,1, $year,12,31, 1,1);
            $empty = 0;
        }
    }
    else
    {
        unless (($mm2 == 12) && ($dd2 == 31) && (!$including2))
        {
            $days -= $self->year($yy2)->delta_workdays(
                $yy2,$mm2,$dd2, $yy2,12,31, $including2,1);
            $empty = 0;
        }
        unless (($mm1 ==  1) && ($dd1 ==  1) && (!$including1))
        {
            $days -= $self->year($yy1)->delta_workdays(
                $yy1, 1, 1, $yy1,$mm1,$dd1, 1,$including1);
            $empty = 0;
        }
        for ( $year = $yy2 + 1; $year < $yy1; $year++ )
        {
            $days -= $self->year($year)->delta_workdays(
                $year,1,1, $year,12,31, 1,1);
            $empty = 0;
        }
    }
    &empty_period() if ($empty);
    return $days;
}

sub add_delta_workdays
{
    my($self) = shift;
    my($yy,$mm,$dd,$days);
    my($date);

    if (ref($_[0]) and ref($_[0]) !~ /^[A-Z]+$/) { ($yy,$mm,$dd) = shift->date(); }
    else                                         { ($yy,$mm,$dd) = (shift,shift,shift); }
    $days = shift;

    ($date,$days) = $self->year($yy)->add_delta_workdays($yy,$mm,$dd,$days);
    while (abs($days) > 0.5)
    {
        ($date,$days) = $self->year($date)->add_delta_workdays($date,$days);
    }
    return($date,$days);
}

sub is_full
{
    my($self) = shift;
    my($year);

    @_ = $_[0]->date() if (ref($_[0]) and ref($_[0]) !~ /^[A-Z]+$/);

    $year = $self->year($_[0]);
    return $year->vec_full->bit_test( $year->date2index(@_) );
}

sub is_half
{
    my($self) = shift;
    my($year);

    @_ = $_[0]->date() if (ref($_[0]) and ref($_[0]) !~ /^[A-Z]+$/);

    $year = $self->year($_[0]);
    return $year->vec_half->bit_test( $year->date2index(@_) );
}

1;

__END__

