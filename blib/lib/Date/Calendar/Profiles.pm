
###############################################################################
##                                                                           ##
##    Copyright (c) 2000 by Steffen Beyer.                                   ##
##    All rights reserved.                                                   ##
##                                                                           ##
##    This package is free software; you can redistribute it                 ##
##    and/or modify it under the same terms as Perl itself.                  ##
##                                                                           ##
###############################################################################

package Date::Calendar::Profiles;

use strict;
use vars qw( @ISA @EXPORT @EXPORT_OK $VERSION $Profiles );

require Exporter;

@ISA = qw(Exporter);

@EXPORT = qw();

@EXPORT_OK = qw( $Profiles );

$VERSION = '5.0';

use Date::Calc qw(:all);
use Carp::Clan qw(^Date::);

##########################################################################
#                                                                        #
#  Moving ("variable") holidays depending on the date of Easter Sunday:  #
#                                                                        #
#  Carnival Monday / Rosenmontag / Veille du Mardi Gras    =  -48 days   #
#  Mardi Gras / Karnevalsdienstag / Mardi Gras             =  -47 days   #
#  Ash Wednesday / Aschermittwoch / Mercredi des Cendres   =  -46 days   #
#  Palm Sunday / Palmsonntag / Dimanche des Rameaux        =   -7 days   #
#  Maundy Thursday / Gruendonnerstag / Jeudi avant Paques  =   -3 days   #
#  Good Friday / Karfreitag / Vendredi Saint               =   -2 days   #
#  Easter Saturday / Ostersamstag / Samedi de Paques       =   -1 day    #
#  Easter Sunday / Ostersonntag / Dimanche de Paques       =   +0 days   #
#  Easter Monday / Ostermontag / Lundi de Paques           =   +1 day    #
#  Prayer Day / Bettag / Jour de la Priere (Denmark)       =  +26 days   #
#  Ascension of Christ / Christi Himmelfahrt / Ascension   =  +39 days   #
#  Whitsunday / Pfingstsonntag / Dimanche de Pentecote     =  +49 days   #
#  Whitmonday / Pfingstmontag / Lundi de Pentecote         =  +50 days   #
#  Feast of Corpus Christi / Fronleichnam / Fete-Dieu      =  +60 days   #
#                                                                        #
##########################################################################

###############################################
#                                             #
# Rules to enhance readability:               #
#                                             #
# 1) First level constants in single quotes,  #
#    second level constants in double quotes. #
# 2) Use leading zeros for fixed length.      #
#                                             #
###############################################

$Profiles = { };

${$Profiles}{'DE'} = # Deutschland
{
    # For labeling only (defaults, may be overridden):
    "Dreikönigstag"             => "#06.01.",
    "Rosenmontag"               => "#-48",
    "Karnevalsdienstag"         => "#-47",
    "Aschermittwoch"            => "#-46",
    "Palmsonntag"               => "#-7",
    "Gründonnerstag"            => "#-3",
    "Karfreitag"                => "#-2",
    "Fronleichnam"              => "#+60",
    "Mariä Himmelfahrt"         => "#15.08.",
    "Reformationstag"           => "#31.10.",
    "Allerheiligen"             => "#01.11.",
    "Buß- und Bettag"           => \&DE_Buss_und_Bettag2,
    "1. Advent"                 => \&Advent1,
    "2. Advent"                 => \&Advent2,
    "3. Advent"                 => \&Advent3,
    "4. Advent"                 => \&Advent4,
    "Heiligabend"               => "#24.12.",
    "Sylvester"                 => "#31.12.",
    # Common legal holidays (in all federal states):
    "Neujahr"                   => "01.01.",
    "Karfreitag"                => "-2",
    "Ostersonntag"              => "+0",
    "Ostermontag"               => "+1",
    "Tag der Arbeit"            => "01.05.",
    "Christi Himmelfahrt"       => "+39",
    "Pfingstsonntag"            => "+49",
    "Pfingstmontag"             => "+50",
    "Tag der deutschen Einheit" => "03.10.",
    "1. Weihnachtsfeiertag"     => "25.12.",
    "2. Weihnachtsfeiertag"     => "26.12."
};

${$Profiles}{'DE-BW'} = # Baden-Wuerttemberg
{
    %{${$Profiles}{'DE'}},
    "Dreikönigstag"             => "06.01.",
    "Fronleichnam"              => "+60",
    "Allerheiligen"             => "01.11."
};

${$Profiles}{'DE-BY'} = # Bayern
{
    %{${$Profiles}{'DE'}},
    "Dreikönigstag"             => "06.01.",
    "Fronleichnam"              => "+60",
    "Mariä Himmelfahrt"         => "15.08.",
    "Allerheiligen"             => "01.11."
};

${$Profiles}{'DE-BE'} = # Berlin
{
    %{${$Profiles}{'DE'}}
};

