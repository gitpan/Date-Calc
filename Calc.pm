
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
    Days_in_Year
    Days_in_Month
    Weeks_in_Year
    leap_year
    check_date
    Day_of_Year
    Date_to_Days
    Day_of_Week
    Week_Number
    Week_of_Year
    Monday_of_Week
    Nth_Weekday_of_Month_Year
    Delta_Days
    Delta_DHMS
    Add_Delta_Days
    Add_Delta_DHMS
    Add_Delta_YMD
    System_Clock
    Today
    Now
    Today_and_Now
    Easter_Sunday
    Decode_Month
    Decode_Day_of_Week
    Decode_Language
    Decode_Date_EU
    Decode_Date_US
    Compress
    Uncompress
    check_compressed
    Compressed_to_Text
    Date_to_Text
    Date_to_Text_Long
    Calendar
    Month_to_Text
    Day_of_Week_to_Text
    Day_of_Week_Abbreviation
    Language_to_Text
    Language
    Languages
    Decode_Date_EU2
    Decode_Date_US2
    Parse_Date
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

Date::Calc - Gregorian calendar date calculations

This package consists of a C library and a Perl module (which uses
the C library, internally) for all kinds of date calculations based
on the Gregorian calendar (the one used in all western countries today),
thereby complying with all relevant norms and standards: S<ISO/R 2015-1971>,
S<DIN 1355> and S<ISO 8601> (where applicable).

(See also http://www.engelschall.com/u/sb/download/Date-Calc/DIN1355/
for a scan of part of the "S<DIN 1355>" document (in German)).

The module of course handles year numbers of 2000 and above correctly
("Year 2000" or "Y2K" compliance) -- actually all year numbers from 1
to the largest positive integer representable on your system (which
is at least 32767) can be dealt with.

In other words, this package B<EXTRAPOLATES> the Gregorian calendar B<BACK>
until the year 1 -- even though the Gregorian calendar was only adopted
in 1582 by most (not all) European countries, in obedience to the
corresponding decree of catholic pope S<Gregor I> in that year.

Some (mainly protestant) countries actually continued to use the Julian
calendar used until then until as late as the beginning of the 20th century.

Note that this package is not intended to do everything you could ever
imagine automatically for you, it is rather intended to serve as a toolbox
(in the best of UNIX spirit and traditions) which should, however, always
get you where you want to go.

=head1 SYNOPSIS

  Days_in_Year
      $days = Days_in_Year($year,$mm);

  Days_in_Month
      $days = Days_in_Month($year,$mm);

  Weeks_in_Year
      $weeks = Weeks_in_Year($year);

  leap_year
      if (leap_year($year))

  check_date
      if (check_date($year,$mm,$dd))

  Day_of_Year
      $doy = Day_of_Year($year,$mm,$dd);

  Date_to_Days
      $days = Date_to_Days($year,$mm,$dd);

  Day_of_Week
      $dow = Day_of_Week($year,$mm,$dd);

  Week_Number
      $week = Week_Number($year,$mm,$dd);

  Week_of_Year
      ($week,$year) = Week_of_Year($year,$mm,$dd);

  Monday_of_Week
      ($year,$mm,$dd) = Monday_of_Week($week,$year);

  Nth_Weekday_of_Month_Year
      if (($year,$mm,$dd) = Nth_Weekday_of_Month_Year($year,$mm,$dow,$n))

  Delta_Days
      $Dd = Delta_Days($year1,$mm1,$dd1, $year2,$mm2,$dd2);

  Delta_DHMS
      ($Dd,$Dh,$Dm,$Ds) = Delta_DHMS($year1,$mm1,$dd1, $h1,$m1,$s1,
                                     $year2,$mm2,$dd2, $h2,$m2,$s2);

  Add_Delta_Days
      ($year,$mm,$dd) = Add_Delta_Days($year,$mm,$dd, $Dd);

  Add_Delta_DHMS
      ($year,$mm,$dd, $h,$m,$s) = Add_Delta_DHMS($year,$mm,$dd,
                                      $h,$m,$s, $Dd,$Dh,$Dm,$Ds);

  Add_Delta_YMD
      ($year,$mm,$dd) = Add_Delta_YMD($year,$mm,$dd, $Dy,$Dm,$Dd);

  System_Clock
      ($year,$mm,$dd, $h,$m,$s, $doy,$dow,$dst) = System_Clock();

  Today
      ($year,$mm,$dd) = Today();

  Now
      ($h,$m,$s) = Now();

  Today_and_Now
      ($year,$mm,$dd, $h,$m,$s) = Today_and_Now();

  Easter_Sunday
      ($year,$mm,$dd) = Easter_Sunday($year);

  Decode_Month
      $mm = Decode_Month($string);

  Decode_Day_of_Week
      $dow = Decode_Day_of_Week($string);

  Decode_Language
      $lang = Decode_Language($string);

  Decode_Date_EU
      ($year,$mm,$dd) = Decode_Date_EU($string);

  Decode_Date_US
      ($year,$mm,$dd) = Decode_Date_US($string);

  Compress
      $date = Compress($yy,$mm,$dd);

  Uncompress
      ($cc,$yy,$mm,$dd) = Uncompress($date);

  check_compressed
      if (check_compressed($date))

  Compressed_to_Text
      $string = Compressed_to_Text($date);

  Date_to_Text
      $string = Date_to_Text($year,$mm,$dd);

  Date_to_Text_Long
      $string = Date_to_Text_Long($year,$mm,$dd);

  Calendar
      $string = Calendar($year,$mm);

  Month_to_Text
      $string = Month_to_Text($mm);

  Day_of_Week_to_Text
      $string = Day_of_Week_to_Text($dow);

  Day_of_Week_Abbreviation
      $string = Day_of_Week_Abbreviation($dow);

  Language_to_Text
      $string = Language_to_Text($lang);

  Language
      $lang = Language();
      Language($lang);
      $oldlang = Language($newlang);

  Languages
      $max_lang = Languages();

  Decode_Date_EU2
      ($year,$mm,$dd) = Decode_Date_EU2($string);

  Decode_Date_US2
      ($year,$mm,$dd) = Decode_Date_US2($string);

  Parse_Date
      ($year,$mm,$dd) = Parse_Date($string);

  Version
      $string = Date::Calc::Version();

