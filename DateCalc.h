#ifndef MODULE_DATE_CALC
#define MODULE_DATE_CALC
/*****************************************************************************/
/*  MODULE NAME:  DateCalc.h                            MODULE TYPE:  (lib)  */
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

extern Z_int DateCalc_Days_in_Year_[2][14];
/*
{
    { 0, 0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365 },
    { 0, 0, 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335, 366 }
};
*/

extern Z_int DateCalc_Days_in_Month_[2][13];
/*
{
    { 0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 },
    { 0, 31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 }
};
*/

#define DateCalc_LANGUAGES 6

extern Z_int  DateCalc_Language; /* Default = 1 (English) */

extern N_char DateCalc_Month_to_Text_[DateCalc_LANGUAGES+1][13][32];
/*
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
*/

extern N_char DateCalc_Day_of_Week_to_Text_[DateCalc_LANGUAGES+1][8][32];
/*
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
*/

extern N_char DateCalc_Day_of_Week_Abbreviation_[DateCalc_LANGUAGES+1][8][4];

    /* Fill the fields below _only_ if special abbreviations are needed! */
    /* Note that the first field serves as a flag and must be non-empty! */
/*
{
    {
        "", "", "", "", "", "", "", ""
    },
    {
        "", "", "", "", "", "", "", ""
    },
    {
        "", "", "", "", "", "", "", ""
    },
    {
        "", "", "", "", "", "", "", ""
    },
    {
        "", "", "", "", "", "", "", ""
    },
    {
        "???", "2ª", "3ª", "4ª", "5ª", "6ª", "Sáb", "Dom"
    },
    {
        "", "", "", "", "", "", "", ""
    }
};
*/

extern N_char DateCalc_Language_to_Text_[DateCalc_LANGUAGES+1][32];
/*
{
    "???", "English", "Français", "Deutsch", "Español", "Português", "Nederlands"
};
*/

/*****************************************************************************/
/*  MODULE IMPLEMENTATION:                                                   */
/*****************************************************************************/

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
