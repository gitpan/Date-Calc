
##
## Based on Carp.pm from Perl 5.005_03.
## Modified 24-Jun-2000 by Steffen Beyer.
##
## This module is free software and can
## be used, modified and redistributed
## under the same terms as Perl itself.
##

package Carp::Clan;

# This package is heavily used. Be small. Be fast. Be good.

# Comments added by Andy Wardley <abw@kfs.org> 09-Apr-98, based on
# an _almost_ complete understanding of the package. Corrections
# and comments are welcome.

# The $Max(EvalLen|(Arg(Len|Nums)) variables are used to specify how
# the eval text and function arguments should be formatted when printed.

$MaxEvalLen = 0;        # How much eval '...text...' to show. 0 = all.
$MaxArgLen = 64;        # How much of each argument to print. 0 = all.
$MaxArgNums = 8;        # How many arguments to print. 0 = all.

$Verbose = 0;           # If true then make shortmess call longmess instead.

$VERSION = '5.0';

# longmess() crawls all the way up the stack reporting on all the function
# calls made. The error string, $error, is originally constructed from the
# arguments passed into longmess() via confess(), cluck() or shortmess().
# This gets appended with the stack trace messages which are generated for
# each function call on the stack.

sub longmess {
    return @_ if ref $_[0];
    local($^W) = 0; # For cases when overloaded stringify returns undef
    my $error = join '', @_;
    my $mess = "";
    my $i = 1;
    my ($pack,$file,$line,$sub,$hargs,$eval,$require);
    my (@a);
    #
    # Crawl up the stack....
    #
    while (do { { package DB; @a = caller($i++) } } ) {
        # Get copies of the variables returned from caller()
        ($pack,$file,$line,$sub,$hargs,undef,$eval,$require) = @a;
        #
        # If the $error error string is newline terminated then it
        # is copied into $mess. Otherwise, $mess gets set (at the end of
        # the 'else {' section below) to one of two things. The first time
        # through, it is set to the "$error at $file line $line" message.
        # $error is then set to 'called' which triggers subsequent loop
        # iterations to append $sub to $mess before appending the "$error
        # at $file line $line" which now actually reads "called at $file line
        # $line". Thus, the stack trace message is constructed:
        #
        #        first time: $mess  = $error at $file line $line
        #  subsequent times: $mess .= $sub $error at $file line $line
        #                                  ^^^^^^
        #                                 "called"
        if ($error =~ m/\n$/) {
            $mess .= $error;
        } else {
            # Build a string, $sub, which names the sub-routine called.
            # This may also be "require ...", "eval '...' or "eval {...}".
            if (defined $eval) {
                if ($require) {
                    $sub = "require $eval";
                } else {
                    $eval =~ s/([\\\'])/\\$1/g;
                    if ($MaxEvalLen && length($eval) > $MaxEvalLen) {
                        substr($eval,$MaxEvalLen) = '...';
                    }
                    $sub = "eval '$eval'";
                }
            } elsif ($sub eq '(eval)') {
                $sub = 'eval {...}';
            }
            # If there are any arguments in the sub-routine call, format
            # them according to the format variables defined earlier in
            # this file and join them onto the $sub sub-routine string.
            if ($hargs) {
                # We may trash some of the args so we take a copy
                @a = @DB::args; # Must get local copy of args
                # Don't print any more than $MaxArgNums
                if ($MaxArgNums and @a > $MaxArgNums) {
                    # Cap the length of $#a and set the last element to '...'
                    $#a = $MaxArgNums;
                    $a[$#a] = "...";
                }
                for (@a) {
                    # Set args to the string "undef" if undefined
                    $_ = "undef", next unless defined $_;
                    if (ref $_) {
                        # Dunno what this is for...
                        # $_ .= '';
                        # s/'/\\'/g;
                        # Well, it's for stringifying $_ and protecting \ and ':
                        $_ = "$_"; # Maybe more obvious...
                        s/([\\\'])/\\$1/g; # Pure paranoia here :-)
                    }
                    else {
                        # s/'/\\'/g;
                        s/([\\\'])/\\$1/g; # This is safer...
                        # Terminate the string early with '...' if too long
                        substr($_,$MaxArgLen) = '...'
                            if $MaxArgLen and $MaxArgLen < length;
                    }
                    # 'Quote' arg unless it looks like a number
                    $_ = "'$_'" unless /^-?[\d.]+$/;
                    # Print high-end chars as 'M-<char>' or '^<char>'
                    s/([\x80-\xFF])/"M-".chr(ord($1)&0x7F)/eg; # "Be fast"er ;-)
                    s/([\x00-\x1F\x7F])/"^".chr(ord($1)^0x40)/eg; # (sprintf is slow!)
                }
                # Append ('all', 'the', 'arguments') to the $sub string
                $sub .= '(' . join(', ', @a) . ')';
            }
            # Here's where the error message, $mess, gets constructed
            $mess .= "\t$sub " if $error eq "called";
            $mess .= "$error at $file line $line\n";
        }
        # We don't need to print the actual error message again so we can
        # change this to "called" so that the string "$error at $file line
        # $line" makes sense as "called at $file line $line".
        $error = "called";
    }
    # This kludge circumvents die's incorrect handling of NUL
    my $msg = \($mess || $error);
    $$msg =~ tr/\0//d;
    $$msg;
}

# shortmess() is called by carp() and croak() to skip all the way up to
# the top-level caller's package and report the error from there. confess()
# and cluck() generate a full stack trace so they call longmess() to
# generate that. In verbose mode shortmess() calls longmess() so you
# always get a stack trace.

sub shortmess { # Short-circuit &longmess if called via multiple packages
    my $pattern = shift;
    goto &longmess if $Verbose or $pattern eq 'verbose';
    return @_ if ref $_[0];
    my $error = join '', @_;
    my ($prevpack) = caller(1);
    my $i = 2;
    my ($pack,$file,$line,$sub);
    # When reporting an error, we want to report it from the context of the
    # calling package. So what is the calling package?  Within a module,
    # there may be many calls between methods and perhaps between sub-classes
    # and super-classes, but the user isn't interested in what happens
    # inside the package. We start by building a hash array which keeps
    # track of all the packages to which the calling package belongs. We
    # do this by examining its @ISA variable. Any call from a base class
    # method (one of our caller's @ISA packages) can be ignored.
    my %isa = ($prevpack,1);

    # Merge all the caller's @ISA packages into %isa
    @isa{@{"${prevpack}::ISA"}} = ()
        if(defined @{"${prevpack}::ISA"});

    # Now we crawl up the calling stack and look at all the packages in
    # there. For each package, we look to see if it has an @ISA and then
    # we see if our caller features in that list. That would imply that
    # our caller is a derived class of that package and its calls can
    # also be ignored.
    while (($pack,$file,$line,$sub) = caller($i++)) {
        if(defined @{$pack . "::ISA"}) {
            my @i = @{$pack . "::ISA"};
            my %i;
            @i{@i} = ();
            # Merge any relevant packages into %isa
            @isa{@i,$pack} = ()
                if(exists $i{$prevpack} || exists $isa{$pack});
        }

        # And here's where we do the ignoring... If the package in
        # question is one of our caller's base or derived packages then
        # we can ignore it (skip it) and go on to the next (but note that
        # the continue { } block below gets called every time).
        next
            if (exists $isa{$pack});

        # Hey! We've found a package that isn't one of our caller's
        # related classes... But wait, we must make sure it doesn't
        # match our family of packages/classes to be skipped. If the
        # package matches the given family pattern, then this is a
        # false alarm. We must merge the package into the %isa hash
        # (so we can ignore it if it pops up again), and continue.
        if ($pack =~ /$pattern/) {
            %isa = ($pack,1);
            @isa{@{$pack . "::ISA"}} = ()
                if (defined @{$pack . "::ISA"});
        }
        else {
            # OK! We've got a candidate package. Time to construct the
            # relevant error message and return it. die() doesn't like
            # to be given NUL characters (which $msg may contain) so we
            # remove them first.
            (my $msg = "$sub(): $error at $file line $line\n") =~ tr/\0//d;
            return $msg;
        }
    }
    continue {
        $prevpack = $pack;
    }

    # Uh-oh! It looks like we crawled all the way up the stack and
    # never found a candidate package. Oh well, let's call longmess
    # to generate a full stack trace. We use the magical form of 'goto'
    # so that this shortmess() function doesn't appear on the stack
    # to further confuse longmess() about it's calling package.
    goto &longmess;
}

# The following four functions call longmess() or shortmess() depending on
# whether they should generate a full stack trace (confess() and cluck())
# or simply report the caller's package (croak() and carp()), respectively.
# confess() and croak() die, carp() and cluck() warn.

# Following code kept for calls with fully qualified subroutine names:

sub croak   { die  shortmess( '^:::', @_ ) }
sub confess { die  longmess (         @_ ) }
sub carp    { warn shortmess( '^:::', @_ ) }
sub cluck   { warn longmess (         @_ ) }

# The following method imports a different closure for every caller!
# I.e., different modules can use this module at the same time
# and in parallel and still use different family patterns.

sub import {
    my $pkg     = shift;
    my $family  = shift || '^:::'; # Pattern never matching any class's name
    my $callpkg = caller(0);

#   $family = qr/$family/; # Speed up pattern match in Perl versions >= 5.005
    *{"${callpkg}::croak"}   = sub { die  shortmess( $family, @_ ) };
    *{"${callpkg}::confess"} = sub { die  longmess (          @_ ) };
    *{"${callpkg}::carp"}    = sub { warn shortmess( $family, @_ ) };
    *{"${callpkg}::cluck"}   = sub { warn longmess (          @_ ) };
}

1;

