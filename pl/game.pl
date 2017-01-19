#!/usr/bin/perl -w

use strict;
use warnings;
use Tk;
use Tk::Animation;
use Time::HiRes;
use Tk::Dialog;

our ($ggg, $mw, $tabState, $win_w, $win_h, $gp);
our ($bgimg, @chess_img, @chess_a_img, @chess_s_img, $gbimg, $moneyimg, $bottomimg, @chance_img, @comm_img);
our ($dices, $dices_bg, @dices_num, $dice_sum);
our (@players, @lands);
our (@xco, @yco);
our $landimg_n;
our $transcard;
our ($mainFrameColor, $mainFrameHeaderColor);
our ($currentChance, $currentComm);
our ($gameCanvas, $proCanvas, $buyCanvas, $chanceCanvas, $commCanvas, $winCanvas);
our ($proFrame, $buyFrame, $chanceFrame, $commFrame, $winFrame);
our ($buybutton, $rollDiceButton);
our (@playerText, @playerImg, @playerMoney, @playerFrame);

our $offLine;

sub createGamePage{
	my ($nb, $page_name, $page_label) = @_;

	$gp = $nb->add($page_name, -label => $page_label, -state => $tabState);
	
	# background image + game board image
	$gameCanvas = $gp->Canvas(-highlightthickness => 0);
	$dices->set_disposal_method(1);
	$gameCanvas->createImage($win_w/2, $win_h/2, -image => $bgimg);
	$gameCanvas->createImage($win_w/2, 0, -image => $gbimg, -anchor => "n");
	$gameCanvas->createImage($win_w/2, $win_h/2-20, -image => $dices_bg, -state => "hidden", -tags => "dices_bg");
	$gameCanvas->createImage($win_w/2, $win_h/2-20, -image => $dices, -state => "hidden", -tags => "dices");
	for (my $i = 1; $i <= 6; $i++){
		$gameCanvas->createImage($win_w/2-80, $win_h/2-20, -image => $dices_num[$i], -state => "hidden", -tags => "d10$i");
		$gameCanvas->createImage($win_w/2+80, $win_h/2-20, -image => $dices_num[$i], -state => "hidden", -tags => "d20$i");
	}
	$dices->start_animation(50);
	$gameCanvas->createImage($xco[0]-10, $yco[0]-2, -image => $players[0]->getImg_s(), -anchor => "nw", -tags => "p0");
	$gameCanvas->createImage($xco[0],    $yco[0]-2, -image => $players[1]->getImg_s(), -anchor => "ne", -tags => "p1");
	$gameCanvas->createImage($xco[0]-10, $yco[0]+5, -image => $players[2]->getImg_s(), -anchor => "sw", -tags => "p2");
	$gameCanvas->createImage($xco[0],    $yco[0]+5, -image => $players[3]->getImg_s(), -anchor => "se", -tags => "p3");
	$gameCanvas->pack(-expand => 1, -fill => "both");
	
	
	# players details [Left]
	$playerFrame[1] = $gp->Frame(-width => 250, -height => 175, -background => $mainFrameColor)
		->place(-x => 10, -y => 0, -anchor => "nw");
	$playerText[1] = $playerFrame[1]->Label(-text => "AAAAAAA", -font => "Helvetica 18", -width => 100, -foreground => "white", -background => $mainFrameHeaderColor)
		->place(-relx => 0.5, -rely => 0, -anchor => "n");
	$playerImg[1] = $playerFrame[1]->Label(-image => $chess_img[1], -background => $mainFrameColor)
		->place(-relx => 0.05, -rely => 0.25, -anchor => "nw");
	$playerMoney[1] = $playerFrame[1]->Label(-text => "\$0", -font => "Helvetica 12", -foreground => "yellow", -background => $mainFrameColor)
		->place(-relx => 0.95, -rely => 0.5, -anchor => "e");
	$playerFrame[1]->Button(-text => "Properties", -relief => "flat", -font => "Helvetica 12",  -borderwidth => 1, 
			-foreground => "blue", -activeforeground => "blue", -background => "SpringGreen3", -activebackground => "SpringGreen2", 
			-command => sub{ showPropertiesFrame(1); })
		->place(-relx => 0.95, -rely => 0.9, -anchor => "se");
		
	$playerFrame[2] = $gp->Frame(-width => 250, -height => 175, -background => $mainFrameColor)
		->place(-x => 10, -y => 185, -anchor => "nw");
	$playerText[2] = $playerFrame[2]->Label(-text => "BBBBBBB", -font => "Helvetica 18", -width => 100, -foreground => "white", -background => $mainFrameHeaderColor)
		->place(-relx => 0.5, -rely => 0, -anchor => "n");
	$playerImg[2] = $playerFrame[2]->Label(-image => $chess_img[2], -background => $mainFrameColor)
		->place(-relx => 0.05, -rely => 0.25, -anchor => "nw");
	$playerMoney[2] = $playerFrame[2]->Label(-text => "\$0", -font => "Helvetica 12", -foreground => "yellow", -background => $mainFrameColor)
		->place(-relx => 0.95, -rely => 0.5, -anchor => "e");
	$playerFrame[2]->Button(-text => "Properties", -relief => "flat", -font => "Helvetica 12", -borderwidth => 1, 
			-foreground => "blue", -activeforeground => "blue", -background => "SpringGreen3", -activebackground => "SpringGreen2", 
			-command => sub{ showPropertiesFrame(2); })
		->place(-relx => 0.95, -rely => 0.9, -anchor => "se");
	
	$playerFrame[3] = $gp->Frame(-width => 250, -height => 175, -background => $mainFrameColor)
		->place(-x => 10, -y => 370, -anchor => "nw");
	$playerText[3] = $playerFrame[3]->Label(-text => "CCCCCCC", -font => "Helvetica 18", -width => 100, -foreground => "white", -background => $mainFrameHeaderColor)
		->place(-relx => 0.5, -rely => 0, -anchor => "n");
	$playerImg[3] = $playerFrame[3]->Label(-image => $chess_img[3], -background => $mainFrameColor)
		->place(-relx => 0.05, -rely => 0.25, -anchor => "nw");
	$playerMoney[3] = $playerFrame[3]->Label(-text => "\$0", -font => "Helvetica 12", -foreground => "yellow", -background => $mainFrameColor)
		->place(-relx => 0.95, -rely => 0.5, -anchor => "e");
	$playerFrame[3]->Button(-text => "Properties", -relief => "flat", -font => "Helvetica 12", -borderwidth => 1, 
			-foreground => "blue", -activeforeground => "blue", -background => "SpringGreen3", -activebackground => "SpringGreen2", 
			-command => sub{ showPropertiesFrame(3); })
		->place(-relx => 0.95, -rely => 0.9, -anchor => "se");
	
	# player details [Right]
	$playerFrame[0] = $gp->Frame(-width => 250, -height => 350, -background => $mainFrameColor)
		->place(-x => $win_w-10, -y => 0, -anchor => "ne");
	$playerText[0] = $playerFrame[0]->Label(-text => "DDDDDDD", -font => "Helvetica 18", -width => 100, -foreground => "white", -background => $mainFrameHeaderColor)
		->place(-relx => 0.5, -rely => 0, -anchor => "n");
	$playerImg[0] = $playerFrame[0]->Label(-image => $chess_a_img[5], -background => $mainFrameColor)
		->place(-relx => 0.5, -rely => 0.1, -anchor => "n");
	$playerMoney[0] = $playerFrame[0]->Label(-text => "\$0", -font => "Helvetica 16", -foreground => "yellow", -background => $mainFrameColor)
		->place(-relx => 0.05, -rely => 0.75, -anchor => "w");
	$playerFrame[0]->Button(-text => "Properties", -relief => "flat", -font => "Helvetica 12", -borderwidth => 1, 
			-foreground => "blue", -activeforeground => "blue", -background => "SpringGreen3", -activebackground => "SpringGreen2", 
			-command => sub{ showPropertiesFrame(0); })
		->place(-relx => 0.95, -rely => 0.75, -anchor => "e");
	$rollDiceButton = $playerFrame[0]->Button(-text => "Roll Dice", -relief => "flat", -font => "Helvetica 12", -width => 20, -borderwidth => 1, 
			-foreground => "white", -activeforeground => "white", -background => "firebrick3", -activebackground => "firebrick2", 
			-command => sub{ $dice_sum = rollDice(); })
		->place(-relx => 0.5, -rely => 0.95, -anchor => "s");
	
	# game history
	my $gpFrame5 = $gp->Frame(-width => 250, -height => 190, -background => $mainFrameColor);
		# ->place(-x => $win_w-10, -y => 360, -anchor => "ne");
	$gpFrame5->Label(-text => "Game History", -font => "Helvetica 18", -width => 100, -foreground => "white", -background => $mainFrameHeaderColor)
		->place(-relx => 0.5, -rely => 0, -anchor => "n");
	
	# properties frame
	$proFrame = $gp->Frame(-width => 920, -height => 500, -background => "SteelBlue4");
	$proCanvas = $proFrame->Canvas(-highlightthickness => 3, -width => 920, -height => 500, -background => "SteelBlue4", -borderwidth => 5);
	$proCanvas->createRectangle(0, 0, 240, 450, -fill => "SteelBlue3", -width => 0);
	$proCanvas->createText(125, 10, -text => "Card Details", -font => "Helvetica 18", -fill => "white", -anchor => "n");
	$proCanvas->createImage(15, 50, -image => $landimg_n, -anchor => "nw", -tags => "landDetails");
	my ($count, $row, $col, $s) = (0, 0, 0, 0);
	foreach my $land(@lands){
		my $name = lc ($land->getName());
		$name =~ s#(\w*) *(\w*)#$1$2#;
		$proCanvas->createImage(255+$col*80+$s*10, 10+$row*110, -image => $land->getImg_s(), -anchor => "nw", -tags => "${name}_s");
		$proCanvas->createImage(255+$col*80+$s*10, 10+$row*110, -image => $transcard, -anchor => "nw", -tags => "trans$count");
		$proCanvas->bind("${name}_s", "<Enter>" => sub{ $proCanvas->itemconfigure("landDetails", -image => $land->getImg()); $proCanvas->update(); });
		$proCanvas->bind("${name}_s", "<Leave>" => sub{ $proCanvas->itemconfigure("landDetails", -image => $landimg_n); $proCanvas->update(); });
		$proCanvas->bind("trans$count", "<Enter>" => sub{ $proCanvas->itemconfigure("landDetails", -image => $land->getImg()); $proCanvas->update(); });
		$proCanvas->bind("trans$count", "<Leave>" => sub{ $proCanvas->itemconfigure("landDetails", -image => $landimg_n); $proCanvas->update(); });
		$count++;
		$col++;
		if ($count == 2 or $count == 5 or $count == 8){
			$row++;
			$col = 0;
		} elsif ($count == 11){
			$row = 0;
			$col = 3;
			$s = 1;
		} elsif ($count == 14 or $count == 17 or $count == 20){
			$row++;
			$col = 3;
		} elsif ($count == 22){
			$row = 0;
			$col = 6;
			$s = 2;
		} elsif ($count == 24 or $count == 26){
			$row++;
			$col = 6;
		}
	}
	$proCanvas->pack(-expand => 1, -fill => "both");
	$proFrame->Button(-text => "Close", -relief => "flat", -font => "Helvetica 12", -borderwidth => 1, 
			-foreground => "blue", -activeforeground => "blue", -background => "SkyBlue3", -activebackground => "SkyBlue2", 
			-command => sub{ hidePropertiesFrame(); })
		->place(-relx => 0.5, -rely => 0.98, -anchor => "s");
	
	# buy land frame
	$buyFrame = $gp->Frame(-width => 300, -height => 400, -background => "SteelBlue4");
	$buyCanvas = $buyFrame->Canvas(-highlightthickness => 3, -width => 300, -height => 400, -background => "SteelBlue4", -borderwidth => 5);
	$buyCanvas->createImage(155, 20, -image => $landimg_n, -anchor => "n", -tags => "buyCard");
	$buyCanvas->pack(-expand => 1, -fill => "both");
	$buybutton = $buyFrame->Button(-text => "Buy This", -relief => "flat", -font => "Helvetica 12", -borderwidth => 1, 
			-foreground => "blue", -activeforeground => "blue", -background => "SpringGreen3", -activebackground => "SpringGreen2", 
			-command => sub{ buyThisOnClick(); goToNextUser(); })
		->place(-relx => 0.25, -rely => 0.9, -anchor => "s");
	$buyFrame->Button(-text => "Cancel", -relief => "flat", -font => "Helvetica 12", -borderwidth => 1, 
			-foreground => "blue", -activeforeground => "blue", -background => "SkyBlue3", -activebackground => "SkyBlue2", 
			-command => sub{ hideBuyLandFrame(); goToNextUser(); })
		->place(-relx => 0.75, -rely => 0.9, -anchor => "s");
		
	# chance frame
	$chanceFrame = $gp->Frame(-width => 500, -height => 300, -background => "SteelBlue4");
	$chanceCanvas = $chanceFrame->Canvas(-highlightthickness => 3, -width => 500, -height => 300, -background => "SteelBlue4", -borderwidth => 5);
	$chanceCanvas->createImage(255, 20, -image => $chance_img[0], -anchor => "n", -tags => "chanceCard");
	$chanceCanvas->pack(-expand => 1, -fill => "both");
	$chanceFrame->Button(-text => "OK", -relief => "flat", -font => "Helvetica 12", -borderwidth => 1, 
			-foreground => "blue", -activeforeground => "blue", -background => "SkyBlue3", -activebackground => "SkyBlue2", 
			-command => sub{ hideChanceFrame(); })
		->place(-relx => 0.5, -rely => 0.9, -anchor => "s");
		
	# comm frame
	$commFrame = $gp->Frame(-width => 500, -height => 300, -background => "SteelBlue4");
	$commCanvas = $commFrame->Canvas(-highlightthickness => 3, -width => 500, -height => 300, -background => "SteelBlue4", -borderwidth => 5);
	$commCanvas->createImage(255, 20, -image => $comm_img[0], -anchor => "n", -tags => "commCard");
	$commCanvas->pack(-expand => 1, -fill => "both");
	$commFrame->Button(-text => "OK", -relief => "flat", -font => "Helvetica 12", -borderwidth => 1, 
			-foreground => "blue", -activeforeground => "blue", -background => "SkyBlue3", -activebackground => "SkyBlue2", 
			-command => sub{ hideCommFrame(); })
		->place(-relx => 0.5, -rely => 0.9, -anchor => "s");
	
	# gain / lose money label
	$gameCanvas->createText($win_w/2+5, 165, -text => "+\$99999999", -font => "Helvetica 70", -fill => "black", -tags => "moneyLabelBg", -state => "hidden");
	$gameCanvas->createText($win_w/2, 160, -text => "+\$99999999", -font => "Helvetica 70", -fill => "yellow", -tags => "moneyLabel", -state => "hidden");
	
	# win frame
	$winFrame = $gp->Frame(-width => 920, -height => 500, -background => "SteelBlue4");
	$winCanvas = $winFrame->Canvas(-highlightthickness => 3, -width => 920, -height => 500, -background => "SteelBlue4", -borderwidth => 5);
	$winCanvas->createImage(465, 500, -image => $bottomimg, -anchor => "s");
	$winCanvas->createImage(0, 0, -image => $moneyimg, -anchor => "nw", -tags => "money1");
	$winCanvas->createImage(920, 0, -image => $moneyimg, -anchor => "ne", -tags => "money2");
	$winCanvas->createImage(465, 30, -image => $chess_a_img[5], -anchor => "n", -tags => "winnerImg");
	$winCanvas->createText(465, 280, -text => "\$99999999", -font => "Helvetica 30", -fill => "yellow", -tags => "winnerMoney");
	$winCanvas->createText(465, 350, -text => "AAAAAAA Wins!", -font => "Helvetica 70", -fill => "green", -tags => "winner");
	$winCanvas->pack(-expand => 1, -fill => "both");
	$winFrame->Button(-text => "Play Again", -relief => "flat", -font => "Helvetica 16",  -borderwidth => 1, -foreground => "blue",
			-command => sub{ $nb->delete("player_setting"); $mw = initialize(); $mw = loadAllImages(); hideWinFrame(); $rollDiceButton->configure(-state => "normal"); $nb = goToTab($nb, $page_name, "start"); })
		->place(-relx => 0.5, -rely => 0.9, -anchor => "center");
	
	return $gp;
}

