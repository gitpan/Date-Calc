

/*****************************************************************************/
/*                                                                           */
/*    Copyright (c) 1995 - 2000 by Steffen Beyer.                            */
/*    All rights reserved.                                                   */
/*                                                                           */
/*    This package is free software; you can redistribute it                 */
/*    and/or modify it under the same terms as Perl itself.                  */
/*                                                                           */
/*****************************************************************************/


#include <ConditionalMacros.h>
#if PRAGMA_IMPORT
#pragma import on
#endif
    
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#if PRAGMA_IMPORT
#pragma import off
#endif


#include "DateCalc.h"


#define DATECALC_ERROR(name,error) \
    croak("Date::Calc::" name "(): " error)

#define DATECALC_DATE_ERROR(name) \
    DATECALC_ERROR(name,"not a valid date")

#define DATECALC_TIME_ERROR(name) \
    DATECALC_ERROR(name,"not a valid time")

#define DATECALC_YEAR_ERROR(name) \
    DATECALC_ERROR(name,"year out of range")

#define DATECALC_MONTH_ERROR(name) \
    DATECALC_ERROR(name,"month out of range")

#define DATECALC_WEEK_ERROR(name) \
    DATECALC_ERROR(name,"week out of range")

#define DATECALC_DAYOFWEEK_ERROR(name) \
    DATECALC_ERROR(name,"day of week out of range")

#define DATECALC_FACTOR_ERROR(name) \
    DATECALC_ERROR(name,"factor out of range")

#define DATECALC_LANGUAGE_ERROR(name) \
    DATECALC_ERROR(name,"language not available")

#define DATECALC_SYSTEM_ERROR(name) \
    DATECALC_ERROR(name,"not available on this system")

#define DATECALC_MEMORY_ERROR(name) \
    DATECALC_ERROR(name,"unable to allocate memory")


MODULE = Date::Calc		PACKAGE = Date::Calc		PREFIX = DateCalc_


PROTOTYPES: DISABLE


void
DateCalc_Days_in_Year(year,month)
    Z_int	year
    Z_int	month
PPCODE:
{
    if (year > 0)
    {
        if ((month >= 1) and (month <= 12))
        {
            EXTEND(sp,1);
            PUSHs(sv_2mortal(newSViv((IV)DateCalc_Days_in_Year_[DateCalc_leap_year(year)][month+1])));
        }
        else DATECALC_MONTH_ERROR("Days_in_Year");
    }
    else DATECALC_YEAR_ERROR("Days_in_Year");
}


void
DateCalc_Days_in_Month(year,month)
    Z_int	year
    Z_int	month
PPCODE:
{
    if (year > 0)
    {
        if ((month >= 1) and (month <= 12))
        {
            EXTEND(sp,1);
            PUSHs(sv_2mortal(newSViv((IV)DateCalc_Days_in_Month_[DateCalc_leap_year(year)][month])));
        }
        else DATECALC_MONTH_ERROR("Days_in_Month");
    }
    else DATECALC_YEAR_ERROR("Days_in_Month");
}


Z_int
DateCalc_Weeks_in_Year(year)
    Z_int	year
CODE:
{
    if (year > 0)
    {
        RETVAL = DateCalc_Weeks_in_Year(year);
    }
    else DATECALC_YEAR_ERROR("Weeks_in_Year");
}
OUTPUT:
RETVAL


boolean
DateCalc_leap_year(year)
    Z_int	year
CODE:
{
    if (year > 0)
    {
        RETVAL = DateCalc_leap_year(year);
    }
    else DATECALC_YEAR_ERROR("leap_year");
}
OUTPUT:
RETVAL


boolean
DateCalc_check_date(year,month,day)
    Z_int	year
    Z_int	month
    Z_int	day


boolean
DateCalc_check_business_date(year,week,dow)
    Z_int	year
    Z_int	week
    Z_int	dow


Z_int
DateCalc_Day_of_Year(year,month,day)
    Z_int	year
    Z_int	month
    Z_int	day
CODE:
{
    RETVAL = DateCalc_Day_of_Year(year,month,day);
    if (RETVAL == 0) DATECALC_DATE_ERROR("Day_of_Year");
}
OUTPUT:
RETVAL


Z_long
DateCalc_Date_to_Days(year,month,day)
    Z_int	year
    Z_int	month
    Z_int	day
