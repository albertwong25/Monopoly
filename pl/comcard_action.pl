#!/usr/bin/perl -w

use strict;
use warnings;
use List::Util qw(shuffle);
use Time::HiRes;

our @xco;
our @yco;
our $gameCanvas;

our @comcard = (0..9);
our @shufflecomcard = @comcard;
@shufflecomcard = shuffle @shufflecomcard;

#draw a card and pop out it, return with its index
sub afterdrawcomcard
{
	my $p = pop @shufflecomcard;
	if($shufflecomcard[0] eq ""){
		@shufflecomcard = @comcard;
		@shufflecomcard = shuffle @shufflecomcard;
	}
	return $p;
}
#start to draw a com card
sub drawcomcard
{
	my $comcardindex = afterdraw();
	return $comcardindex;
	
}

#comcard[0]
sub saleStock
{
	my $player = $_[0];
	$player->setMoney($player->getMoney() + 500000);
	gainOrLoseMoney("+", 500000);
	updatePlayer(0,$player);
}

#comcard[1]
sub lifeInsurance
{
	my $player = $_[0];
	$player->setMoney($player->getMoney() + 1000000);
	gainOrLoseMoney("+", 1000000);
	updatePlayer(0,$player);
}

#comcard[2]
sub holidayFund
{
	my $player = $_[0];
	$player->setMoney($player->getMoney() + 1000000);
	gainOrLoseMoney("+", 1000000);
	updatePlayer(0,$player);
}

#comcard[3]
sub gojail_comcard
{
	my $player = $_[0];
	$player->setPosition(10);
	$player->setNoprison(3);
	my $i = $player->getIndex();
	$gameCanvas->coords("p$i", $xco[10], $yco[10]);
	$gameCanvas->update();
}

#comcard[4]
sub paySchoolFee
{
	my $player = $_[0];
	$player->setMoney($player->getMoney() - 500000);
	gainOrLoseMoney("-", 500000);
	updatePlayer(0,$player);
}

#comcard[5]
sub payHospitalFee
{
	my $player = $_[0];
	$player->setMoney($player->getMoney() - 1000000);
	gainOrLoseMoney("-", 1000000);
	updatePlayer(0,$player);
}

#comcard[6]
sub advGo_comcard
{
	my $player = $_[0];
	$player->setPosition(0);
	my $i = $player->getIndex();
	$gameCanvas->coords("p$i", $xco[0], $yco[0]);
	$gameCanvas->update();
	$player->setMoney($player->getMoney() + 2000000);
	gainOrLoseMoney("+", 2000000);
	updatePlayer(0,$player);
}

#comcard[7]
sub incometaxRefund
{
	my $player = $_[0];
	$player->setMoney($player->getMoney() + 200000);
	gainOrLoseMoney("+", 200000);
	updatePlayer(0,$player);
}

#comcard[8]
sub payDoctorFee
{
	my $player = $_[0];
	$player->setMoney($player->getMoney() - 500000);
	gainOrLoseMoney("-", 500000);
	updatePlayer(0,$player);
}

#comcard[9]
sub wonBeautyContest
{
	my $player = $_[0];
	$player->setMoney($player->getMoney() + 100000);
	gainOrLoseMoney("+", 100000);
	updatePlayer(0,$player);
}