
###############################################################################
##                                                                           ##
##    Copyright (c) 1995, 1996, 1997, 1998 by Steffen Beyer.                 ##
##    All rights reserved.                                                   ##
##                                                                           ##
##    This package is free software; you can redistribute it                 ##
##    and/or modify it under the same terms as Perl itself.                  ##
##                                                                           ##
###############################################################################

package Date::Calc;

require Exporter;
require DynaLoader;

@ISA = qw(Exporter DynaLoader);

@EXPORT = qw();

@EXPORT_OK = qw(
Days_in_Year Days_in_Month Weeks_in_Year
leap_year check_date Day_of_Year Date_to_Days Day_of_Week
Week_Number Week_of_Year Monday_of_Week Nth_Weekday_of_Month_Year
Delta_Days Delta_DHMS Add_Delta_Days Add_Delta_DHMS Add_Delta_YMD
System_Clock Today Now Today_and_Now Easter_Sunday
Decode_Month Decode_Day_of_Week Decode_Language
Decode_Date_EU Decode_Date_US
Compress Uncompress check_compressed Compressed_to_Text
Date_to_Text Date_to_Text_Long Calendar
Month_to_Text Day_of_Week_to_Text Day_of_Week_Abbreviation
Language_to_Text Language Languages
Decode_Date_EU2 Decode_Date_US2 Parse_Date
);

%EXPORT_TAGS = (all => [@EXPORT_OK]);

##################################################
##                                              ##
##  "Version()" is available but not exported   ##
##  in order to avoid possible name clashes.    ##
##  Call with "Date::Calc::Version()" instead!  ##
##                                              ##
##################################################

$VERSION = '4.0';

bootstrap Date::Calc $VERSION;

use Carp;

sub Decode_Date_EU2
{
    croak "Usage: (\$year,\$mm,\$dd) = Decode_Date_EU2(\$date);"
      if (@_ != 1);

    my($buffer) = @_;
    my($yy,$mm,$dd,$len);

    if ($buffer =~ /^\D*  (\d+)  [^A-Za-z0-9]*  ([A-Za-z]+)  [^A-Za-z0-9]*  (\d+)  \D*$/x)
    {
        ($dd,$mm,$yy) = ($1,$2,$3);
        $mm = Decode_Month($mm);
        unless ($mm > 0)
        {
            return(); # can't decode month!
        }
    }
    elsif ($buffer =~ /^\D*  0*(\d+)  \D*$/x)
    {
        $buffer = $1;
        $len = length($buffer);
        if    ($len == 3)
        {
            $dd = substr($buffer,0,1);
            $mm = substr($buffer,1,1);
            $yy = substr($buffer,2,1);
        }
        elsif ($len == 4)
        {
            $dd = substr($buffer,0,1);
            $mm = substr($buffer,1,1);
            $yy = substr($buffer,2,2);
        }
        elsif ($len == 5)
        {
            $dd = substr($buffer,0,1);
            $mm = substr($buffer,1,2);
            $yy = substr($buffer,3,2);
        }
        elsif ($len == 6)
        {
            $dd = substr($buffer,0,2);
            $mm = substr($buffer,2,2);
            $yy = substr($buffer,4,2);
        }
        elsif ($len == 7)
        {
            $dd = substr($buffer,0,1);
            $mm = substr($buffer,1,2);
            $yy = substr($buffer,3,4);
        }
        elsif ($len == 8)
        {
            $dd = substr($buffer,0,2);
            $mm = substr($buffer,2,2);
            $yy = substr($buffer,4,4);
        }
        else { return(); } # wrong number of digits!
    }
    elsif ($buffer =~ /^\D*  (\d+)  \D+  (\d+)  \D+  (\d+)  \D*$/x)
    {
        ($dd,$mm,$yy) = ($1,$2,$3);
    }
    else { return(); } # no match at all!

    if ($yy < 100) { $yy += 1900; }

    if (check_date($yy,$mm,$dd))
    {
        return($yy,$mm,$dd);
    }
    else { return(); } # not a valid date!
}