CODE:
{
    RETVAL = DateCalc_Date_to_Days(year,month,day);
    if (RETVAL == 0) DATECALC_DATE_ERROR("Date_to_Days");
}
OUTPUT:
RETVAL


Z_int
DateCalc_Day_of_Week(year,month,day)
    Z_int	year
    Z_int	month
    Z_int	day
CODE:
{
    RETVAL = DateCalc_Day_of_Week(year,month,day);
    if (RETVAL == 0) DATECALC_DATE_ERROR("Day_of_Week");
}
OUTPUT:
RETVAL


Z_int
DateCalc_Week_Number(year,month,day)
    Z_int	year
    Z_int	month
    Z_int	day
CODE:
{
    if (DateCalc_check_date(year,month,day))
    {
        RETVAL = DateCalc_Week_Number(year,month,day);
    }
    else DATECALC_DATE_ERROR("Week_Number");
}
OUTPUT:
RETVAL


void
DateCalc_Week_of_Year(year,month,day)
    Z_int	year
    Z_int	month
    Z_int	day
PPCODE:
{
    Z_int week;

    if (DateCalc_week_of_year(&week,&year,month,day))
    {
        EXTEND(sp,2);
        PUSHs(sv_2mortal(newSViv((IV)week)));
        PUSHs(sv_2mortal(newSViv((IV)year)));
    }
    else DATECALC_DATE_ERROR("Week_of_Year");
}


void
DateCalc_Monday_of_Week(week,year)
    Z_int	week
    Z_int	year
PPCODE:
{
    Z_int month;
    Z_int day;

    if (year > 0)
    {
        if ((week > 0) and (week <= DateCalc_Weeks_in_Year(year)))
        {
            if (DateCalc_monday_of_week(week,&year,&month,&day))
            {
                EXTEND(sp,3);
                PUSHs(sv_2mortal(newSViv((IV)year)));
                PUSHs(sv_2mortal(newSViv((IV)month)));
                PUSHs(sv_2mortal(newSViv((IV)day)));
            }
            else DATECALC_DATE_ERROR("Monday_of_Week");
        }
        else DATECALC_WEEK_ERROR("Monday_of_Week");
    }
    else DATECALC_YEAR_ERROR("Monday_of_Week");
}


void
DateCalc_Nth_Weekday_of_Month_Year(year,month,dow,n)
    Z_int	year
    Z_int	month
    Z_int	dow
    Z_int	n
PPCODE:
{
    Z_int day;

    if (year > 0)
    {
        if ((month >= 1) and (month <= 12))
        {
            if ((dow >= 1) and (dow <= 7))
            {
                if ((n >= 1) and (n <= 5))
                {
                    if (DateCalc_nth_weekday_of_month_year(&year,&month,&day,dow,n))
                    {
                        EXTEND(sp,3);
                        PUSHs(sv_2mortal(newSViv((IV)year)));
                        PUSHs(sv_2mortal(newSViv((IV)month)));
                        PUSHs(sv_2mortal(newSViv((IV)day)));
                    }
                    /* else return empty list */
                }
                else DATECALC_FACTOR_ERROR("Nth_Weekday_of_Month_Year");
            }
            else DATECALC_DAYOFWEEK_ERROR("Nth_Weekday_of_Month_Year");
        }
        else DATECALC_MONTH_ERROR("Nth_Weekday_of_Month_Year");
    }
    else DATECALC_YEAR_ERROR("Nth_Weekday_of_Month_Year");
}


void
DateCalc_Standard_to_Business(year,month,day)
    Z_int	year
    Z_int	month
    Z_int	day
PPCODE:
{
    Z_int week;
    Z_int dow;

    if (DateCalc_standard_to_business(&year,&week,&dow,month,day))
    {
        EXTEND(sp,3);
        PUSHs(sv_2mortal(newSViv((IV)year)));
        PUSHs(sv_2mortal(newSViv((IV)week)));
        PUSHs(sv_2mortal(newSViv((IV)dow)));
    }
    else DATECALC_DATE_ERROR("Standard_to_Business");
}


void
DateCalc_Business_to_Standard(year,week,dow)
    Z_int	year
    Z_int	week
    Z_int	dow
PPCODE:
{
    Z_int month;
    Z_int day;

    if (DateCalc_business_to_standard(&year,&month,&day,week,dow))
    {
        EXTEND(sp,3);
        PUSHs(sv_2mortal(newSViv((IV)year)));
        PUSHs(sv_2mortal(newSViv((IV)month)));
        PUSHs(sv_2mortal(newSViv((IV)day)));
    }
    else DATECALC_DATE_ERROR("Business_to_Standard");
}