sub showPropertiesFrame{
	my ($n) = @_;
	
	for (my $i = 0; $i < 40; $i++){
		my $index = getLandIndexByGBIndex($i);
		if ($players[$n]->getHouse($i) == 1){
			$proCanvas->itemconfigure("trans$index", -state => "hidden"); 
		} else{
			$proCanvas->itemconfigure("trans$index", -state => "normal"); 
		}
	}
	$proFrame->place(-x => $win_w/2, -y => $win_h/2-20, -anchor => "center");
}

sub hidePropertiesFrame{
	$proFrame->placeForget();
}

sub buyThisOnClick{
	my $index = getLandIndexByGBIndex($players[0]->getPosition());
	$players[0]->buyLand($lands[$index]);
	$lands[$index]->setOwner($players[0]->getName());
	hideBuyLandFrame();
	gainOrLoseMoney("-", $lands[$index]->getPrice());
	updatePlayer(0, $players[0]);
}

sub showBuyLandFrame{
	my $index = getLandIndexByGBIndex($players[0]->getPosition());
	my $dice = $_[0];
	if($ggg == 1){
		$ggg =0;
		return;
	}
	$buybutton->configure(-state => "normal");
	if($players[0]->getMoney() < $lands[$index]->getPrice()){
		$buybutton->configure(-state => "disabled");		
	}
	if($lands[$index]->getOwner() ne ""){
		if($lands[$index]->getOwner() ne $players[0]->getName())
		{
			for(my $i = 1; $i<4 ;$i++){
				if($lands[$index]->getOwner() eq $players[$i]->getName()){
					my $weighting = monopolyRent( $lands[$index], $players[$i], $dice );
					my $hseweighting = houseWeighting( $lands[$index] );
					$players[0]->setMoney($players[0]->getMoney() - $lands[$index]->getRent() * $weighting * $hseweighting);
					$players[$i]->setMoney($players[$i]->getMoney() + $lands[$index]->getRent()* $weighting * $hseweighting);
					gainOrLoseMoney("-", $lands[$index]->getRent()* $weighting * $hseweighting);
					updatePlayer(0,$players[0]);
					updatePlayer($i,$players[$i]);
					
				}	
			}
		}
		else{
			if($lands[$index]->getType() ne "transportation" and $lands[$index]->getType() ne "powerstation"){ 
				my $dialog = $mw->Dialog( -title => "Buying a house", -text   => "Pay \$".$lands[$index]->getHouseCost()." to buy a house?",
				-buttons => [ "Okay", "Cancel" ] , -bitmap => "question" ) ->Show();
				if($dialog eq "Okay"){
					$players[0]->setMoney($players[0]->getMoney() - $lands[$index]->getHouseCost());
					$lands[$index]->buyHouse($lands[$index]->getHouse()+1);
					gainOrLoseMoney("-", $lands[$index]->getHouseCost());
					updatePlayer(0,$players[0]);
				}
			}
		}
		goToNextUser();
		return;
	}
	if ($index >= 0){
		$buyCanvas->itemconfigure("buyCard", -image => $lands[$index]->getImg()); 
		$buyFrame->place(-x => $win_w/2, -y => $win_h/2-20, -anchor => "center");
	}
}

