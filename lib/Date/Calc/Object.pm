
###############################################################################
##                                                                           ##
##    Copyright (c) 2000 by Steffen Beyer.                                   ##
##    All rights reserved.                                                   ##
##                                                                           ##
##    This package is free software; you can redistribute it                 ##
##    and/or modify it under the same terms as Perl itself.                  ##
##                                                                           ##
###############################################################################

###############################################################################
##                                                                           ##
## Mottos of this module:                                                    ##
##                                                                           ##
## 1) Small is beautiful.                                                    ##
##                                                                           ##
## 2) Make frequent things easy and infrequent or hard things possible.      ##
##                                                                           ##
###############################################################################

package Date::Calc::Object;

use strict;
use vars qw(@ISA @EXPORT @EXPORT_OK %EXPORT_TAGS $VERSION);

BEGIN # Re-export imports from Date::Calc:
{
    require Exporter;
    require Date::Calc;
    @ISA         = qw(Exporter Date::Calc);
    @EXPORT      = @Date::Calc::EXPORT;
    @EXPORT_OK   = @Date::Calc::EXPORT_OK;
    %EXPORT_TAGS = (all => [@EXPORT_OK]);
    $VERSION     = '5.0';
    Date::Calc->import(@EXPORT,@EXPORT_OK);
}

package Date::Calc;

use Carp::Clan qw(^Date::);

use overload
      '0+' => 'number',
      '""' => 'string',
    'bool' => 'is_valid',
     'neg' => '_unary_minus_',
     'abs' => 'number',
       'x' => '_xerox_',
     '<=>' => '_compare_date_',
     'cmp' => '_compare_date_time_',
      '==' => '_equal_date_',
      '!=' => '_not_equal_date_',
      'eq' => '_equal_date_time_',
      'ne' => '_not_equal_date_time_',
       '+' => '_plus_',
       '-' => '_minus_',
      '+=' => '_plus_equal_',
      '-=' => '_minus_equal_',
      '++' => '_increment_',
      '--' => '_decrement_',
       '=' => 'clone',
'nomethod' => 'OVERLOAD', # equivalent of AUTOLOAD :-)
'fallback' =>  undef;

sub OVERLOAD # notify user
{
    croak("operator '$_[3]' is not implemented");
}

sub _xerox_ # prevent nonsense (e.g. nearly infinite loops)
{
    croak("operator 'x' is not implemented");
}

my $ACCURATE_MODE = 1;
my $NUMBER_FORMAT = 0;
my $DELTA_FORMAT = 0;
my $DATE_FORMAT = 0;

sub accurate_mode
{
    my($flag) = $ACCURATE_MODE;

    if (@_ > 1)
    {
        $ACCURATE_MODE = $_[1] || 0;
    }
    return $flag;
}

sub number_format
{
    my($flag) = $NUMBER_FORMAT;

    if (@_ > 1)
    {
        $NUMBER_FORMAT = $_[1] || 0;
    }
    return $flag;
}

sub delta_format
{
    my($flag) = $DELTA_FORMAT;

    if (@_ > 1)
    {
        $DELTA_FORMAT = $_[1] || 0;
    }
    return $flag;
}

sub date_format
{
    my($flag) = $DATE_FORMAT;

    if (@_ > 1)
    {
        $DATE_FORMAT = $_[1] || 0;
    }
    return $flag;
}

sub is_delta
{
    my($self) = @_;
    my($bool) = undef;

    eval
    {
        if (defined ${$self}[0]) { $bool = (${$self}[0] ? 1 : 0); }
    };
    if ($@) { $@ =~ s!\s+at\s+\S.*\s*$!!; croak($@); }
    return $bool;
}

sub is_date
{
    my($self) = @_;
    my($bool) = undef;

    eval
    {
        if (defined ${$self}[0]) { $bool = (${$self}[0] ? 0 : 1); }
    };
    if ($@) { $@ =~ s!\s+at\s+\S.*\s*$!!; croak($@); }
    return $bool;
}

