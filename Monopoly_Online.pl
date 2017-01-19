#!/usr/bin/perl -w

use strict;
use warnings;
use Tk;
use Tk::NoteBook;
use Tk::JPEG;
use Tk::PNG;

require "pl/setting.pl";
require "pl/utility.pl";
require "pl/class_player.pl";
require "pl/class_land.pl";
require "pl/start.pl";
require "pl/connect.pl";
require "pl/player.pl";
require "pl/loading_player.pl";
require "pl/game.pl";
require "pl/chance_action.pl";
require "pl/comcard_action.pl";
our ($mw, $win_title, $win_w, $win_h, $hideTab, $bgimg);our ($start_page, $connect_page, $player_page, $player_loading_page, $game_page);

$mw = MainWindow->new();
$mw->title($win_title);
my $win_pos_x = int(($mw->screenwidth / 2) - ($win_w / 2)); 
my $win_pos_y = int(($mw->screenheight / 2) - ($win_h / 2)) - 20; 
$mw->geometry($win_w."x".$win_h."+".$win_pos_x."+".$win_pos_y);
$mw->minsize($win_w, $win_h);
$mw->maxsize($win_w, $win_h);

$mw = initialize();
$mw = loadAllImages();
my $nb = $mw->NoteBook(-background => "#043A82", -foreground => "white")->pack(-expand => 1, -fill => "both");
$nb->Label(-image => $bgimg)->pack(-expand => 1, -fill => "both") if ($hideTab > 0);
$start_page = createStartPage($nb, "start", "Start");$connect_page = createConnectPage($nb, "connect", "Connect");
# $player_page = createPlayerPage($nb, "player_setting", "Player Setting");
$player_loading_page = createLoadingPlayerPage($nb, "loading_player_info", "Loading Player Info");
$game_page = createGamePage($nb, "monopoly_game", "Monopoly Game");
MainLoop;
