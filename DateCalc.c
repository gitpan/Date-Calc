#ifndef MODULE_DATE_CALC
#define MODULE_DATE_CALC
/*****************************************************************************/
/*  MODULE NAME:  DateCalc.c                            MODULE TYPE:  (lib)  */
/*****************************************************************************/
/*          Gregorian calendar date calculations in compliance with          */
/*          ISO/R 2015-1971, DIN 1355 and (to some extent) ISO 8601.         */
/*****************************************************************************/
/*  MODULE IMPORTS:                                                          */
/*****************************************************************************/
#include <stdlib.h>                                 /*  MODULE TYPE:  (sys)  */
#include <string.h>                                 /*  MODULE TYPE:  (sys)  */
#include <ctype.h>                                  /*  MODULE TYPE:  (sys)  */
#include <time.h>                                   /*  MODULE TYPE:  (sys)  */
#include "ToolBox.h"                                /*  MODULE TYPE:  (dat)  */
/*****************************************************************************/
/*  MODULE INTERFACE:                                                        */
/*****************************************************************************/

boolean
DateCalc_leap_year                     (Z_int   year);

boolean
DateCalc_check_date                    (Z_int   year,
                                        Z_int   month,
                                        Z_int   day);

boolean
DateCalc_check_business_date           (Z_int   year,
                                        Z_int   week,
                                        Z_int   dow);

Z_int
DateCalc_Day_of_Year                   (Z_int   year,
                                        Z_int   month,
                                        Z_int   day);

Z_long
DateCalc_Date_to_Days                  (Z_int   year,
                                        Z_int   month,
                                        Z_int   day);

Z_int
DateCalc_Day_of_Week                   (Z_int   year,
                                        Z_int   month,
                                        Z_int   day);

Z_int
DateCalc_Weeks_in_Year                 (Z_int   year);

Z_int
DateCalc_Week_Number                   (Z_int   year,
                                        Z_int   month,
                                        Z_int   day);

boolean
DateCalc_week_of_year                  (Z_int  *week,       /*   O   */
                                        Z_int  *year,       /*  I/O  */
                                        Z_int   month,      /*   I   */
                                        Z_int   day);       /*   I   */

boolean
DateCalc_monday_of_week                (Z_int   week,       /*   I   */
                                        Z_int  *year,       /*  I/O  */
                                        Z_int  *month,      /*   O   */
                                        Z_int  *day);       /*   O   */

boolean
DateCalc_nth_weekday_of_month_year     (Z_int  *year,       /*  I/O  */
                                        Z_int  *month,      /*  I/O  */
                                        Z_int  *day,        /*   O   */
                                        Z_int   dow,        /*   I   */
                                        Z_int   n);         /*   I   */

boolean
DateCalc_standard_to_business          (Z_int  *year,       /*  I/O  */
                                        Z_int  *week,       /*   O   */
                                        Z_int  *dow,        /*   O   */
                                        Z_int   month,      /*   I   */
                                        Z_int   day);       /*   I   */

boolean
DateCalc_business_to_standard          (Z_int  *year,       /*  I/O  */
                                        Z_int  *month,      /*   O   */
                                        Z_int  *day,        /*   O   */
                                        Z_int   week,       /*   I   */
                                        Z_int   dow);       /*   I   */

Z_long
DateCalc_Delta_Days                    (Z_int   year1,
                                        Z_int   month1,
                                        Z_int   day1,
                                        Z_int   year2,
                                        Z_int   month2,
                                        Z_int   day2);

boolean
DateCalc_delta_dhms                    (Z_long *Dd,         /*   O   */
                                        Z_int  *Dh,         /*   O   */
                                        Z_int  *Dm,         /*   O   */
                                        Z_int  *Ds,         /*   O   */
                                        Z_int   year1,      /*   I   */
                                        Z_int   month1,     /*   I   */
                                        Z_int   day1,       /*   I   */
                                        Z_int   hour1,      /*   I   */
                                        Z_int   min1,       /*   I   */
                                        Z_int   sec1,       /*   I   */
                                        Z_int   year2,      /*   I   */
                                        Z_int   month2,     /*   I   */
                                        Z_int   day2,       /*   I   */
                                        Z_int   hour2,      /*   I   */
                                        Z_int   min2,       /*   I   */
                                        Z_int   sec2);      /*   I   */

boolean
DateCalc_add_delta_days                (Z_int  *year,       /*  I/O  */
                                        Z_int  *month,      /*  I/O  */
                                        Z_int  *day,        /*  I/O  */
                                        Z_long  Dd);        /*   I   */

boolean
DateCalc_add_delta_dhms                (Z_int  *year,       /*  I/O  */
                                        Z_int  *month,      /*  I/O  */
                                        Z_int  *day,        /*  I/O  */
                                        Z_int  *hour,       /*  I/O  */
                                        Z_int  *min,        /*  I/O  */
                                        Z_int  *sec,        /*  I/O  */
                                        Z_long  Dd,         /*   I   */
                                        Z_long  Dh,         /*   I   */
                                        Z_long  Dm,         /*   I   */
                                        Z_long  Ds);        /*   I   */

boolean
DateCalc_add_delta_ymd                 (Z_int  *year,       /*  I/O  */
                                        Z_int  *month,      /*  I/O  */
                                        Z_int  *day,        /*  I/O  */
                                        Z_long  Dy,         /*   I   */
                                        Z_long  Dm,         /*   I   */
                                        Z_long  Dd);        /*   I   */

boolean
DateCalc_system_clock                  (Z_int  *year,       /*   O   */
                                        Z_int  *month,      /*   O   */
                                        Z_int  *day,        /*   O   */
                                        Z_int  *hour,       /*   O   */
                                        Z_int  *min,        /*   O   */
                                        Z_int  *sec,        /*   O   */
                                        Z_int  *doy,        /*   O   */
                                        Z_int  *dow,        /*   O   */
                                        Z_int  *dst);       /*   O   */

boolean
DateCalc_easter_sunday                 (Z_int  *year,       /*  I/O  */
                                        Z_int  *month,      /*   O   */
                                        Z_int  *day);       /*   O   */

Z_int
DateCalc_Decode_Month                  (charptr buffer,
                                        Z_int   length);

Z_int
DateCalc_Decode_Day_of_Week            (charptr buffer,
                                        Z_int   length);

Z_int
DateCalc_Decode_Language               (charptr buffer,
                                        Z_int   length);

boolean
DateCalc_decode_date_eu                (charptr buffer,     /*   I   */
                                        Z_int  *year,       /*   O   */
                                        Z_int  *month,      /*   O   */
                                        Z_int  *day);       /*   O   */

boolean
DateCalc_decode_date_us                (charptr buffer,     /*   I   */
                                        Z_int  *year,       /*   O   */
                                        Z_int  *month,      /*   O   */
                                        Z_int  *day);       /*   O   */

Z_int
DateCalc_Compress                      (Z_int   year,
                                        Z_int   month,
                                        Z_int   day);