sub is_short
{
    my($self) = @_;
    my($bool) = undef;

    eval
    {
        if    (@{$self} == 4) { $bool = 1; }
        elsif (@{$self} == 7) { $bool = 0; }
    };
    if ($@) { $@ =~ s!\s+at\s+\S.*\s*$!!; croak($@); }
    return $bool;
}

sub is_long
{
    my($self) = @_;
    my($bool) = undef;

    eval
    {
        if    (@{$self} == 7) { $bool = 1; }
        elsif (@{$self} == 4) { $bool = 0; }
    };
    if ($@) { $@ =~ s!\s+at\s+\S.*\s*$!!; croak($@); }
    return $bool;
}

sub is_valid
{
    my($self) = @_;
    my($bool);

    $bool = eval
    {
        if (defined ${$self}[0] and
            (${$self}[0] == 0 or ${$self}[0] == 1) and
            (@{$self}    == 4 or @{$self}    == 7))
        {
            if (${$self}[0]) # is_delta
            {
                return 0 unless
                (
                    defined ${$self}[1] and
                    defined ${$self}[2] and
                    defined ${$self}[3]
                );
                if (@{$self} > 4) # is_long
                {
                    return 0 unless
                    (
                        defined ${$self}[4] and
                        defined ${$self}[5] and
                        defined ${$self}[6]
                    );
                }
                return 1;
            }
            else # is_date
            {
                return 0 unless
                (
                    defined ${$self}[1] and
                    defined ${$self}[2] and
                    defined ${$self}[3] and
                    check_date(@{$self}[1..3])
                );
                if (@{$self} > 4) # is_long
                {
                    return 0 unless
                    (
                        defined ${$self}[4] and
                        defined ${$self}[5] and
                        defined ${$self}[6] and
                        check_time(@{$self}[4..6])
                    );
                }
                return 1;
            }
        }
        return undef;
    };
    if ($@) { $@ =~ s!\s+at\s+\S.*\s*$!!; croak($@); }
    return $bool;
}

sub new
{
    splice(@_,1,1,@{$_[1]}) if (@_ == 2 and ref($_[1]) eq 'ARRAY');

    croak("wrong number of arguments")
        unless (@_ == 1 or @_ == 2 or @_ == 4 or @_ == 5 or @_ == 7 or @_ == 8);

    my($class) = shift;
    my($type,$self);

    if (@_ == 1 or @_ == 4 or @_ == 7)
    {
        $type = (shift() ? 1 : 0);
        $self = [ $type, @_ ];
    }
    elsif (@_ == 3 or @_ == 6)
    {
        $self = [ 0, @_ ];
    }
    else
    {
        $self = [ ];
    }
    bless($self, ref($class) || $class || __PACKAGE__);
    return $self;
}

sub clone
{
    my($self) = @_;
    my($this);

    croak("invalid date/time") unless ($self->is_valid());
    $this = $self->new();
    @{$this} = @{$self};
    return $this;
}

sub copy
{
    my($self,$this) = @_;

    eval { @{$self} = @{$this}; };
    if ($@) { $@ =~ s!\s+at\s+\S.*\s*$!!; croak($@); }
    croak("invalid date/time") unless ($self->is_valid());
    return $self;
}

sub date
{
    splice(@_,1,1,@{$_[1]}) if (@_ == 2 and ref($_[1]) eq 'ARRAY');

    croak("wrong number of arguments")
        unless (@_ == 1 or @_ == 2 or @_ == 4 or @_ == 5 or @_ == 7 or @_ == 8);

    my($self) = shift;

    eval
    {
        if (@_ == 1 or @_ == 4 or @_ == 7)
        {
            ${$self}[0] = (shift() ? 1 : 0);
        }
        if (@_ == 3 or @_ == 6)
        {
            splice( @{$self}, 1, scalar(@_), @_ );
        }
    };
    if ($@) { $@ =~ s!\s+at\s+\S.*\s*$!!; croak($@); }
    croak("invalid date/time") unless ($self->is_valid());
    return (@{$self}[1..3]);
}