${$Profiles}{'DE-BB'} = # Brandenburg
{
    %{${$Profiles}{'DE'}},
    "Reformationstag"           => "31.10."
};

${$Profiles}{'DE-HB'} = # Bremen
{
    %{${$Profiles}{'DE'}}
};

${$Profiles}{'DE-HH'} = # Hamburg
{
    %{${$Profiles}{'DE'}}
};

${$Profiles}{'DE-HE'} = # Hessen
{
    %{${$Profiles}{'DE'}},
    "Fronleichnam"              => "+60"
};

${$Profiles}{'DE-MV'} = # Mecklenburg-Vorpommern
{
    %{${$Profiles}{'DE'}},
    "Reformationstag"           => "31.10."
};

${$Profiles}{'DE-NI'} = # Niedersachsen
{
    %{${$Profiles}{'DE'}}
};

${$Profiles}{'DE-NW'} = # Nordrhein-Westfalen
{
    %{${$Profiles}{'DE'}},
    "Fronleichnam"              => "+60",
    "Allerheiligen"             => "01.11."
};

${$Profiles}{'DE-RP'} = # Rheinland-Pfalz
{
    %{${$Profiles}{'DE'}},
    "Fronleichnam"              => "+60",
    "Allerheiligen"             => "01.11."
};

${$Profiles}{'DE-SL'} = # Saarland
{
    %{${$Profiles}{'DE'}},
    "Fronleichnam"              => "+60",
    "Mariä Himmelfahrt"         => "15.08.",
    "Allerheiligen"             => "01.11."
};

${$Profiles}{'DE-SN'} = # Sachsen
{
    %{${$Profiles}{'DE'}},
    "Reformationstag"           => "31.10.",
    "Buß- und Bettag"           => \&DE_Buss_und_Bettag
};

${$Profiles}{'DE-ST'} = # Sachsen-Anhalt
{
    %{${$Profiles}{'DE'}},
    "Dreikönigstag"             => "06.01.",
    "Reformationstag"           => "31.10."
};

${$Profiles}{'DE-SH'} = # Schleswig-Holstein
{
    %{${$Profiles}{'DE'}}
};

${$Profiles}{'DE-TH'} = # Thueringen
{
    %{${$Profiles}{'DE'}},
    "Reformationstag"           => "31.10."
};

sub DE_Buss_und_Bettag # Dritter Werktag-Mittwoch im November
{
    my($year,$label) = @_;

    if (Day_of_Week($year,11,1) == 3)
    {
        return Nth_Weekday_of_Month_Year($year,11,3,4);
    }
    else
    {
        return Nth_Weekday_of_Month_Year($year,11,3,3);
    }
}

# Alternative:
# Buss- und Bettag = 1. Advent - 11 Tage
#        1. Advent = 4. Advent - 21 Tage (3 Wochen)
#        4. Advent = letzter Sonntag vor dem 25.12.
#sub DE_Buss_und_Bettag
#{
#    my($year,$label) = @_;
#
#    return Add_Delta_Days($year,12,25,
#        -(Day_of_Week($year,12,25)+32));
#}
# (Beide Alternativen sind auf dem Definitionsbereich
# [1583..2299] aequivalent!)

sub DE_Buss_und_Bettag2
{
    return( &DE_Buss_und_Bettag(@_), '#' );
}

sub Advent1
{
    my($year,$label) = @_;

    return( Add_Delta_Days($year,12,25,
        -(Day_of_Week($year,12,25)+21)), '#' );
}

sub Advent2
{
    my($year,$label) = @_;

    return( Add_Delta_Days($year,12,25,
        -(Day_of_Week($year,12,25)+14)), '#' );
}

sub Advent3
{
    my($year,$label) = @_;

    return( Add_Delta_Days($year,12,25,
        -(Day_of_Week($year,12,25)+7)), '#' );
}

sub Advent4
{
    my($year,$label) = @_;

    return( Add_Delta_Days($year,12,25,
        -Day_of_Week($year,12,25)), '#' );
}

${$Profiles}{'US'} = # Unites States of America
{
    # For labeling only (defaults, may be overridden):
    "Maundy Thursday"               => "#-3",
    "Good Friday"                   => "#-2",
    "Election Day"                  => \&US_Election,
    # Common legal holidays (in all federal states):
    "New Year's Day"                => \&US_New_Year,
    "Martin Luther King's Birthday" => "3/Mon/Jan",
    "President's Day"               => "3/Mon/Feb",
    "Memorial Day"                  => "5/Mon/May",
    "Independence Day"              => \&US_Independence,
    "Labor Day"                     => \&US_Labor,
    "Columbus Day"                  => "2/Mon/Oct",
    "Veterans' Day"                 => \&US_Veteran,
    "Thanksgiving Day"              => "4/Thu/Nov",
    "Christmas Day"                 => \&US_Christmas
};

