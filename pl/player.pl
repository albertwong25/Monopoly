#!/usr/bin/perl -w

use strict;
use warnings;
use Tk;

our ($tabState, $win_w, $win_h);
our ($bgimg, $bottomimg, @chess_img, @chess_a_img, @chess_s_img);
our $mainFrameColor;
our (@players, @connectPlayers);
our $playerNum;
our $currentPlayer;
our $isImageClick;
our $selectedImage;
our $pcanvas;

sub createPlayerPage{
	my ($nb, $page_name, $page_label) = @_;
	
	my $pp = $nb->add($page_name, -label => $page_label, -state => $tabState);
	
	# background image + label + chess images
	$pcanvas = $pp->Canvas(-highlightthickness => 0);
	
	$pcanvas->createImage($win_w/2, $win_h/2, -image => $bgimg);
	$currentPlayer = 0;
	my $name = $players[$currentPlayer]->getName();
	$pcanvas->createText($win_w/2, 100, -text => "Hi $name! Please choose a character below.", -font => "Helvetica 18", -fill => "white", -tags => "textLabel");
	for (my $i = 1; $i <= 6; $i++){
		$pcanvas->createImage(175+($i-1)*150, $win_h/2-50, -image => $chess_img[$i], -tags => "c0$i");
	}
	$pcanvas->createImage($win_w/2, $win_h-20, -image => $bottomimg, -anchor => "s");
	$pcanvas->pack(-expand => 1, -fill => "both");
	
	$isImageClick = 0;
	$selectedImage = "";

	$pcanvas->bind("c01", "<Enter>" => sub{ $pcanvas = updateImage($pcanvas, "c01", $chess_img[1], $chess_a_img[1], "Enter"); });
	$pcanvas->bind("c01", "<Leave>" => sub{ $pcanvas = updateImage($pcanvas, "c01", $chess_img[1], $chess_a_img[1], "Leave"); });
	$pcanvas->bind("c01", "<ButtonRelease>" => sub{ $isImageClick = 1; $selectedImage = "c01"; $pcanvas = resetAllImages($pcanvas); });
	$pcanvas->bind("c02", "<Enter>" => sub{ $pcanvas = updateImage($pcanvas, "c02", $chess_img[2], $chess_a_img[2], "Enter"); });
	$pcanvas->bind("c02", "<Leave>" => sub{ $pcanvas = updateImage($pcanvas, "c02", $chess_img[2], $chess_a_img[2], "Leave"); });
	$pcanvas->bind("c02", "<ButtonRelease>" => sub{ $isImageClick = 1; $selectedImage = "c02"; $pcanvas = resetAllImages($pcanvas); });
	$pcanvas->bind("c03", "<Enter>" => sub{ $pcanvas = updateImage($pcanvas, "c03", $chess_img[3], $chess_a_img[3], "Enter"); });
	$pcanvas->bind("c03", "<Leave>" => sub{ $pcanvas = updateImage($pcanvas, "c03", $chess_img[3], $chess_a_img[3], "Leave"); });
	$pcanvas->bind("c03", "<ButtonRelease>" => sub{ $isImageClick = 1; $selectedImage = "c03"; $pcanvas = resetAllImages($pcanvas); });
	$pcanvas->bind("c04", "<Enter>" => sub{ $pcanvas = updateImage($pcanvas, "c04", $chess_img[4], $chess_a_img[4], "Enter"); });
	$pcanvas->bind("c04", "<Leave>" => sub{ $pcanvas = updateImage($pcanvas, "c04", $chess_img[4], $chess_a_img[4], "Leave"); });
	$pcanvas->bind("c04", "<ButtonRelease>" => sub{ $isImageClick = 1; $selectedImage = "c04"; $pcanvas = resetAllImages($pcanvas); });
	$pcanvas->bind("c05", "<Enter>" => sub{ $pcanvas = updateImage($pcanvas, "c05", $chess_img[5], $chess_a_img[5], "Enter"); });
	$pcanvas->bind("c05", "<Leave>" => sub{ $pcanvas = updateImage($pcanvas, "c05", $chess_img[5], $chess_a_img[5], "Leave"); });
	$pcanvas->bind("c05", "<ButtonRelease>" => sub{ $isImageClick = 1; $selectedImage = "c05"; $pcanvas = resetAllImages($pcanvas); });
	$pcanvas->bind("c06", "<Enter>" => sub{ $pcanvas = updateImage($pcanvas, "c06", $chess_img[6], $chess_a_img[6], "Enter"); });
	$pcanvas->bind("c06", "<Leave>" => sub{ $pcanvas = updateImage($pcanvas, "c06", $chess_img[6], $chess_a_img[6], "Leave"); });
	$pcanvas->bind("c06", "<ButtonRelease>" => sub{ $isImageClick = 1; $selectedImage = "c06"; $pcanvas = resetAllImages($pcanvas); });
	
	# header
	$pp->Label(-text => "Player Setting", -font => "Helvetica 24", -width => 100, -foreground => "white", -background => $mainFrameColor)
		->place(-relx => 0.5, -rely => 0, -anchor => "n");
	
	# ready button
	$pp->Button(-text => "Ready", -relief => "flat", -font => "Helvetica 12",  -borderwidth => 1, -width => 15, -foreground => "blue",
			-command => sub{ $nb = readyButtonOnClick($nb, $page_name);})
		->place(-relx => 0.5, -rely => 0.8, -anchor => "center");
	
	return $pp;
}