boolean
DateCalc_uncompress                    (Z_int   date,       /*   I   */
                                        Z_int  *century,    /*   O   */
                                        Z_int  *year,       /*   O   */
                                        Z_int  *month,      /*   O   */
                                        Z_int  *day);       /*   O   */

boolean
DateCalc_check_compressed              (Z_int   date);

charptr
DateCalc_Compressed_to_Text            (Z_int   date);

charptr
DateCalc_Date_to_Text                  (Z_int   year,
                                        Z_int   month,
                                        Z_int   day);

charptr
DateCalc_Date_to_Text_Long             (Z_int   year,
                                        Z_int   month,
                                        Z_int   day);

charptr                                                     /*   O   */
DateCalc_English_Ordinal               (charptr result,     /*   O   */
                                        Z_int   number);    /*   I   */

charptr
DateCalc_Calendar                      (Z_int   year,
                                        Z_int   month);

void
DateCalc_Dispose                       (charptr string);

charptr
DateCalc_Version                       (void);

/*****************************************************************************/
/*  MODULE RESOURCES:                                                        */
/*****************************************************************************/

#define  DateCalc_YEAR_OF_EPOCH        70    /* year of reference (epoch)    */
#define  DateCalc_CENTURY_OF_EPOCH   1900    /* century of reference (epoch) */
#define  DateCalc_EPOCH (DateCalc_CENTURY_OF_EPOCH + DateCalc_YEAR_OF_EPOCH)

const Z_int DateCalc_Days_in_Year_[2][14] =
{
    { 0, 0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365 },
    { 0, 0, 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335, 366 }
};

const Z_int DateCalc_Days_in_Month_[2][13] =
{
    { 0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 },
    { 0, 31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 }
};

#define DateCalc_LANGUAGES 7

Z_int  DateCalc_Language = 1; /* Default = 1 (English) */

const N_char DateCalc_Month_to_Text_[DateCalc_LANGUAGES+1][13][32] =
{
    {
        "???", "???", "???", "???", "???", "???", "???",
        "???", "???", "???", "???", "???", "???"
    },
    {
        "???", "January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December"
    },
    {
        "???", "Janvier", "Février", "Mars", "Avril", "Mai", "Juin",
        "Juillet", "Août", "Septembre", "Octobre", "Novembre", "Décembre"
    },
    {
        "???", "Januar", "Februar", "März", "April", "Mai", "Juni",
        "Juli", "August", "September", "Oktober", "November", "Dezember"
    },
    {
        "???", "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio",
        "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"
    },
    {
        "???", "Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho",
        "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"
    },
    {
        "???", "Januari", "Februari", "Maart", "April", "Mei", "Juni",
        "Juli", "Augustus", "September", "October", "November", "December"
    },
    {
        "???", "Gennaio", "Febbraio", "Marzo", "Aprile", "Maggio", "Giugno",
        "Luglio", "Agosto", "Settembre", "Ottobre", "Novembre", "Dicembre"
    }
};

const N_char DateCalc_Day_of_Week_to_Text_[DateCalc_LANGUAGES+1][8][32] =
{
    {
        "???", "???", "???", "???",
        "???", "???", "???", "???"
    },
    {
        "???", "Monday", "Tuesday", "Wednesday",
        "Thursday", "Friday", "Saturday", "Sunday"
    },
    {
        "???", "Lundi", "Mardi", "Mercredi",
        "Jeudi", "Vendredi", "Samedi", "Dimanche"
    },
    {
        "???", "Montag", "Dienstag", "Mittwoch",
        "Donnerstag", "Freitag", "Samstag", "Sonntag"
    },
    {
        "???", "Lunes", "Martes", "Miércoles",
        "Jueves", "Viernes", "Sábado", "Domingo"
    },
    {
        "???", "Segunda-feira", "Terça-feira", "Quarta-feira",
        "Quinta-feira", "Sexta-feira", "Sábado", "Domingo"
    },
    {
        "???", "Maandag", "Dinsdag", "Woensdag",
        "Donderdag", "Vrijdag", "Zaterdag", "Zondag"
    },
    {
        "???", "Lunedì", "Martedì", "Mercoledì",
        "Giovedì", "Venerdì", "Sabato", "Domenica"
    }
};

const N_char DateCalc_Day_of_Week_Abbreviation_[DateCalc_LANGUAGES+1][8][4] =

    /* Fill the fields below _only_ if special abbreviations are needed! */
    /* Note that the first field serves as a flag and must be non-empty! */
{
    {
        "", "", "", "", "", "", "", ""    /* 0 */
    },
    {
        "", "", "", "", "", "", "", ""    /* 1 */
    },
    {
        "", "", "", "", "", "", "", ""    /* 2 */
    },
    {
        "", "", "", "", "", "", "", ""    /* 3 */
    },
    {
        "", "", "", "", "", "", "", ""    /* 4 */
    },
    {
        "???", "2ª", "3ª", "4ª", "5ª", "6ª", "Sáb", "Dom"    /* 5 */
    },
    {
        "", "", "", "", "", "", "", ""    /* 6 */
    },
    {
        "", "", "", "", "", "", "", ""    /* 7 */
    }
};

const N_char DateCalc_English_Ordinals_[4][4] =
{
    "th",
    "st",
    "nd",
    "rd"
};

const N_char DateCalc_Date_Long_Format_[DateCalc_LANGUAGES+1][64] =
{
    "%s, %d %s %d",                     /* 0  Default     */
    "%s, %s %s %d",                     /* 1  English     */
    "%s, le %d %s %d",                  /* 2  Français    */
    "%s, den %d. %s %d",                /* 3  Deutsch     */
    "%s, %d de %s de %d",               /* 4  Español     */
    "%s, dia %d de %s de %d",           /* 5  Português   */
    "%s, %d. %s %d",                    /* 6  Nederlands  */
    "%s, %d %s %d"                      /* 7  Italiano    */
};

const N_char DateCalc_Language_to_Text_[DateCalc_LANGUAGES+1][32] =
{
    "???", "English", "Français", "Deutsch", "Español",
    "Português", "Nederlands", "Italiano"
};

/*****************************************************************************/
/*  MODULE IMPLEMENTATION:                                                   */
/*****************************************************************************/

static Z_long DateCalc_Year_to_Days(Z_int year)
{
    Z_long days;

    days = year * 365L;
    days += year >>= 2;
    days -= year /= 25;
    days += year >>  2;
    return(days);
}

static boolean DateCalc_scan9(charptr str, Z_int len, Z_int idx, boolean neg)
{   /* Mnemonic: COBOL "PIC 9" */
    if ((str != NULL) and (idx >= 0) and (idx < len))
      return( (isdigit(str[idx]) != 0) XOR neg );
    else return( false );
}

static boolean DateCalc_scanx(charptr str, Z_int len, Z_int idx, boolean neg)
{   /* Mnemonic: COBOL "PIC X" */
    if ((str != NULL) and (idx >= 0) and (idx < len))
      return( (isalnum(str[idx]) != 0) XOR neg );
    else return( false );
}