=head1 IMPORTANT NOTES

=over 2

=item *

"Year 2000" (Y2K) compliance

The upper limit for any year number in this module is only given
by the size of the largest positive integer that can be represented
in a variable of the C type "int" on your system, which is at least
32767, according to the ANSI C standard (exceptions see below).

In order to simplify calculations, this module B<EXTRAPOLATES>
the gregorian calendar B<BACK> until the year 1 A.D. -- i.e.,
back B<BEYOND> the year 1582 when this calendar was first decreed
by the catholic pope S<Gregor I>!

Therefore, B<BE SURE TO ALWAYS SPECIFY "1998" WHEN YOU MEAN "1998">,
for instance, and B<DO NOT WRITE "98" INSTEAD>, because this will
in fact perform a calculation based on the year "98" A.D. and
B<NOT> "1998"!

The only exceptions from this rule are the functions which contain
the word "compress" in their names (which only handle years between
1970 and 2069 and also accept the abbreviations "00" to "99"), and
the functions with the words "decode_date" in their names (which
add "1900" to the year if the year is less than 100).

=item *

First index

B<ALL> indices in this module start with "C<1>", B<NOT> "C<0>"!

I.e., the day of month, day of week, day of year, month of year,
week of year, first valid year number and language B<ALL> start
counting at one, B<NOT> zero!

The only exception is the function "C<Week_Number()>", which may
in fact return "C<0>" when the given date actually lies in the
last week of the B<PREVIOUS> year.

=item *

Function naming conventions

Function names completely in lower case indicate a boolean return value.

=item *

Boolean values

Boolean values in this module are always a numeric zero ("C<0>") for
"false" and a numeric one ("C<1>") for "true".

=back

=head1 DESCRIPTION

=over 2

=item *

C<$days = Days_in_Year($year,$mm);>

=item *

C<$days = Days_in_Month($year,$mm);>

=item *

C<$weeks = Weeks_in_Year($year);>

=item *

C<if (leap_year($year))>

=item *

C<if (check_date($year,$mm,$dd))>

=item *

C<$doy = Day_of_Year($year,$mm,$dd);>

=item *

C<$days = Date_to_Days($year,$mm,$dd);>

=item *

C<$dow = Day_of_Week($year,$mm,$dd);>

=item *

C<$week = Week_Number($year,$mm,$dd);>

=item *

C<($week,$year) = Week_of_Year($year,$mm,$dd);>

=item *

C<($year,$mm,$dd) = Monday_of_Week($week,$year);>