sub Decode_Date_US2
{
    croak "Usage: (\$year,\$mm,\$dd) = Decode_Date_US2(\$date);"
      if (@_ != 1);

    my($buffer) = @_;
    my($yy,$mm,$dd,$len);

    if ($buffer =~ /^[^A-Za-z0-9]*  ([A-Za-z]+)  [^A-Za-z0-9]*  0*(\d+)  \D*$/x)
    {
        ($mm,$buffer) = ($1,$2);
        $mm = Decode_Month($mm);
        unless ($mm > 0)
        {
            return(); # can't decode month!
        }
        $len = length($buffer);
        if    ($len == 2)
        {
            $dd = substr($buffer,0,1);
            $yy = substr($buffer,1,1);
        }
        elsif ($len == 3)
        {
            $dd = substr($buffer,0,1);
            $yy = substr($buffer,1,2);
        }
        elsif ($len == 4)
        {
            $dd = substr($buffer,0,2);
            $yy = substr($buffer,2,2);
        }
        elsif ($len == 5)
        {
            $dd = substr($buffer,0,1);
            $yy = substr($buffer,1,4);
        }
        elsif ($len == 6)
        {
            $dd = substr($buffer,0,2);
            $yy = substr($buffer,2,4);
        }
        else { return(); } # wrong number of digits!
    }
    elsif ($buffer =~ /^[^A-Za-z0-9]*  ([A-Za-z]+)  [^A-Za-z0-9]*  (\d+)  \D+  (\d+)  \D*$/x)
    {
        ($mm,$dd,$yy) = ($1,$2,$3);
        $mm = Decode_Month($mm);
        unless ($mm > 0)
        {
            return(); # can't decode month!
        }
    }
    elsif ($buffer =~ /^\D*  0*(\d+)  \D*$/x)
    {
        $buffer = $1;
        $len = length($buffer);
        if    ($len == 3)
        {
            $mm = substr($buffer,0,1);
            $dd = substr($buffer,1,1);
            $yy = substr($buffer,2,1);
        }
        elsif ($len == 4)
        {
            $mm = substr($buffer,0,1);
            $dd = substr($buffer,1,1);
            $yy = substr($buffer,2,2);
        }
        elsif ($len == 5)
        {
            $mm = substr($buffer,0,1);
            $dd = substr($buffer,1,2);
            $yy = substr($buffer,3,2);
        }
        elsif ($len == 6)
        {
            $mm = substr($buffer,0,2);
            $dd = substr($buffer,2,2);
            $yy = substr($buffer,4,2);
        }
        elsif ($len == 7)
        {
            $mm = substr($buffer,0,1);
            $dd = substr($buffer,1,2);
            $yy = substr($buffer,3,4);
        }
        elsif ($len == 8)
        {
            $mm = substr($buffer,0,2);
            $dd = substr($buffer,2,2);
            $yy = substr($buffer,4,4);
        }
        else { return(); } # wrong number of digits!
    }
    elsif ($buffer =~ /^\D*  (\d+)  \D+  (\d+)  \D+  (\d+)  \D*$/x)
    {
        ($mm,$dd,$yy) = ($1,$2,$3);
    }
    else { return(); } # no match at all!

    if ($yy < 100) { $yy += 1900; }

    if (check_date($yy,$mm,$dd))
    {
        return($yy,$mm,$dd);
    }
    else { return(); } # not a valid date!
}

sub Parse_Date
{
    croak "Usage: (\$year,\$mm,\$dd) = Parse_Date(\$date);"
      if (@_ != 1);

    my($date) = @_;
    my($yy,$mm,$dd);
    unless ($date =~ /\b([JFMASOND][aepuco][nbrynlgptvc])\s+([0123]??\d)\b/)
    {
        return();
    }
    $mm = $1;
    $dd = $2;
    unless ($date =~ /\b(19\d\d|20\d\d)\b/)
    {
        return();
    }
    $yy = $1;
    $mm = Decode_Month($mm);
    unless ($mm > 0)
    {
        return();
    }
    unless (check_date($yy,$mm,$dd))
    {
        return();
    }
    return($yy,$mm,$dd);
}

1;

__END__

=head1 NAME

Date::Calc - Gregorian Calendar Date Calculations

in compliance with ISO/R 2015-1971 and DIN 1355 standards

=head1 SYNOPSIS


=head1 DESCRIPTION


=head1 EXAMPLES

=over 3

=item 1)

How do I verify wether someone has a certain age?

  use Date::Calc qw( Decode_Date_EU Today leap_year Delta_Days );

  $date = <STDIN>; # birthday

  ($yy1,$mm1,$dd1) = Decode_Date_EU($date);

  ($yy2,$mm2,$dd2) = Today();

  if (($mm1 == 2) && ($dd1 == 29) && !leap_year($yy2))
      { $dd1--; }

  if ( (($yy2 - $yy1) >  18) ||
     ( (($yy2 - $yy1) == 18) &&
      (Delta_Days($yy2,$mm1,$dd1,$yy2,$mm2,$dd2) >= 0) ) )
  {
      print "Ok - you are over 18.\n";
  }
  else
  {
      print "Sorry - you aren't 18 yet!\n";
  }