static Z_int DateCalc_Str2Int(charptr string, Z_int length)
{
    Z_int number = 0;

    while (length-- > 0)
    {
        if (number) number *= 10;
        number += (Z_int) (*string++ - '0');
    }
    return(number);
}

static void DateCalc_Center(charptr *target, charptr source, Z_int width)
{
    Z_int length;
    Z_int blank;

    length = strlen((char *)source);
    if (length > width) length = width;
    blank = width - length;
    blank >>= 1;
    while (blank-- > 0) *(*target)++ = ' ';
    while (length-- > 0) *(*target)++ = *source++;
    *(*target)++ = '\n';
    *(*target)   = '\0';
}

static void DateCalc_Blank(charptr *target, Z_int count)
{
    while (count-- > 0) *(*target)++ = ' ';
    *(*target) = '\0';
}

static void DateCalc_Newline(charptr *target, Z_int count)
{
    while (count-- > 0) *(*target)++ = '\n';
    *(*target) = '\0';
}

/*****************************************************************************/

boolean DateCalc_leap_year(Z_int year)
{
    Z_int yy;

    return( ((year AND 0x03) == 0) and
            ( (((yy = (Z_int) (year / 100)) * 100) != year) or
              ((yy AND 0x03) == 0) ) );
}

boolean DateCalc_check_date(Z_int year, Z_int month, Z_int day)
{
    if ((year >= 1) and
        (month >= 1) and (month <= 12) and
        (day >= 1) and
        (day <= DateCalc_Days_in_Month_[DateCalc_leap_year(year)][month]))
      return(true);
    else return(false);
}

boolean DateCalc_check_business_date(Z_int year, Z_int week, Z_int dow)
{
    if ((year >= 1) and
        (week >= 1) and (week <= DateCalc_Weeks_in_Year(year)) and
        (dow >= 1) and (dow <= 7))
      return(true);
    else return(false);
}

Z_int DateCalc_Day_of_Year(Z_int year, Z_int month, Z_int day)
{
    boolean leap;

    if ((year >= 1) and
        (month >= 1) and (month <= 12) and
        (day >= 1) and
        (day <= DateCalc_Days_in_Month_[leap=DateCalc_leap_year(year)][month]))
      return( DateCalc_Days_in_Year_[leap][month] + day );
    else return(0);
}

Z_long DateCalc_Date_to_Days(Z_int year, Z_int month, Z_int day)
{
    boolean leap;

    if ((year >= 1) and
        (month >= 1) and (month <= 12) and
        (day >= 1) and
        (day <= DateCalc_Days_in_Month_[leap=DateCalc_leap_year(year)][month]))
      return( DateCalc_Year_to_Days(--year) +
              DateCalc_Days_in_Year_[leap][month] + day );
    else return(0L);
}

Z_int DateCalc_Day_of_Week(Z_int year, Z_int month, Z_int day)
{
    Z_long days;

    days = DateCalc_Date_to_Days(year,month,day);
    if (days > 0L)
    {
        days--;
        days %= 7L;
        days++;
    }
    return( (Z_int) days );
}

Z_int DateCalc_Weeks_in_Year(Z_int year)
{
    return(52 + ((DateCalc_Day_of_Week(year,1,1) == 4) or
                 (DateCalc_Day_of_Week(year,12,31) == 4)));
}

Z_int DateCalc_Week_Number(Z_int year, Z_int month, Z_int day)
{
    Z_int first;

    first = DateCalc_Day_of_Week(year,1,1) - 1;
    return( (Z_int) ( (DateCalc_Delta_Days(year,1,1, year,month,day) +
      first) / 7L ) + (first < 4) );
}

boolean DateCalc_week_of_year(Z_int *week,
                              Z_int *year, Z_int month, Z_int day)
{
    if (DateCalc_check_date(*year,month,day))
    {
        *week = DateCalc_Week_Number(*year,month,day);
        if (*week == 0) *week = DateCalc_Weeks_in_Year(--(*year));
        else if (*week > DateCalc_Weeks_in_Year(*year))
        {
            *week = 1;
            (*year)++;
        }
        return(true);
    }
    else return(false);
}

boolean DateCalc_monday_of_week(Z_int  week,
                                Z_int *year, Z_int *month, Z_int *day)
{
    Z_int first;

    *month = *day = 1;
    first = DateCalc_Day_of_Week(*year,1,1) - 1;
    if (first < 4) week--;
    return(DateCalc_add_delta_days(year,month,day, (week * 7L - first) ));
}

boolean
DateCalc_nth_weekday_of_month_year(Z_int *year, Z_int *month, Z_int *day,
                                   Z_int  dow,  Z_int  n)
{
    Z_int  mm = *month;
    Z_int  first;
    Z_long delta;

    *day = 1;
    if ((*year < 1) or
        (mm < 1) or (mm > 12) or
        (dow < 1) or (dow > 7) or
        (n < 1) or (n > 5))
      return(false);
    first = DateCalc_Day_of_Week(*year,mm,1);
    if (dow < first) dow += 7;
    delta = (Z_long) (dow - first);
    delta += (n-1) * 7L;
    if (DateCalc_add_delta_days(year,month,day,delta) and (*month == mm))
      return(true);
    else return(false);
}

boolean DateCalc_standard_to_business(Z_int *year,  Z_int *week, Z_int *dow,
                                      Z_int  month, Z_int  day)
{
    Z_int yy = *year;

    if (DateCalc_week_of_year(week,year,month,day))
    {
        *dow = DateCalc_Day_of_Week(yy,month,day);
        return(true);
    }
    else return(false);
}

boolean DateCalc_business_to_standard(Z_int *year, Z_int *month, Z_int *day,
                                      Z_int  week, Z_int  dow)
{
    Z_int  first;
    Z_long delta;

    if (DateCalc_check_business_date(*year,week,dow))
    {
        *month = *day = 1;
        first = DateCalc_Day_of_Week(*year,1,1);
        delta = ((week + (first > 4) - 1) * 7L) + (dow - first);
        return( DateCalc_add_delta_days(year,month,day,delta) );
    }
    else return(false);
}

Z_long DateCalc_Delta_Days(Z_int year1, Z_int month1, Z_int day1,
                           Z_int year2, Z_int month2, Z_int day2)
{
    return( DateCalc_Date_to_Days(year2,month2,day2) -
            DateCalc_Date_to_Days(year1,month1,day1) );
}

