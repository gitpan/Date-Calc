#!perl -w

###############################################################################
##                                                                           ##
##    Copyright (c) 1998 by Steffen Beyer.                                   ##
##    All rights reserved.                                                   ##
##                                                                           ##
##    This program is free software; you can redistribute it                 ##
##    and/or modify it under the same terms as Perl itself.                  ##
##                                                                           ##
###############################################################################

use strict;
no strict "vars";

$self = $0;
$self =~ s!^.*/!!;

unless (@ARGV)
{
    print "\nUsage: perl $self <filename> [<filename>]*\n\n";
    print "This utility tries to upgrade your Perl application(s) \"<filename>\"\n";
    print "from \"Date::DateCalc\" version 3.x to \"Date::Calc\" version 4.0.\n\n";
    exit(0);
}

FILE:
foreach $file (@ARGV)
{
    unless (-f $file)
    {
        warn "$self: unable to find \"$file\"!\n";
        next FILE;
    }
    unless (rename($file,"$file.bak"))
    {
        warn "$self: unable to rename \"$file\" to \"$file.bak\": $!\n";
        next FILE;
    }
    unless (open(INPUT, "<$file.bak"))
    {
        warn "$self: unable to read \"$file.bak\": $!\n";
        next FILE;
    }
    unless (open(OUTPUT, ">$file"))
    {
        warn "$self: unable to write \"$file\": $!\n";
        close(INPUT);
        next FILE;
    }
    print "$self: upgrading \"$file\"...\n";
    while (<INPUT>)
    {
        s!\bDate::DateCalcLib\b!Date::Calc!g;
        s!\bDate::DateCalc\b!Date::Calc!g;
        s!\buse\s+Date::Calc\s+3\.\d\b!use Date::Calc 4.0!g;
        s!\bleap\b!leap_year!g;
        s!\bcompress\b!Compress!g;
        s!\buncompress\b!Uncompress!g;
        s!\bcompressed_to_short\b!Compressed_to_Text!g;
        s!\bcalc_days\b!Date_to_Days!g;
        s!\bday_of_week\b!Day_of_Week!g;
        s!\bdates_difference\b!Delta_Days!g;
        s!\bcalc_new_date\b!Add_Delta_Days!g;
        s!\bdate_time_difference\b!Delta_DHMS!g;
        s!\bcalc_new_date_time\b!Add_Delta_DHMS!g;
        s!\bdate_to_short\b!Date_to_Text!g;
        s!\bdate_to_string\b!Date_to_Text_Long!g;
        s!\bweek_number\b!Week_of_Year!g;
        s!\bfirst_in_week\b!Monday_of_Week!g;
        s!\bweeks_in_year\b!Weeks_in_Year!g;
        s!\bday_name_tab\b!Day_of_Week_to_Text!g;
        s!\bmonth_name_tab\b!Month_to_Text!g;
        s!\bdecode_day\b!Decode_Day_of_Week!g;
        s!\bdecode_month\b!Decode_Month!g;
        s!\bdays_in_month\b!Days_in_Month!g;
        s!\bnth_wday_of_month_year\s*\(\s*([^,]+?)\s*,(\s*)([^,]+?)\s*,(\s*)([^,]+?)\s*,(\s*)([^)]+?)\s*\)!Nth_Weekday_of_Month_Year($7,$2$5,$4$3,$6$1)!g;
        s!\bnth_wday_of_month_year\b!Nth_Weekday_of_Month_Year!g;
        s!\bdecode_date\b!Decode_Date_EU!g;
        s!\bdecode_date_us\b!Decode_Date_US2!g;
        s!\bdecode_date_eu\b!Decode_Date_EU2!g;
        s!\byear_month_day_offset\b!Add_Delta_YMD!g;
        s!\bparse_date\b!Parse_Date!g;
        s!\beaster_sunday\b!Easter_Sunday!g;
        s!\bcalendar\b!Calendar!g;
        print OUTPUT;
    }
    close(INPUT);
    close(OUTPUT);
}

__END__