Z_long
DateCalc_Delta_Days(year1,month1,day1, year2,month2,day2)
    Z_int	year1
    Z_int	month1
    Z_int	day1
    Z_int	year2
    Z_int	month2
    Z_int	day2
CODE:
{
    if (DateCalc_check_date(year1,month1,day1) and
        DateCalc_check_date(year2,month2,day2))
    {
        RETVAL = DateCalc_Delta_Days(year1,month1,day1, year2,month2,day2);
    }
    else DATECALC_DATE_ERROR("Delta_Days");
}
OUTPUT:
RETVAL


void
DateCalc_Delta_DHMS(year1,month1,day1, hour1,min1,sec1, year2,month2,day2, hour2,min2,sec2)
    Z_int	year1;
    Z_int	month1;
    Z_int	day1;
    Z_int	hour1;
    Z_int	min1;
    Z_int	sec1;
    Z_int	year2;
    Z_int	month2;
    Z_int	day2;
    Z_int	hour2;
    Z_int	min2;
    Z_int	sec2;
PPCODE:
{
    Z_long Dd;
    Z_int  Dh;
    Z_int  Dm;
    Z_int  Ds;

    if (DateCalc_check_date(year1,month1,day1) and
        DateCalc_check_date(year2,month2,day2))
    {
        if ((hour1 >= 0) and (min1 >= 0) and (sec1 >= 0) and
            (hour2 >= 0) and (min2 >= 0) and (sec2 >= 0) and
            (hour1 < 24) and (min1 < 60) and (sec1 < 60) and
            (hour2 < 24) and (min2 < 60) and (sec2 < 60))
        {
            if (DateCalc_delta_dhms(&Dd,&Dh,&Dm,&Ds,
                                    year1,month1,day1, hour1,min1,sec1,
                                    year2,month2,day2, hour2,min2,sec2))
            {
                EXTEND(sp,4);
                PUSHs(sv_2mortal(newSViv((IV)Dd)));
                PUSHs(sv_2mortal(newSViv((IV)Dh)));
                PUSHs(sv_2mortal(newSViv((IV)Dm)));
                PUSHs(sv_2mortal(newSViv((IV)Ds)));
            }
            else DATECALC_DATE_ERROR("Delta_DHMS");
        }
        else DATECALC_TIME_ERROR("Delta_DHMS");
    }
    else DATECALC_DATE_ERROR("Delta_DHMS");
}


void
DateCalc_Add_Delta_Days(year,month,day, Dd)
    Z_int	year
    Z_int	month
    Z_int	day
    Z_long	Dd
PPCODE:
{
    if (DateCalc_add_delta_days(&year,&month,&day, Dd))
    {
        EXTEND(sp,3);
        PUSHs(sv_2mortal(newSViv((IV)year)));
        PUSHs(sv_2mortal(newSViv((IV)month)));
        PUSHs(sv_2mortal(newSViv((IV)day)));
    }
    else DATECALC_DATE_ERROR("Add_Delta_Days");
}


void
DateCalc_Add_Delta_DHMS(year,month,day, hour,min,sec, Dd,Dh,Dm,Ds)
    Z_int	year;
    Z_int	month;
    Z_int	day;
    Z_int	hour;
    Z_int	min;
    Z_int	sec;
    Z_long	Dd;
    Z_long	Dh;
    Z_long	Dm;
    Z_long	Ds;
PPCODE:
{
    if (DateCalc_check_date(year,month,day))
    {
        if ((hour >= 0) and (min >= 0) and (sec >= 0) and
            (hour < 24) and (min < 60) and (sec < 60))
        {
            if (DateCalc_add_delta_dhms(&year,&month,&day,
                                        &hour,&min,&sec,
                                        Dd,Dh,Dm,Ds))
            {
                EXTEND(sp,6);
                PUSHs(sv_2mortal(newSViv((IV)year)));
                PUSHs(sv_2mortal(newSViv((IV)month)));
                PUSHs(sv_2mortal(newSViv((IV)day)));
                PUSHs(sv_2mortal(newSViv((IV)hour)));
                PUSHs(sv_2mortal(newSViv((IV)min)));
                PUSHs(sv_2mortal(newSViv((IV)sec)));
            }
            else DATECALC_DATE_ERROR("Add_Delta_DHMS");
        }
        else DATECALC_TIME_ERROR("Add_Delta_DHMS");
    }
    else DATECALC_DATE_ERROR("Add_Delta_DHMS");
}


