#ifndef MODULE_PC_TO_ISO
#define MODULE_PC_TO_ISO
/*****************************************************************************/
/*  MODULE NAME:  pc2iso.c                              MODULE TYPE:  (lib)  */
/*****************************************************************************/
/*  MODULE IMPORTS:                                                          */
/*****************************************************************************/
#include <stdio.h>                                  /*  MODULE TYPE:  (sys)  */
/*****************************************************************************/
/*  MODULE INTERFACE:                                                        */
/*****************************************************************************/
/*

    This application is a typical UNIX filter designed to convert
    special characters (with ASCII codes ranging from 0x80 to 0xFF)
    from the PC character set to the ISO-Latin-1 character set in
    a REVERSIBLE way WITHOUT LOSSES of information.

    This filter thereby tries to provide a "best possible" translation,
    i.e., all characters that are visually the same or very similar in
    both character sets are converted into one another, which should
    give a pretty well readable translation of any text containing
    international characters.

    Moreover, some of the characters without visual equivalent in the
    other character set are converted anyway (where necessary) to some
    arbitrary character, in order to assure that EVERY character in
    the character set has a UNIQUE equivalent (in order to assure
    the invertibility of the translation table used by this filter
    and thus the reversibility of the transformation performed by
    this filter).

    The filter thereby tries to convert as little of these characters
    without visual equivalent as possible in order to produce as little
    "distortions" in the filtered text as possible.

    Characters affected by the translation of this filter are the ones
    with ASCII codes ranging from 0x80 to 0xFF, all other characters
    are simply passed through.

    Input comes from standard input, output goes to standard output.

    Both can be redirected to/from files using the corresponding UNIX
    redirection operators.

*/
/*****************************************************************************/
/*  MODULE RESOURCES:                                                        */
/*****************************************************************************/

/*
    Only characters that are visually the same or very similar in both
    character sets need to be specified here, the rest of this translation
    table is filled up automatically.
*/

static int iso2pc[0x80] =
{
    0x00, 0x00, 0x00, 0x00,   0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00,   0x00, 0x00, 0x00, 0x00,

    0x00, 0x00, 0x00, 0x00,   0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00,   0x00, 0x00, 0x00, 0x00,

    0x00, 0xAD, 0x9B, 0x9C,   0x00, 0x9D, 0xB3, 0x9F,
    0x00, 0x00, 0xA6, 0xAE,   0xAA, 0xC4, 0x00, 0x00,

    0xF8, 0xF1, 0xFD, 0x00,   0x00, 0xE6, 0xBB, 0xF9,
    0x00, 0x00, 0xA7, 0xAF,   0xAC, 0xAB, 0x00, 0xA8,

    0x00, 0x00, 0x00, 0x00,   0x8E, 0x8F, 0x92, 0x80,
    0x00, 0x90, 0x00, 0x00,   0x00, 0x00, 0x00, 0x00,

    0x00, 0xA5, 0x00, 0x00,   0x00, 0x00, 0x99, 0x00,
    0x00, 0x00, 0x00, 0x00,   0x9A, 0x00, 0x00, 0xE1,

    0x85, 0xA0, 0x83, 0xE0,   0x84, 0x86, 0x91, 0x87,
    0x8A, 0x82, 0x88, 0x89,   0x8D, 0xA1, 0x8C, 0x8B,

    0xEB, 0xA4, 0x95, 0xA2,   0x93, 0x00, 0x94, 0xF6,
    0xED, 0x97, 0xA3, 0x96,   0x81, 0x00, 0x00, 0x98
};

/*****************************************************************************/
/*  MODULE IMPLEMENTATION:                                                   */
/*****************************************************************************/

static int pc2iso[0x80];

void initialize(void)
{
    int i,j,k;

    for ( i = 0x00; i < 0x80; i++ )
    {
        pc2iso[i] = 0x00;
    }
    for ( i = 0x00; i < 0x80; i++ )
    {
        if (iso2pc[i] != 0x00) pc2iso[iso2pc[i] & 0x7F] = i | 0x80;
    }
    for ( i = 0x00; i < 0x80; i++ )
    {
        if ((iso2pc[i] == 0x00) && (pc2iso[i] == 0x00))
        {
            iso2pc[i] = i | 0x80;
            pc2iso[i] = i | 0x80;
        }
    }
    k = 0x00;
    for ( i = 0x00; i < 0x80; i++ )
    {
        if (iso2pc[i] == 0x00)
        {
            for ( j = k; j < 0x80; j++ )
            {
                if (pc2iso[j] == 0x00)
                {
                    iso2pc[i] = j | 0x80;
                    pc2iso[j] = i | 0x80;
                    k = j + 1;
                    break;
                }
            }
        }
    }
    for ( i = 0x00; i < 0x80; i++ )
    {
        if ((iso2pc[i] == 0x00) || (pc2iso[i] == 0x00))
        {
            fprintf(stderr,"pc2iso: internal configuration error!\n");
            exit(1);
        }
    }
}

void dump_table(void)
{
    int i,k;

    initialize();
    fprintf(stdout,"static int iso2pc[0x80] =\n");
    fprintf(stdout,"{\n");
    for ( i = 0x00; i < 0x80; i++ )
    {
        k = i & 0x07;
        if      (k == 0x00) fprintf(stdout,"    ");
        else if (k == 0x04) fprintf(stdout,"  ");
/*      fprintf(stdout,"0x%02.2X", iso2pc[i]);      */
        fprintf(stdout,"0x%02.2X", pc2iso[i]);
        if (k == 0x07)
        {
            if (i == 0x7F)               fprintf(stdout,"\n");
            else if ((i & 0x0F) == 0x0F) fprintf(stdout,",\n\n");
            else                         fprintf(stdout,",\n");
        }
        else                             fprintf(stdout,", ");
    }
    fprintf(stdout,"};\n");
}

int main_(void)
{
    dump_table();
    return(0);
}

int main(void)
{
    int c;

    initialize();
    while ((c = getchar()) != EOF)
    {
        if ((c & ~0x7F) == 0x80)
        {
            putchar(pc2iso[c & 0x7F]);
        }
        else
        {
            putchar(c);
        }
    }
    return(0);
}

/*****************************************************************************/
/*  VERSION:  1.0                                                            */
/*****************************************************************************/
/*  VERSION HISTORY:                                                         */
/*****************************************************************************/
/*                                                                           */
/*    10.04.98    Version 1.0                                                */
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
/*    Copyright (c) 1998 by Steffen Beyer.                                   */
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