sub hideBuyLandFrame{
	$buyFrame->placeForget();
}

sub showChanceFrame{
	if ($players[0]->getPosition() == 7 or $players[0]->getPosition() == 22 or $players[0]->getPosition() == 36){
		$currentChance = drawchancecard();
		$chanceCanvas->itemconfigure("chanceCard", -image => $chance_img[$currentChance]); 
		$chanceFrame->place(-x => $win_w/2, -y => $win_h/2-20, -anchor => "center");
	}
}

sub hideChanceFrame{
	$chanceFrame->placeForget();
	if ($currentChance == 0){
		gojail($players[0]);
		goToNextUser();
	} elsif ($currentChance == 1){
		goairport($players[0]);
	} elsif ($currentChance == 2){
		speedingfine($players[0]);
		goToNextUser();
	} elsif ($currentChance == 3){
		advMontreal($players[0]);
	} elsif ($currentChance == 4){
		advGdynia($players[0]);
	} elsif ($currentChance == 5){
		advGo($players[0]);
		goToNextUser();
	} elsif ($currentChance == 6){
		advRome($players[0]);
	} elsif ($currentChance == 7){
		bankpaydividends($players[0]);
		goToNextUser();
	} elsif ($currentChance == 8){
		backthreesteps($players[0]);
	} elsif ($currentChance == 9){
		buildingloan($players[0]);
		goToNextUser();
	}
}