boolean DateCalc_delta_dhms(Z_long *Dd,
                            Z_int  *Dh,   Z_int *Dm,    Z_int *Ds,
                            Z_int  year1, Z_int month1, Z_int day1,
                            Z_int  hour1, Z_int min1,   Z_int sec1,
                            Z_int  year2, Z_int month2, Z_int day2,
                            Z_int  hour2, Z_int min2,   Z_int sec2)
{
    Z_long  delta;
    Z_long  quot;
    boolean sign;

    *Dd = *Dh = *Dm = *Ds = 0;
    if (DateCalc_check_date(year1,month1,day1) and
        DateCalc_check_date(year2,month2,day2) and
        (hour1 >= 0) and (min1 >= 0) and (sec1 >= 0) and
        (hour2 >= 0) and (min2 >= 0) and (sec2 >= 0) and
        (hour1 < 24) and (min1 < 60) and (sec1 < 60) and
        (hour2 < 24) and (min2 < 60) and (sec2 < 60))
    {
        delta = ((((hour2 * 60L) + min2) * 60L) + sec2) -
                ((((hour1 * 60L) + min1) * 60L) + sec1);
        *Dd = DateCalc_Delta_Days(year1,month1,day1, year2,month2,day2);
        if (*Dd != 0L)
        {
            if (*Dd > 0L)
            {
                if (delta < 0L)
                {
                    delta += 86400L;
                    (*Dd)--;
                }
            }
            else
            {
                if (delta > 0L)
                {
                    delta -= 86400L;
                    (*Dd)++;
                }
            }
        }
        if (delta != 0L)
        {
            sign = false;
            if (delta < 0L)
            {
                sign = true;
                delta = -delta;
            }
            quot  = (Z_long) (delta / 60);
            *Ds   = (Z_int)  (delta - quot * 60L);
            delta = quot;
            quot  = (Z_long) (delta / 60);
            *Dm   = (Z_int)  (delta - quot * 60L);
            *Dh   = (Z_int) quot;
            if (sign)
            {
                *Ds = -(*Ds);
                *Dm = -(*Dm);
                *Dh = -(*Dh);
            }
        }
        return(true);
    }
    else return(false);
}

boolean DateCalc_add_delta_days(Z_int *year, Z_int *month, Z_int *day,
                                                           Z_long Dd)
{
    Z_long  days;
    boolean leap;

    if (((days = DateCalc_Date_to_Days(*year,*month,*day)) > 0L) and
        ((days += Dd) > 0L))
    {
        *year = (Z_int) ( days / 365.2425 );
        *day  = (Z_int) ( days - DateCalc_Year_to_Days(*year) );
        if (*day < 1)
        {
            *day = (Z_int) ( days - DateCalc_Year_to_Days(*year-1) );
        }
        else (*year)++;
        leap = DateCalc_leap_year(*year);
        if (*day > DateCalc_Days_in_Year_[leap][13])
        {
            *day -= DateCalc_Days_in_Year_[leap][13];
            leap  = DateCalc_leap_year(++(*year));
        }
        for ( *month = 12; *month >= 1; (*month)-- )
        {
            if (*day > DateCalc_Days_in_Year_[leap][*month])
            {
                *day -= DateCalc_Days_in_Year_[leap][*month];
                break;
            }
        }
        return(true);
    }
    else return(false);
}

boolean DateCalc_add_delta_dhms(Z_int *year, Z_int *month, Z_int *day,
                                Z_int *hour, Z_int *min,   Z_int *sec,
                                Z_long Dd,
                                Z_long Dh,   Z_long Dm,    Z_long Ds)
{
    Z_long  sum;
    Z_long  quot;

    if (DateCalc_check_date(*year,*month,*day) and
        (*hour >= 0) and (*min >= 0) and (*sec >= 0) and
        (*hour < 24) and (*min < 60) and (*sec < 60))
    {
        /* Prevent overflow errors on systems */
        /* with short "long"s (e.g. 32 bits): */

        quot = (Z_long) (Dh / 24);
        Dh  -= quot * 24L;
        Dd  += quot;
        quot = (Z_long) (Dm / 60);
        Dm  -= quot * 60L;
        Dh  += quot;
        quot = (Z_long) (Ds / 60);
        Ds  -= quot * 60L;
        Dm  += quot;
        quot = (Z_long) (Dm / 60);
        Dm  -= quot * 60L;
        Dh  += quot;
        quot = (Z_long) (Dh / 24);
        Dh  -= quot * 24L;
        Dd  += quot;

        sum = ((((*hour * 60L) + *min) * 60L) + *sec) +
              (((( Dh   * 60L) +  Dm)  * 60L) +  Ds);
        if (sum < 0L)
        {
            quot = (Z_long) (sum / 86400L);
            sum -= quot * 86400L;
            Dd += quot;
            if (sum < 0L)
            {
                sum += 86400L;
                Dd--;
            }
        }
        if (sum > 0L)
        {
            quot  = (Z_long) (sum / 60);
            *sec  = (Z_int)  (sum - quot * 60L);
            sum   = quot;
            quot  = (Z_long) (sum / 60);
            *min  = (Z_int)  (sum - quot * 60L);
            sum   = quot;
            quot  = (Z_long) (sum / 24);
            *hour = (Z_int)  (sum - quot * 24L);
            Dd   += quot;
        }
        else
        {
            *hour = *min = *sec = 0;
        }
        return(DateCalc_add_delta_days(year,month,day,Dd));
    }
    else return(false);
}

boolean DateCalc_add_delta_ymd(Z_int *year, Z_int *month, Z_int *day,
                               Z_long Dy,   Z_long Dm,    Z_long Dd)
{
    Z_long delta = 0L;

    if (not DateCalc_check_date(*year,*month,*day)) return(false);
    if ((Dd != 0L) and not DateCalc_add_delta_days(year,month,day,Dd))
      return(false);
    if (Dm != 0L)
    {
        Dm   += (Z_long) (*month - 1);
        delta = (Z_long) (Dm / 12);
        Dm   -= delta * 12L;
        if (Dm < 0L)
        {
            Dm += 12L;
            delta--;
        }
        *month = (Z_int) (Dm + 1);
    }
    Dy += delta + *year;
    if (Dy >= 1)
    {
        *year = (Z_int) Dy;
        if (*day >
            (Dd = DateCalc_Days_in_Month_[DateCalc_leap_year(*year)][*month]))
        {
            *day = Dd;
        }
        return(true);
    }
    else return(false);
}

boolean DateCalc_system_clock(Z_int *year, Z_int *month, Z_int *day,
                              Z_int *hour, Z_int *min,   Z_int *sec,
                              Z_int *doy,  Z_int *dow,   Z_int *dst)
{
    time_t seconds;
    struct tm *date;

    if (time(&seconds) > 0)
    {
        date   = localtime(&seconds);
        *year  = (*date).tm_year + 1900;
        *month = (*date).tm_mon + 1;
        *day   = (*date).tm_mday;
        *hour  = (*date).tm_hour;
        *min   = (*date).tm_min;
        *sec   = (*date).tm_sec;
        *doy   = (*date).tm_yday + 1;
        *dow   = (*date).tm_wday; if (*dow == 0) *dow = 7;
        *dst   = (*date).tm_isdst;
        if (*dst != 0)
        {
            if (*dst < 0) *dst = -1;
            else          *dst =  1;
        }
        return(true);
    }
    else return(false);
}