sub time
{
    splice(@_,1,1,@{$_[1]}) if (@_ == 2 and ref($_[1]) eq 'ARRAY');

    croak("wrong number of arguments")
        unless (@_ == 1 or @_ == 2 or @_ == 4 or @_ == 5);

    my($self) = shift;

    eval
    {
        if (@_ == 1 or @_ == 4)
        {
            ${$self}[0] = (shift() ? 1 : 0);
        }
        if (@_ == 3)
        {
            splice( @{$self}, 4, 3, @_ );
        }
    };
    if ($@) { $@ =~ s!\s+at\s+\S.*\s*$!!; croak($@); }
    croak("invalid date/time") unless ($self->is_valid());
    if (@{$self} == 7) { return (@{$self}[4..6]); }
    else               { return (); }
}

sub datetime
{
    splice(@_,1,1,@{$_[1]}) if (@_ == 2 and ref($_[1]) eq 'ARRAY');

    croak("wrong number of arguments")
        unless (@_ == 1 or @_ == 2 or @_ == 4 or @_ == 5 or @_ == 7 or @_ == 8);

    my($self) = shift;

    eval
    {
        if (@_ == 1 or @_ == 4 or @_ == 7)
        {
            ${$self}[0] = (shift() ? 1 : 0);
        }
        if (@_ == 3)
        {
            splice( @{$self}, 1, 6, @_, 0,0,0 );
        }
        elsif (@_ == 6)
        {
            splice( @{$self}, 1, 6, @_ );
        }
    };
    if ($@) { $@ =~ s!\s+at\s+\S.*\s*$!!; croak($@); }
    croak("invalid date/time") unless ($self->is_valid());
    if (@{$self} == 7) { return (@{$self}[1..6]); }
    else               { return (@{$self}[1..3],0,0,0); }
}

sub today
{
    my($self) = @_;

    if (ref $self)
    {
        $self->date( 0, Today() );
        return $self;
    }
    else
    {
        $self ||= __PACKAGE__;
        return $self->new( 0, Today() );
    }
}

sub now
{
    my($self) = @_;

    if (ref $self)
    {
        $self->time( 0, Now() );
        return $self;
    }
    else
    {
        $self ||= __PACKAGE__;
        return $self->new( 0, Today_and_Now() );
    }
}

sub today_and_now
{
    my($self) = @_;

    if (ref $self)
    {
        $self->date( 0, Today_and_Now() );
        return $self;
    }
    else
    {
        $self ||= __PACKAGE__;
        return $self->new( 0, Today_and_Now() );
    }
}

sub year
{
    my($self) = shift;

    if (@_ > 0)
    {
        eval { ${$self}[1] = $_[0] || 0; };
        if ($@) { $@ =~ s!\s+at\s+\S.*\s*$!!; croak($@); }
    }
    croak("invalid date/time") unless ($self->is_valid());
    return ${$self}[1];
}

sub month
{
    my($self) = shift;

    if (@_ > 0)
    {
        eval { ${$self}[2] = $_[0] || 0; };
        if ($@) { $@ =~ s!\s+at\s+\S.*\s*$!!; croak($@); }
    }
    croak("invalid date/time") unless ($self->is_valid());
    return ${$self}[2];
}

sub day
{
    my($self) = shift;

    if (@_ > 0)
    {
        eval { ${$self}[3] = $_[0] || 0; };
        if ($@) { $@ =~ s!\s+at\s+\S.*\s*$!!; croak($@); }
    }
    croak("invalid date/time") unless ($self->is_valid());
    return ${$self}[3];
}

sub hours
{
    my($self) = shift;

    if (@_ > 0)
    {
        eval
        {
            if (@{$self} == 4)
            {
                ${$self}[4] = 0;
                ${$self}[5] = 0;
                ${$self}[6] = 0;
            }
            if (@{$self} == 7)
            {
                ${$self}[4] = $_[0] || 0;
            }
        };
        if ($@) { $@ =~ s!\s+at\s+\S.*\s*$!!; croak($@); }
    }
    croak("invalid date/time") unless ($self->is_valid());
    if (@{$self} == 7) { return ${$self}[4]; }
    else               { return undef; }
}

