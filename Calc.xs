

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
    Z_int mm;
    Z_int dd;

    if (year > 0)
    {
        if ((week > 0) and (week <= DateCalc_Weeks_in_Year(year)))
        {
            if (DateCalc_monday_of_week(week,&year,&mm,&dd))
            {
                EXTEND(sp,3);
                PUSHs(sv_2mortal(newSViv((IV)year)));
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
DateCalc_Nth_Weekday_of_Month_Year(year,mm,dow,n)
    Z_int	year
    Z_int	mm
    Z_int	dow
    Z_int	n
PPCODE:
{
    Z_int dd;

    if (year > 0)
    {
        if ((mm >= 1) and (mm <= 12))
        {
            if ((dow >= 1) and (dow <= 7))
            {
                if ((n >= 1) and (n <= 5))
                {
                    if (DateCalc_nth_weekday_of_month_year(&year,&mm,&dd,dow,n))
                    {
                        EXTEND(sp,3);
                        PUSHs(sv_2mortal(newSViv((IV)year)));
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
DateCalc_Delta_Days(year1,mm1,dd1, year2,mm2,dd2)
    Z_int	year1
    Z_int	mm1
    Z_int	dd1
    Z_int	year2
    Z_int	mm2
    Z_int	dd2
CODE:
{
    if (DateCalc_check_date(year1,mm1,dd1) and DateCalc_check_date(year2,mm2,dd2))
    {
        RETVAL = DateCalc_Delta_Days(year1,mm1,dd1, year2,mm2,dd2);
    }
    else DATECALC_DATE_ERROR("Delta_Days");
}
OUTPUT:
RETVAL


void
DateCalc_Delta_DHMS(year1,mm1,dd1, h1,m1,s1, year2,mm2,dd2, h2,m2,s2)
    Z_int	year1;
    Z_int	mm1;
    Z_int	dd1;
    Z_int	h1;
    Z_int	m1;
    Z_int	s1;
    Z_int	year2;
    Z_int	mm2;
    Z_int	dd2;
    Z_int	h2;
    Z_int	m2;
    Z_int	s2;
PPCODE:
{
    Z_long Dd;
    Z_int  Dh;
    Z_int  Dm;
    Z_int  Ds;

    if (DateCalc_check_date(year1,mm1,dd1) and DateCalc_check_date(year2,mm2,dd2))
    {
        if ((h1 >= 0) and (m1 >= 0) and (s1 >= 0) and
            (h2 >= 0) and (m2 >= 0) and (s2 >= 0) and
            (h1 < 24) and (m1 < 60) and (s1 < 60) and
            (h2 < 24) and (m2 < 60) and (s2 < 60))
        {
            if (DateCalc_delta_dhms(&Dd,&Dh,&Dm,&Ds,
                                    year1,mm1,dd1, h1,m1,s1,
                                    year2,mm2,dd2, h2,m2,s2))
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
DateCalc_Add_Delta_Days(year,mm,dd, Dd)
    Z_int	year
    Z_int	mm
    Z_int	dd
    Z_long	Dd
PPCODE:
{
    if (DateCalc_add_delta_days(&year,&mm,&dd, Dd))
    {
        EXTEND(sp,3);
        PUSHs(sv_2mortal(newSViv((IV)year)));
        PUSHs(sv_2mortal(newSViv((IV)mm)));
        PUSHs(sv_2mortal(newSViv((IV)dd)));
    }
    else DATECALC_DATE_ERROR("Add_Delta_Days");
}


void
DateCalc_Add_Delta_DHMS(year,mm,dd, h,m,s, Dd,Dh,Dm,Ds)
    Z_int	year;
    Z_int	mm;
    Z_int	dd;
    Z_int	h;
    Z_int	m;
    Z_int	s;
    Z_long	Dd;
    Z_long	Dh;
    Z_long	Dm;
    Z_long	Ds;
PPCODE:
{
    if (DateCalc_check_date(year,mm,dd))
    {
        if ((h >= 0) and (m >= 0) and (s >= 0) and
            (h < 24) and (m < 60) and (s < 60))
        {
            if (DateCalc_add_delta_dhms(&year,&mm,&dd, &h,&m,&s, Dd,Dh,Dm,Ds))
            {
                EXTEND(sp,6);
                PUSHs(sv_2mortal(newSViv((IV)year)));
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
DateCalc_Add_Delta_YMD(year,mm,dd, Dy,Dm,Dd)
    Z_int	year
    Z_int	mm
    Z_int	dd
    Z_int	Dy
    Z_int	Dm
    Z_int	Dd
PPCODE:
{
    if (DateCalc_add_delta_ymd(&year,&mm,&dd, Dy,Dm,Dd))
    {
        EXTEND(sp,3);
        PUSHs(sv_2mortal(newSViv((IV)year)));
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
    Z_int doy;
    Z_int dow;
    Z_int dst;

    if (DateCalc_system_clock(&year,&mm,&dd, &h,&m,&s, &doy,&dow,&dst))
    {
        EXTEND(sp,9);
        PUSHs(sv_2mortal(newSViv((IV)year)));
        PUSHs(sv_2mortal(newSViv((IV)mm)));
        PUSHs(sv_2mortal(newSViv((IV)dd)));
        PUSHs(sv_2mortal(newSViv((IV)h)));
        PUSHs(sv_2mortal(newSViv((IV)m)));
        PUSHs(sv_2mortal(newSViv((IV)s)));
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
    Z_int mm;
    Z_int dd;
    Z_int h;
    Z_int m;
    Z_int s;
    Z_int doy;
    Z_int dow;
    Z_int dst;

    if (DateCalc_system_clock(&year,&mm,&dd, &h,&m,&s, &doy,&dow,&dst))
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
    Z_int doy;
    Z_int dow;
    Z_int dst;

    if (DateCalc_system_clock(&year,&mm,&dd, &h,&m,&s, &doy,&dow,&dst))
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
    Z_int doy;
    Z_int dow;
    Z_int dst;

    if (DateCalc_system_clock(&year,&mm,&dd, &h,&m,&s, &doy,&dow,&dst))
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
    Z_int mm;
    Z_int dd;

    if ((year > 0) and DateCalc_easter_sunday(&year,&mm,&dd))
    {
        EXTEND(sp,3);
        PUSHs(sv_2mortal(newSViv((IV)year)));
        PUSHs(sv_2mortal(newSViv((IV)mm)));
        PUSHs(sv_2mortal(newSViv((IV)dd)));
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
    Z_int mm;
    Z_int dd;

    if (DateCalc_decode_date_eu(string,&year,&mm,&dd))
    {
        EXTEND(sp,3);
        PUSHs(sv_2mortal(newSViv((IV)year)));
        PUSHs(sv_2mortal(newSViv((IV)mm)));
        PUSHs(sv_2mortal(newSViv((IV)dd)));
    }
    /* else return empty list */
}


void
DateCalc_Decode_Date_US(string)
    charptr	string
PPCODE:
{
    Z_int year;
    Z_int mm;
    Z_int dd;

    if (DateCalc_decode_date_us(string,&year,&mm,&dd))
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
            strncpy(buffer,DateCalc_Day_of_Week_to_Text_[DateCalc_Language][dow],3);
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