boolean DateCalc_easter_sunday(Z_int *year, Z_int *month, Z_int *day)
{
    /****************************************************************/
    /*                                                              */
    /*  Gauss'sche Regel (Gaussian Rule)                            */
    /*  ================================                            */
    /*                                                              */
    /*  Quelle / Source:                                            */
    /*                                                              */
    /*  H. H. Voigt, "Abriss der Astronomie", Wissenschaftsverlag,  */
    /*  Bibliographisches Institut, Seite 9.                        */
    /*                                                              */
    /****************************************************************/

    Z_int a, b, c, d, e, m, n;

    if ((*year < 1583) or (*year > 2299)) return(false);

    if      (*year < 1700) { m = 22; n = 2; }
    else if (*year < 1800) { m = 23; n = 3; }
    else if (*year < 1900) { m = 23; n = 4; }
    else if (*year < 2100) { m = 24; n = 5; }
    else if (*year < 2200) { m = 24; n = 6; }
    else                   { m = 25; n = 0; }

    a = *year % 19;
    b = *year % 4;
    c = *year % 7;
    d = (19 * a + m) % 30;
    e = (2 * b + 4 * c + 6 * d + n) % 7;
    *day = 22 + d + e;
    *month = 3;
    if (*day > 31)
    {
        *day -= 31; /* same as *day = d + e - 9; */
        (*month)++;
    }
    if ((*day == 26) and (*month == 4)) *day = 19;
    if ((*day == 25) and (*month == 4) and
        (d == 28) and (e == 6) and (a > 10)) *day = 18;
    return(true);
}

/*  Carnival Monday / Rosenmontag / Veille du Mardi Gras   =  easter sunday - 48  */
/*  Mardi Gras / Karnevalsdienstag / Mardi Gras            =  easter sunday - 47  */
/*  Ash Wednesday / Aschermittwoch / Mercredi des Cendres  =  easter sunday - 46  */
/*  Palm Sunday / Palmsonntag / Dimanche des Rameaux       =  easter sunday - 7   */
/*  Easter Friday / Karfreitag / Vendredi Saint            =  easter sunday - 2   */
/*  Easter Saturday / Ostersamstag / Samedi de Paques      =  easter sunday - 1   */
/*  Easter Monday / Ostermontag / Lundi de Paques          =  easter sunday + 1   */
/*  Ascension of Christ / Christi Himmelfahrt / Ascension  =  easter sunday + 39  */
/*  Whitsunday / Pfingstsonntag / Dimanche de Pentecote    =  easter sunday + 49  */
/*  Whitmonday / Pfingstmontag / Lundi de Pentecote        =  easter sunday + 50  */
/*  Feast of Corpus Christi / Fronleichnam / Fete-Dieu     =  easter sunday + 60  */

Z_int DateCalc_Decode_Month(charptr buffer, Z_int length) /* 0 = error */
{
    Z_int   i,j;
    Z_int   month;
    boolean same;
    boolean ok;

/*****************************************************************************/
/*  BEWARE that the parameter "length" must always be set in such a way      */
/*  so that the string in "buffer[0]" up to "buffer[length-1]" does not      */
/*  contain any terminating null character '\0'. Otherwise this routine      */
/*  may read beyond allocated memory, probably resulting in an access        */
/*  violation and program abortion. This problem cannot arise, for example,  */
/*  if you use the library function "strlen" to determine the length         */
/*  "length" of the string in "buffer".                                      */
/*****************************************************************************/

    month = 0;
    ok = true;
    for ( i = 1; ok and (i <= 12); i++ )
    {
        same = true;
        for ( j = 0; same and (j < length); j++ )
        {
            same = ( toupper(buffer[j]) ==
                     toupper(DateCalc_Month_to_Text_[DateCalc_Language][i][j]) );
        }
        if (same)
        {
            if (month > 0) ok = false;
            else           month = i;
        }
    }
    if (ok) return(month);
    else return(0);
}

Z_int DateCalc_Decode_Day_of_Week(charptr buffer, Z_int length) /* 0 = error */
{
    Z_int   i,j;
    Z_int   day;
    boolean same;
    boolean ok;

/*****************************************************************************/
/*  BEWARE that the parameter "length" must always be set in such a way      */
/*  so that the string in "buffer[0]" up to "buffer[length-1]" does not      */
/*  contain any terminating null character '\0'. Otherwise this routine      */
/*  may read beyond allocated memory, probably resulting in an access        */
/*  violation and program abortion. This problem cannot arise, for example,  */
/*  if you use the library function "strlen" to determine the length         */
/*  "length" of the string in "buffer".                                      */
/*****************************************************************************/

    day = 0;
    ok = true;
    for ( i = 1; ok and (i <= 7); i++ )
    {
        same = true;
        for ( j = 0; same and (j < length); j++ )
        {
            same = ( toupper(buffer[j]) ==
                     toupper(DateCalc_Day_of_Week_to_Text_[DateCalc_Language][i][j]) );
        }
        if (same)
        {
            if (day > 0) ok = false;
            else         day = i;
        }
    }
    if (ok) return(day);
    else return(0);
}

Z_int DateCalc_Decode_Language(charptr buffer, Z_int length) /* 0 = error */
{
    Z_int   i,j;
    Z_int   lang;
    boolean same;
    boolean ok;

/*****************************************************************************/
/*  BEWARE that the parameter "length" must always be set in such a way      */
/*  so that the string in "buffer[0]" up to "buffer[length-1]" does not      */
/*  contain any terminating null character '\0'. Otherwise this routine      */
/*  may read beyond allocated memory, probably resulting in an access        */
/*  violation and program abortion. This problem cannot arise, for example,  */
/*  if you use the library function "strlen" to determine the length         */
/*  "length" of the string in "buffer".                                      */
/*****************************************************************************/

    lang = 0;
    ok = true;
    for ( i = 1; ok and (i <= DateCalc_LANGUAGES); i++ )
    {
        same = true;
        for ( j = 0; same and (j < length); j++ )
        {
            same = ( toupper(buffer[j]) ==
                     toupper(DateCalc_Language_to_Text_[i][j]) );
        }
        if (same)
        {
            if (lang > 0) ok = false;
            else          lang = i;
        }
    }
    if (ok) return(lang);
    else return(0);
}