sub minutes
{
    my($self) = shift;

    if (@_ > 0)
    {
        eval
        {
            if (@{$self} == 4)
            {
                ${$self}[4] = 0;
                ${$self}[5] = 0;
                ${$self}[6] = 0;
            }
            if (@{$self} == 7)
            {
                ${$self}[5] = $_[0] || 0;
            }
        };
        if ($@) { $@ =~ s!\s+at\s+\S.*\s*$!!; croak($@); }
    }
    croak("invalid date/time") unless ($self->is_valid());
    if (@{$self} == 7) { return ${$self}[5]; }
    else               { return undef; }
}

sub seconds
{
    my($self) = shift;

    if (@_ > 0)
    {
        eval
        {
            if (@{$self} == 4)
            {
                ${$self}[4] = 0;
                ${$self}[5] = 0;
                ${$self}[6] = 0;
            }
            if (@{$self} == 7)
            {
                ${$self}[6] = $_[0] || 0;
            }
        };
        if ($@) { $@ =~ s!\s+at\s+\S.*\s*$!!; croak($@); }
    }
    croak("invalid date/time") unless ($self->is_valid());
    if (@{$self} == 7) { return ${$self}[6]; }
    else               { return undef; }
}

sub number
{
    my($self) = shift;
    my($format,$sign,@temp);

    if ($self->is_valid())
    {              ################# = because of overloading!
        if (@_ > 0 and defined $_[0]) { $format = $_[0]; }
        else                          { $format = $NUMBER_FORMAT; }
        if (${$self}[0]) # is_delta
        {
            croak("can't convert a delta vector with year/month diff into a number")
                if ((${$self}[1] != 0) or (${$self}[2] != 0));
            if (@{$self} == 4) # is_short
            {
                return ${$self}[3];
            }
            else # is_long
            {
                if ($format == 2)
                {
                    return ${$self}[3] +
                        (((${$self}[4]*60+${$self}[5])*60+${$self}[6])/86400);
                }
                else
                {
                    local($_);
                    $sign = 0;
                    @temp = map( $_ < 0 ? $sign = -$_ : $_, Normalize_DHMS(@{$self}[3..6]) );
                    return sprintf( "%s%d.%02d%02d%02d", $sign ? '-' : '', @temp );
                }
            }
        }
        else # is_date
        {
            if (@{$self} == 4) # is_short
            {
                if ($format == 2 or $format == 1)
                {
                    return Date_to_Days( @{$self}[1..3] );
                }
                else
                {
                    return sprintf( "%04d%02d%02d",
                        @{$self}[1..3] );
                }
            }
            else # is_long
            {
                if ($format == 2)
                {
                    return Date_to_Days( @{$self}[1..3] ) +
                        (((${$self}[4]*60+${$self}[5])*60+${$self}[6])/86400);
                }
                elsif ($format == 1)
                {
                    return Date_to_Days( @{$self}[1..3] ) .
                        sprintf( ".%02d%02d%02d", @{$self}[4..6] );
                }
                else
                {
                    return sprintf( "%04d%02d%02d.%02d%02d%02d",
                        @{$self}[1..6] );
                }
            }
        }
    }
    return undef;
}

