#ifndef MODULE_DATE_CALC
#define MODULE_DATE_CALC
/*****************************************************************************/
/*  MODULE NAME:  DateCalc.c                            MODULE TYPE:  (lib)  */
/*****************************************************************************/
/*  Date calculations complying with ISO/R 2015-1971 and DIN 1355 standards  */
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

boolean DateCalc_leap_year          (Z_int year);

boolean DateCalc_check_date         (Z_int year,  Z_int mm,  Z_int dd);

Z_int   DateCalc_Day_of_Year        (Z_int year,  Z_int mm,  Z_int dd);

Z_long  DateCalc_Date_to_Days       (Z_int year,  Z_int mm,  Z_int dd);

Z_int   DateCalc_Day_of_Week        (Z_int year,  Z_int mm,  Z_int dd);

Z_int   DateCalc_Weeks_in_Year      (Z_int year);

Z_int   DateCalc_Week_Number        (Z_int year,  Z_int mm,  Z_int dd);

boolean DateCalc_week_of_year       (Z_int *week,
                                     Z_int *year, Z_int mm,  Z_int dd);

boolean DateCalc_monday_of_week     (Z_int week,
                                     Z_int *year, Z_int *mm, Z_int *dd);

boolean DateCalc_nth_weekday_of_month_year
                                    (Z_int *year, Z_int *mm, Z_int *dd,
                                     Z_int dow,   Z_int n);

Z_long  DateCalc_Delta_Days         (Z_int year1, Z_int mm1, Z_int dd1,
                                     Z_int year2, Z_int mm2, Z_int dd2);

boolean DateCalc_delta_dhms
(
    Z_long *Dd,
    Z_int  *Dh,   Z_int *Dm,  Z_int *Ds,
    Z_int  year1, Z_int mm1,  Z_int dd1,
    Z_int  h1,    Z_int m1,   Z_int s1,
    Z_int  year2, Z_int mm2,  Z_int dd2,
    Z_int  h2,    Z_int m2,   Z_int s2
);

boolean DateCalc_add_delta_days     (Z_int *year, Z_int *mm, Z_int *dd,
                                     Z_long Dd);

boolean DateCalc_add_delta_dhms
(
    Z_int *year, Z_int *mm,  Z_int *dd,
    Z_int *h,    Z_int *m,   Z_int *s,
    Z_long Dd,
    Z_long Dh,   Z_long Dm,  Z_long Ds
);

boolean DateCalc_add_delta_ymd      (Z_int *year, Z_int *mm, Z_int *dd,
                                     Z_long Dy,   Z_long Dm, Z_long Dd);

boolean DateCalc_system_clock       (Z_int *year, Z_int *mm, Z_int *dd,
                                     Z_int *h,    Z_int *m,  Z_int *s,
                                     Z_int *doy,  Z_int *dow,Z_int *dst);

boolean DateCalc_easter_sunday      (Z_int *year, Z_int *mm, Z_int *dd);

Z_int   DateCalc_Decode_Month       (charptr buffer, Z_int len);

Z_int   DateCalc_Decode_Day_of_Week (charptr buffer, Z_int len);

Z_int   DateCalc_Decode_Language    (charptr buffer, Z_int len);

boolean DateCalc_decode_date_eu     (charptr buffer,
                                     Z_int *year, Z_int *mm, Z_int *dd);

boolean DateCalc_decode_date_us     (charptr buffer,
                                     Z_int *year, Z_int *mm, Z_int *dd);

Z_int   DateCalc_Compress           (Z_int yy,    Z_int mm,  Z_int dd);

boolean DateCalc_uncompress         (Z_int date,  Z_int *cc,
                                     Z_int *yy,   Z_int *mm, Z_int *dd);

boolean DateCalc_check_compressed   (Z_int date);

charptr DateCalc_Compressed_to_Text (Z_int date);

charptr DateCalc_Date_to_Text       (Z_int year,  Z_int mm,  Z_int dd);

charptr DateCalc_Date_to_Text_Long  (Z_int year,  Z_int mm,  Z_int dd);

charptr DateCalc_Calendar           (Z_int year,  Z_int mm);

void    DateCalc_Dispose            (charptr string);

charptr DateCalc_Version            (void);

/*****************************************************************************/
/*  MODULE RESOURCES:                                                        */
/*****************************************************************************/

#define  DateCalc_YEAR_OF_EPOCH        70    /* year of reference (epoch)    */
#define  DateCalc_CENTURY_OF_EPOCH   1900    /* century of reference (epoch) */
#define  DateCalc_EPOCH (DateCalc_CENTURY_OF_EPOCH + DateCalc_YEAR_OF_EPOCH)