=item *

C<if (($year,$mm,$dd) = Nth_Weekday_of_Month_Year($year,$mm,$dow,$n))>

=item *

C<$Dd = Delta_Days($year1,$mm1,$dd1, $year2,$mm2,$dd2);>

=item *

C<($Dd,$Dh,$Dm,$Ds) = Delta_DHMS($year1,$mm1,$dd1, $h1,$m1,$s1, $year2,$mm2,$dd2, $h2,$m2,$s2);>

=item *

C<($year,$mm,$dd) = Add_Delta_Days($year,$mm,$dd, $Dd);>

=item *

C<($year,$mm,$dd, $h,$m,$s) = Add_Delta_DHMS($year,$mm,$dd, $h,$m,$s, $Dd,$Dh,$Dm,$Ds);>

=item *

C<($year,$mm,$dd) = Add_Delta_YMD($year,$mm,$dd, $Dy,$Dm,$Dd);>

=item *

C<($year,$mm,$dd, $h,$m,$s, $doy,$dow,$dst) = System_Clock();>

=item *

C<($year,$mm,$dd) = Today();>

=item *

C<($h,$m,$s) = Now();>

=item *

C<($year,$mm,$dd, $h,$m,$s) = Today_and_Now();>

=item *

C<($year,$mm,$dd) = Easter_Sunday($year);>

=item *

C<$mm = Decode_Month($string);>

=item *

C<$dow = Decode_Day_of_Week($string);>

=item *

C<$lang = Decode_Language($string);>

=item *

C<($year,$mm,$dd) = Decode_Date_EU($string);>

=item *

C<($year,$mm,$dd) = Decode_Date_US($string);>

=item *

C<$date = Compress($yy,$mm,$dd);>

=item *

C<($cc,$yy,$mm,$dd) = Uncompress($date);>

=item *

C<if (check_compressed($date))>

=item *

C<$string = Compressed_to_Text($date);>

=item *

C<$string = Date_to_Text($year,$mm,$dd);>

=item *

C<$string = Date_to_Text_Long($year,$mm,$dd);>

=item *

C<$string = Calendar($year,$mm);>

=item *

C<$string = Month_to_Text($mm);>

=item *

C<$string = Day_of_Week_to_Text($dow);>

=item *

C<$string = Day_of_Week_Abbreviation($dow);>

=item *

C<$string = Language_to_Text($lang);>

=item *

C<$lang = Language();>

C<Language($lang);>

C<$oldlang = Language($newlang);>

=item *

C<$max_lang = Languages();>

=item *

C<($year,$mm,$dd) = Decode_Date_EU2($string);>

=item *

C<($year,$mm,$dd) = Decode_Date_US2($string);>

=item *

C<($year,$mm,$dd) = Parse_Date($string);>

=item *

C<$string = Date::Calc::Version();>

=back

=head1 EXAMPLES

=over 3

=item 1)

How do I compare two dates?

  use Date::Calc qw( Date_to_Days );

  if (Date_to_Days($year1,$mm1,$dd1)  <
      Date_to_Days($year2,$mm2,$dd2))

  if (Date_to_Days($year1,$mm1,$dd1)  <=
      Date_to_Days($year2,$mm2,$dd2))

  if (Date_to_Days($year1,$mm1,$dd1)  >
      Date_to_Days($year2,$mm2,$dd2))

  if (Date_to_Days($year1,$mm1,$dd1)  >=
      Date_to_Days($year2,$mm2,$dd2))

  $cmp = (Date_to_Days($year1,$mm1,$dd1)  <=>
          Date_to_Days($year2,$mm2,$dd2));

=item 2)

How do I check wether a given date lies within a certain range of dates?

  use Date::Calc qw( Date_to_Days );

  $lower = Date_to_Days($year1,$mm1,$dd1);
  $upper = Date_to_Days($year2,$mm2,$dd2);

  $date = Date_to_Days($year,$mm,$dd);

  if (($date >= $lower) && ($date <= $upper))
  {
      # ok
  }
  else
  {
      # not ok
  }

=item 3)