void
DateCalc_Add_Delta_YMD(year,month,day, Dy,Dm,Dd)
    Z_int	year
    Z_int	month
    Z_int	day
    Z_int	Dy
    Z_int	Dm
    Z_int	Dd
PPCODE:
{
    if (DateCalc_add_delta_ymd(&year,&month,&day, Dy,Dm,Dd))
    {
        EXTEND(sp,3);
        PUSHs(sv_2mortal(newSViv((IV)year)));
        PUSHs(sv_2mortal(newSViv((IV)month)));
        PUSHs(sv_2mortal(newSViv((IV)day)));
    }
    else DATECALC_DATE_ERROR("Add_Delta_YMD");
}


void
DateCalc_System_Clock()
PPCODE:
{
    Z_int year;
    Z_int month;
    Z_int day;
    Z_int hour;
    Z_int min;
    Z_int sec;
    Z_int doy;
    Z_int dow;
    Z_int dst;

    if (DateCalc_system_clock(&year,&month,&day,
                              &hour,&min,&sec,
                              &doy,&dow,&dst))
    {
        EXTEND(sp,9);
        PUSHs(sv_2mortal(newSViv((IV)year)));
        PUSHs(sv_2mortal(newSViv((IV)month)));
        PUSHs(sv_2mortal(newSViv((IV)day)));
        PUSHs(sv_2mortal(newSViv((IV)hour)));
        PUSHs(sv_2mortal(newSViv((IV)min)));
        PUSHs(sv_2mortal(newSViv((IV)sec)));
        PUSHs(sv_2mortal(newSViv((IV)doy)));
        PUSHs(sv_2mortal(newSViv((IV)dow)));
        PUSHs(sv_2mortal(newSViv((IV)dst)));
    }
    else DATECALC_SYSTEM_ERROR("System_Clock");
}


void
DateCalc_Today()
PPCODE:
{
    Z_int year;
    Z_int month;
    Z_int day;
    Z_int hour;
    Z_int min;
    Z_int sec;
    Z_int doy;
    Z_int dow;
    Z_int dst;

    if (DateCalc_system_clock(&year,&month,&day,
                              &hour,&min,&sec,
                              &doy,&dow,&dst))
    {
        EXTEND(sp,3);
        PUSHs(sv_2mortal(newSViv((IV)year)));
        PUSHs(sv_2mortal(newSViv((IV)month)));
        PUSHs(sv_2mortal(newSViv((IV)day)));
    }
    else DATECALC_SYSTEM_ERROR("Today");
}


void
DateCalc_Now()
PPCODE:
{
    Z_int year;
    Z_int month;
    Z_int day;
    Z_int hour;
    Z_int min;
    Z_int sec;
    Z_int doy;
    Z_int dow;
    Z_int dst;

    if (DateCalc_system_clock(&year,&month,&day,
                              &hour,&min,&sec,
                              &doy,&dow,&dst))
    {
        EXTEND(sp,3);
        PUSHs(sv_2mortal(newSViv((IV)hour)));
        PUSHs(sv_2mortal(newSViv((IV)min)));
        PUSHs(sv_2mortal(newSViv((IV)sec)));
    }
    else DATECALC_SYSTEM_ERROR("Now");
}


void
DateCalc_Today_and_Now()
PPCODE:
{
    Z_int year;
    Z_int month;
    Z_int day;
    Z_int hour;
    Z_int min;
    Z_int sec;
    Z_int doy;
    Z_int dow;
    Z_int dst;

    if (DateCalc_system_clock(&year,&month,&day,
                              &hour,&min,&sec,
                              &doy,&dow,&dst))
    {
        EXTEND(sp,6);
        PUSHs(sv_2mortal(newSViv((IV)year)));
        PUSHs(sv_2mortal(newSViv((IV)month)));
        PUSHs(sv_2mortal(newSViv((IV)day)));
        PUSHs(sv_2mortal(newSViv((IV)hour)));
        PUSHs(sv_2mortal(newSViv((IV)min)));
        PUSHs(sv_2mortal(newSViv((IV)sec)));
    }
    else DATECALC_SYSTEM_ERROR("Today_and_Now");
}


void
DateCalc_Easter_Sunday(year)
    Z_int	year
