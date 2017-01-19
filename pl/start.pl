#!/usr/bin/perl -w

use strict;
use warnings;
use Tk;

our ($mw, $win_w, $win_h);
our ($bgimg, $logoimg, @players, @connectPlayers);
our $playerNum;
our $player_page;
our @playerNameTextbox;

sub createStartPage{
	my ($nb, $page_name, $page_label) = @_;
	
	my $sp = $nb->add($page_name, -label => $page_label);
	
	# background image + logo image + label
	my $canvas = $sp->Canvas(-highlightthickness => 0);
	$canvas->createImage($win_w/2, $win_h/2, -image => $bgimg);
	$canvas->createImage($win_w/2, 0, -image => $logoimg, -anchor => "n");
	$canvas->createText($win_w*0.2, $win_h*0.65, -text => "Player 1:", -font => "Helvetica 18", -fill => "white");
	$canvas->createText($win_w*0.4, $win_h*0.65, -text => "Player 2:", -font => "Helvetica 18", -fill => "white");
	$canvas->createText($win_w*0.6, $win_h*0.65, -text => "Player 3:", -font => "Helvetica 18", -fill => "white");
	$canvas->createText($win_w*0.8, $win_h*0.65, -text => "Player 4:", -font => "Helvetica 18", -fill => "white");
	$canvas->pack(-expand => 1, -fill => "both");
	
	# player name textbox
	$playerNameTextbox[0] = $sp->Text(-width => 15, -height => 1, -font => "Helvetica 16", -background => "light green", -wrap => "none")
		->place(-relx => 0.2, -rely => 0.75, -anchor => "center");
	$playerNameTextbox[1] = $sp->Text(-width => 15, -height => 1, -font => "Helvetica 16", -background => "light green", -wrap => "none")
		->place(-relx => 0.4, -rely => 0.75, -anchor => "center");
	$playerNameTextbox[2] = $sp->Text(-width => 15, -height => 1, -font => "Helvetica 16", -background => "light green", -wrap => "none")
		->place(-relx => 0.6, -rely => 0.75, -anchor => "center");
	$playerNameTextbox[3] = $sp->Text(-width => 15, -height => 1, -font => "Helvetica 16", -background => "light green", -wrap => "none")
		->place(-relx => 0.8, -rely => 0.75, -anchor => "center");
	
	# start game button
	$sp->Button(-text => "Start Game", -relief => "flat", -font => "Helvetica 16",  -borderwidth => 1, -foreground => "blue",
			-command => sub{$nb = startGameButtonOnClick($nb, $page_name); })
		->place(-relx => 0.5, -rely => 0.9, -anchor => "center");
		
	return $sp;
}

sub startGameButtonOnClick{
	my ($nb, $page_name) = @_;
	
	for (my $i = 0; $i < 4; $i++){
		my $input = $playerNameTextbox[$i]->get("1.0","end-1c");
		if (!($input =~ /^\w{1,10}$/)){
			if ($input eq "" and ($i == 0 or $i == 1)){
				my $err = $mw->messageBox(-title => "Invalid Input", 
					-message => "There should be at least 2 players!", 
					-type => "Ok", -icon => "error", -default => "ok");
			} elsif (!($input eq "" and ($i == 2 or $i == 3))){
				my $err = $mw->messageBox(-title => "Invalid Input", 
					-message => "Your player name should be 1-10 characters!\nWords and numbers only!", 
					-type => "Ok", -icon => "error", -default => "ok");
			} else{
				next;
			}
			for (my $j = 0; $j < 4; $j++){
				$players[$j]->setName("");
			}
			return $nb;
		}
		$players[$i]->setName($input);
	}
	
	for (my $i = 0; $i < 4-1; $i++){
		for (my $j = $i+1; $j < 4; $j++){
			if ($players[$i]->getName() eq $players[$j]->getName() and $players[$i]->getName() ne ""){
				my $err = $mw->messageBox(-title => "Invalid Input", 
					-message => "There should not be same player name!", 
					-type => "Ok", -icon => "error", -default => "ok");
				for (my $j = 0; $j < 4; $j++){
					$players[$j]->setName("");
				}
				return $nb;
			}
		}
	}
	
	for ($playerNum = 0; $playerNum < 4; $playerNum++){
		if ($players[$playerNum]->getName() eq ""){
			last;
		}
	}
	
	for (my $i = 0; $i < 4; $i++){
		updateConnectPlayer($i, $connectPlayers[$i]);
	}
	$player_page = createPlayerPage($nb, "player_setting", "Player Setting");
	$nb = goToTab($nb, $page_name, "player_setting");
	
	return $nb;
}

1;