How do I verify wether someone has a certain age?

  use Date::Calc qw( Decode_Date_EU Today leap_year Delta_Days );

  $date = <STDIN>; # get birthday

  ($yy1,$mm1,$dd1) = Decode_Date_EU($date);

  ($yy2,$mm2,$dd2) = Today();

  if (($mm1 == 2) && ($dd1 == 29) && !leap_year($yy2))
      { $dd1--; }

  if ( (($yy2 - $yy1) >  18) ||
     ( (($yy2 - $yy1) == 18) &&
      (Delta_Days($yy2,$mm1,$dd1, $yy2,$mm2,$dd2) >= 0) ) )
  {
      print "Ok - you are over 18.\n";
  }
  else
  {
      print "Sorry - you aren't 18 yet!\n";
  }

=item 4)

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

  ($year,$mm,$dd) = Today();

  $week = int(($dd + Day_of_Week($year,$mm,1) - 2) / 7) + 1;

=item 5)

How do I calculate wether a given date is the 1st, 2nd, 3rd, 4th or 5th
of that day of week in the given month?

For example:

           October 2000
    Mon Tue Wed Thu Fri Sat Sun
                              1
      2   3   4   5   6   7   8
      9  10  11  12  13  14  15
     16  17  18  19  20  21  22
     23  24  25  26  27  28  29
     30  31

Is Sunday, the 15th of October 2000, the 1st, 2nd, 3rd, 4th or 5th
Sunday of that month?

Solution:

  use Date::Calc qw( Day_of_Week Delta_Days Nth_Weekday_of_Month_Year
                     Date_to_Text_Long Day_of_Week_to_Text Month_to_Text );

  %ordinal = ( 1 => 'st', 2 => 'nd', 3 => 'rd' );

  ($year,$mm,$dd) = (2000,10,15);

  $dow = Day_of_Week($year,$mm,$dd);

  $n = int( Delta_Days(
            Nth_Weekday_of_Month_Year($year,$mm,$dow,1),
            $year,$mm,$dd)
            / 7) + 1;

  printf("%s is the %s %s in %s %d.\n",
      Date_to_Text_Long($year,$mm,$dd),
      $n . ($ordinal{$n} || 'th'),
      Day_of_Week_to_Text($dow),
      Month_to_Text($mm),
      $year);

This prints:

  Sunday, 15 October 2000 is the 3rd Sunday in October 2000.

=item 6)

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

=item 7)

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

=item 8)

How do I convert a MS Visual Basic "DATETIME" value into its date
and time constituents?

  use Date::Calc qw( Add_Delta_DHMS Date_to_Text );

  $datetime = "35883.121653";

  ($Dd,$Dh,$Dm,$Ds) = ($datetime =~ /^(\d+)\.(\d\d)(\d\d)(\d\d)$/);

  ($year,$mm,$dd, $h,$m,$s) =
      Add_Delta_DHMS(1900,1,1, 0,0,0, $Dd,$Dh,$Dm,$Ds);

  printf("The given date is %s %02d:%02d:%02d\n",
      Date_to_Text($year,$mm,$dd), $h, $m, $s);

This prints:

  The given date is Tue 31-Mar-1998 12:16:53

=item 9)

How can I print a date in a different format than provided by
the functions "C<Date_to_Text()>", "C<Date_to_Text_Long()>" or
"C<Compressed_to_Text()>"?

  use Date::Calc qw( Day_of_Week Day_of_Week_to_Text
                     Month_to_Text Today );

  ($year,$mm,$dd) = Today();

For example with leading zeros for the day: "S<Fri 03-Jan-1964>"

  printf("%.3s %02d-%.3s-%d\n",
      Day_of_Week_to_Text(Day_of_Week($year,$mm,$dd)),
      $dd,
      Month_to_Text($mm),
      $year);

For example in U.S. american format: "S<April 12th, 1998>"

  %ordinal = ( 1 => 'st', 2 => 'nd', 3 => 'rd' );

  sub ordinal
  {
      return( $_[0] .
          ( (substr($_[0],-2,1) ne '1') &&
            $ordinal{substr($_[0],-1)} ||
            'th' ) );
  }

  $string = sprintf("%s %s, %d",
                Month_to_Text($mm),
                ordinal($dd),
                $year);

(See also L<perlfunc/printf> and/or L<perlfunc/sprintf>!)

=back

=head1 SEE ALSO

perl(1), perlfunc(1), perlsub(1), perlmod(1),
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
be redistributed and/or modified under the terms of the
"GNU Library General Public License".

Please refer to the files "Artistic.txt", "GNU_GPL.txt" and
"GNU_LGPL.txt" in this distribution for details!

=head1 DISCLAIMER

This package is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