sub string
{
    my($self) = shift;
    my($format);

    if ($self->is_valid())
    {
        if (${$self}[0]) # is_delta
        {              ################# = because of overloading!
            if (@_ > 0 and defined $_[0]) { $format = $_[0]; }
            else                          { $format = $DELTA_FORMAT; }
            if (@{$self} == 4) # is_short
            {
                if ($format == 3)
                {
                    return sprintf( "%+d Y %+d M %+d D",
                        @{$self}[1..3] );
                }
                elsif ($format == 2)
                {
                    return sprintf( "%+dY %+dM %+dD",
                        @{$self}[1..3] );
                }
                elsif ($format == 1)
                {
                    return sprintf( "%+d %+d %+d",
                        @{$self}[1..3] );
                }
                else
                {
                    return sprintf( "%+d%+d%+d",
                        @{$self}[1..3] );
                }
            }
            else # is_long
            {
                if ($format == 3)
                {
                    return sprintf( "%+d Y %+d M %+d D %+d h %+d m %+d s",
                        @{$self}[1..6] );
                }
                elsif ($format == 2)
                {
                    return sprintf( "%+dY %+dM %+dD %+dh %+dm %+ds",
                        @{$self}[1..6] );
                }
                elsif ($format == 1)
                {
                    return sprintf( "%+d %+d %+d %+d %+d %+d",
                        @{$self}[1..6] );
                }
                else
                {
                    return sprintf( "%+d%+d%+d%+d%+d%+d",
                        @{$self}[1..6] );
                }
            }
        }
        else # is_date
        {              ################# = because of overloading!
            if (@_ > 0 and defined $_[0]) { $format = $_[0]; }
            else                          { $format = $DATE_FORMAT; }
            if (@{$self} == 4) # is_short
            {
                if ($format == 3)
                {
                    return Date_to_Text_Long( @{$self}[1..3] );
                }
                elsif ($format == 2)
                {
                    return Date_to_Text( @{$self}[1..3] );
                }
                elsif ($format == 1)
                {
                    return sprintf( "%02d-%.3s-%04d",
                        ${$self}[3],
                        Month_to_Text(${$self}[2]),
                        ${$self}[1] );
                }
                else
                {
                    return sprintf( "%04d%02d%02d",
                        @{$self}[1..3] );
                }
            }
            else # is_long
            {
                if ($format == 3)
                {
                    return Date_to_Text_Long( @{$self}[1..3] ) .
                        sprintf( " %02d:%02d:%02d", @{$self}[4..6] );
                }
                elsif ($format == 2)
                {
                    return Date_to_Text( @{$self}[1..3] ) .
                        sprintf( " %02d:%02d:%02d", @{$self}[4..6] );
                }
                elsif ($format == 1)
                {
                    return sprintf( "%02d-%.3s-%04d %02d:%02d:%02d",
                        ${$self}[3],
                        Month_to_Text(${$self}[2]),
                        ${$self}[1],
                        @{$self}[4..6] );
                }
                else
                {
                    return sprintf( "%04d%02d%02d%02d%02d%02d",
                        @{$self}[1..6] );
                }
            }
        }
    }
    return undef;
}

