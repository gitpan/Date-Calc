#ifndef MODULE_TOOLBOX
#define MODULE_TOOLBOX
#ifdef __cplusplus
extern "C"
{
#endif
/*****************************************************************************/
/*  MODULE NAME:  ToolBox.h                             MODULE TYPE:  (dat)  */
/*****************************************************************************/
/*  MODULE IMPORTS:                                                          */
/*****************************************************************************/

/*****************************************************************************/
/*  MODULE INTERFACE:                                                        */
/*****************************************************************************/

/*****************************************************************************/
/*  MODULE RESOURCES:                                                        */
/*****************************************************************************/

/*****************************************************************************/
/*  NOTE: The type names that have been chosen here are somewhat weird on    */
/*        purpose, in order to avoid name clashes with system header files   */
/*        and your own application(s) which might - directly or indirectly - */
/*        include this definitions file.                                     */
/*****************************************************************************/

typedef  unsigned   char    N_char;
typedef  unsigned   char    N_byte;
typedef  unsigned   short   N_short;
typedef  unsigned   short   N_shortword;
typedef  unsigned   int     N_int;
typedef  unsigned   int     N_word;
typedef  unsigned   long    N_long;
typedef  unsigned   long    N_longword;

/*  Mnemonic 1:  The natural numbers,  N = { 0, 1, 2, 3, ... }               */
/*  Mnemonic 2:  Nnnn = u_N_signed,  _N_ot signed                            */

typedef  signed     char    Z_char;
typedef  signed     char    Z_byte;
typedef  signed     short   Z_short;
typedef  signed     short   Z_shortword;
typedef  signed     int     Z_int;
typedef  signed     int     Z_word;
typedef  signed     long    Z_long;
typedef  signed     long    Z_longword;

/*  Mnemonic 1:  The whole numbers,  Z = { 0, -1, 1, -2, 2, -3, 3, ... }     */
/*  Mnemonic 2:  Zzzz = Ssss_igned                                           */

typedef  void               *voidptr;
typedef  N_char             *charptr;
typedef  N_byte             *byteptr;
typedef  N_short            *shortptr;
typedef  N_shortword        *shortwordptr;
typedef  N_int              *intptr;
typedef  N_word             *wordptr;
typedef  N_long             *longptr;
typedef  N_longword         *longwordptr;

typedef  N_char             *N_charptr;
typedef  N_byte             *N_byteptr;
typedef  N_short            *N_shortptr;
typedef  N_shortword        *N_shortwordptr;
typedef  N_int              *N_intptr;
typedef  N_word             *N_wordptr;
typedef  N_long             *N_longptr;
typedef  N_longword         *N_longwordptr;

typedef  Z_char             *Z_charptr;
typedef  Z_byte             *Z_byteptr;
typedef  Z_short            *Z_shortptr;
typedef  Z_shortword        *Z_shortwordptr;
typedef  Z_int              *Z_intptr;
typedef  Z_word             *Z_wordptr;
typedef  Z_long             *Z_longptr;
typedef  Z_longword         *Z_longwordptr;

#undef  FALSE
#define FALSE       (0!=0)

#undef  TRUE
#define TRUE        (0==0)

#ifdef __cplusplus
    typedef bool boolean;
#else
    #ifdef MACOS_TRADITIONAL
        #define boolean Boolean
    #else
        typedef enum { false = FALSE, true = TRUE } boolean;
    #endif
#endif

#define and         &&      /* logical (boolean) operators: lower case */
#define or          ||
#define not         !

#define AND         &       /* binary (bitwise) operators: UPPER CASE */
#define OR          |
#define XOR         ^
#define NOT         ~
#define SHL         <<
#define SHR         >>

#ifdef ENABLE_MODULO
#define mod         %       /* arithmetic operators */
#endif

#define blockdef(name,size)         unsigned char name[size]
#define blocktypedef(name,size)     typedef unsigned char name[size]

/*******************************************************************************/
/*  MODULE IMPLEMENTATION:                                                     */
/*******************************************************************************/

/*******************************************************************************/
/*  VERSION:  5.5.1                                                            */
/*******************************************************************************/
/*  VERSION HISTORY:                                                           */
/*******************************************************************************/
/*                                                                             */
/*    Version 5.5.1  28.02.07  Uploaded correct version to CPAN.               */
/*    Version 5.5    23.01.07  Fixed compiler warning under gcc-4.             */
/*    Version 5.4    03.10.04  Added compiler directives for C++.              */
/*    Version 5.3    29.09.02  No changes.                                     */
/*    Version 5.2    18.09.02  No changes.                                     */
/*    Version 5.1    08.09.02  Added conditional changes for MacOS/MacPerl.    */
/*    Version 5.0    10.10.01  New YMD/HMS functions, replaced <ctype.h>, ...  */
/*    Version 4.3    08.01.00  decode_date_??: (yy < 70 ? 20yy : 19yy)         */
/*    Version 4.2    07.09.98  No changes.                                     */
/*    Version 4.1    08.06.98  Fixed bug in "add_delta_ymd()".                 */
/*    Version 4.0    12.05.98  Major rework. Added multi-language support.     */
/*    Version 3.2    15.06.97  Added "week_of_year()".                         */
/*    Version 3.1    12.06.97  No significant changes.                         */
/*    Version 3.0    16.02.97  Changed conventions for unsuccessful returns.   */
/*    Version 2.3    22.11.96  Fixed unbalanced "malloc" and "free".           */
/*    Version 2.2    26.05.96  No significant changes.                         */
/*    Version 2.1    26.05.96  Fixed HH MM SS parameter checks.                */
/*    Version 2.0    25.05.96  Added time calculations. Major rework.          */
/*    Version 1.6    20.04.96  Not published.                                  */
/*    Version 1.5    14.03.96  No significant changes.                         */
/*    Version 1.4    11.02.96  No significant changes.                         */
/*    Version 1.3    10.12.95  Added "days_in_month()".                        */
/*    Version 1.2b   27.11.95  No significant changes.                         */
/*    Version 1.2a   21.11.95  Fix for type name clashes.                      */
/*    Version 1.1    18.11.95  Fix for type name clashes.                      */
/*    Version 1.01   16.11.95  Improved compliance w/ programming standards.   */
/*    Version 1.0    14.11.95  First version under UNIX (with Perl module).    */
/*    Version 0.9    01.11.93  First version of C library under MS-DOS.        */
/*                                                                             */
/*******************************************************************************/
/*  AUTHOR:                                                                    */
/*******************************************************************************/
/*                                                                             */
/*    Steffen Beyer                                                            */
/*    mailto:sb@engelschall.com                                                */
/*    http://www.engelschall.com/u/sb/download/                                */
/*                                                                             */
/*******************************************************************************/
/*  COPYRIGHT:                                                                 */
/*******************************************************************************/
/*                                                                             */
/*    Copyright (c) 1993 - 2004 by Steffen Beyer.                              */
/*    All rights reserved.                                                     */
/*                                                                             */
/*******************************************************************************/
/*  LICENSE:                                                                   */
/*******************************************************************************/
/*                                                                             */
/*    This library is free software; you can redistribute it and/or            */
/*    modify it under the terms of the GNU Library General Public              */
/*    License as published by the Free Software Foundation; either             */
/*    version 2 of the License, or (at your option) any later version.         */
/*                                                                             */
/*    This library is distributed in the hope that it will be useful,          */
/*    but WITHOUT ANY WARRANTY; without even the implied warranty of           */
/*    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU         */
/*    Library General Public License for more details.                         */
/*                                                                             */
/*    You should have received a copy of the GNU Library General Public        */
/*    License along with this library; if not, write to the                    */
/*    Free Software Foundation, Inc.,                                          */
/*    59 Temple Place, Suite 330, Boston, MA 02111-1307 USA                    */
/*    or download a copy from ftp://ftp.gnu.org/pub/gnu/COPYING.LIB-2.0        */
/*                                                                             */
/*******************************************************************************/
#ifdef __cplusplus
}
#endif
#endif