sub US_Adjust1
{
    my($yy) = shift;
    my($mm) = shift;
    my($dd) = shift;
    my($dow);

# If holiday falls on Saturday, use following Monday instead;
# if holiday falls on Sunday, use day after (Monday) instead:

    $dow = Day_of_Week($yy,$mm,$dd);
    if    ($dow == 6) { ($yy,$mm,$dd) = Add_Delta_Days($yy,$mm,$dd,+2); }
    elsif ($dow == 7) { ($yy,$mm,$dd) = Add_Delta_Days($yy,$mm,$dd,+1); }
    return($yy,$mm,$dd,@_);
}

sub US_Adjust2
{
    my($yy) = shift;
    my($mm) = shift;
    my($dd) = shift;
    my($dow);

# If holiday falls on Saturday, use day before (Friday) instead;
# if holiday falls on Sunday, use day after (Monday) instead:

    $dow = Day_of_Week($yy,$mm,$dd);
    if    ($dow == 6) { ($yy,$mm,$dd) = Add_Delta_Days($yy,$mm,$dd,-1); }
    elsif ($dow == 7) { ($yy,$mm,$dd) = Add_Delta_Days($yy,$mm,$dd,+1); }
    return($yy,$mm,$dd,@_);
}

sub US_New_Year # First of January
{
    my($year,$label) = @_;

    return &US_Adjust1($year,1,1);
}

sub US_Independence # Fourth of July
{
    my($year,$label) = @_;

    return &US_Adjust2($year,7,4);
}

sub US_Labor # First Monday after the first Sunday in September
{
    my($year,$label) = @_;

    return Add_Delta_Days(
        Nth_Weekday_of_Month_Year($year,9,7,1), +1);
}

sub US_Election # First Tuesday after the first Monday in November
{
    my($year,$label) = @_;

    return( Add_Delta_Days(
        Nth_Weekday_of_Month_Year($year,11,1,1), +1), '#' );
}

sub US_Veteran # Eleventh of November
{
    my($year,$label) = @_;

    return &US_Adjust2($year,11,11);
}

sub US_Christmas # 25th of December
{
    my($year,$label) = @_;

    return &US_Adjust1($year,12,25);
}

