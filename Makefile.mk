# This Makefile is for the Date::Calc extension to perl.
#
# It was generated automatically by MakeMaker version
# 5.0 (Revision: ) from the contents of
# Makefile.PL. Don't edit this file, edit Makefile.PL instead.
#
#	ANY CHANGES MADE HERE WILL BE LOST!
#
#   MakeMaker Parameters:

#	DEFINE => q[]
#	INC => q[]
#	LIBS => [q[]]
#	NAME => q[Date::Calc]
#	OBJECT => q[$(O_FILES)]
#	PREREQ_PM => { Bit::Vector=>q[5.7] }
#	VERSION_FROM => q[Calc.pm]
#	dist => { COMPRESS=>q[gzip -9], SUFFIX=>q[gz] }

# --- MakeMaker constants section:
NAME = Date::Calc
DISTNAME = Date-Calc
NAME_SYM = Date_Calc
VERSION = 5.0
VERSION_SYM = 5_0
XS_VERSION = 5.0
INST_LIB = MacintoshHD:MacPerl Ä:site_perl
INST_ARCHLIB = MacintoshHD:MacPerl Ä:site_perl
PERL_LIB = MacintoshHD:MacPerl Ä:site_perl
PERL = miniperl
FULLPERL = perl
SOURCE =  Calc.c Calc_68K.c DateCalc.c

MODULES = :lib:Carp:Clan.pm \
	:lib:Carp:Clan.pod \
	:lib:Date:Calc:Object.pm \
	:lib:Date:Calc:Object.pod \
	:lib:Date:Calendar:Profiles.pm \
	:lib:Date:Calendar:Profiles.pod \
	:lib:Date:Calendar:Year.pm \
	:lib:Date:Calendar:Year.pod \
	Calc.pm \
	Calc.pod \
	Calendar.pm \
	Calendar.pod
PMLIBDIRS = lib


.INCLUDE : $(PERL_SRC)BuildRules.mk


# FULLEXT = Pathname for extension directory (eg DBD:Oracle).
# BASEEXT = Basename part of FULLEXT. May be just equal FULLEXT.
# ROOTEXT = Directory part of FULLEXT (eg DBD)
# DLBASE  = Basename part of dynamic library. May be just equal BASEEXT.
FULLEXT = Date:Calc
BASEEXT = Calc
ROOTEXT = Date:
DEFINE = 
INC = 

# Handy lists of source code files:
XS_FILES= Calc.xs \
	Calc_68K.xs
C_FILES = Calc.c \
	Calc_68K.c \
	DateCalc.c
H_FILES = DateCalc.h \
	ToolBox.h


.INCLUDE : $(PERL_SRC)ext:ExtBuildRules.mk


# --- MakeMaker dlsyms section:

dynamic :: Calc.exp


Calc.exp: Makefile.PL
	$(PERL) "-I$(PERL_LIB)" -e 'use ExtUtils::Mksymlists; Mksymlists("NAME" => "Date::Calc", "DL_FUNCS" => {  }, "DL_VARS" => []);'


# --- MakeMaker dynamic section:

all :: dynamic

install :: do_install_dynamic

install_dynamic :: do_install_dynamic


# --- MakeMaker static section:

all :: static

install :: do_install_static

install_static :: do_install_static


# --- MakeMaker clean section:

# Delete temporary files but do not touch installed files. We don't delete
# the Makefile here so a later make realclean still has a makefile to use.

clean ::
	$(RM_RF) Calc_68K.c Calc.c
	$(MV) Makefile.mk Makefile.mk.old


# --- MakeMaker realclean section:

# Delete temporary files (via clean) and also delete installed files
realclean purge ::  clean
	$(RM_RF) Makefile.mk Makefile.mk.old


# --- MakeMaker postamble section:


# --- MakeMaker rulez section:

install install_static install_dynamic :: 
	$(PERL_SRC)PerlInstall -l $(PERL_LIB)
	$(PERL_SRC)PerlInstall -l "MacintoshHD:MacPerl Ä:site_perl:"

.INCLUDE : $(PERL_SRC)BulkBuildRules.mk


# End.