PPCODE:
{
    Z_int month;
    Z_int day;

    if ((year > 0) and DateCalc_easter_sunday(&year,&month,&day))
    {
        EXTEND(sp,3);
        PUSHs(sv_2mortal(newSViv((IV)year)));
        PUSHs(sv_2mortal(newSViv((IV)month)));
        PUSHs(sv_2mortal(newSViv((IV)day)));
    }
    else DATECALC_YEAR_ERROR("Easter_Sunday");
}


Z_int
DateCalc_Decode_Month(string)
    charptr	string
CODE:
{
    RETVAL = DateCalc_Decode_Month(string,strlen((char *)string));
}
OUTPUT:
RETVAL


Z_int
DateCalc_Decode_Day_of_Week(string)
    charptr	string
CODE:
{
    RETVAL = DateCalc_Decode_Day_of_Week(string,strlen((char *)string));
}
OUTPUT:
RETVAL


Z_int
DateCalc_Decode_Language(string)
    charptr	string
CODE:
{
    RETVAL = DateCalc_Decode_Language(string,strlen((char *)string));
}
OUTPUT:
RETVAL


void
DateCalc_Decode_Date_EU(string)
    charptr	string
PPCODE:
{
    Z_int year;
    Z_int month;
    Z_int day;

    if (DateCalc_decode_date_eu(string,&year,&month,&day))
    {
        EXTEND(sp,3);
        PUSHs(sv_2mortal(newSViv((IV)year)));
        PUSHs(sv_2mortal(newSViv((IV)month)));
        PUSHs(sv_2mortal(newSViv((IV)day)));
    }
    /* else return empty list */
}


void
DateCalc_Decode_Date_US(string)
    charptr	string
PPCODE:
{
    Z_int year;
    Z_int month;
    Z_int day;

    if (DateCalc_decode_date_us(string,&year,&month,&day))
    {
        EXTEND(sp,3);
        PUSHs(sv_2mortal(newSViv((IV)year)));
        PUSHs(sv_2mortal(newSViv((IV)month)));
        PUSHs(sv_2mortal(newSViv((IV)day)));
    }
    /* else return empty list */
}


Z_int
DateCalc_Compress(year,month,day)
    Z_int	year
    Z_int	month
    Z_int	day


void
DateCalc_Uncompress(date)
    Z_int	date
PPCODE:
{
    Z_int century;
    Z_int year;
    Z_int month;
    Z_int day;

    if (DateCalc_uncompress(date,&century,&year,&month,&day))
    {
        EXTEND(sp,4);
        PUSHs(sv_2mortal(newSViv((IV)century)));
        PUSHs(sv_2mortal(newSViv((IV)year)));
        PUSHs(sv_2mortal(newSViv((IV)month)));
        PUSHs(sv_2mortal(newSViv((IV)day)));
    }
    /* else return empty list */
    /* else DATECALC_DATE_ERROR("Uncompress"); */
}


boolean
DateCalc_check_compressed(date)
    Z_int	date


void
DateCalc_Compressed_to_Text(date)
    Z_int	date
PPCODE:
{
    charptr string;

    string = DateCalc_Compressed_to_Text(date);
    if (string != NULL)
    {
        EXTEND(sp,1);
        PUSHs(sv_2mortal(newSVpv((char *)string,0)));
        DateCalc_Dispose(string);
    }
    else DATECALC_MEMORY_ERROR("Compressed_to_Text");
}


void
DateCalc_Date_to_Text(year,month,day)
    Z_int	year
    Z_int	month
    Z_int	day
PPCODE:
{
    charptr string;

    if (DateCalc_check_date(year,month,day))
    {
        string = DateCalc_Date_to_Text(year,month,day);
        if (string != NULL)
        {
            EXTEND(sp,1);
            PUSHs(sv_2mortal(newSVpv((char *)string,0)));
            DateCalc_Dispose(string);
        }
        else DATECALC_MEMORY_ERROR("Date_to_Text");
    }
    else DATECALC_DATE_ERROR("Date_to_Text");
}


void
DateCalc_Date_to_Text_Long(year,month,day)
    Z_int	year
    Z_int	month
    Z_int	day
PPCODE:
{
    charptr string;

    if (DateCalc_check_date(year,month,day))
    {
        string = DateCalc_Date_to_Text_Long(year,month,day);
        if (string != NULL)
        {
            EXTEND(sp,1);
            PUSHs(sv_2mortal(newSVpv((char *)string,0)));
            DateCalc_Dispose(string);
        }
        else DATECALC_MEMORY_ERROR("Date_to_Text_Long");
    }
    else DATECALC_DATE_ERROR("Date_to_Text_Long");
}