${$Profiles}{'US-AK'} = # Alaska
{
    %{${$Profiles}{'US'}}
};
${$Profiles}{'US-AL'} = # Alabama
{
    %{${$Profiles}{'US'}}
};
${$Profiles}{'US-AR'} = # Arkansas
{
    %{${$Profiles}{'US'}}
};
${$Profiles}{'US-AS'} = # American Samoa
{
    %{${$Profiles}{'US'}}
};
${$Profiles}{'US-AZ'} = # Arizona
{
    %{${$Profiles}{'US'}}
};
${$Profiles}{'US-CA'} = # California
{
    %{${$Profiles}{'US'}}
};
${$Profiles}{'US-CO'} = # Colorado
{
    %{${$Profiles}{'US'}}
};
${$Profiles}{'US-CT'} = # Connecticut
{
    %{${$Profiles}{'US'}}
};
${$Profiles}{'US-DC'} = # District of Columbia
{
    %{${$Profiles}{'US'}}
};
${$Profiles}{'US-DE'} = # Delaware
{
    %{${$Profiles}{'US'}}
};
${$Profiles}{'US-FL'} = # Florida
{
    %{${$Profiles}{'US'}}
};
${$Profiles}{'US-FM'} = # Federated States of Micronesia
{
    %{${$Profiles}{'US'}}
};
${$Profiles}{'US-GA'} = # Georgia
{
    %{${$Profiles}{'US'}}
};
${$Profiles}{'US-GU'} = # Guam
{
    %{${$Profiles}{'US'}}
};
${$Profiles}{'US-HI'} = # Hawaii
{
    %{${$Profiles}{'US'}}
};
${$Profiles}{'US-IA'} = # Iowa
{
    %{${$Profiles}{'US'}}
};
${$Profiles}{'US-ID'} = # Idaho
{
    %{${$Profiles}{'US'}}
};
${$Profiles}{'US-IL'} = # Illinois
{
    %{${$Profiles}{'US'}}
};
${$Profiles}{'US-IN'} = # Indiana
{
    %{${$Profiles}{'US'}}
};
${$Profiles}{'US-KS'} = # Kansas
{
    %{${$Profiles}{'US'}}
};
${$Profiles}{'US-KY'} = # Kentucky
{
    %{${$Profiles}{'US'}}
};
${$Profiles}{'US-LA'} = # Louisiana
{
    %{${$Profiles}{'US'}}
};
${$Profiles}{'US-MA'} = # Massachusetts
{
    %{${$Profiles}{'US'}}
};
${$Profiles}{'US-MD'} = # Maryland
{
    %{${$Profiles}{'US'}}
};
${$Profiles}{'US-ME'} = # Maine
{
    %{${$Profiles}{'US'}}
};
${$Profiles}{'US-MH'} = # Marshall Islands
{
    %{${$Profiles}{'US'}}
};
${$Profiles}{'US-MI'} = # Michigan
{
    %{${$Profiles}{'US'}}
};
${$Profiles}{'US-MN'} = # Minnesota
{
    %{${$Profiles}{'US'}}
};
${$Profiles}{'US-MO'} = # Missouri
{
    %{${$Profiles}{'US'}}
};
${$Profiles}{'US-MP'} = # Northern Mariana Islands
{
    %{${$Profiles}{'US'}}
};
${$Profiles}{'US-MS'} = # Mississippi
{
    %{${$Profiles}{'US'}}
};
${$Profiles}{'US-MT'} = # Montana
{
    %{${$Profiles}{'US'}}
};
${$Profiles}{'US-NC'} = # North Carolina
{
    %{${$Profiles}{'US'}}
};
${$Profiles}{'US-ND'} = # North Dakota
{
    %{${$Profiles}{'US'}}
};
${$Profiles}{'US-NE'} = # Nebraska
{
    %{${$Profiles}{'US'}}
};
${$Profiles}{'US-NH'} = # New Hampshire
{
    %{${$Profiles}{'US'}}
};
${$Profiles}{'US-NJ'} = # New Jersey
{
    %{${$Profiles}{'US'}}
};
${$Profiles}{'US-NM'} = # New Mexico
{
    %{${$Profiles}{'US'}}
};
${$Profiles}{'US-NV'} = # Nevada
{
    %{${$Profiles}{'US'}}
};
${$Profiles}{'US-NY'} = # New York
{
    %{${$Profiles}{'US'}}
};
${$Profiles}{'US-OH'} = # Ohio
{
    %{${$Profiles}{'US'}}
};
${$Profiles}{'US-OK'} = # Oklahoma
{
    %{${$Profiles}{'US'}}
};
${$Profiles}{'US-OR'} = # Oregon
{
    %{${$Profiles}{'US'}}
};
${$Profiles}{'US-PA'} = # Pennsylvania
{
    %{${$Profiles}{'US'}}
};
${$Profiles}{'US-PR'} = # Puerto Rico
{
    %{${$Profiles}{'US'}}
};
${$Profiles}{'US-PW'} = # Palau
{
    %{${$Profiles}{'US'}}
};
${$Profiles}{'US-RI'} = # Rhode Island
{
    %{${$Profiles}{'US'}}
};
${$Profiles}{'US-SC'} = # South Carolina
{
    %{${$Profiles}{'US'}}
};
${$Profiles}{'US-SD'} = # South Dakota
{
    %{${$Profiles}{'US'}}
};
${$Profiles}{'US-TN'} = # Tennessee
{
    %{${$Profiles}{'US'}}
};
${$Profiles}{'US-TX'} = # Texas
{
    %{${$Profiles}{'US'}}
};
${$Profiles}{'US-UT'} = # Utah
{
    %{${$Profiles}{'US'}}
};
${$Profiles}{'US-VA'} = # Virginia
{
    %{${$Profiles}{'US'}}
};
${$Profiles}{'US-VI'} = # Virgin Islands
{
    %{${$Profiles}{'US'}}
};
${$Profiles}{'US-VT'} = # Vermont
{
    %{${$Profiles}{'US'}}
};
${$Profiles}{'US-WA'} = # Washington
{
    %{${$Profiles}{'US'}}
};
${$Profiles}{'US-WI'} = # Wisconsin
{
    %{${$Profiles}{'US'}}
};
${$Profiles}{'US-WV'} = # West Virginia
{
    %{${$Profiles}{'US'}}
};
${$Profiles}{'US-WY'} = # Wyoming
{
    %{${$Profiles}{'US'}}
};

${$Profiles}{'CA'} = # Canada
{
    "New Year's Day"       => "Jan/01",
    "Good Friday"          => "-2",
    "Labour Day"           => "1/Mon/Sep",
    "Christmas Day"        => "Dec/25"
};

