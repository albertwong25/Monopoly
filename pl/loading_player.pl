#!/usr/bin/perl -w

use strict;
use warnings;
use Tk;

our $tabState;
our $win_w;
our $win_h;
our $bgimg;
our $bottomimg;
our $mainFrameColor;
our $mainFrameHeaderColor;

our @players;
our @connectPlayers;

our @loadingPlayerText;

sub createLoadingPlayerPage{
	my ($nb, $page_name, $page_label) = @_;
	
	my $lpp = $nb->add($page_name, -label => $page_label, -state => $tabState);
	
	# background image
	my $canvas = $lpp->Canvas(-highlightthickness => 0);
	$canvas->createImage($win_w/2, $win_h/2, -image => $bgimg);
	$canvas->createImage($win_w/2, $win_h-20, -image => $bottomimg, -anchor => "s");
	$canvas->pack(-expand => 1, -fill => "both");
	
	# header
	$lpp->Label(-text => "Waiting for other player(s)...", -font => "Helvetica 24", -width => 100, -foreground => "white", -background => $mainFrameColor)
		->place(-relx => 0.5, -rely => 0, -anchor => "n");
	
	# table
	my $lppFrame = $lpp->Frame(-width => 600, -height => 300, -background => $mainFrameColor)
		->place(-relx => 0.5, -rely => 0.2, -anchor => "n");
	$lppFrame->Label(-text => "~ Monopoly Room ~", -font => "Helvetica 18", -width => 100, -foreground => "white", -background => $mainFrameHeaderColor)
		->place(-relx => 0.5, -rely => 0, -anchor => "n");
	$lppFrame->Label(-text => "Player 1: ", -font => "Helvetica 16", -foreground => "white", -background => $mainFrameColor)
		->place(-relx => 0.1, -rely => 0.2, -anchor => "nw");
	$lppFrame->Label(-text => "Player 2: ", -font => "Helvetica 16", -foreground => "white", -background => $mainFrameColor)
		->place(-relx => 0.1, -rely => 0.3, -anchor => "nw");
	$lppFrame->Label(-text => "Player 3: ", -font => "Helvetica 16", -foreground => "white", -background => $mainFrameColor)
		->place(-relx => 0.1, -rely => 0.4, -anchor => "nw");
	$lppFrame->Label(-text => "Player 4: ", -font => "Helvetica 16", -foreground => "white", -background => $mainFrameColor)
		->place(-relx => 0.1, -rely => 0.5, -anchor => "nw");
	$loadingPlayerText[0] = $lppFrame->Label(-text => "AAAAAAA", -font => "Helvetica 16", -foreground => "white", -background => $mainFrameColor)
		->place(-relx => 0.35, -rely => 0.2, -anchor => "nw");
	$loadingPlayerText[1] = $lppFrame->Label(-text => "BBBBBBB", -font => "Helvetica 16", -foreground => "white", -background => $mainFrameColor)
		->place(-relx => 0.35, -rely => 0.3, -anchor => "nw");
	$loadingPlayerText[2] = $lppFrame->Label(-text => "CCCCCCC", -font => "Helvetica 16", -foreground => "white", -background => $mainFrameColor)
		->place(-relx => 0.35, -rely => 0.4, -anchor => "nw");
	$loadingPlayerText[3] = $lppFrame->Label(-text => "DDDDDDD", -font => "Helvetica 16", -foreground => "white", -background => $mainFrameColor)
		->place(-relx => 0.35, -rely => 0.5, -anchor => "nw");
	$lppFrame->Label(-text => "Ready", -font => "Helvetica 16", -foreground => "white", -background => $mainFrameColor)
		->place(-relx => 0.9, -rely => 0.2, -anchor => "ne");
	$lppFrame->Label(-text => "Waiting", -font => "Helvetica 16", -foreground => "white", -background => $mainFrameColor)
		->place(-relx => 0.9, -rely => 0.3, -anchor => "ne");
	$lppFrame->Label(-text => "Waiting", -font => "Helvetica 16", -foreground => "white", -background => $mainFrameColor)
		->place(-relx => 0.9, -rely => 0.4, -anchor => "ne");
	$lppFrame->Label(-text => "Waiting", -font => "Helvetica 16", -foreground => "white", -background => $mainFrameColor)
		->place(-relx => 0.9, -rely => 0.5, -anchor => "ne");
	
	# test button
	$lpp->Button(-text => "test only", -relief => "flat", -font => "Helvetica 12",  -borderwidth => 1, -width => 15, -foreground => "blue",
			-command => sub{ $nb = finishLoading($nb, $page_name); })
		->place(-relx => 0.5, -rely => 0.8, -anchor => "center");
	
	return $lpp;
}

sub finishLoading{
	my ($nb, $page_name) = @_;
	
	for (my $i = 0; $i < 4; $i++){
		updatePlayer($i, $players[$i]); 
	}
	$nb = goToTab($nb, $page_name, "monopoly_game");
	
	return $nb;
}

sub updateLoadingPlayer{
	my ($i, $connectPlayer) = @_;
	
	$loadingPlayerText[$i]->configure(-text => $connectPlayer->getName());
}

1;