void
DateCalc_English_Ordinal(number)
    Z_int	number
PPCODE:
{
    blockdef(string,64);

    DateCalc_English_Ordinal(string,number);
    EXTEND(sp,1);
    PUSHs(sv_2mortal(newSVpv((char *)string,0)));
}


void
DateCalc_Calendar(year,month)
    Z_int	year
    Z_int	month
PPCODE:
{
    charptr string;

    if (year > 0)
    {
        if ((month >= 1) and (month <= 12))
        {
            string = DateCalc_Calendar(year,month);
            if (string != NULL)
            {
                EXTEND(sp,1);
                PUSHs(sv_2mortal(newSVpv((char *)string,0)));
                DateCalc_Dispose(string);
            }
            else DATECALC_MEMORY_ERROR("Calendar");
        }
        else DATECALC_MONTH_ERROR("Calendar");
    }
    else DATECALC_YEAR_ERROR("Calendar");
}


void
DateCalc_Month_to_Text(month)
    Z_int	month
PPCODE:
{
    if ((month >= 1) and (month <= 12))
    {
        EXTEND(sp,1);
        PUSHs(sv_2mortal(newSVpv((char *)DateCalc_Month_to_Text_[DateCalc_Language][month],0)));
    }
    else DATECALC_MONTH_ERROR("Month_to_Text");
}


void
DateCalc_Day_of_Week_to_Text(dow)
    Z_int	dow
PPCODE:
{
    if ((dow >= 1) and (dow <= 7))
    {
        EXTEND(sp,1);
        PUSHs(sv_2mortal(newSVpv((char *)DateCalc_Day_of_Week_to_Text_[DateCalc_Language][dow],0)));
    }
    else DATECALC_DAYOFWEEK_ERROR("Day_of_Week_to_Text");
}


void
DateCalc_Day_of_Week_Abbreviation(dow)
    Z_int	dow
PPCODE:
{
    blockdef(buffer,4);

    if ((dow >= 1) and (dow <= 7))
    {
        EXTEND(sp,1);
        if (DateCalc_Day_of_Week_Abbreviation_[DateCalc_Language][0][0] != '\0')
        {
            PUSHs(sv_2mortal(newSVpv((char *)DateCalc_Day_of_Week_Abbreviation_[DateCalc_Language][dow],0)));
        }
        else
        {
            strncpy((char *)buffer,(char *)DateCalc_Day_of_Week_to_Text_[DateCalc_Language][dow],3);
            buffer[3] = '\0';
            PUSHs(sv_2mortal(newSVpv((char *)buffer,0)));
        }
    }
    else DATECALC_DAYOFWEEK_ERROR("Day_of_Week_Abbreviation");
}


void
DateCalc_Language_to_Text(lang)
    Z_int	lang
PPCODE:
{
    if ((lang >= 1) and (lang <= DateCalc_LANGUAGES))
    {
        EXTEND(sp,1);
        PUSHs(sv_2mortal(newSVpv((char *)DateCalc_Language_to_Text_[lang],0)));
    }
    else DATECALC_LANGUAGE_ERROR("Language_to_Text");
}


Z_int
DateCalc_Language(...)
CODE:
{
    Z_int lang;

    if ((items >= 0) and (items <= 1))
    {
        RETVAL = DateCalc_Language;
        if (items == 1)
        {
            lang = (Z_int) SvIV( ST(0) );
            if ((lang >= 1) and (lang <= DateCalc_LANGUAGES))
            {
                DateCalc_Language = lang;
            }
            else DATECALC_LANGUAGE_ERROR("Language");
        }
    }
    else croak("Usage: [$lang = ] Date::Calc::Language( [$lang] );");
}
OUTPUT:
RETVAL


Z_int
DateCalc_Languages()
CODE:
{
    RETVAL = DateCalc_LANGUAGES;
}
OUTPUT:
RETVAL


void
DateCalc_Version()
PPCODE:
{
    charptr string;

    string = DateCalc_Version();
    if (string != NULL)
    {
        EXTEND(sp,1);
        PUSHs(sv_2mortal(newSVpv((char *)string,0)));
    }
    else DATECALC_MEMORY_ERROR("Version");
}