sub _process_
{
    my($self,$this,$flag,$code) = @_;
    my($result,$val1,$val2,$len1,$len2,$last,$item);

    croak("invalid date/time") unless ($self->is_valid());
    if ($code == 0)
    {
        croak("can't apply unary minus to a date")
            unless ($self->is_delta());
        $result = $self->new();
        ${$result}[0] = ${$self}[0];
        for ( $item = 1; $item < @{$self}; $item++ )
        {
            ${$result}[$item] = -${$self}[$item];
        }
        return $result;
    }
    if (defined $this and ref($this) =~ /::/)
    {
        croak("invalid date/time") unless ($this->is_valid());
    }
    elsif (defined $this and ref($this) eq 'ARRAY')
    {
        if (@{$this} == 3 or @{$this} == 6)
        {
            if ($code == 6)
            {
                $this = $self->new(0,@{$this});
            }
            elsif ($code == 5)
            {
                $this = $self->new($self->is_date(),@{$this});
            }
            else
            {
                $this = $self->new($self->is_delta(),@{$this});
            }
        }
        else
        {
            $this = $self->new(@{$this});
        }
        croak("invalid date/time") unless ($this->is_valid());
    }
    elsif (defined $this and not ref($this))
    {
        $this = $self->new(1,0,0,$this || 0);
        croak("invalid date/time") unless ($this->is_valid());
    }
    else { croak("illegal operand type"); }
    $val1 = $self->is_date();
    $val2 = $this->is_date();
    if ($code == 6 or $code == 5)
    {
        if ($code == 6)
        {
            croak("can't subtract a date from a delta vector")
                if ((not $val1 and $val2 and not $flag) or
                    ($val1 and not $val2 and $flag));
        }
        else
        {
            croak("can't add two dates")
                if ($val1 and $val2);
        }
        $len1 = $self->is_long();
        $len2 = $this->is_long();
        if ($len1 or $len2) { $last = 7; }
        else                { $last = 4; }
        if (defined $flag) { $result = $self->new((0) x $last); }
        else               { $result = $self; }
        if (not $val1 and not $val2)
        {
            ${$result}[0] = 1;
            for ( $item = 1; $item < $last; $item++ )
            {
                if ($code == 6)
                {
                    if ($flag)
                    {
                        ${$result}[$item] =
                            (${$this}[$item] || 0) -
                            (${$self}[$item] || 0);
                    }
                    else
                    {
                        ${$result}[$item] =
                            (${$self}[$item] || 0) -
                            (${$this}[$item] || 0);
                    }
                }
                else
                {
                    ${$result}[$item] =
                        (${$self}[$item] || 0) +
                        (${$this}[$item] || 0);
                }
            }
        }
        return ($result,$this,$val1,$val2,$len1,$len2);
    }
    elsif ($code <= 4 and $code >= 1)
    {
        croak("can't compare a date and a delta vector")
            if ($val1 xor $val2);
        if ($code >= 3)
        {
            if ($code == 4) { $last = 7; }
            else            { $last = 4; }
            $result = 1;
            ITEM:
            for ( $item = 1; $item < $last; $item++ )
            {
                if ((${$self}[$item] || 0) !=
                    (${$this}[$item] || 0))
                { $result = 0; last ITEM; }
            }
            return $result;
        }
        else # ($code <= 2)
        {
            croak("can't compare two delta vectors")
                if (not $val1 and not $val2);
            if ($code == 2)
            {
                $len1 = $self->number();
                $len2 = $this->number();
            }
            else
            {
                $len1 = int($self->number());
                $len2 = int($this->number());
            }
            if ($flag) { return $len2 <=> $len1; }
            else       { return $len1 <=> $len2; }
        }
    }
    else { croak("unexpected internal error; please contact author"); }
}

sub _unary_minus_
{
    my($self,$this,$flag) = @_;

    return $self->_process_($this,$flag,0);
}

sub _compare_date_
{
    my($self,$this,$flag) = @_;

    return $self->_process_($this,$flag,1);
}

sub _compare_date_time_
{
    my($self,$this,$flag) = @_;

    return $self->_process_($this,$flag,2);
}

sub _equal_date_
{
    my($self,$this,$flag) = @_;

    return $self->_process_($this,$flag,3);
}

sub _not_equal_date_
{
    my($self,$this,$flag) = @_;

    return $self->_process_($this,$flag,3) ^ 1;
}

sub _equal_date_time_
{
    my($self,$this,$flag) = @_;

    return $self->_process_($this,$flag,4);
}

sub _not_equal_date_time_
{
    my($self,$this,$flag) = @_;

    return $self->_process_($this,$flag,4) ^ 1;
}

sub _date_time_
{
    my($self) = @_;

    if (@{$self} == 7) { return (@{$self}[1..6]); }
    else               { return (@{$self}[1..3],0,0,0); }
}

sub _add_
{
    my($result,$self,$this,$flag,$val1,$val2,$len1,$len2) = @_;

    if ($val1) # date + delta => date
    {
        if ($len1 or $len2)
        {
            splice( @{$result}, 1, 6,
                Add_Delta_YMDHMS( $self->_date_time_(),
                                  $this->_date_time_() ) );
        }
        else # short
        {
            splice( @{$result}, 1, 3,
                Add_Delta_YMD( @{$self}[1..3], @{$this}[1..3] ) );
        }
    }
    else # delta + date => date
    {
        if ($len1 or $len2)
        {
            splice( @{$result}, 1, 6,
                Add_Delta_YMDHMS( $this->_date_time_(),
                                  $self->_date_time_() ) );
        }
        else # short
        {
            splice( @{$result}, 1, 3,
                Add_Delta_YMD( @{$this}[1..3], @{$self}[1..3] ) );
        }
        carp("implicitly changed object type from delta vector to date")
            if (not defined $flag and $^W);
    }
    ${$result}[0] = 0;
}