boolean DateCalc_decode_date_eu(charptr buffer,
                                Z_int *year, Z_int *month, Z_int *day)
{
    Z_int   i,j;
    Z_int   length;

    *year = *month = *day = 0;
    length = strlen((char *)buffer);
    if (length > 0)
    {
        i = 0;
        while (DateCalc_scan9(buffer,length,i,true)) i++;
        j = length-1;
        while (DateCalc_scan9(buffer,length,j,true)) j--;
        if (i+1 < j)        /* at least 3 chars, else error! */
        {
            buffer += i;
            length = j-i+1;
            i = 1;
            while (DateCalc_scan9(buffer,length,i,false)) i++;
            j = length-2;
            while (DateCalc_scan9(buffer,length,j,false)) j--;
            if (j < i)  /* only numerical chars without delimiters */
            {
                switch (length)
                {
                case 3:
                    *day   = DateCalc_Str2Int(buffer,  1);
                    *month = DateCalc_Str2Int(buffer+1,1);
                    *year  = DateCalc_Str2Int(buffer+2,1);
                    break;
                case 4:
                    *day   = DateCalc_Str2Int(buffer,  1);
                    *month = DateCalc_Str2Int(buffer+1,1);
                    *year  = DateCalc_Str2Int(buffer+2,2);
                    break;
                case 5:
                    *day   = DateCalc_Str2Int(buffer,  1);
                    *month = DateCalc_Str2Int(buffer+1,2);
                    *year  = DateCalc_Str2Int(buffer+3,2);
                    break;
                case 6:
                    *day   = DateCalc_Str2Int(buffer,  2);
                    *month = DateCalc_Str2Int(buffer+2,2);
                    *year  = DateCalc_Str2Int(buffer+4,2);
                    break;
                case 7:
                    *day   = DateCalc_Str2Int(buffer,  1);
                    *month = DateCalc_Str2Int(buffer+1,2);
                    *year  = DateCalc_Str2Int(buffer+3,4);
                    break;
                case 8:
                    *day   = DateCalc_Str2Int(buffer,  2);
                    *month = DateCalc_Str2Int(buffer+2,2);
                    *year  = DateCalc_Str2Int(buffer+4,4);
                    break;
                default:
                    return(false);
                    break;
                }
            }
            else        /* at least one non-numerical char (i <= j) */
            {
                *day  = DateCalc_Str2Int(buffer,i);
                *year = DateCalc_Str2Int(buffer+(j+1),length-(j+1));
                while (DateCalc_scanx(buffer,length,i,true)) i++;
                while (DateCalc_scanx(buffer,length,j,true)) j--;
                if (i <= j)         /* at least one char left for month */
                {
                    buffer += i;
                    length = j-i+1;
                    i = 1;
                    while (DateCalc_scanx(buffer,length,i,false)) i++;
                    if (i >= length)    /* ok, no more delimiters */
                    {
                        i = 0;
                        while (DateCalc_scan9(buffer,length,i,false)) i++;
                        if (i >= length) /* only digits for month */
                        {
                            *month = DateCalc_Str2Int(buffer,length);
                        }
                        else             /* match with month names */
                        {
                            *month = DateCalc_Decode_Month(buffer,length);
                        }
                    }
                    else return(false); /* delimiters inside month string */
                }
                else return(false); /* no chars left for month */
            }           /* at least one non-numerical char (i <= j) */
        }
        else return(false); /* less than 3 chars in buffer */
    }
    else return(false); /* length <= 0 */
    if (*year < 100)
    {
        if (*year < DateCalc_YEAR_OF_EPOCH) *year += 100;
        *year += DateCalc_CENTURY_OF_EPOCH;
    }
    return(DateCalc_check_date(*year,*month,*day));
}

boolean DateCalc_decode_date_us(charptr buffer,
                                Z_int *year, Z_int *month, Z_int *day)
{
    Z_int   i,j,k;
    Z_int   length;

    *year = *month = *day = 0;
    length = strlen((char *)buffer);
    if (length > 0)
    {
        i = 0;
        while (DateCalc_scanx(buffer,length,i,true)) i++;
        j = length-1;
        while (DateCalc_scan9(buffer,length,j,true)) j--;
        if (i+1 < j)        /* at least 3 chars, else error! */
        {
            buffer += i;
            length = j-i+1;
            i = 1;
            while (DateCalc_scanx(buffer,length,i,false)) i++;
            j = length-2;
            while (DateCalc_scan9(buffer,length,j,false)) j--;
            if (i >= length)  /* only alphanumeric chars left */
            {
                if (j < 0) /* case 0 : xxxx999999xxxx */
                {          /*             j0     i    */
                    switch (length)
                    {
                    case 3:
                        *month = DateCalc_Str2Int(buffer,  1);
                        *day   = DateCalc_Str2Int(buffer+1,1);
                        *year  = DateCalc_Str2Int(buffer+2,1);
                        break;
                    case 4:
                        *month = DateCalc_Str2Int(buffer,  1);
                        *day   = DateCalc_Str2Int(buffer+1,1);
                        *year  = DateCalc_Str2Int(buffer+2,2);
                        break;
                    case 5:
                        *month = DateCalc_Str2Int(buffer,  1);
                        *day   = DateCalc_Str2Int(buffer+1,2);
                        *year  = DateCalc_Str2Int(buffer+3,2);
                        break;
                    case 6:
                        *month = DateCalc_Str2Int(buffer,  2);
                        *day   = DateCalc_Str2Int(buffer+2,2);
                        *year  = DateCalc_Str2Int(buffer+4,2);
                        break;
                    case 7:
                        *month = DateCalc_Str2Int(buffer,  1);
                        *day   = DateCalc_Str2Int(buffer+1,2);
                        *year  = DateCalc_Str2Int(buffer+3,4);
                        break;
                    case 8:
                        *month = DateCalc_Str2Int(buffer,  2);
                        *day   = DateCalc_Str2Int(buffer+2,2);
                        *year  = DateCalc_Str2Int(buffer+4,4);
                        break;
                    default:
                        return(false);
                        break;
                    }
                }
                else       /* case 1 : xxxxAAA999999xxxx */
                {          /*              0 j      i    */
                    *month = DateCalc_Decode_Month(buffer,j+1);
                    buffer += j+1;
                    length -= j+1;
                    switch (length)
                    {
                    case 2:
                        *day  = DateCalc_Str2Int(buffer,  1);
                        *year = DateCalc_Str2Int(buffer+1,1);
                        break;
                    case 3:
                        *day  = DateCalc_Str2Int(buffer,  1);
                        *year = DateCalc_Str2Int(buffer+1,2);
                        break;
                    case 4:
                        *day  = DateCalc_Str2Int(buffer,  2);
                        *year = DateCalc_Str2Int(buffer+2,2);
                        break;
                    case 5:
                        *day  = DateCalc_Str2Int(buffer,  1);
                        *year = DateCalc_Str2Int(buffer+1,4);
                        break;
                    case 6:
                        *day  = DateCalc_Str2Int(buffer,  2);
                        *year = DateCalc_Str2Int(buffer+2,4);
                        break;
                    default:
                        return(false);
                        break;
                    }
                }
            }              /*              0  i  j    l         */
            else           /* case 2 : xxxxAAAxxxx9999xxxx _OR_ */
            {              /* case 3 : xxxxAAAxx99xx9999xx      */
                k = 0;     /*              0  i    j    l       */
                while (DateCalc_scan9(buffer,length,k,false)) k++;
                if (k >= i) /* ok, only digits */
                {
                    *month = DateCalc_Str2Int(buffer,i);
                }
                else       /* no, some non-digits */
                {
                    *month = DateCalc_Decode_Month(buffer,i);
                    if (*month == 0) return(false);
                }
                buffer += i;
                length -= i;
                j -= i;
                k = j+1; /* remember start posn of day+year(2)/year(3) */
                i = 1;
                while (DateCalc_scanx(buffer,length,i,true)) i++;
                j--;
                while (DateCalc_scan9(buffer,length,j,true)) j--;
                if (j < i) /* case 2 : xxxxAAAxxxx9999xxxx */
                {          /*                j0   i   l    */
                    buffer += k;    /*            k        */
                    length -= k;
                    switch (length)
                    {
                    case 2:
                        *day  = DateCalc_Str2Int(buffer,  1);
                        *year = DateCalc_Str2Int(buffer+1,1);
                        break;
                    case 3:
                        *day  = DateCalc_Str2Int(buffer,  1);
                        *year = DateCalc_Str2Int(buffer+1,2);
                        break;
                    case 4:
                        *day  = DateCalc_Str2Int(buffer,  2);
                        *year = DateCalc_Str2Int(buffer+2,2);
                        break;
                    case 5:
                        *day  = DateCalc_Str2Int(buffer,  1);
                        *year = DateCalc_Str2Int(buffer+1,4);
                        break;
                    case 6:
                        *day  = DateCalc_Str2Int(buffer,  2);
                        *year = DateCalc_Str2Int(buffer+2,4);
                        break;
                    default:
                        return(false);
                        break;
                    }
                }
                else       /* case 3 : xxxxAAAxx99xx9999xx */
                {          /*                 0 ij  k   l  */
                    *year = DateCalc_Str2Int(buffer+k,length-k);
                    k = i;
                    while (DateCalc_scan9(buffer,length,k,false)) k++;
                    if (k > j)          /* ok, only digits */
                    {
                        *day = DateCalc_Str2Int(buffer+i,j-i+1);
                    }
                    else return(false); /* non-digits inside day */
                }
            }                 /* i < length */
        }
        else return(false); /* less than 3 chars in buffer */
    }
    else return(false); /* length <= 0 */
    if (*year < 100)
    {
        if (*year < DateCalc_YEAR_OF_EPOCH) *year += 100;
        *year += DateCalc_CENTURY_OF_EPOCH;
    }
    return(DateCalc_check_date(*year,*month,*day));
}