sub showCommFrame{
	if ($players[0]->getPosition() == 2 or $players[0]->getPosition() == 17 or $players[0]->getPosition() == 33){
		$currentComm = drawcomcard();
		$commCanvas->itemconfigure("commCard", -image => $comm_img[$currentComm]); 
		$commFrame->place(-x => $win_w/2, -y => $win_h/2-20, -anchor => "center");
	}
}

sub hideCommFrame{
	$commFrame->placeForget();
	if ($currentComm == 0){
		saleStock($players[0]);
		goToNextUser();
	} elsif ($currentComm == 1){
		lifeInsurance($players[0]);
		goToNextUser();
	} elsif ($currentComm == 2){
		holidayFund($players[0]);
		goToNextUser();
	} elsif ($currentComm == 3){
		gojail_comcard($players[0]);
		goToNextUser();
	} elsif ($currentComm == 4){
		paySchoolFee($players[0]);
		goToNextUser();
	} elsif ($currentComm == 5){
		payHospitalFee($players[0]);
		goToNextUser();
	} elsif ($currentComm == 6){
		advGo_comcard($players[0]);
		goToNextUser();
	} elsif ($currentComm == 7){
		incometaxRefund($players[0]);
		goToNextUser();
	} elsif ($currentComm == 8){
		payDoctorFee($players[0]);
		goToNextUser();
	} elsif ($currentComm == 9){
		wonBeautyContest($players[0]);
		goToNextUser();
	}
}