sub updateImage{
	my ($canvas, $tag, $image1, $image2, $motion) = @_;
	
	if ($motion eq "Leave"){
		if ($isImageClick > 0 or $selectedImage eq $tag){
			$pcanvas->itemconfigure($tag, -image => $image2);
			$isImageClick = 0;
		} else{
			$pcanvas->itemconfigure($tag, -image => $image1); 
		}
	} else{
		$pcanvas->itemconfigure($tag, -image => $image2); 
	}
	$pcanvas->update();
	
	return $pcanvas;
}

sub resetAllImages{
	my $canvas = $_[0];
	
	for (my $i = 1; $i <= 6; $i++){
		$pcanvas->itemconfigure("c0$i", -image => $chess_img[$i]) if ($selectedImage ne "c0$i"); 
	}
	$pcanvas->update();
	
	return $pcanvas;
}

sub readyButtonOnClick{
	my ($nb, $page_name, $canvas) = @_;
	
	if ($selectedImage eq ""){
		my $err = $nb->messageBox(-title => "Invalid Input", 
			-message => "Please choose a character!", 
			-type => "Ok", -icon => "error", -default => "ok");
		return $nb;
	}
	
	$players[$currentPlayer]->setImg($chess_img[int(substr($selectedImage, 2, 1))]);
	$players[$currentPlayer]->setImg_a($chess_a_img[int(substr($selectedImage, 2, 1))]);
	$players[$currentPlayer]->setImg_s($chess_s_img[int(substr($selectedImage, 2, 1))]);
	$players[$currentPlayer]->setPosition(0);
	
	for (my $i = 0; $i < 4; $i++){
		updateLoadingPlayer($i, $connectPlayers[$i]);
	}
	
	$currentPlayer++;
	
	if ($currentPlayer < $playerNum){
		$selectedImage = "";
		$pcanvas = resetAllImages($pcanvas);
		my $name = $players[$currentPlayer]->getName();
		$pcanvas->itemconfigure("textLabel", -text => "Hi $name! Please choose a character below.");
		$pcanvas->update();
		return $nb;
	}
	
	for (my $i = 0; $i < 4; $i++){
		updatePlayer($i, $players[$i]); 
	}
	$nb = goToTab($nb, $page_name, "monopoly_game");
	
	return $nb;
}

1;
