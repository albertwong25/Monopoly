#!/usr/bin/perl -w

use strict;
use warnings;
use List::Util qw(shuffle);

our ($mw, $tabState);
our ($bgimg, $logoimg, $bottomimg, @chess_img, @chess_a_img, @chess_s_img, $gbimg, @chance_img, @comm_img, $moneyimg);
our ($dices, $dices_bg, @dices_num);
our (@lands, $landimg_n);
our $transcard;

sub loadAllImages{
	$bgimg = $mw->Photo(-format => "JPEG", -file => "img/bg.jpg");
	$logoimg = $mw->Photo(-format => "PNG", -file=>"img/logo.png");
	$bottomimg = $mw->Photo(-format => "PNG", -file => "img/bottom.png");
	for (my $i = 1; $i <= 6; $i++){
		$chess_img[$i] = $mw->Photo(-format => "PNG", -file => "img/player/chess0$i.png");
		$chess_a_img[$i] = $mw->Photo(-format => "PNG", -file => "img/player/chess0${i}_a.png");
		$chess_s_img[$i] = $mw->Photo(-format => "PNG", -file => "img/player/chess0${i}_s.png");
	}
	$gbimg = $mw->Photo(-format => "JPEG", -file => "img/board.jpg");
	$dices  = $mw->Animation(-format => "gif", -file => "img/dice/dices.gif");
	$dices_bg = $mw->Photo(-format => "PNG", -file => "img/dice/dices_bg.png");
	for (my $i = 1; $i <= 6; $i++){
		$dices_num[$i] = $mw->Photo(-format => "PNG", -file => "img/dice/dice0$i.png");
	}
	foreach my $land(@lands){
		my $name = lc ($land->getName());
		$name =~ s#(\w*) *(\w*)#$1$2#;
		$land->setImg($mw->Photo(-format => "PNG", -file => "img/land/$name.png"));
		$land->setImg_s($mw->Photo(-format => "PNG", -file => "img/land/${name}_s.png"));
	}
	$landimg_n = $mw->Photo(-format => "PNG", -file => "img/land/none.png");
	$transcard = $mw->Photo(-format => "PNG", -file => "img/land/trans.png");
	for (my $i = 0; $i < 10; $i++){
		$chance_img[$i] = $mw->Photo(-format => "PNG", -file => "img/chance/chance0$i.png");
		$comm_img[$i] = $mw->Photo(-format => "PNG", -file => "img/comm/comm0$i.png");
	}
	$moneyimg = $mw->Photo(-format => "PNG", -file => "img/money.png");
	return $mw;
}

sub goToTab{
	my ($nb, $fromTab, $toTab) = @_;
	
	$nb->pageconfigure($toTab, -state => "normal");
	$nb->raise($toTab);
	$nb->pageconfigure($fromTab, -state => $tabState);
	return $nb;
}

sub randNum{
	my ($from, $to) = @_;
	
	return (int(rand($to - $from + 1)) + $from);
}

sub getLandIndexByGBIndex{
	my ($index) = @_;
	for (my $i = 0; $i < $#lands+1; $i++){
		if ($lands[$i]->getIndex() == $index){
			return $i;
		}
	}
	return -1;
}


1;