Z_int DateCalc_Compress(Z_int year, Z_int month, Z_int day)
{
    Z_int yy;

    if ((year >= DateCalc_EPOCH) and (year < (DateCalc_EPOCH + 100)))
    {
        yy = year;
        year -= DateCalc_EPOCH;
    }
    else
    {
        if ((year < 0) or (year > 99)) return(0);
        if (year < DateCalc_YEAR_OF_EPOCH)
        {
            yy = DateCalc_CENTURY_OF_EPOCH + 100 + year;
            year += 100 - DateCalc_YEAR_OF_EPOCH;
        }
        else
        {
            yy = DateCalc_CENTURY_OF_EPOCH + year;
            year -= DateCalc_YEAR_OF_EPOCH;
        }
    }
    if ((month < 1) or (month > 12)) return(0);
    if ((day < 1) or
        (day > DateCalc_Days_in_Month_[DateCalc_leap_year(yy)][month]))
      return(0);
    return( (year SHL 9) OR (month SHL 5) OR day );
}

boolean
DateCalc_uncompress(Z_int date,
                    Z_int *century, Z_int *year, Z_int *month, Z_int *day)
{
    if (date > 0)
    {
        *year  =  date SHR 9;
        *month = (date AND 0x01FF) SHR 5;
        *day   =  date AND 0x001F;

        if (*year < 100)
        {
            if (*year < 100-DateCalc_YEAR_OF_EPOCH)
            {
                *century = DateCalc_CENTURY_OF_EPOCH;
                *year += DateCalc_YEAR_OF_EPOCH;
            }
            else
            {
                *century = DateCalc_CENTURY_OF_EPOCH+100;
                *year -= 100-DateCalc_YEAR_OF_EPOCH;
            }
            return(DateCalc_check_date(*century+*year,*month,*day));
        }
        else return(false);
    }
    else return(false);
}

boolean DateCalc_check_compressed(Z_int date)
{
    Z_int century;
    Z_int year;
    Z_int month;
    Z_int day;

    return(DateCalc_uncompress(date,&century,&year,&month,&day));
}

charptr DateCalc_Compressed_to_Text(Z_int date)
{
    Z_int   century;
    Z_int   year;
    Z_int   month;
    Z_int   day;
    charptr string;

    string = (charptr) malloc(16);
    if (string == NULL) return(NULL);
    if (DateCalc_uncompress(date,&century,&year,&month,&day))
      sprintf((char *)string,"%02d-%.3s-%02d",day,
        DateCalc_Month_to_Text_[DateCalc_Language][month],year);
    else
      sprintf((char *)string,"??""-???""-??");
        /* prevent interpretation as trigraphs */
    return(string);
}

charptr DateCalc_Date_to_Text(Z_int year, Z_int month, Z_int day)
{
    charptr string;

    if (DateCalc_check_date(year,month,day) and
        ((string = (charptr) malloc(32)) != NULL))
    {
        if (DateCalc_Day_of_Week_Abbreviation_[DateCalc_Language][0][0] != '\0')
        {
            sprintf((char *)string,"%.3s %d-%.3s-%d",
              DateCalc_Day_of_Week_Abbreviation_[DateCalc_Language][DateCalc_Day_of_Week(year,month,day)],
              day,DateCalc_Month_to_Text_[DateCalc_Language][month],year);
            return(string);
        }
        else
        {
            sprintf((char *)string,"%.3s %d-%.3s-%d",
              DateCalc_Day_of_Week_to_Text_[DateCalc_Language][DateCalc_Day_of_Week(year,month,day)],
              day,DateCalc_Month_to_Text_[DateCalc_Language][month],year);
            return(string);
        }
    }
    else return(NULL);
}

charptr DateCalc_English_Ordinal(charptr result, Z_int number)
{
    N_int length;
    N_int digit;

    sprintf((char *)result, "%d", number);
    if (length = strlen((char *)result))
    {
        if ( not
             (
               ( ((length > 1) and (result[length-2] != '1')) or (length == 1) )
               and
               ( (digit = (N_int)(result[length-1] XOR '0')) <= 3 )
             )
           )
        {
            digit = 0;
        }
        sprintf( (char *)(result+length), "%s",
            DateCalc_English_Ordinals_[digit] );
    }
    return(result);
}

charptr DateCalc_Date_to_Text_Long(Z_int year, Z_int month, Z_int day)
{
    charptr string;
    blockdef(buffer,64);

    if (DateCalc_check_date(year,month,day) and
        ((string = (charptr) malloc(64)) != NULL))
    {
        switch (DateCalc_Language)
        {
            case 1:
                sprintf(
                    (char *)string,
                    (char *)DateCalc_Date_Long_Format_[DateCalc_Language],
                    DateCalc_Day_of_Week_to_Text_[DateCalc_Language]
                        [DateCalc_Day_of_Week(year,month,day)],
                    DateCalc_Month_to_Text_[DateCalc_Language][month],
                    DateCalc_English_Ordinal(buffer,day),
                    year );
                break;
            default:
                sprintf(
                    (char *)string,
                    (char *)DateCalc_Date_Long_Format_[DateCalc_Language],
                    DateCalc_Day_of_Week_to_Text_[DateCalc_Language]
                        [DateCalc_Day_of_Week(year,month,day)],
                    day,
                    DateCalc_Month_to_Text_[DateCalc_Language][month],
                    year );
                break;
        }
        return(string);
    }
    else return(NULL);
}

