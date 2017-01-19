#!/usr/bin/perl -w

use strict;
use warnings;
use List::Util qw(shuffle);
use Time::HiRes;

our @xco;
our @yco;
our $gameCanvas;
our $position;
our $dice;
our $ggg;

our @chancecard = (0..9);
our @shufflechancecard = @chancecard;
@shufflechancecard = shuffle @shufflechancecard;

#draw a card and pop out it, return with its index
sub afterdraw
{
	my $p = pop @shufflechancecard;
	if($shufflechancecard[0] eq ""){
		@shufflechancecard = @chancecard;
		@shufflechancecard = shuffle @shufflechancecard;
	}
	return $p;
}
#start to draw a chance card
sub drawchancecard
{
	my $chancecardindex = afterdraw();
	return $chancecardindex;
	
}

#chancecard[0]
sub gojail
{
	my $player = $_[0];
	$player->setPosition(10);
	$player->setNoprison(3);
	my $i = $player->getIndex();
	$gameCanvas->coords("p$i", $xco[10], $yco[10]);
	$gameCanvas->update();
}

#chancecard[1]
sub goairport
{
	my $player = $_[0];
	$position = $player->getPosition();
	if($position == 15){
		return;
	}
	if($position < 15){
		$dice = 15 - $position;
		moveitem($player, $dice);
	}
	if($position > 15){
		$dice = 40 - $position + 15;
		moveitem($player, $dice);
	}
}

#chancecard[2]
sub speedingfine
{
	my $player = $_[0];
	$player->setMoney($player->getMoney() - 150000);
	gainOrLoseMoney("-", 150000);
	updatePlayer(0,$player);
}

#chancecard[3]
sub advMontreal
{
	my $player = $_[0];
	$player->setPosition(39);
	my $i = $player->getIndex();
	$gameCanvas->coords("p$i", $xco[39], $yco[39]);
	$gameCanvas->update();
	showBuyLandFrame();
}

#chancecard[4]
sub advGdynia
{
	my $player = $_[0];
	$position = $player->getPosition();
	if($position == 1){
		return;
	}
	if($position < 1){
		$dice = 1 - $position;
		moveitem($player, $dice);
		$ggg = 1;
	}
	if($position > 1){
		$dice = 40 - $position + 1;
		moveitem($player, $dice);
		$ggg = 1;
	}
}

#chancecard[5]
sub advGo
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

#chancecard[6]
sub advRome
{
	my $player = $_[0];
	$position = $player->getPosition();
	if($position == 16){
		return;
	}
	if($position < 16){
		$dice = 16 - $position;
		moveitem($player, $dice);
		$ggg = 1;
	}
	if($position > 16){
		$dice = 40 - $position + 16;
		moveitem($player, $dice);
		$ggg = 1;
	}
}

#chancecard[7]
sub bankpaydividends
{
	my $player = $_[0];
	$player->setMoney($player->getMoney() + 500000);
	gainOrLoseMoney("+", 500000);
	updatePlayer(0,$player);
}

#chancecard[8]
sub backthreesteps
{
	my $player = $_[0];
	my $start = $player->getPosition();
	$player->setPosition($start - 3);
	my $final = $player->getPosition();
	my $i = $player->getIndex();
	while(1){
		$start--;
		$start %= 40;
		my $dx = 0;
		my $dy = 0;
		if ($i == 0 or $i == 2){
			$dx = -10;
		}
		if ($i == 2 or $i == 3){
			$dy = 5;
		} else{
			$dy = -2;
		}
		$gameCanvas->coords("p$i", $xco[$start]+$dx, $yco[$start]+$dy);
		$gameCanvas->update();
		Time::HiRes::sleep(0.2);
		if($start== $final){
			#go to prison
			if($final==30){
				$start = 10;
				$player->setPosition( $start);
				$player->setNoprison(3);
				$gameCanvas->coords("p$i", $xco[$start]+$dx, $yco[$start]+$dy);
				$gameCanvas->update();
				goToNextUser();
				return;
				
			}
			#income tax
			if($final == 4){
				$player->setMoney($player->getMoney() - 2000000);
				gainOrLoseMoney("-", 2000000);
				updatePlayer(0,$player);
				goToNextUser();
				return;
			}
			#super tax
			if($final == 38){
				$player->setMoney($player->getMoney() - 1000000);
				gainOrLoseMoney("-", 1000000);
				updatePlayer(0,$player);
				goToNextUser();
				return;
			}
			#prision / parking / go
			if($final == 0 or $final == 10 or $final == 20){
				goToNextUser();
				return;
			}
			last;
			
		}
	}
	
	showChanceFrame();
	showCommFrame();
	showBuyLandFrame(3);
	$ggg = 1;
}

#chancecard[9]
sub buildingloan
{
	my $player = $_[0];
	$player->setMoney($player->getMoney() + 1500000);
	gainOrLoseMoney("+", 1500000);
	updatePlayer(0,$player);
}
