

/*****************************************************************************/
/*                                                                           */
/*    Copyright (c) 1995, 1996, 1997, 1998 by Steffen Beyer.                 */
/*    All rights reserved.                                                   */
/*                                                                           */
/*    This package is free software; you can redistribute it                 */
/*    and/or modify it under the same terms as Perl itself.                  */
/*                                                                           */
/*****************************************************************************/


#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"


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
DateCalc_Days_in_Year(year,mm)
    Z_int	year
    Z_int	mm
PPCODE:
{
    if (year > 0)
    {
        if ((mm >= 1) and (mm <= 12))
        {
            EXTEND(sp,1);
            PUSHs(sv_2mortal(newSViv((IV)DateCalc_Days_in_Year_[DateCalc_leap_year(year)][mm+1])));
        }
        else DATECALC_MONTH_ERROR("Days_in_Year");
    }
    else DATECALC_YEAR_ERROR("Days_in_Year");
}


void
DateCalc_Days_in_Month(year,mm)
    Z_int	year
    Z_int	mm
PPCODE:
{
    if (year > 0)
    {
        if ((mm >= 1) and (mm <= 12))
        {
            EXTEND(sp,1);
            PUSHs(sv_2mortal(newSViv((IV)DateCalc_Days_in_Month_[DateCalc_leap_year(year)][mm])));
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
DateCalc_check_date(year,mm,dd)
    Z_int	year
    Z_int	mm
    Z_int	dd


Z_int
DateCalc_Day_of_Year(year,mm,dd)
    Z_int	year
    Z_int	mm
    Z_int	dd
CODE:
{
    RETVAL = DateCalc_Day_of_Year(year,mm,dd);
    if (RETVAL == 0) DATECALC_DATE_ERROR("Day_of_Year");
}
OUTPUT:
RETVAL


Z_long
DateCalc_Date_to_Days(year,mm,dd)
    Z_int	year
    Z_int	mm
    Z_int	dd
CODE:
{
    RETVAL = DateCalc_Date_to_Days(year,mm,dd);
    if (RETVAL == 0) DATECALC_DATE_ERROR("Date_to_Days");
}
OUTPUT:
RETVAL


Z_int
DateCalc_Day_of_Week(year,mm,dd)
    Z_int	year
    Z_int	mm
    Z_int	dd
CODE:
{
    RETVAL = DateCalc_Day_of_Week(year,mm,dd);
    if (RETVAL == 0) DATECALC_DATE_ERROR("Day_of_Week");
}
OUTPUT:
RETVAL


Z_int
DateCalc_Week_Number(year,mm,dd)
    Z_int	year
    Z_int	mm
    Z_int	dd
CODE:
{
    if (DateCalc_check_date(year,mm,dd))
    {
        RETVAL = DateCalc_Week_Number(year,mm,dd);
    }
    else DATECALC_DATE_ERROR("Week_Number");
}
OUTPUT:
RETVAL


void
DateCalc_Week_of_Year(year,mm,dd)
    Z_int	year
    Z_int	mm
    Z_int	dd
PPCODE:
{
    Z_int week;
    if (DateCalc_week_of_year(&week,&year,mm,dd))
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
    Z_int yy = year;
    Z_int mm = 0;
    Z_int dd = 0;
    if (yy > 0)
    {
        if ((week > 0) and (week <= DateCalc_Weeks_in_Year(yy)))
        {
            if (DateCalc_monday_of_week(week,&yy,&mm,&dd))
            {
                EXTEND(sp,3);
                PUSHs(sv_2mortal(newSViv((IV)yy)));
                PUSHs(sv_2mortal(newSViv((IV)mm)));
                PUSHs(sv_2mortal(newSViv((IV)dd)));
            }
            else DATECALC_DATE_ERROR("Monday_of_Week");
        }
        else DATECALC_WEEK_ERROR("Monday_of_Week");
    }
    else DATECALC_YEAR_ERROR("Monday_of_Week");
}


void
DateCalc_Nth_Weekday_of_Month_Year(year,month,wd,n)
    Z_int	year
    Z_int	month
    Z_int	wd
    Z_int	n
PPCODE:
{
    Z_int yy = year;
    Z_int mm = month;
    Z_int dd;
    if (yy > 0)
    {
        if ((mm >= 1) and (mm <= 12))
        {
            if ((wd >= 1) and (wd <= 7))
            {
                if ((n >= 1) and (n <= 5))
                {
                    if (DateCalc_nth_weekday_of_month_year(&yy,&mm,&dd,wd,n))
                    {
                        EXTEND(sp,3);
                        PUSHs(sv_2mortal(newSViv((IV)yy)));
                        PUSHs(sv_2mortal(newSViv((IV)mm)));
                        PUSHs(sv_2mortal(newSViv((IV)dd)));
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


Z_long
DateCalc_Delta_Days(year1,month1,day1,year2,month2,day2)
    Z_int	year1
    Z_int	month1
    Z_int	day1
    Z_int	year2
    Z_int	month2
    Z_int	day2
CODE:
{
    if (DateCalc_check_date(year1,month1,day1) and DateCalc_check_date(year2,month2,day2))
    {
        RETVAL = DateCalc_Delta_Days(year1,month1,day1,year2,month2,day2);
    }
    else DATECALC_DATE_ERROR("Delta_Days");
}
OUTPUT:
RETVAL


void
DateCalc_Delta_DHMS(year1,month1,day1,hour1,min1,sec1,year2,month2,day2,hour2,min2,sec2)
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
    Z_long delta_d;
    Z_int  delta_h;
    Z_int  delta_m;
    Z_int  delta_s;
    if (DateCalc_check_date(year1,month1,day1) and DateCalc_check_date(year2,month2,day2))
    {
        if ((hour1 >= 0) and (min1 >= 0) and (sec1 >= 0) and
            (hour2 >= 0) and (min2 >= 0) and (sec2 >= 0) and
            (hour1 < 24) and (min1 < 60) and (sec1 < 60) and
            (hour2 < 24) and (min2 < 60) and (sec2 < 60))
        {
            if (DateCalc_delta_dhms(&delta_d,&delta_h,&delta_m,&delta_s,
                year1,month1,day1,hour1,min1,sec1,
                year2,month2,day2,hour2,min2,sec2))
            {
                EXTEND(sp,4);
                PUSHs(sv_2mortal(newSViv((IV)delta_d)));
                PUSHs(sv_2mortal(newSViv((IV)delta_h)));
                PUSHs(sv_2mortal(newSViv((IV)delta_m)));
                PUSHs(sv_2mortal(newSViv((IV)delta_s)));
            }
            else DATECALC_DATE_ERROR("Delta_DHMS");
        }
        else DATECALC_TIME_ERROR("Delta_DHMS");
    }
    else DATECALC_DATE_ERROR("Delta_DHMS");
}


void
DateCalc_Add_Delta_Days(year,mm,dd,delta_d)
    Z_int	year
    Z_int	mm
    Z_int	dd
    Z_long	delta_d
PPCODE:
{
    Z_int y = year;
    Z_int m = mm;
    Z_int d = dd;
    if (DateCalc_add_delta_days(&y,&m,&d,delta_d))
    {
        EXTEND(sp,3);
        PUSHs(sv_2mortal(newSViv((IV)y)));
        PUSHs(sv_2mortal(newSViv((IV)m)));
        PUSHs(sv_2mortal(newSViv((IV)d)));
    }
    else DATECALC_DATE_ERROR("Add_Delta_Days");
}


void
DateCalc_Add_Delta_DHMS(year,month,day,hour,min,sec,delta_d,delta_h,delta_m,delta_s)
    Z_int	year;
    Z_int	month;
    Z_int	day;
    Z_int	hour;
    Z_int	min;
    Z_int	sec;
    Z_long	delta_d;
    Z_long	delta_h;
    Z_long	delta_m;
    Z_long	delta_s;
PPCODE:
{
    Z_int yy = year;
    Z_int mm = month;
    Z_int dd = day;
    Z_int h = hour;
    Z_int m = min;
    Z_int s = sec;
    if (DateCalc_check_date(yy,mm,dd))
    {
        if ((h >= 0) and (m >= 0) and (s >= 0) and
            (h < 24) and (m < 60) and (s < 60))
        {
            if (DateCalc_add_delta_dhms(&yy,&mm,&dd,&h,&m,&s,delta_d,delta_h,delta_m,delta_s))
            {
                EXTEND(sp,6);
                PUSHs(sv_2mortal(newSViv((IV)yy)));
                PUSHs(sv_2mortal(newSViv((IV)mm)));
                PUSHs(sv_2mortal(newSViv((IV)dd)));
                PUSHs(sv_2mortal(newSViv((IV)h)));
                PUSHs(sv_2mortal(newSViv((IV)m)));
                PUSHs(sv_2mortal(newSViv((IV)s)));
            }
            else DATECALC_DATE_ERROR("Add_Delta_DHMS");
        }
        else DATECALC_TIME_ERROR("Add_Delta_DHMS");
    }
    else DATECALC_DATE_ERROR("Add_Delta_DHMS");
}


void
DateCalc_Add_Delta_YMD(year,month,day,delta_y,delta_m,delta_d)
    Z_int	year
    Z_int	month
    Z_int	day
    Z_int	delta_y
    Z_int	delta_m
    Z_int	delta_d
PPCODE:
{
    Z_int yy = year;
    Z_int mm = month;
    Z_int dd = day;
    if (DateCalc_add_delta_ymd(&yy,&mm,&dd,delta_y,delta_m,delta_d))
    {
        EXTEND(sp,3);
        PUSHs(sv_2mortal(newSViv((IV)yy)));
        PUSHs(sv_2mortal(newSViv((IV)mm)));
        PUSHs(sv_2mortal(newSViv((IV)dd)));
    }
    else DATECALC_DATE_ERROR("Add_Delta_YMD");
}


void
DateCalc_System_Clock()
PPCODE:
{
    Z_int year;
    Z_int mm;
    Z_int dd;
    Z_int h;
    Z_int m;
    Z_int s;
    Z_int yd;
    Z_int wd;
    Z_int dst;
    if (DateCalc_system_clock(&year,&mm,&dd,&h,&m,&s,&yd,&wd,&dst))
    {
        EXTEND(sp,9);
        PUSHs(sv_2mortal(newSViv((IV)year)));
        PUSHs(sv_2mortal(newSViv((IV)mm)));
        PUSHs(sv_2mortal(newSViv((IV)dd)));
        PUSHs(sv_2mortal(newSViv((IV)h)));
        PUSHs(sv_2mortal(newSViv((IV)m)));
        PUSHs(sv_2mortal(newSViv((IV)s)));
        PUSHs(sv_2mortal(newSViv((IV)yd)));
        PUSHs(sv_2mortal(newSViv((IV)wd)));
        PUSHs(sv_2mortal(newSViv((IV)dst)));
    }
    else DATECALC_SYSTEM_ERROR("System_Clock");
}


void
DateCalc_Today()
PPCODE:
{
    Z_int year;
    Z_int mm;
    Z_int dd;
    Z_int h;
    Z_int m;
    Z_int s;
    Z_int yd;
    Z_int wd;
    Z_int dst;
    if (DateCalc_system_clock(&year,&mm,&dd,&h,&m,&s,&yd,&wd,&dst))
    {
        EXTEND(sp,3);
        PUSHs(sv_2mortal(newSViv((IV)year)));
        PUSHs(sv_2mortal(newSViv((IV)mm)));
        PUSHs(sv_2mortal(newSViv((IV)dd)));
    }
    else DATECALC_SYSTEM_ERROR("Today");
}


void
DateCalc_Now()
PPCODE:
{
    Z_int year;
    Z_int mm;
    Z_int dd;
    Z_int h;
    Z_int m;
    Z_int s;
    Z_int yd;
    Z_int wd;
    Z_int dst;
    if (DateCalc_system_clock(&year,&mm,&dd,&h,&m,&s,&yd,&wd,&dst))
    {
        EXTEND(sp,3);
        PUSHs(sv_2mortal(newSViv((IV)h)));
        PUSHs(sv_2mortal(newSViv((IV)m)));
        PUSHs(sv_2mortal(newSViv((IV)s)));
    }
    else DATECALC_SYSTEM_ERROR("Now");
}


void
DateCalc_Today_and_Now()
PPCODE:
{
    Z_int year;
    Z_int mm;
    Z_int dd;
    Z_int h;
    Z_int m;
    Z_int s;
    Z_int yd;
    Z_int wd;
    Z_int dst;
    if (DateCalc_system_clock(&year,&mm,&dd,&h,&m,&s,&yd,&wd,&dst))
    {
        EXTEND(sp,6);
        PUSHs(sv_2mortal(newSViv((IV)year)));
        PUSHs(sv_2mortal(newSViv((IV)mm)));
        PUSHs(sv_2mortal(newSViv((IV)dd)));
        PUSHs(sv_2mortal(newSViv((IV)h)));
        PUSHs(sv_2mortal(newSViv((IV)m)));
        PUSHs(sv_2mortal(newSViv((IV)s)));
    }
    else DATECALC_SYSTEM_ERROR("Today_and_Now");
}


void
DateCalc_Easter_Sunday(year)
    Z_int	year
PPCODE:
{
    Z_int yy = year;
    Z_int mm;
    Z_int dd;
    if ((yy > 0) and DateCalc_easter_sunday(&yy,&mm,&dd))
    {
        EXTEND(sp,3);
        PUSHs(sv_2mortal(newSViv((IV)yy)));
        PUSHs(sv_2mortal(newSViv((IV)mm)));
        PUSHs(sv_2mortal(newSViv((IV)dd)));
    }
    else DATECALC_YEAR_ERROR("Easter_Sunday");
}


Z_int
DateCalc_Decode_Month(buffer)
    charptr	buffer
CODE:
{
    RETVAL = DateCalc_Decode_Month(buffer,strlen((char *)buffer));
}
OUTPUT:
RETVAL


Z_int
DateCalc_Decode_Day_of_Week(buffer)
    charptr	buffer
CODE:
{
    RETVAL = DateCalc_Decode_Day_of_Week(buffer,strlen((char *)buffer));
}
OUTPUT:
RETVAL


Z_int
DateCalc_Decode_Language(buffer)
    charptr	buffer
CODE:
{
    RETVAL = DateCalc_Decode_Language(buffer,strlen((char *)buffer));
}
OUTPUT:
RETVAL


void
DateCalc_Decode_Date_EU(buffer)
    charptr	buffer
PPCODE:
{
    Z_int year;
    Z_int mm;
    Z_int dd;
    if (DateCalc_decode_date_eu(buffer,&year,&mm,&dd))
    {
        EXTEND(sp,3);
        PUSHs(sv_2mortal(newSViv((IV)year)));
        PUSHs(sv_2mortal(newSViv((IV)mm)));
        PUSHs(sv_2mortal(newSViv((IV)dd)));
    }
    /* else return empty list */
}


void
DateCalc_Decode_Date_US(buffer)
    charptr	buffer
PPCODE:
{
    Z_int year;
    Z_int mm;
    Z_int dd;
    if (DateCalc_decode_date_us(buffer,&year,&mm,&dd))
    {
        EXTEND(sp,3);
        PUSHs(sv_2mortal(newSViv((IV)year)));
        PUSHs(sv_2mortal(newSViv((IV)mm)));
        PUSHs(sv_2mortal(newSViv((IV)dd)));
    }
    /* else return empty list */
}


Z_int
DateCalc_Compress(yy,mm,dd)
    Z_int	yy
    Z_int	mm
    Z_int	dd


void
DateCalc_Uncompress(date)
    Z_int	date
PPCODE:
{
    Z_int cc;
    Z_int yy;
    Z_int mm;
    Z_int dd;
    if (DateCalc_uncompress(date,&cc,&yy,&mm,&dd))
    {
        EXTEND(sp,4);
        PUSHs(sv_2mortal(newSViv((IV)cc)));
        PUSHs(sv_2mortal(newSViv((IV)yy)));
        PUSHs(sv_2mortal(newSViv((IV)mm)));
        PUSHs(sv_2mortal(newSViv((IV)dd)));
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
DateCalc_Date_to_Text(year,mm,dd)
    Z_int	year
    Z_int	mm
    Z_int	dd
PPCODE:
{
    charptr string;
    if (DateCalc_check_date(year,mm,dd))
    {
        string = DateCalc_Date_to_Text(year,mm,dd);
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
DateCalc_Date_to_Text_Long(year,mm,dd)
    Z_int	year
    Z_int	mm
    Z_int	dd
PPCODE:
{
    charptr string;
    if (DateCalc_check_date(year,mm,dd))
    {
        string = DateCalc_Date_to_Text_Long(year,mm,dd);
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
DateCalc_Calendar(year,mm)
    Z_int	year
    Z_int	mm
PPCODE:
{
    charptr string;
    if (year > 0)
    {
        if ((mm >= 1) and (mm <= 12))
        {
            string = DateCalc_Calendar(year,mm);
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
DateCalc_Month_to_Text(mm)
    Z_int	mm
PPCODE:
{
    if ((mm >= 1) and (mm <= 12))
    {
        EXTEND(sp,1);
        PUSHs(sv_2mortal(newSVpv((char *)DateCalc_Month_to_Text_[DateCalc_Language][mm],0)));
    }
    else DATECALC_MONTH_ERROR("Month_to_Text");
}


void
DateCalc_Day_of_Week_to_Text(wd)
    Z_int	wd
PPCODE:
{
    if ((wd >= 1) and (wd <= 7))
    {
        EXTEND(sp,1);
        PUSHs(sv_2mortal(newSVpv((char *)DateCalc_Day_of_Week_to_Text_[DateCalc_Language][wd],0)));
    }
    else DATECALC_DAYOFWEEK_ERROR("Day_of_Week_to_Text");
}


void
DateCalc_Day_of_Week_Abbreviation(wd)
    Z_int	wd
PPCODE:
{
    N_char buffer[4];
    if ((wd >= 1) and (wd <= 7))
    {
        EXTEND(sp,1);
        if (DateCalc_Day_of_Week_Abbreviation_[DateCalc_Language][0][0] != '\0')
        {
            PUSHs(sv_2mortal(newSVpv((char *)DateCalc_Day_of_Week_Abbreviation_[DateCalc_Language][wd],0)));
        }
        else
        {
            strncpy(buffer,DateCalc_Day_of_Week_to_Text_[DateCalc_Language][wd],3);
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