=item 2)

How do I calculate the number of the week of month
the current date lies in?

For example:

            April 1998
    Mon Tue Wed Thu Fri Sat Sun
              1   2   3   4   5  =  week #1
      6   7   8   9  10  11  12  =  week #2
     13  14  15  16  17  18  19  =  week #3
     20  21  22  23  24  25  26  =  week #4
     27  28  29  30              =  week #5

Solution:

  use Date::Calc qw( Today Day_of_Week );

  ($year,$month,$day) = Today();

  $week = int(($day + Day_of_Week($year,$month,1) - 2) / 7) + 1;

=item 3)

How do I calculate the date of the Wednesday of the same week as
the current date?

Solution #1:

  use Date::Calc qw( Today Day_of_Week Add_Delta_Days );

  $searching_dow = 3; # 3 = Wednesday

  @today = Today();

  $current_dow = Day_of_Week(@today);

  @date = Add_Delta_Days(@today, $searching_dow - $current_dow);

Solution #2:

  use Date::Calc qw( Today Monday_of_Week
                     Week_of_Year Add_Delta_Days );

  $searching_dow = 3; # 3 = Wednesday

  @today = Today();

  @date = Add_Delta_Days( Monday_of_Week( Week_of_Year(@today) ),
                          $searching_dow - 1 );

=item 4)

How do I calculate the last and the next Saturday for any
given date?

  use Date::Calc qw( Today Day_of_Week Add_Delta_Days
                     Day_of_Week_to_Text Date_to_Text );

  $searching_dow = 6; # 6 = Saturday

  @today = Today();

  $current_dow = Day_of_Week(@today);

  if ($searching_dow == $current_dow)
  {
      @prev = Add_Delta_Days(@today,-7);
      @next = Add_Delta_Days(@today,+7);
  }
  else
  {
      if ($searching_dow > $current_dow)
      {
          @next = Add_Delta_Days(@today,
                    $searching_dow - $current_dow);
          @prev = Add_Delta_Days(@next,-7);
      }
      else
      {
          @prev = Add_Delta_Days(@today,
                    $searching_dow - $current_dow);
          @next = Add_Delta_Days(@prev,+7);
      }
  }

  $dow = Day_of_Week_to_Text($searching_dow);

  print "Today is:      ", ' ' x length($dow),
                               Date_to_Text(@today), "\n";
  print "Last $dow was:     ", Date_to_Text(@prev),  "\n";
  print "Next $dow will be: ", Date_to_Text(@next),  "\n";

This will print something like:

  Today is:              Sun 12-Apr-1998
  Last Saturday was:     Sat 11-Apr-1998
  Next Saturday will be: Sat 18-Apr-1998

=item 5)

How do I convert a MS Visual Basic "DATETIME" value into its date
and time constituents?

  use Date::Calc qw( Add_Delta_DHMS Date_to_Text );

  $datetime = "35883.121653";

  ($days,$hours,$minutes,$seconds) =
      ($datetime =~ /^(\d+)\.(\d\d)(\d\d)(\d\d)$/);

  ($year,$month,$day,$h,$m,$s) =
      Add_Delta_DHMS(1900,1,1,0,0,0,$days,$hours,$minutes,$seconds);

  printf("The given date is %s %02d:%02d:%02d\n",
      Date_to_Text($year,$month,$day), $h, $m, $s);

This prints:

  The given date is Tue 31-Mar-1998 12:16:53

=back

=head1 SEE ALSO

perl(1), perlsub(1), perlmod(1),
perlxs(1), perlxstut(1), perlguts(1).

=head1 VERSION

This man page documents "Date::Calc" version 4.0.

=head1 AUTHOR

  Steffen Beyer
  Ainmillerstr. 5 / App. 513
  D-80801 Munich
  Germany

  mailto:sb@engelschall.com
  http://www.engelschall.com/u/sb/download/

=head1 COPYRIGHT

Copyright (c) 1995, 1996, 1997, 1998 by Steffen Beyer.
All rights reserved.

=head1 LICENSE

This package is free software; you can redistribute it and/or
modify it under the same terms as Perl itself, i.e., under the
terms of the "Artistic License" or the "GNU General Public License".

The C library at the core of this Perl module can additionally
be redistributed and/or modified under the terms of the "GNU
Library General Public License".

Please refer to the files "Artistic", "GNU_GPL" and "GNU_LGPL"
in this distribution for details!

=head1 DISCLAIMER

This package is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