${$Profiles}{'CA-AB'} = # Alberta
{
    %{${$Profiles}{'CA'}},
    "Family Day"           => "3/Mon/Feb",
    "Victoria Day"         => "May/22",
    "Canada Day"           => "Jul/01",
    "Thanksgiving Day"     => "2/Mon/Oct",
    "Remembrance Day"      => "Nov/11"
};
${$Profiles}{'CA-BC'} = # British Columbia
{
    %{${$Profiles}{'CA'}},
    "Victoria Day"         => "May/22",
    "Canada Day"           => "Jul/01",
    "British Columbia Day" => "1/Mon/Aug",
    "Thanksgiving Day"     => "2/Mon/Oct",
    "Remembrance Day"      => "Nov/11"
};
${$Profiles}{'CA-MB'} = # Manitoba
{
    %{${$Profiles}{'CA'}},
    "Victoria Day"         => "May/22",
    "Canada Day"           => "Jul/01",
    "Thanksgiving Day"     => "2/Mon/Oct"
};
${$Profiles}{'CA-NB'} = # New Brunswick
{
    %{${$Profiles}{'CA'}},
    "Canada Day"           => "Jul/01",
    "New Brunswick Day"    => "1/Mon/Aug"
};
${$Profiles}{'CA-NF'} = # Newfoundland
{
    %{${$Profiles}{'CA'}},
    "Memorial Day"         => "Jul/01"
};
${$Profiles}{'CA-NS'} = # Nova Scotia
{
    %{${$Profiles}{'CA'}},
    "Canada Day"           => "Jul/01"
};
${$Profiles}{'CA-NT'} = # Northwest Territories and Nunavut
{
    %{${$Profiles}{'CA'}},
    "Victoria Day"         => "May/22",
    "Canada Day"           => "Jul/01",
    "Thanksgiving Day"     => "2/Mon/Oct",
    "Remembrance Day"      => "Nov/11"
};
${$Profiles}{'CA-ON'} = # Ontario
{
    %{${$Profiles}{'CA'}},
    "Victoria Day"         => "May/22",
    "Canada Day"           => "Jul/01",
    "Thanksgiving Day"     => "2/Mon/Oct",
    "Boxing Day"           => "Dec/26"
};
${$Profiles}{'CA-PE'} = # Prince Edward Island
{
    %{${$Profiles}{'CA'}},
    "Canada Day"           => "Jul/01"
};
${$Profiles}{'CA-QC'} = # Quebec
{
    %{${$Profiles}{'CA'}},
    "Victoria Day"         => "May/22",
    "Canada Day"           => "Jul/01",
    "Thanksgiving Day"     => "2/Mon/Oct"
};
${$Profiles}{'CA-SK'} = # Saskatchewan
{
    %{${$Profiles}{'CA'}},
    "Victoria Day"         => "May/22",
    "Canada Day"           => "Jul/01",
    "Saskatchewan Day"     => "1/Mon/Aug",
    "Thanksgiving Day"     => "2/Mon/Oct",
    "Remembrance Day"      => "Nov/11"
};
${$Profiles}{'CA-YK'} = # Yukon Territory
{
    %{${$Profiles}{'CA'}},
    "Victoria Day"         => "May/22",
    "Canada Day"           => "Jul/01",
    "Discovery Day"        => "3/Mon/Aug",
    "Thanksgiving Day"     => "2/Mon/Oct",
    "Remembrance Day"      => "Nov/11"
};

${$Profiles}{'sdm'} = # software design & management AG
{
    "Heiligabend"               => ":24.12.",
    "Sylvester"                 => ":31.12."
};

${$Profiles}{'sdm-MUC'} = { %{${$Profiles}{'DE-BY'}}, %{${$Profiles}{'sdm'}} };
${$Profiles}{'sdm-STG'} = { %{${$Profiles}{'DE-BW'}}, %{${$Profiles}{'sdm'}} };
${$Profiles}{'sdm-FFM'} = { %{${$Profiles}{'DE-HE'}}, %{${$Profiles}{'sdm'}} };
${$Profiles}{'sdm-BON'} = { %{${$Profiles}{'DE-NW'}}, %{${$Profiles}{'sdm'}} };
${$Profiles}{'sdm-RAT'} = { %{${$Profiles}{'DE-NW'}}, %{${$Profiles}{'sdm'}} };
${$Profiles}{'sdm-HAN'} = { %{${$Profiles}{'DE-NI'}}, %{${$Profiles}{'sdm'}} };
${$Profiles}{'sdm-HH'}  = { %{${$Profiles}{'DE-HH'}}, %{${$Profiles}{'sdm'}} };
${$Profiles}{'sdm-DET'} = { %{${$Profiles}{'US-MI'}}, %{${$Profiles}{'sdm'}} };

${$Profiles}{'AT'} = # Oesterreich
{
    "Neujahr"                   => "01.01.",
    "Dreikönigstag"             => "06.01.",
    "Karfreitag"                => "#-2", # regional unterschiedlich
    "Ostersonntag"              => "+0",
    "Ostermontag"               => "+1",
    "Staatsfeiertag"            => "01.05.",
    "Christi Himmelfahrt"       => "+39",
    "Pfingstsonntag"            => "+49",
    "Pfingstmontag"             => "+50",
    "Fronleichnam"              => "+60",
    "Mariä Himmelfahrt"         => "15.08.",
    "Nationalfeiertag"          => "26.10.",
    "Allerheiligen"             => "01.11.",
    "Mariä Empfängnis"          => "08.12.",
    "Christtag"                 => "25.12.",
    "Stephanitag"               => "26.12."
};