sub showWinFrame{
	
	$winFrame->place(-x => $win_w/2, -y => $win_h/2-20, -anchor => "center");
}

sub hideWinFrame{
	$winFrame->placeForget();
}

sub rollDice{
	$rollDiceButton->configure(-state => "disabled");
	$gameCanvas->itemconfigure("dices", -state => "normal"); 
	$gameCanvas->itemconfigure("dices_bg", -state => "normal");
	$gameCanvas->update();
	our $dice1 = randNum(1, 6);
	our $dice2 = randNum(1, 6);
	$gameCanvas->after(2000, \&finishRolling); 
	
	sub finishRolling{
		$gameCanvas->itemconfigure("dices", -state => "hidden");
		$gameCanvas->itemconfigure("d10$dice1", -state => "normal");
		$gameCanvas->itemconfigure("d20$dice2", -state => "normal");
		$gameCanvas->update();
		$gameCanvas->after(2000, \&hideDice); 
	}
	
	sub hideDice{
		$gameCanvas->itemconfigure("d10$dice1", -state => "hidden");
		$gameCanvas->itemconfigure("d20$dice2", -state => "hidden");
		$gameCanvas->itemconfigure("dices_bg", -state => "hidden");
		$gameCanvas->update();
		# $rollDiceButton->configure(-state => "normal");
		moveitem( $players[0], ($dice1 + $dice2) );
	}
	
	return $dice1 + $dice2;
}

