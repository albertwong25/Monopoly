#!/usr/bin/perl -w

use strict;
use warnings;

# MainWindow
our $mw;
our $win_title = "Monopoly Online";

our $win_w = 1100;
our $win_h = 600;

# Notebook
our $hideTab = 1; # 1/0
our $tabState = "normal"; # normal/disabled

# Frame
our $mainFrameColor = "#033677";
our $mainFrameHeaderColor = "navy";
our $subFrameColor = "#033680";

our $offLine = 1;

our (@lands, @players, @connectPlayers, @xco, @yco);

our $ggg = 0;

# Initialize
sub initialize{
	# players
	for (my $i = 0; $i < 4; $i++){
		$players[$i] = new Player("", $i);
		$connectPlayers[$i] = new Player("", $i);
	}
	# lands
	$lands[0] = new Land( "GDYNIA", 600000, 1, 20000, "brown", 500000);
	$lands[1] = new Land( "TAIPEI", 600000, 3, 40000,"brown", 500000);
	$lands[2] = new Land( "TOKYO", 1000000, 6, 60000, "lightblue", 500000);
	$lands[3] = new Land( "BARCELONA", 1000000, 8, 60000, "lightblue", 500000);
	$lands[4] = new Land( "ATHENS", 1200000, 9, 80000, "lightblue", 500000);
	$lands[5] = new Land( "ISTANBUL", 1400000, 11, 100000, "pink", 1000000);
	$lands[6] = new Land( "KYIV", 1400000, 13, 100000, "pink", 1000000);
	$lands[7] = new Land( "TORONTO", 1600000, 14, 120000, "pink", 1000000);
	$lands[8] = new Land( "ROME", 1800000, 16, 140000, "orange", 1000000);
	$lands[9] = new Land( "SHANGHAI", 1800000, 18, 140000, "orange", 1000000);
	$lands[10] = new Land( "VANCOUVER", 2000000, 19, 160000, "orange", 1000000);
	$lands[11] = new Land( "SYDNEY", 2200000, 21, 180000, "red", 1500000);
	$lands[12] = new Land( "NEW YORK", 2200000, 23, 180000, "red", 1500000);
	$lands[13] = new Land( "LONDON", 2400000, 24, 200000, "red", 1500000);
	$lands[14] = new Land( "BEIJING", 2600000, 26, 220000, "yellow", 1500000);
	$lands[15] = new Land( "HONG KONG", 2600000, 27, 220000, "yellow", 1500000);
	$lands[16] = new Land( "JERUSALEM", 2800000, 29, 240000, "yellow", 1500000);
	$lands[17] = new Land( "PARIS", 3000000, 31, 260000, "green", 2000000);
	$lands[18] = new Land( "BELGRADE", 3000000, 32, 260000, "green", 2000000);
	$lands[19] = new Land( "CAPETOWN", 3200000, 34, 280000, "green", 2000000);
	$lands[20] = new Land( "RIGA", 3500000, 37, 350000, "blue", 2000000);
	$lands[21] = new Land( "MONTREAL", 4000000, 39, 500000, "blue", 2000000);
	$lands[22] = new Land( "MONOPOLY RAIL", 2000000, 5, 250000, "transportation",0);
	$lands[23] = new Land( "MONOPOLY AIR", 2000000, 15, 250000, "transportation",0);
	$lands[24] = new Land( "MONOPOLY CRUISE", 2000000, 25, 250000, "transportation",0);
	$lands[25] = new Land( "MONOPOLY SPACE", 2000000, 35, 250000, "transportation",0);
	$lands[26] = new Land( "SOLAR POWER", 1500000, 12, 40000, "powerstation",0);
	$lands[27] = new Land( "WIND POWER", 1500000, 28, 40000, "powerstation",0);
	
	#x,y coordinates of lands
	@xco = (800,730,690,640,600,550,510,460,420,370,325,310,310,310,310,310,310,310,310,310,320,370,420,460,510,550,600,640,690,730,800,800,800,800,800,800,800,800,800,800);
	@yco = (520,520,520,520,520,520,520,520,520,520,505,450,410,360,320,270,230,180,140, 90, 40, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 90,140,180,230,270,320,360,410,450);

	return $mw;
}

1;