${$Profiles}{'CH-DE'} = # Schweiz
{
    "Neujahr"                   => "01.01.",
    "Dreikönigstag"             => "06.01.",
    "Karfreitag"                => "#-2", # regional unterschiedlich
    "Ostersonntag"              => "+0",
    "Ostermontag"               => "+1",
    "Auffahrt"                  => "+39",
    "Pfingstsonntag"            => "+49",
    "Pfingstmontag"             => "+50",
    "Fronleichnam"              => "#+60", # regional unterschiedlich
    "Bundesfeiertag"            => "01.08.",
    "Mariä Himmelfahrt"         => "#15.08.", # regional unterschiedlich
    "Allerheiligen"             => "#01.11.", # regional unterschiedlich
    "Weihnachten"               => "25.12.",
    "Stefanstag"                => "26.12."
};
${$Profiles}{'CH-FR'} = # Suisse
{
};
${$Profiles}{'CH-IT'} = # Switzerland - Italian
{
};
${$Profiles}{'CH-RM'} = # Switzerland - Rhaeto-Romance
{
};

${$Profiles}{'FR'} = # France
{
    "Nouvel An"                 => "01.01.",
    "Dimanche de Pâques"        => "+0",
    "Lundi de Pâques"           => "+1",
    "Jour du Travail"           => "01.05.",
    "Armistice 1945"            => "08.05.",
    "Ascension du Christ"       => "+39",
    "Dimanche de Pentecôte"     => "+49",
    "Lundi de Pentecôte"        => "+50",
    "Jour de la République"     => "14.07.",
    "Ascension de Marie"        => "15.08.",
    "Toussaint"                 => "01.11.",
    "Armistice 1918"            => "11.11.",
    "Noël"                      => "25.12."
};

${$Profiles}{'BE-DE'} = # Belgien
{
    "Neujahr"                   => "01.01.",
    "Ostersonntag"              => "+0",
    "Ostermontag"               => "+1",
    "Tag der Arbeit"            => "01.05.",
    "Christi Himmelfahrt"       => "+39",
    "Pfingstsonntag"            => "+49",
    "Pfingstmontag"             => "+50",
    "Nationalfeiertag"          => "21.07.",
    "Mariä Himmelfahrt"         => "15.08.",
    "Allerheiligen"             => "01.11.",
    "Allerseelen"               => "02.11.",
    "Waffenstillstand 1918"     => "11.11.",
    "1. Weihnachtsfeiertag"     => "25.12.",
    "2. Weihnachtsfeiertag"     => "26.12."
};
${$Profiles}{'BE-NL'} = # Belgie
{
};
${$Profiles}{'BE-FR'} = # Belgique
{
    "Nouvel An"                 => "01.01.",
    "Dimanche de Pâques"        => "+0",
    "Lundi de Pâques"           => "+1",
    "Jour du Travail"           => "01.05.",
    "Ascension du Christ"       => "+39",
    "Dimanche de Pentecôte"     => "+49",
    "Lundi de Pentecôte"        => "+50",
    "Jour National"             => "21.07.",
    "Ascension de Marie"        => "15.08.",
    "Toussaint"                 => "01.11.",
    "???"                       => "02.11.",
    "Armistice 1918"            => "11.11.",
    "Noël(1)"                   => "25.12.",
    "Noël(2)"                   => "26.12."
};

${$Profiles}{'LU-DE'} = # Grossherzogtum Luxemburg
{
    "Neujahr"                   => "01.01.",
    "Fastnachtsmontag"          => "#-48", # regional unterschiedlich
    "Ostersonntag"              => "+0",
    "Ostermontag"               => "+1",
    "Tag der Arbeit"            => "01.05.",
    "Christi Himmelfahrt"       => "+39",
    "Pfingstsonntag"            => "+49",
    "Pfingstmontag"             => "+50",
    "Nationalfeiertag"          => "23.06.",
    "Mariä Himmelfahrt"         => "15.08.",
    "Allerheiligen"             => "01.11.",
    "Allerseelen"               => "#02.11.", # regional unterschiedlich
    "1. Weihnachtsfeiertag"     => "25.12.",
    "2. Weihnachtsfeiertag"     => "26.12."
};
${$Profiles}{'LU-FR'} = # Grand Duche du Luxembourg
{
    "Nouvel An"                 => "01.01.",
    "Veille du Mardi Gras"      => "#-48", # varie selon la region
    "Dimanche de Pâques"        => "+0",
    "Lundi de Pâques"           => "+1",
    "Jour du Travail"           => "01.05.",
    "Ascension du Christ"       => "+39",
    "Dimanche de Pentecôte"     => "+49",
    "Lundi de Pentecôte"        => "+50",
    "Jour National"             => "23.06.",
    "Ascension de Marie"        => "15.08.",
    "Toussaint"                 => "01.11.",
    "???"                       => "#02.11.", # varie selon la region
    "Noël(1)"                   => "25.12.",
    "Noël(2)"                   => "26.12."
};

