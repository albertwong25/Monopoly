#!/usr/bin/perl -w
use strict;
use warnings;

our @lands;
package Land;

sub new
{
	my $class = shift;
	my $self = {
		_name => shift,
		_price => shift,
		_house => 0,
		_index => shift,
		_img => "",
		_img_s => "",
		_owner => "",
		_rent => shift,
		_type => shift,
		_housecost => shift
	};
	bless $self, $class;
	return $self;
}

sub buyHouse
{
	my( $self, $house ) = @_;
	$self->{_house} = $house if defined($house);
	return $self->{_house};
}

sub setOwner
{
	my( $self, $owner) = @_;
	$self->{_owner} = $owner if defined($owner);
	return $self->{_owner};
}

sub setRent
{
	my( $self, $rent) = @_; 
	$self->{_rent} = $rent if defined($rent);
	return $self->{_rent};
}

sub getRent
{
	my( $self ) = @_;
	return $self->{_rent};
} 

sub getHouseCost
{
	my( $self ) = @_;
	return $self->{_housecost};
}

sub getType
{
	my( $self ) = @_;
	return $self->{_type};
}

sub getOwner
{
	my( $self ) = @_;
	return $self->{_owner};
}

sub getHouse
{
	my( $self ) = @_;
	return $self->{_house};
}

sub getName
{
	my( $self ) = @_;
	return $self->{_name};
}

sub getPrice
{
	my( $self ) = @_;
	return $self->{_price};
}

sub getIndex
{
	my( $self ) = @_;
	return $self->{_index};
}

sub setImg
{
	my( $self, $img ) = @_;
	$self->{_img} = $img if defined($img);
	return $self->{_img};
}

sub getImg
{
	my( $self ) = @_;
	return $self->{_img};
}

sub setImg_s
{
	my( $self, $img_s ) = @_;
	$self->{_img_s} = $img_s if defined($img_s);
	return $self->{_img_s};
}

sub getImg_s
{
	my( $self ) = @_;
	return $self->{_img_s};
}


1;