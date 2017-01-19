#!/usr/bin/perl -w

use strict;
use warnings;
use Tk;
use Net::Address::IP::Local;

our $tabState;
our $win_w;
our $win_h;
our $bgimg;
our $bottomimg;
our $mainFrameColor;
our $mainFrameHeaderColor;
our $subFrameColor;

our @players;
our @connectPlayerText;

sub createConnectPage{
	my ($nb, $page_name, $page_label) = @_;
	
	my $cp = $nb->add($page_name, -label => $page_label, -state => $tabState);
	
	# background image
	my $canvas = $cp->Canvas(-highlightthickness => 0);
	$canvas->createImage($win_w/2, $win_h/2, -image => $bgimg);
	$canvas->createImage($win_w/2, $win_h-20, -image => $bottomimg, -anchor => "s");
	$canvas->pack(-expand => 1, -fill => "both");
	
	# header
	$cp->Label(-text => "Game Connection", -font => "Helvetica 24", -width => 100, -foreground => "white", -background => $mainFrameColor)
		->place(-relx => 0.5, -rely => 0, -anchor => "n");
	
	# left frame (top: host)
	my $ipaddress = Net::Address::IP::Local->public();
	my $cpFrameLT = $cp->Frame(-width => 300, -height => 150, -background => $mainFrameColor)
		->place(-relx => 0.1, -rely => 0.2, -anchor => "nw");
	$cpFrameLT->Label(-text => "~ Host ~", -font => "Helvetica 18", -width => 100, -foreground => "white", -background => $mainFrameHeaderColor)
		->place(-relx => 0.5, -rely => 0, -anchor => "n");
	$cpFrameLT->Label(-text => "Your IP Address: ", -font => "Helvetica 12", -foreground => "white", -background => $mainFrameColor)
		->place(-relx => 0.5, -rely => 0.25, -anchor => "n");
	$cpFrameLT->Label(-text => $ipaddress, -font => "Helvetica 16", -foreground => "yellow", -background => $mainFrameColor)
		->place(-relx => 0.5, -rely => 0.4, -anchor => "n");
	$cpFrameLT->Button(-text => "Create Room", -relief => "flat", -font => "Helvetica 12",  -borderwidth => 1, -foreground => "blue",
			-command => sub{})
		->place(-relx => 0.5, -rely => 0.9, -anchor => "s");
	
	# left frame (bottom: join)
	my $cpFrameLB = $cp->Frame(-width => 300, -height => 150, -background => $mainFrameColor)
		->place(-relx => 0.1, -rely => 0.8, -anchor => "sw");
	$cpFrameLB->Label(-text => "~ Join ~", -font => "Helvetica 18", -width => 100, -foreground => "white", -background => $mainFrameHeaderColor)
		->place(-relx => 0.5, -rely => 0, -anchor => "n");
	$cpFrameLB->Label(-text => "Connect IP Address: ", -font => "Helvetica 12", -foreground => "white", -background => $mainFrameColor)
		->place(-relx => 0.5, -rely => 0.25, -anchor => "n");
	$cpFrameLB->Text(-width => 20, -height => 1, -font => "Helvetica 12", -background => "light green", -wrap => "none")
		->place(-relx => 0.5, -rely => 0.45, -anchor => "n");
	$cpFrameLB->Button(-text => "Join Room", -relief => "flat", -font => "Helvetica 12",  -borderwidth => 1, -foreground => "blue",
			-command => sub{})
		->place(-relx => 0.5, -rely => 0.9, -anchor => "s");
	
	# right frame (table)
	my $cpFrameR = $cp->Frame(-width => 450, -height => 340, -background => $mainFrameColor)
		->place(-relx => 0.9, -rely => 0.2, -anchor => "ne");
	$cpFrameR->Label(-text => "~ Monopoly Room ~", -font => "Helvetica 18", -width => 100, -foreground => "white", -background => $mainFrameHeaderColor)
		->place(-relx => 0.5, -rely => 0, -anchor => "n");
	$cpFrameR->Label(-text => "Player 1: ", -font => "Helvetica 16", -foreground => "white", -background => $mainFrameColor)
		->place(-relx => 0.1, -rely => 0.2, -anchor => "nw");
	$cpFrameR->Label(-text => "Player 2: ", -font => "Helvetica 16", -foreground => "white", -background => $mainFrameColor)
		->place(-relx => 0.1, -rely => 0.3, -anchor => "nw");
	$cpFrameR->Label(-text => "Player 3: ", -font => "Helvetica 16", -foreground => "white", -background => $mainFrameColor)
		->place(-relx => 0.1, -rely => 0.4, -anchor => "nw");
	$cpFrameR->Label(-text => "Player 4: ", -font => "Helvetica 16", -foreground => "white", -background => $mainFrameColor)
		->place(-relx => 0.1, -rely => 0.5, -anchor => "nw");
	$connectPlayerText[0] = $cpFrameR->Label(-text => "AAAAAAA", -font => "Helvetica 16", -foreground => "white", -background => $mainFrameColor)
		->place(-relx => 0.35, -rely => 0.2, -anchor => "nw");
	$connectPlayerText[1] = $cpFrameR->Label(-text => "BBBBBBB", -font => "Helvetica 16", -foreground => "white", -background => $mainFrameColor)
		->place(-relx => 0.35, -rely => 0.3, -anchor => "nw");
	$connectPlayerText[2] = $cpFrameR->Label(-text => "CCCCCCC", -font => "Helvetica 16", -foreground => "white", -background => $mainFrameColor)
		->place(-relx => 0.35, -rely => 0.4, -anchor => "nw");
	$connectPlayerText[3] = $cpFrameR->Label(-text => "DDDDDDD", -font => "Helvetica 16", -foreground => "white", -background => $mainFrameColor)
		->place(-relx => 0.35, -rely => 0.5, -anchor => "nw");
	$cpFrameR->Label(-text => "[Host]", -font => "Helvetica 16", -foreground => "white", -background => $mainFrameColor)
		->place(-relx => 0.9, -rely => 0.2, -anchor => "ne");
	$cpFrameR->Button(-text => "Start Game", -relief => "flat", -font => "Helvetica 12",  -borderwidth => 1, -width => 15, -foreground => "blue",
			-command => sub{$nb = goToTab($nb, $page_name, "player_setting")})
		->place(-relx => 0.1, -rely => 0.9, -anchor => "sw");
	$cpFrameR->Button(-text => "Leave Room", -relief => "flat", -font => "Helvetica 12",  -borderwidth => 1, -width => 15, -foreground => "blue",
			-command => sub{})
		->place(-relx => 0.9, -rely => 0.9, -anchor => "se");
		
	return $cp;
}

sub updateConnectPlayer{
	my ($i, $connectPlayer) = @_;
	
	$connectPlayerText[$i]->configure(-text => $connectPlayer->getName());
}

1;