${$Profiles}{'PT'} = # Portugal
{
    "Ano Novo"                  => "01.01.",
    "Terça-feira de Carnaval"   => "-47",
    "Sexta-feira de Páscoas"    => "-2",
    "Domingo de Páscoas"        => "+0",
    "Dia da Liberdade"          => "25.04.",
    "Dia do Trabalho"           => "01.05.",
    "Ascensão de Christo"       => "+39",
    "Domingo de Pentecostes"    => "+49",
    "Dia Nacional"              => "10.06.",
    "???"                       => "#+60", # varia segundo a regiao
    "Ascensão de Maria"         => "15.08.",
    "Dia da República"          => "05.10.",
    "Todos os Santos"           => "01.11.",
    "Dia da Independência"      => "01.12.",
    "Conceição de Maria"        => "08.12.",
    "Natal"                     => "25.12."
};

${$Profiles}{'ES'} = # Espana
{
    "Año Nuevo"                 => "01.01.",
    "Dia de los Tres Reyes"     => "06.01.",
    "Dia de Santo José"         => "19.03.",
    "Jueves antes de Páscuas"   => "-3",
    "Viernes antes de Páscuas"  => "-2",
    "Domingo de Páscuas"        => "+0",
    "Lunes de Páscuas"          => "#+1", # varia segundo la region
    "Dia del Trabajo"           => "01.05.",
    "Domingo de Pentecostes"    => "+49",
    "Santiago Apóstol"          => "25.07.",
    "Ascensión de Maria"        => "#15.08.", # varia segundo la region
    "Dia Nacional"              => "12.10.",
    "Todos Santos"              => "01.11.",
    "Dia de la Constitución"    => "06.12.",
    "Dia de la Concepción"      => "08.12.",
    "Páscuas de Navidad"        => "25.12."
};

#${$Profiles}{'IT'} = # Italia
#{
#    "Neujahr"                   => "01.01.",
#    "Dreikönigstag"             => "06.01.",
#    "Josephstag"                => "19.03.",
#    "Ostersonntag"              => "+0",
#    "Ostermontag"               => "+1",
#    "Tag der Befreiung"         => "25.04.",
#    "Tag der Arbeit"            => "01.05.",
#    "Pfingstsonntag"            => "+49",
#    "Peter und Paul"            => "#29.06.", # regional unterschiedlich
#    "Mariä Himmelfahrt"         => "15.08.",
#    "Allerheiligen"             => "01.11.",
#    "Mariä Empfängnis"          => "08.12.",
#    "1. Weihnachtsfeiertag"     => "25.12.",
#    "2. Weihnachtsfeiertag"     => "26.12."
#};

#${$Profiles}{'GR'} = # Greece
#{
#    "Neujahr"                   => "01.01.",
#    "Dreikönigstag"             => "06.01.",
#    "Rosenmontag"               => "-48",
#    "Mariä Verkündung"          => "25.03.",
#    "Karfreitag"                => "-2",
#    "Ostersonntag"              => "+0",
#    "Ostermontag"               => "+1",
#    "Tag der Arbeit"            => "01.05.",
#    "Christi Himmelfahrt"       => "+39",
#    "Pfingstsonntag"            => "+49",
#    "Pfingstmontag"             => "+50",
#    "Mariä Himmelfahrt"         => "15.08.",
#    "Fest der Kreuzerhöhung"    => "14.09.",
#    "Nationalfeiertag"          => "28.10.",
#    "1. Weihnachtsfeiertag"     => "25.12.",
#    "2. Weihnachtsfeiertag"     => "26.12."
#};

#${$Profiles}{'DK'} = # Denmark
#{
#    "Neujahr"                   => "01.01.",
#    "Gr\xfcndonnerstag"            => "-3",
#    "Karfreitag"                => "-2",
#    "Ostersonntag"              => "+0",
#    "Ostermontag"               => "+1",
#    "Bettag"                    => "+26",
#    "Christi Himmelfahrt"       => "+39",
#    "Pfingstsonntag"            => "+49",
#    "Pfingstmontag"             => "+50",
#    "Verfassungstag"            => "05.06.",
#    "1. Weihnachtsfeiertag"     => "25.12.",
#    "2. Weihnachtsfeiertag"     => "26.12."
#};

#${$Profiles}{'NL'} = # Nederland
#{
#    "Neujahr"                   => "01.01.",
#    "Karfreitag"                => "-2",
#    "Ostersonntag"              => "+0",
#    "Ostermontag"               => "+1",
#    "Koninginnedag"             => \&Koninginne,
#    "Befreiungstag"             => "05.05.",
#    "Christi Himmelfahrt"       => "+39",
#    "Pfingstsonntag"            => "+49",
#    "Pfingstmontag"             => "+50",
#    "1. Weihnachtsfeiertag"     => "25.12.",
#    "2. Weihnachtsfeiertag"     => "26.12."
#};