Z_int DateCalc_Days_in_Year_[2][14] =
{
    { 0, 0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365 },
    { 0, 0, 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335, 366 }
};

Z_int DateCalc_Days_in_Month_[2][13] =
{
    { 0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 },
    { 0, 31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 }
};

#define DateCalc_LANGUAGES 6

Z_int  DateCalc_Language = 1; /* Default = 1 (English) */

N_char DateCalc_Month_to_Text_[DateCalc_LANGUAGES+1][13][32] =
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
    }
};

N_char DateCalc_Day_of_Week_to_Text_[DateCalc_LANGUAGES+1][8][32] =
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
    }
};

N_char DateCalc_Day_of_Week_Abbreviation_[DateCalc_LANGUAGES+1][8][4] =

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
    }
};

N_char DateCalc_Language_to_Text_[DateCalc_LANGUAGES+1][32] =
{
    "???", "English", "Français", "Deutsch", "Español", "Português", "Nederlands"
};

/*****************************************************************************/
/*  MODULE IMPLEMENTATION:                                                   */
/*****************************************************************************/

static Z_long DateCalc_Year_to_Days(Z_int year)
{
    return( year * 365L + (year / 4) - (year / 100) + (year / 400) );
}

static boolean DateCalc_scan9(charptr s, Z_int len, Z_int i, boolean neg)
{
    if ((s != NULL) and (i >= 0) and (i < len))
        return( (isdigit(s[i]) != 0) XOR neg );
    else
        return( false );
} /* Believe it or not, name was inspired by COBOL "PIC 9" :-) */

static boolean DateCalc_scanx(charptr s, Z_int len, Z_int i, boolean neg)
{
    if ((s != NULL) and (i >= 0) and (i < len))
        return( (isalnum(s[i]) != 0) XOR neg );
    else
        return( false );
} /* Believe it or not, name was inspired by COBOL "PIC X" :-) */

static Z_int DateCalc_Str2Int(charptr string, Z_int len)
{
    Z_int number = 0;

    while (len-- > 0)
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
    return((((year % 4) == 0) and ((year % 100) != 0)) or ((year % 400) == 0));
}

boolean DateCalc_check_date(Z_int year, Z_int mm, Z_int dd)
{
    if (year < 1) return(false);
    if ((mm < 1) or (mm > 12)) return(false);
    if ((dd < 1) or (dd > DateCalc_Days_in_Month_[DateCalc_leap_year(year)][mm])) return(false);
    return(true);
}

Z_int DateCalc_Day_of_Year(Z_int year, Z_int mm, Z_int dd)
{
    boolean leap;

    if (year < 1) return(0);
    if ((mm < 1) or (mm > 12)) return(0);
    if ((dd < 1) or (dd > DateCalc_Days_in_Month_[(leap = DateCalc_leap_year(year))][mm]))
        return(0);
    return( DateCalc_Days_in_Year_[leap][mm] + dd );
}

Z_long DateCalc_Date_to_Days(Z_int year, Z_int mm, Z_int dd)
{
    boolean leap;

    if (year < 1) return(0L);
    if ((mm < 1) or (mm > 12)) return(0L);
    if ((dd < 1) or (dd > DateCalc_Days_in_Month_[(leap = DateCalc_leap_year(year))][mm]))
        return(0L);
    return( DateCalc_Year_to_Days(--year) + DateCalc_Days_in_Year_[leap][mm] + dd );
}

