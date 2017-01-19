#!/usr/bin/perl -w
use strict;
use warnings;
package Player;

sub new
{
	my $class = shift;
	my $self = {
		_name => shift,
		_money => 30000000,
		_position => 0,
		_house => [],
		_img => "",
		_img_a => "",
		_img_s => "",
		_noprison => 0,
		_index => shift
		
	};
	for (my $i = 0; $i < 40; $i++){
		$self->{_house}[$i] = 0;
	}
	bless $self, $class;
	return $self;
}

sub setName
{
	my( $self, $name ) = @_;
	$self->{_name} = $name if defined($name);
	return $self->{_name};
}

sub getName
{
	my( $self ) = @_;
	return $self->{_name};
}

sub setMoney
{
	my( $self, $money ) = @_;
	$self->{_money} = $money if defined($money);
	return $self->{_money};
}

sub setPosition
{
	my( $self, $position ) = @_;
	$position = $position % 40 if defined($position);
	$self->{_position} = $position if defined($position);
	return $self->{_position};
}

sub getMoney
{
	my( $self ) = @_;
	return $self->{_money};
}

sub getPosition
{
	my( $self ) = @_;
	return $self->{_position};
}

sub setHouse
{
	my( $self, $house ) = @_;
	$self->{_house}[$house] = 1 if defined($house);
	return $self->{_house}[$house];
}

sub getHouse
{
	my( $self, $i ) = @_;
	return $self->{_house}[$i];
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

sub setImg_a
{
	my( $self, $img_a ) = @_;
	$self->{_img_a} = $img_a if defined($img_a);
	return $self->{_img_a};
}

sub getImg_a
{
	my( $self ) = @_;
	return $self->{_img_a};
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

sub buyLand
{
	my( $self, $land ) = @_;
	$self->setHouse($land->getIndex());
	$self->setMoney($self->getMoney() - $land->getPrice());
}

sub setNoprison
{
	my( $self, $noprison ) = @_;
	$self->{_noprison} = $noprison if defined($noprison);
	return $self->{_noprison};
}

sub getNoprison
{
	my( $self ) = @_;
	return $self->{_noprison};
}

sub getIndex
{
	my( $self ) = @_;
	return $self->{_index};
}

sub setIndex
{
	my( $self, $index ) = @_;
	$self->{_index} = $index if defined($index);
	return $self->{_index};
}

1;