sub NL_Koninginne
{
    my($year,$label) = @_;
    my(@date);

    @date = ($year,4,30);
    if (Day_of_Week(@date) == 7) { @date = Add_Delta_Days(@date,-1); }
    return(@date);
}

${$Profiles}{'SV'} = # Sweden
{
    "New Years Day"             => "01.01",
    "Twelfth Day"               => "06.01",
    "Good Friday"               => "-2",
    "Easter Sunday"             => "+0",
    "Easter Monday"             => "+1",
    "May 1st"                   => "01.05.",
    "Ascension Day"             => "+39",
    "Whitsunday"                => "+49",
    "Whitmonday"                => "+50",
    "Midsummer's Day"           => \&SV_Midsummer,
    "All Saints' Day"           => \&SV_AllSaints,
    "Christmas Day"             => "25.12.",
    "Boxing Day"                => "26.12."
};

# Erland Sommarskog <sommar@algonet.se> sent me the following
# two formulas, but my pocket calendar gives different dates
# for 2000 than the ones calculated by them. I decided to
# use his formulas anyway for lack of a better guess, but
# please correct me if this should indeed be wrong!

sub SV_Midsummer # Saturday that falls on June 20th to 26th
{
    my($year,$label) = @_;

    return Add_Delta_Days($year,6,28,
        -(Day_of_Week($year,6,28)+1));
}

sub SV_AllSaints # Saturday that falls on Oct 31st to Nov 6th
{
    my($year,$label) = @_;

    return Add_Delta_Days($year,11,8,
        -(Day_of_Week($year,11,8)+1));
}

${$Profiles}{'NO'} = # Norway
{
    "Nyttårsdag"            => "01/01",
    "Skjærtorsdag"          => "-3",
    "Langfredag"            => "-2",
    "Påskedag"              => "+0",
    "2. Påskedag"           => "+1",
    "1. mai"                => "05/01",
    "Grunnlovsdag"          => "05/17",
    "Kristi himmelfartsdag" => "+39",
    "Pinsedag"              => "+49",
    "2. Pinsedag"           => "+50",
    "Juledag"               => "12/25",
    "2. Juledag"            => "12/26",
};

${$Profiles}{'GB'} = # Great Britain
{
    "New Year's Day"            => "01.01.",
    "New Year's Bank Holiday"   => \&GB_New_Year,
    "Good Friday"               => "-2",
    "Easter Sunday"             => "+0",
    "Easter Monday"             => "+1",
    "Early May Bank Holiday"    => \&GB_Early_May,
    "Late May Bank Holiday"     => "5/Mon/May", # Last Monday
#
# Jonathan Stowe <gellyfish@gellyfish.com> told me that spring
# bank holiday is the first Monday after Whitsun, but my pocket
# calendar suggests otherwise. I decided to follow my pocket
# guide and an educated guess ;-), but please correct me if
# we're wrong!
#
    "Summer Bank Holiday"       => "5/Mon/Aug", # Last Monday
    "Christmas Day"             => "25.12.",
    "Boxing Day"                => "26.12.",
    "Christmas Bank Holiday"    => \&GB_Christmas,
    "Boxing Bank Holiday"       => \&GB_Boxing
};

sub GB_New_Year # Next Monday if New Year falls on Saturday or Sunday
{
    my($year,$label) = @_;
    my(@date);
    my($dow);

    @date = ($year,1,1);
    $dow = Day_of_Week(@date);
    if    ($dow == 6) { return Add_Delta_Days(@date,+2); }
    elsif ($dow == 7) { return Add_Delta_Days(@date,+1); }
    else              { return (); }
}

# The following formula (also from Jonathan Stowe <gellyfish@gellyfish.com>)
# also contradicts my pocket calendar, but for lack of a better guess I
# left it as it is. Please tell me the correct formula in case this one
# is wrong! Thank you!

sub GB_Early_May # May bank holiday is the first Monday after May 1st
{
    my($year,$label) = @_;

    if (Day_of_Week($year,5,1) == 1)
        { return Nth_Weekday_of_Month_Year($year,5,1,2); }
    else
        { return Nth_Weekday_of_Month_Year($year,5,1,1); }
}

# If Christmas day and/or the day after (Boxing Day) fall on a weekend
# then Monday and/or Tuesday is a bank holiday:

sub GB_Christmas
{
    my($year,$label) = @_;
    my(@date);
    my($dow);

    @date = ($year,12,25);
    $dow = Day_of_Week(@date);
    if (($dow == 6) or ($dow == 7))
    {
        return Add_Delta_Days(@date,+2);
    }
    else { return (); }
}

sub GB_Boxing
{
    my($year,$label) = @_;
    my(@date);
    my($dow);

    @date = ($year,12,26);
    $dow = Day_of_Week(@date);
    if (($dow == 6) or ($dow == 7))
    {
        return Add_Delta_Days(@date,+2);
    }
    else { return (); }
}

1;

__END__