sub _plus_
{
    my($self,$this,$flag) = @_;
    my($result,$val1,$val2,$len1,$len2);

    ($result,$this,$val1,$val2,$len1,$len2) = $self->_process_($this,$flag,5);
    if ($val1 or $val2)
    {
        $result->_add_($self,$this,$flag,$val1,$val2,$len1,$len2);
    }
    return $result;
}

sub _minus_
{
    my($self,$this,$flag) = @_;
    my($result,$val1,$val2,$len1,$len2,$temp,$item);

    ($result,$this,$val1,$val2,$len1,$len2) = $self->_process_($this,$flag,6);
    if ($val1 or $val2)
    {
        if ($val1 and $val2) # date - date => delta
        {
            if ($len1 or $len2)
            {
                if ($ACCURATE_MODE)
                {
                    if ($flag)
                    {
                        splice( @{$result}, 1, 6, 0, 0,
                            Delta_DHMS( $self->_date_time_(),
                                        $this->_date_time_() ) );
                    }
                    else
                    {
                        splice( @{$result}, 1, 6, 0, 0,
                            Delta_DHMS( $this->_date_time_(),
                                        $self->_date_time_() ) );
                    }
                }
                else # YMD_MODE
                {
                    if ($flag)
                    {
                        splice( @{$result}, 1, 6,
                            Delta_YMDHMS( $self->_date_time_(),
                                          $this->_date_time_() ) );
                    }
                    else
                    {
                        splice( @{$result}, 1, 6,
                            Delta_YMDHMS( $this->_date_time_(),
                                          $self->_date_time_() ) );
                    }
                }
            }
            else # short
            {
                if ($ACCURATE_MODE)
                {
                    if ($flag)
                    {
                        splice( @{$result}, 1, 3, 0, 0,
                            Delta_Days( @{$self}[1..3], @{$this}[1..3] ) );
                    }
                    else
                    {
                        splice( @{$result}, 1, 3, 0, 0,
                            Delta_Days( @{$this}[1..3], @{$self}[1..3] ) );
                    }
                }
                else # YMD_MODE
                {
                    if ($flag)
                    {
                        splice( @{$result}, 1, 3,
                            Delta_YMD( @{$self}[1..3], @{$this}[1..3] ) );
                    }
                    else
                    {
                        splice( @{$result}, 1, 3,
                            Delta_YMD( @{$this}[1..3], @{$self}[1..3] ) );
                    }
                }
            }
            carp("implicitly changed object type from date to delta vector")
                if (not defined $flag and $^W);
            ${$result}[0] = 1;
        }
        else # date - delta => date
        {
            if ($val1)
            {
                $temp = $this->new();
                ${$temp}[0] = ${$this}[0];
                for ( $item = 1; $item < @{$this}; $item++ )
                {
                    ${$temp}[$item] = -${$this}[$item];
                }
                $result->_add_($self,$temp,$flag,$val1,$val2,$len1,$len2);
            }
            else
            {
                $temp = $self->new();
                ${$temp}[0] = ${$self}[0];
                for ( $item = 1; $item < @{$self}; $item++ )
                {
                    ${$temp}[$item] = -${$self}[$item];
                }
                $result->_add_($temp,$this,$flag,$val1,$val2,$len1,$len2);
            }
        }
    }
    return $result;
}

sub _plus_equal_
{
    my($self,$this) = @_;

    return $self->_plus_($this,undef);
}

sub _minus_equal_
{
    my($self,$this) = @_;

    return $self->_minus_($this,undef);
}

sub _increment_
{
    my($self) = @_;

    return $self->_plus_(1,undef);
}

sub _decrement_
{
    my($self) = @_;

    return $self->_minus_(1,undef);
}

1;

__END__