Z_int DateCalc_Day_of_Week(Z_int year, Z_int mm, Z_int dd)
{
    Z_long  days;

    days = DateCalc_Date_to_Days(year,mm,dd);
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

Z_int DateCalc_Week_Number(Z_int year, Z_int mm, Z_int dd)
{
    Z_int first;

    first = DateCalc_Day_of_Week(year,1,1) - 1;
    return( (Z_int) ( (DateCalc_Delta_Days(year,1,1, year,mm,dd) +
        first) / 7L ) + (first < 4) );
}

boolean DateCalc_week_of_year(Z_int *week, Z_int *year, Z_int mm, Z_int dd)
{
    if (DateCalc_check_date(*year,mm,dd))
    {
        *week = DateCalc_Week_Number(*year,mm,dd);
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

boolean DateCalc_monday_of_week(Z_int week, Z_int *year, Z_int *mm, Z_int *dd)
{
    Z_int first;

    *mm = *dd = 1;
    first = DateCalc_Day_of_Week(*year,1,1) - 1;
    if (first < 4) week--;
    return(DateCalc_add_delta_days(year,mm,dd, (week * 7L - first) ));
}

boolean DateCalc_nth_weekday_of_month_year(Z_int *year, Z_int *mm, Z_int *dd, Z_int dow, Z_int n)
{
    Z_int first, month = *mm;
    Z_long delta;

    *dd = 1;
    if ((*year < 1) or (month < 1) or (month > 12) or (dow < 1) or (dow > 7) or (n < 1) or (n > 5))
        return(false);
    first = DateCalc_Day_of_Week(*year,month,1);
    if (dow < first) dow += 7;
    delta = (Z_long) (dow - first);
    delta += (n-1) * 7L;
    if (DateCalc_add_delta_days(year,mm,dd,delta) and (*mm == month))
        return(true);
    else
        return(false);
}

Z_long DateCalc_Delta_Days(Z_int year1, Z_int mm1, Z_int dd1,
                           Z_int year2, Z_int mm2, Z_int dd2)
{
    return( DateCalc_Date_to_Days(year2,mm2,dd2) - DateCalc_Date_to_Days(year1,mm1,dd1) );
}

boolean DateCalc_delta_dhms
(
    Z_long *Dd,
    Z_int  *Dh,   Z_int *Dm,  Z_int *Ds,
    Z_int  year1, Z_int mm1,  Z_int dd1,
    Z_int  h1,    Z_int m1,   Z_int s1,
    Z_int  year2, Z_int mm2,  Z_int dd2,
    Z_int  h2,    Z_int m2,   Z_int s2
)
{
    Z_long  diff;
    Z_long  quot;
    boolean sign;

    *Dd = *Dh = *Dm = *Ds = 0;
    if (DateCalc_check_date(year1,mm1,dd1) and
        DateCalc_check_date(year2,mm2,dd2) and
        (h1 >= 0) and (m1 >= 0) and (s1 >= 0) and
        (h2 >= 0) and (m2 >= 0) and (s2 >= 0) and
        (h1 < 24) and (m1 < 60) and (s1 < 60) and
        (h2 < 24) and (m2 < 60) and (s2 < 60))
    {
        diff = ((((h2 * 60L) + m2) * 60L) + s2) -
               ((((h1 * 60L) + m1) * 60L) + s1);
        *Dd = DateCalc_Delta_Days(year1,mm1,dd1, year2,mm2,dd2);
        if (*Dd != 0L)
        {
            if (*Dd > 0L)
            {
                if (diff < 0L)
                {
                    diff += 86400L;
                    (*Dd)--;
                }
            }
            else
            {
                if (diff > 0L)
                {
                    diff -= 86400L;
                    (*Dd)++;
                }
            }
        }
        if (diff != 0L)
        {
            sign = false;
            if (diff < 0L)
            {
                sign = true;
                diff = -diff;
            }
            quot = (Z_long) (diff / 60);
            *Ds = (Z_int) (diff - quot * 60L);
            diff = quot;
            quot = (Z_long) (diff / 60);
            *Dm = (Z_int) (diff - quot * 60L);
            *Dh = (Z_int) quot;
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

boolean DateCalc_add_delta_days(Z_int *year, Z_int *mm, Z_int *dd, Z_long Dd)
{
    Z_long  days;
    boolean leap;

    if (((days = DateCalc_Date_to_Days(*year,*mm,*dd)) > 0L) and ((days += Dd) > 0L))
    {
        *year = (Z_int) ( days / 365.2425 );
        *dd = (Z_int) ( days - DateCalc_Year_to_Days(*year) );
        if (*dd < 1)
        {
            *dd = (Z_int) ( days - DateCalc_Year_to_Days(*year-1) );
        }
        else (*year)++;
        leap = DateCalc_leap_year(*year);
        if (*dd > DateCalc_Days_in_Year_[leap][13])
        {
            *dd -= DateCalc_Days_in_Year_[leap][13];
            leap = DateCalc_leap_year(++(*year));
        }
        for ( *mm = 12; *mm > 0; (*mm)-- )
        {
            if (*dd > DateCalc_Days_in_Year_[leap][*mm])
            {
                *dd -= DateCalc_Days_in_Year_[leap][*mm];
                break;
            }
        }
        return(true);
    }
    else return(false);
}

boolean DateCalc_add_delta_dhms
(
    Z_int *year, Z_int *mm,  Z_int *dd,
    Z_int *h,    Z_int *m,   Z_int *s,
    Z_long Dd,
    Z_long Dh,   Z_long Dm,  Z_long Ds
)
{
    Z_long  sum;
    Z_long  quot;

    if (DateCalc_check_date(*year,*mm,*dd) and
        (*h >= 0) and (*m >= 0) and (*s >= 0) and
        (*h < 24) and (*m < 60) and (*s < 60))
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

        sum = ((((*h * 60L) + *m) * 60L) + *s) +
              ((((Dh * 60L) + Dm) * 60L) + Ds);
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
            quot = (Z_long) (sum / 60);
            *s   = (Z_int)  (sum - quot * 60L);
            sum  = quot;
            quot = (Z_long) (sum / 60);
            *m   = (Z_int)  (sum - quot * 60L);
            sum  = quot;
            quot = (Z_long) (sum / 24);
            *h   = (Z_int)  (sum - quot * 24L);
            Dd  += quot;
        }
        else
        {
            *h = *m = *s = 0;
        }
        return(DateCalc_add_delta_days(year,mm,dd,Dd));
    }
    else return(false);
}

boolean DateCalc_add_delta_ymd(Z_int *year, Z_int *mm, Z_int *dd, Z_long Dy, Z_long Dm, Z_long Dd)
{
    Z_long diff = 0;

    if (not DateCalc_check_date(*year,*mm,*dd)) return(false);
    if ((Dd != 0L) and not DateCalc_add_delta_days(year,mm,dd,Dd)) return(false);
    if (Dm != 0L)
    {
        Dm  += (Z_long) (*mm - 1);
        diff = (Z_long) (Dm / 12);
        Dm  -= diff * 12L;
        if (Dm < 0L)
        {
            Dm += 12L;
            diff--;
        }
        *mm = (Z_int) (Dm + 1);
    }
    Dy += diff + *year;
    if (Dy > 0)
    {
        *year = (Z_int) Dy;
        if ((*dd == 29) and (*mm == 2) and not DateCalc_leap_year(*year))
        {
            *dd = 1;
            *mm = 3;
        }
        return(true);
    }
    else return(false);
}

boolean DateCalc_system_clock(Z_int *year, Z_int *mm,  Z_int *dd,
                              Z_int *h,    Z_int *m,   Z_int *s,
                              Z_int *doy,  Z_int *dow, Z_int *dst)
{
    time_t seconds;
    struct tm *date;

    if (time(&seconds) > 0)
    {
        date  = localtime(&seconds);
        *year = (*date).tm_year + 1900;
        *mm   = (*date).tm_mon + 1;
        *dd   = (*date).tm_mday;
        *h    = (*date).tm_hour;
        *m    = (*date).tm_min;
        *s    = (*date).tm_sec;
        *doy  = (*date).tm_yday + 1;
        *dow  = (*date).tm_wday; if (*dow == 0) *dow = 7;
        *dst  = (*date).tm_isdst;
        if (*dst != 0)
        {
            if (*dst < 0) *dst = -1;
            else          *dst =  1;
        }
        return(true);
    }
    else return(false);
}

boolean DateCalc_easter_sunday(Z_int *year, Z_int *mm, Z_int *dd)
{
    /****************************************************************/
    /*                                                              */
    /*  Gauss'sche Regel (Gauss' Rule)                              */
    /*  ==============================                              */
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
    *dd = 22 + d + e;
    *mm = 3;
    if (*dd > 31)
    {
        *dd -= 31; /* same as *dd = d + e - 9; */
        (*mm)++;
    }
    if ((*dd == 26) and (*mm == 4)) *dd = 19;
    if ((*dd == 25) and (*mm == 4) and (d == 28) and (e == 6) and (a > 10)) *dd = 18;
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

Z_int DateCalc_Decode_Month(charptr buffer, Z_int len) /* 0 = unable to decode month */
{
    Z_int   i,j;
    Z_int   month;
    boolean same;
    boolean ok;

    /* BEWARE that the parameter "len" must always be set in such a way so   */
    /* that the string in "buffer[0]" up to "buffer[len-1]" does not contain */
    /* any terminating null character '\0'. Otherwise this routine may read  */
    /* beyond allocated memory, probably resulting in an access violation    */
    /* and program abortion.                                                 */
    /* This is assured, for instance, by using the library function "strlen" */
    /* in order to determine the length "len" of the string in "buffer".     */

    month = 0;
    ok = true;
    for ( i = 1; ok and (i <= 12); i++ )
    {
        same = true;
        for ( j = 0; same and (j < len); j++ )
        {
            same = ( toupper(buffer[j]) ==
                     toupper(DateCalc_Month_to_Text_[DateCalc_Language][i][j]) );
        }
        if (same)
        {
            if (month > 0)
                ok = false;
            else
                month = i;
        }
    }
    if (ok) return(month);
    else return(0);
}

Z_int DateCalc_Decode_Day_of_Week(charptr buffer, Z_int len) /* 0 = unable to decode day */
{
    Z_int   i,j;
    Z_int   day;
    boolean same;
    boolean ok;

    /* BEWARE that the parameter "len" must always be set in such a way so   */
    /* that the string in "buffer[0]" up to "buffer[len-1]" does not contain */
    /* any terminating null character '\0'. Otherwise this routine may read  */
    /* beyond allocated memory, probably resulting in an access violation    */
    /* and program abortion.                                                 */
    /* This is assured, for instance, by using the library function "strlen" */
    /* in order to determine the length "len" of the string in "buffer".     */

    day = 0;
    ok = true;
    for ( i = 1; ok and (i <= 7); i++ )
    {
        same = true;
        for ( j = 0; same and (j < len); j++ )
        {
            same = ( toupper(buffer[j]) ==
                     toupper(DateCalc_Day_of_Week_to_Text_[DateCalc_Language][i][j]) );
        }
        if (same)
        {
            if (day > 0)
                ok = false;
            else
                day = i;
        }
    }
    if (ok) return(day);
    else return(0);
}

Z_int DateCalc_Decode_Language(charptr buffer, Z_int len) /* 0 = unable to decode language */
{
    Z_int   i,j;
    Z_int   lang;
    boolean same;
    boolean ok;

    /* BEWARE that the parameter "len" must always be set in such a way so   */
    /* that the string in "buffer[0]" up to "buffer[len-1]" does not contain */
    /* any terminating null character '\0'. Otherwise this routine may read  */
    /* beyond allocated memory, probably resulting in an access violation    */
    /* and program abortion.                                                 */
    /* This is assured, for instance, by using the library function "strlen" */
    /* in order to determine the length "len" of the string in "buffer".     */

    lang = 0;
    ok = true;
    for ( i = 1; ok and (i <= DateCalc_LANGUAGES); i++ )
    {
        same = true;
        for ( j = 0; same and (j < len); j++ )
        {
            same = ( toupper(buffer[j]) ==
                     toupper(DateCalc_Language_to_Text_[i][j]) );
        }
        if (same)
        {
            if (lang > 0)
                ok = false;
            else
                lang = i;
        }
    }
    if (ok) return(lang);
    else return(0);
}

boolean DateCalc_decode_date_eu(charptr buffer, Z_int *year, Z_int *mm, Z_int *dd)
{
    Z_int   i,j;
    Z_int   buflen;

    *year = *mm = *dd = 0;
    buflen = strlen((char *)buffer);
    if (buflen > 0)
    {
        i = 0;
        while (DateCalc_scan9(buffer,buflen,i,true)) i++;
        j = buflen-1;
        while (DateCalc_scan9(buffer,buflen,j,true)) j--;
        if (i+1 < j)        /* at least 3 chars, else error! */
        {
            buffer += i;
            buflen = j-i+1;
            i = 1;
            while (DateCalc_scan9(buffer,buflen,i,false)) i++;
            j = buflen-2;
            while (DateCalc_scan9(buffer,buflen,j,false)) j--;
            if (j < i)  /* only numerical chars without delimiters */
            {
                switch (buflen)
                {
                case 3:
                    *dd   = DateCalc_Str2Int(buffer,  1);
                    *mm   = DateCalc_Str2Int(buffer+1,1);
                    *year = DateCalc_Str2Int(buffer+2,1);
                    break;
                case 4:
                    *dd   = DateCalc_Str2Int(buffer,  1);
                    *mm   = DateCalc_Str2Int(buffer+1,1);
                    *year = DateCalc_Str2Int(buffer+2,2);
                    break;
                case 5:
                    *dd   = DateCalc_Str2Int(buffer,  1);
                    *mm   = DateCalc_Str2Int(buffer+1,2);
                    *year = DateCalc_Str2Int(buffer+3,2);
                    break;
                case 6:
                    *dd   = DateCalc_Str2Int(buffer,  2);
                    *mm   = DateCalc_Str2Int(buffer+2,2);
                    *year = DateCalc_Str2Int(buffer+4,2);
                    break;
                case 7:
                    *dd   = DateCalc_Str2Int(buffer,  1);
                    *mm   = DateCalc_Str2Int(buffer+1,2);
                    *year = DateCalc_Str2Int(buffer+3,4);
                    break;
                case 8:
                    *dd   = DateCalc_Str2Int(buffer,  2);
                    *mm   = DateCalc_Str2Int(buffer+2,2);
                    *year = DateCalc_Str2Int(buffer+4,4);
                    break;
                default:
                    return(false);
                    break;
                }
            }
            else        /* at least one non-numerical char (i <= j) */
            {
                *dd   = DateCalc_Str2Int(buffer,i);
                *year = DateCalc_Str2Int(buffer+(j+1),buflen-(j+1));
                while (DateCalc_scanx(buffer,buflen,i,true)) i++;
                while (DateCalc_scanx(buffer,buflen,j,true)) j--;
                if (i <= j)         /* at least one char left for month */
                {
                    buffer += i;
                    buflen = j-i+1;
                    i = 1;
                    while (DateCalc_scanx(buffer,buflen,i,false)) i++;
                    if (i >= buflen)    /* ok, no more delimiters */
                    {
                        i = 0;
                        while (DateCalc_scan9(buffer,buflen,i,false)) i++;
                        if (i >= buflen) /* only digits for month */
                        {
                            *mm = DateCalc_Str2Int(buffer,buflen);
                        }
                        else             /* match with month names */
                        {
                            *mm = DateCalc_Decode_Month(buffer,buflen);
                        }
                    }
                    else return(false); /* delimiters inside month string */
                }
                else return(false); /* no chars left for month */
            }           /* at least one non-numerical char (i <= j) */
        }
        else return(false); /* less than 3 chars in buffer */
    }
    else return(false); /* buflen <= 0 */
    if (*year < 100)
    {
        /* if (*year < DateCalc_YEAR_OF_EPOCH) *year += 100; */
        *year += DateCalc_CENTURY_OF_EPOCH;
    }
    return(DateCalc_check_date(*year,*mm,*dd));
}

boolean DateCalc_decode_date_us(charptr buffer, Z_int *year, Z_int *mm, Z_int *dd)
{
    Z_int   i,j,k;
    Z_int   buflen;

    *year = *mm = *dd = 0;
    buflen = strlen((char *)buffer);
    if (buflen > 0)
    {
        i = 0;
        while (DateCalc_scanx(buffer,buflen,i,true)) i++;
        j = buflen-1;
        while (DateCalc_scan9(buffer,buflen,j,true)) j--;
        if (i+1 < j)        /* at least 3 chars, else error! */
        {
            buffer += i;
            buflen = j-i+1;
            i = 1;
            while (DateCalc_scanx(buffer,buflen,i,false)) i++;
            j = buflen-2;
            while (DateCalc_scan9(buffer,buflen,j,false)) j--;
            if (i >= buflen)  /* only alphanumeric chars left */
            {
                if (j < 0) /* case 0 : xxxx999999xxxx */
                {          /*             j0     i    */
                    switch (buflen)
                    {
                    case 3:
                        *mm   = DateCalc_Str2Int(buffer,  1);
                        *dd   = DateCalc_Str2Int(buffer+1,1);
                        *year = DateCalc_Str2Int(buffer+2,1);
                        break;
                    case 4:
                        *mm   = DateCalc_Str2Int(buffer,  1);
                        *dd   = DateCalc_Str2Int(buffer+1,1);
                        *year = DateCalc_Str2Int(buffer+2,2);
                        break;
                    case 5:
                        *mm   = DateCalc_Str2Int(buffer,  1);
                        *dd   = DateCalc_Str2Int(buffer+1,2);
                        *year = DateCalc_Str2Int(buffer+3,2);
                        break;
                    case 6:
                        *mm   = DateCalc_Str2Int(buffer,  2);
                        *dd   = DateCalc_Str2Int(buffer+2,2);
                        *year = DateCalc_Str2Int(buffer+4,2);
                        break;
                    case 7:
                        *mm   = DateCalc_Str2Int(buffer,  1);
                        *dd   = DateCalc_Str2Int(buffer+1,2);
                        *year = DateCalc_Str2Int(buffer+3,4);
                        break;
                    case 8:
                        *mm   = DateCalc_Str2Int(buffer,  2);
                        *dd   = DateCalc_Str2Int(buffer+2,2);
                        *year = DateCalc_Str2Int(buffer+4,4);
                        break;
                    default:
                        return(false);
                        break;
                    }
                }
                else       /* case 1 : xxxxAAA999999xxxx */
                {          /*              0 j      i    */
                    *mm = DateCalc_Decode_Month(buffer,j+1);
                    buffer += j+1;
                    buflen -= j+1;
                    switch (buflen)
                    {
                    case 2:
                        *dd   = DateCalc_Str2Int(buffer,  1);
                        *year = DateCalc_Str2Int(buffer+1,1);
                        break;
                    case 3:
                        *dd   = DateCalc_Str2Int(buffer,  1);
                        *year = DateCalc_Str2Int(buffer+1,2);
                        break;
                    case 4:
                        *dd   = DateCalc_Str2Int(buffer,  2);
                        *year = DateCalc_Str2Int(buffer+2,2);
                        break;
                    case 5:
                        *dd   = DateCalc_Str2Int(buffer,  1);
                        *year = DateCalc_Str2Int(buffer+1,4);
                        break;
                    case 6:
                        *dd   = DateCalc_Str2Int(buffer,  2);
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
                while (DateCalc_scan9(buffer,buflen,k,false)) k++;
                if (k >= i) /* ok, only digits */
                {
                    *mm = DateCalc_Str2Int(buffer,i);
                }
                else       /* no, some non-digits */
                {
                    *mm = DateCalc_Decode_Month(buffer,i);
                    if (*mm == 0) return(false);
                }
                buffer += i;
                buflen -= i;
                j -= i;
                k = j+1; /* remember start posn of day+year(2)/year(3) */
                i = 1;
                while (DateCalc_scanx(buffer,buflen,i,true)) i++;
                j--;
                while (DateCalc_scan9(buffer,buflen,j,true)) j--;
                if (j < i) /* case 2 : xxxxAAAxxxx9999xxxx */
                {          /*                j0   i   l    */
                    buffer += k;    /*            k        */
                    buflen -= k;
                    switch (buflen)
                    {
                    case 2:
                        *dd   = DateCalc_Str2Int(buffer,  1);
                        *year = DateCalc_Str2Int(buffer+1,1);
                        break;
                    case 3:
                        *dd   = DateCalc_Str2Int(buffer,  1);
                        *year = DateCalc_Str2Int(buffer+1,2);
                        break;
                    case 4:
                        *dd   = DateCalc_Str2Int(buffer,  2);
                        *year = DateCalc_Str2Int(buffer+2,2);
                        break;
                    case 5:
                        *dd   = DateCalc_Str2Int(buffer,  1);
                        *year = DateCalc_Str2Int(buffer+1,4);
                        break;
                    case 6:
                        *dd   = DateCalc_Str2Int(buffer,  2);
                        *year = DateCalc_Str2Int(buffer+2,4);
                        break;
                    default:
                        return(false);
                        break;
                    }
                }
                else       /* case 3 : xxxxAAAxx99xx9999xx */
                {          /*                 0 ij  k   l  */
                    *year = DateCalc_Str2Int(buffer+k,buflen-k);
                    k = i;
                    while (DateCalc_scan9(buffer,buflen,k,false)) k++;
                    if (k > j)          /* ok, only digits */
                    {
                        *dd = DateCalc_Str2Int(buffer+i,j-i+1);
                    }
                    else return(false); /* non-digits inside day */
                }
            }                 /* i < buflen */
        }
        else return(false); /* less than 3 chars in buffer */
    }
    else return(false); /* buflen <= 0 */
    if (*year < 100)
    {
        /* if (*year < DateCalc_YEAR_OF_EPOCH) *year += 100; */
        *year += DateCalc_CENTURY_OF_EPOCH;
    }
    return(DateCalc_check_date(*year,*mm,*dd));
}

Z_int DateCalc_Compress(Z_int yy, Z_int mm, Z_int dd)
{
    Z_int year;

    if ((yy >= DateCalc_EPOCH) and (yy < (DateCalc_EPOCH + 100)))
    {
        year = yy;
        yy -= DateCalc_EPOCH;
    }
    else
    {
        if ( /* (yy < 0) or */ (yy > 99)) return(0);
        if (yy < DateCalc_YEAR_OF_EPOCH)
        {
            year = DateCalc_CENTURY_OF_EPOCH + 100 + yy;
            yy += 100 - DateCalc_YEAR_OF_EPOCH;
        }
        else
        {
            year = DateCalc_CENTURY_OF_EPOCH + yy;
            yy -= DateCalc_YEAR_OF_EPOCH;
        }
    }
    if ((mm < 1) or (mm > 12)) return(0);
    if ((dd < 1) or (dd > DateCalc_Days_in_Month_[DateCalc_leap_year(year)][mm])) return(0);
    return( (yy SHL 9) OR (mm SHL 5) OR dd );
}

boolean DateCalc_uncompress(Z_int date, Z_int *cc, Z_int *yy, Z_int *mm, Z_int *dd)
{
    if (date > 0)
    {
        *yy = date SHR 9;
        *mm = (date AND 0x01FF) SHR 5;
        *dd = date AND 0x001F;

        if (*yy < 100)
        {
            if (*yy < 100-DateCalc_YEAR_OF_EPOCH)
            {
                *cc = DateCalc_CENTURY_OF_EPOCH;
                *yy += DateCalc_YEAR_OF_EPOCH;
            }
            else
            {
                *cc = DateCalc_CENTURY_OF_EPOCH+100;
                *yy -= 100-DateCalc_YEAR_OF_EPOCH;
            }
            return(DateCalc_check_date(*cc+*yy,*mm,*dd));
        }
        else return(false);
    }
    else return(false);
}

boolean DateCalc_check_compressed(Z_int date)
{
    Z_int cc;
    Z_int yy;
    Z_int mm;
    Z_int dd;

    return(DateCalc_uncompress(date,&cc,&yy,&mm,&dd));
}

charptr DateCalc_Compressed_to_Text(Z_int date)
{
    Z_int cc;
    Z_int yy;
    Z_int mm;
    Z_int dd;
    charptr string;

    string = (charptr) malloc(16);
    if (string == NULL) return(NULL);
    if (DateCalc_uncompress(date,&cc,&yy,&mm,&dd))
        sprintf((char *)string,"%02d-%.3s-%02d",dd,
        DateCalc_Month_to_Text_[DateCalc_Language][mm],yy);
    else
        sprintf((char *)string,"??""-???""-??");
        /* prevent interpretation as trigraphs */
    return(string);
}

charptr DateCalc_Date_to_Text(Z_int year, Z_int mm, Z_int dd)
{
    charptr string;

    if (DateCalc_check_date(year,mm,dd) and
        ((string = (charptr) malloc(32)) != NULL))
    {
        if (DateCalc_Day_of_Week_Abbreviation_[DateCalc_Language][0][0] != '\0')
        {
            sprintf((char *)string,"%.3s %d-%.3s-%d",
            DateCalc_Day_of_Week_Abbreviation_[DateCalc_Language][DateCalc_Day_of_Week(year,mm,dd)],
            dd,DateCalc_Month_to_Text_[DateCalc_Language][mm],year);
            return(string);
        }
        else
        {
            sprintf((char *)string,"%.3s %d-%.3s-%d",
            DateCalc_Day_of_Week_to_Text_[DateCalc_Language][DateCalc_Day_of_Week(year,mm,dd)],
            dd,DateCalc_Month_to_Text_[DateCalc_Language][mm],year);
            return(string);
        }
    }
    else return(NULL);
}

charptr DateCalc_Date_to_Text_Long(Z_int year, Z_int mm, Z_int dd)
{
    charptr string;

    if (DateCalc_check_date(year,mm,dd) and
        ((string = (charptr) malloc(64)) != NULL))
    {
        sprintf((char *)string,"%s, %d %s %d",
        DateCalc_Day_of_Week_to_Text_[DateCalc_Language][DateCalc_Day_of_Week(year,mm,dd)],
        dd,DateCalc_Month_to_Text_[DateCalc_Language][mm],year);
        return(string);
    }
    else return(NULL);
}

charptr DateCalc_Calendar(Z_int year, Z_int mm)
{
    static blockdef(buffer,30);
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
        DateCalc_Month_to_Text_[DateCalc_Language][mm],year);
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
    first = DateCalc_Day_of_Week(year,mm,1);
    last = DateCalc_Days_in_Month_[DateCalc_leap_year(year)][mm];
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
    return((charptr)"4.0");
}

/*****************************************************************************/
/*  VERSION:  4.0                                                            */
/*****************************************************************************/
/*  VERSION HISTORY:                                                         */
/*****************************************************************************/
/*                                                                           */
/*    Version 4.0   26.04.98  Major rework. Added multi-language support.    */
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
/*    Copyright (c) 1993, 1995, 1996, 1997, 1998 by Steffen Beyer.           */
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
/*                                                                           */
/*    or download a copy from ftp://ftp.gnu.org/pub/gnu/COPYING.LIB-2.0      */
/*                                                                           */
/*****************************************************************************/
#endif