charptr DateCalc_Calendar(Z_int year, Z_int month)
{
    blockdef(buffer,30);
    charptr string;
    charptr cursor;
    Z_int first;
    Z_int last;
    Z_int day;

    string = (charptr) malloc(256);
    if (string == NULL) return(NULL);
    cursor = string;
    DateCalc_Newline(&cursor,1);
    sprintf((char *)buffer,"%s %d",
      DateCalc_Month_to_Text_[DateCalc_Language][month],year);
    DateCalc_Center(&cursor,buffer,27);
    if (DateCalc_Day_of_Week_Abbreviation_[DateCalc_Language][0][0] != '\0')
    {
        sprintf((char *)cursor,"%3.3s %3.3s %3.3s %3.3s %3.3s %3.3s %3.3s\n",
          DateCalc_Day_of_Week_Abbreviation_[DateCalc_Language][1],
          DateCalc_Day_of_Week_Abbreviation_[DateCalc_Language][2],
          DateCalc_Day_of_Week_Abbreviation_[DateCalc_Language][3],
          DateCalc_Day_of_Week_Abbreviation_[DateCalc_Language][4],
          DateCalc_Day_of_Week_Abbreviation_[DateCalc_Language][5],
          DateCalc_Day_of_Week_Abbreviation_[DateCalc_Language][6],
          DateCalc_Day_of_Week_Abbreviation_[DateCalc_Language][7]);
    }
    else
    {
        sprintf((char *)cursor,"%3.3s %3.3s %3.3s %3.3s %3.3s %3.3s %3.3s\n",
          DateCalc_Day_of_Week_to_Text_[DateCalc_Language][1],
          DateCalc_Day_of_Week_to_Text_[DateCalc_Language][2],
          DateCalc_Day_of_Week_to_Text_[DateCalc_Language][3],
          DateCalc_Day_of_Week_to_Text_[DateCalc_Language][4],
          DateCalc_Day_of_Week_to_Text_[DateCalc_Language][5],
          DateCalc_Day_of_Week_to_Text_[DateCalc_Language][6],
          DateCalc_Day_of_Week_to_Text_[DateCalc_Language][7]);
    }
    cursor += 28;
    first = DateCalc_Day_of_Week(year,month,1);
    last = DateCalc_Days_in_Month_[DateCalc_leap_year(year)][month];
    if (--first > 0) DateCalc_Blank(&cursor,(first<<2)-1);
    for ( day = 1; day <= last; day++, first++ )
    {
        if (first > 0)
        {
            if (first > 6)
            {
                first = 0;
                DateCalc_Newline(&cursor,1);
            }
            else DateCalc_Blank(&cursor,1);
        }
        sprintf((char *)cursor," %2d",day);
        cursor += 3;
    }
    DateCalc_Newline(&cursor,2);
    return(string);
}

void DateCalc_Dispose(charptr string)
{
    free((voidptr) string);
}

charptr DateCalc_Version(void)
{
    return((charptr)"4.3");
}

/*****************************************************************************/
/*  VERSION:  4.3                                                            */
/*****************************************************************************/
/*  VERSION HISTORY:                                                         */
/*****************************************************************************/
/*                                                                           */
/*    Version 4.3   08.01.00  decode_date_??: (yy < 70 ? 20yy : 19yy)        */
/*    Version 4.2   07.09.98  No changes.                                    */
/*    Version 4.1   08.06.98  Fixed bug in "add_delta_ymd()".                */
/*    Version 4.0   12.05.98  Major rework. Added multi-language support.    */
/*    Version 3.2   15.06.97  Added "week_of_year()".                        */
/*    Version 3.1   12.06.97  No significant changes.                        */
/*    Version 3.0   16.02.97  Changed conventions for unsuccessful returns.  */
/*    Version 2.3   22.11.96  Fixed unbalanced "malloc" and "free".          */
/*    Version 2.2   26.05.96  No significant changes.                        */
/*    Version 2.1   26.05.96  Fixed HH MM SS parameter checks.               */
/*    Version 2.0   25.05.96  Added time calculations. Major rework.         */
/*    Version 1.6   20.04.96  Not published.                                 */
/*    Version 1.5   14.03.96  No significant changes.                        */
/*    Version 1.4   11.02.96  No significant changes.                        */
/*    Version 1.3   10.12.95  Added "days_in_month()".                       */
/*    Version 1.2b  27.11.95  No significant changes.                        */
/*    Version 1.2a  21.11.95  Fix for type name clashes.                     */
/*    Version 1.1   18.11.95  Fix for type name clashes.                     */
/*    Version 1.01  16.11.95  Improved compliance w/ programming standards.  */
/*    Version 1.0   14.11.95  First version under UNIX (with Perl module).   */
/*    Version 0.9   01.11.93  First version of C library under MS-DOS.       */
/*                                                                           */
/*****************************************************************************/
/*  AUTHOR:                                                                  */
/*****************************************************************************/
/*                                                                           */
/*    Steffen Beyer                                                          */
/*    Ainmillerstr. 5 / App. 513                                             */
/*    D-80801 Munich                                                         */
/*    Germany                                                                */
/*                                                                           */
/*    mailto:sb@engelschall.com                                              */
/*    http://www.engelschall.com/u/sb/download/                              */
/*                                                                           */
/*****************************************************************************/
/*  COPYRIGHT:                                                               */
/*****************************************************************************/
/*                                                                           */
/*    Copyright (c) 1993 - 2000 by Steffen Beyer.                            */
/*    All rights reserved.                                                   */
/*                                                                           */
/*****************************************************************************/
/*  LICENSE:                                                                 */
/*****************************************************************************/
/*                                                                           */
/*    This library is free software; you can redistribute it and/or          */
/*    modify it under the terms of the GNU Library General Public            */
/*    License as published by the Free Software Foundation; either           */
/*    version 2 of the License, or (at your option) any later version.       */
/*                                                                           */
/*    This library is distributed in the hope that it will be useful,        */
/*    but WITHOUT ANY WARRANTY; without even the implied warranty of         */
/*    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU       */
/*    Library General Public License for more details.                       */
/*                                                                           */
/*    You should have received a copy of the GNU Library General Public      */
/*    License along with this library; if not, write to the                  */
/*    Free Software Foundation, Inc.,                                        */
/*    59 Temple Place, Suite 330, Boston, MA 02111-1307 USA                  */
/*    or download a copy from ftp://ftp.gnu.org/pub/gnu/COPYING.LIB-2.0      */
/*                                                                           */
/*****************************************************************************/
#endif