sub moveitem{
	my $player = $_[0];
	my $dice = $_[1];
	my $start = $player->getPosition();
	$player->setPosition( $start + $dice );
	my $final = $player->getPosition();
	my $index = $player->getIndex();
	while(1){
		$start++;
		$start %= 40;
		my $dx = 0;
		my $dy = 0;
		if ($index == 0 or $index == 2){
			$dx = -10;
		}
		if ($index == 2 or $index == 3){
			$dy = 5;
		} else{
			$dy = -2;
		}
		$gameCanvas->coords("p$index", $xco[$start]+$dx, $yco[$start]+$dy);
		$gameCanvas->update();
		if($start == 0){
			$player->setMoney($player->getMoney() + 2000000);
			gainOrLoseMoney("+", 2000000);
			updatePlayer(0,$player);
		}
		
		Time::HiRes::sleep(0.2);
		if($start== $final){
			#go to prison
			if($final==30){
				$start = 10;
				$player->setPosition( $start);
				$player->setNoprison(3);
				$gameCanvas->coords("p$index", $xco[$start]+$dx, $yco[$start]+$dy);
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
	showBuyLandFrame($dice);
}

sub updatePlayer{
	my ($i, $player) = @_;
	
	if ($player->getName() eq ""){
		$playerFrame[$i]->placeForget();
	}
	
	$playerText[$i]->configure(-text => $player->getName());
	if ($i == 0){
		$playerImg[$i]->configure(-image => $player->getImg_a());
	} else{
		$playerImg[$i]->configure(-image => $player->getImg());
	}
	$playerMoney[$i]->configure(-text => "\$".$player->getMoney());
	
	$gameCanvas->itemconfigure("p$i", -image => $player->getImg_s());
	
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
	$gameCanvas->coords("p$i", $xco[$player->getPosition()]+$dx, $yco[$player->getPosition()]+$dy);
	
	
}

sub gainOrLoseMoney{
	my ($gainOrLose, $amount) = @_;
	my $color = ($gainOrLose eq "+" ? "green" : "red");
	$gameCanvas->itemconfigure("moneyLabelBg", -text => "${gainOrLose}\$$amount", -state => "normal");
	$gameCanvas->itemconfigure("moneyLabel", -text => "${gainOrLose}\$$amount", -fill => $color, -state => "normal");
	$gameCanvas->update();
	my $count = 165;
	while(1){
		$gameCanvas->coords("moneyLabel", $win_w/2, $count);
		$gameCanvas->coords("moneyLabelBg", $win_w/2+5, $count+5);
		$gameCanvas->update();
		Time::HiRes::sleep(0.001);
		$count--;
		last if ($count < -100);
	}
	$gameCanvas->itemconfigure("moneyLabelBg", -state => "hidden");
	$gameCanvas->itemconfigure("moneyLabel", -state => "hidden");
}

sub goToNextUser{
	
	if ($offLine <= 0){
		return;
	}
	
	if ($players[0]->getMoney() < 0){
		gameOver();
		return;
	}
	
	$gameCanvas->update();
	sleep(1);
	
	$rollDiceButton->configure(-state => "normal");
	
	my $count = 0;
	for ($count = 0; $count < 4; $count++){
		last if ($players[$count]->getName() eq "");
	}
	
	my $temp = $players[0];
	for (my $i = 0; $i < $count-1; $i++){
		$players[$i] = $players[$i+1];
		$players[$i]->setIndex($i);
	}
	$players[$count-1] = $temp;
	$players[$count-1]->setIndex($count-1);
	
	for (my $i = 0; $i < 4; $i++){
		updatePlayer($i, $players[$i]); 
	}
	
	$gameCanvas->update();
	if($players[0]->getNoprison()!= 0){
		if ($players[0]->getMoney() >= 3000000){
			my $dialog = $mw->Dialog( -title => "You are in jail", -text   => "Pay 3000000M to escape?",
                            -buttons => [ "Okay", "Cancel" ] , -bitmap => "question" ) ->Show();
                            if($dialog eq "Okay"){
                            	$players[0]->setNoprison( 0 );
                            	$players[0]->setMoney($players[0]->getMoney() - 3000000);
                            	gainOrLoseMoney("-", 3000000);
                            	updatePlayer(0,$players[0]);
                            }
			else{
				$players[0]->setNoprison( $players[0]->getNoprison() -1 );
				goToNextUser();
			}
		} else{
			$players[0]->setNoprison( $players[0]->getNoprison() -1 );
			goToNextUser();
		}
	}
	$gameCanvas->update();
}

sub monopolyRent
{
	my ( $thisland, $player, $dice) = @_;
	my $totalType = 0;
	my $playerlandtype = 0;
	for(my $i= 0; $i< 28; $i++){
		if($thisland->getType() eq $lands[$i]->getType()){
			$totalType++;
		if($player->getHouse($lands[$i]->getIndex())==1){
			$playerlandtype++;
		}
	}
	}
	if($totalType == 4){ # transportation 
		 return $playerlandtype;
	}
	if($totalType > 1 and $totalType < 4 and $thisland->getType() ne "powerstation" and $totalType == $playerlandtype){
		return 2;
	}
	if($thisland->getType() eq "powerstation"){
		if($playerlandtype == 1){
			return $dice;
		}
		else{
			return 2.5 * $dice;
		}
	}
	return 1;
}

sub houseWeighting
{
	my ( $thisland ) = @_;
	if($thisland->getHouse() == 1){
		return 5;
	}
	if($thisland->getHouse() == 2){
		return 15;
	}
	
	return 1;
}

sub gameOver{
	my $winner = 1;
	for (my $i = 2; $i < 4; $i++){
		if ($players[$i]->getMoney() > $players[$winner]->getMoney()){
			$winner = $i;
		}
	}
		my $name = $players[$winner]->getName();
	my $money = $players[$winner]->getMoney();
	$winCanvas->itemconfigure("winner", -text => "$name Wins!");
	$winCanvas->itemconfigure("winnerMoney", -text => "\$$money");
	$winCanvas->itemconfigure("winnerImg", -image => $players[$winner]->getImg_a());
	$winCanvas->update();
	showWinFrame();
}

1;
