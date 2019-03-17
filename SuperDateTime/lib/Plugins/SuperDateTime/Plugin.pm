# SuperDateTime plugin.pm by Greg Brown Feb 2005    www.gregbrown.net/squeeze
#   Copyright (c) 2005 
#   All rights reserved.
#
# DESCRIPTION
# SlimServer plugin screensaver datetime replacement. Graphically displays current weather conditions and forecasts.  
# Will also optionally display stock quotes and upcoming/current game information for MLB, NBA, NHL, NFL, and college 
# football and basketball teams at user-configurable intervals.
#
# REMOTE CONTROL
# Pressing up or down cycles the information shown on line one during time display.  It will also immediately
# display the time if it is not currently being shown.
# Pressing right or left cycles through the available games and long weather forecasts that normally cycle automatically.
# Pressing FWD or REW cycles through the long weather forecasts.
# Pressing '+' will force an immediate data refresh.
#
# This screen saver is based on the standard SlimServer DateTime screensaver written written by kdf.
# The graphical weather icons and the code to support them are based on the WeatherTime screensaver written by Martin Rehfeld.
#
# VERSION HISTORY
# 5.9.50 03/16/19   Adjusted 15 day forecast to start with the current day.
#
# 5.9.49 02/18/19   Fixed certain NCAA team ICONs that were not displaying correctly. 
#					Added handling for Postponed College Basketball games.					
#					Cleaned up "Extras" display on Touch/Radio/Controller.
#
# 5.9.48 11/27/18   NCAA updated url for college football. 
#					Improved ICON resolution for college basketball
#
# 5.9.47 11/07/18   Improved halftime and overtime detection in 
#					NCAA Basketball(CBB) games.
#
# 5.9.46 11/04/18   Fixed halftime detection in CFB games.
#                   Updated for 2018-2019 NCAA Basketball season (CBB).
#
# 5.9.45 10/08/18   Re-established upcoming game times for NFL.
#
# 5.9.44 10/06/18   Interim release to work around change in NFL.com HTML.
#                   Upcoming NFL game times are not currently available. Displayed as TBD.
#                   Some upcoming college football games are also shown as TBD.
#
# 5.9.43 07/02/18   Re-established support for quotes of multiple stocks or indices.
#                   Fix icons for graphical display players (Boom, Transporter, Classic)                    
#
# 5.9.42 06/26/18   Corrected bug introduced in 5.9.41 for display of celsius temps.
#                   Added support for $funcptr requested by barberousse(Guillaume)
#
# 5.9.41 06/12/18   Updated to new weather.com URLs and JSON file formats.
#                   Added language setting for weather.com URLs.  Thanks barberousse(Guillaume).
#                   Added support for multiple OT periods in NBA games.
#                   Cleanup unused code for weather map support.
#
# 5.9.40 11/11/17   Corrected display of final CFB games that went into overtime.
#                   Added calculation for start of College Basketball (CBB) season.
#                   Fixed Stock quotes - Currently limited to one stock or index.
#
# 5.9.39 10/06/17   Updated NBA for change of URL and JSON file format. 
#                   Improved detection of Overtime and Multiple Overtime CFB games.
#
# 5.9.38 09/12/17   No functional changes.  To make user installation easier, a repository has been setup for 
#                   the weather.com version of SDT.
#                   http://sourceforge.net/projects/sdt-weather-com/files/repo.xml 
#
# 5.9.37 09/09/17   Fixed detection of College Football game status in gotCFB. 
#                   Update NFL teams for Chargers move to Los Angeles. 
#                   Also changed in Settings.pm 
#
# 5.9.36 01/02/17   Improve post season game date matching for College Football. 
#                   Force 2 digit day comparison.
#
# 5.9.35 12/27/16   Improve post season game date matching for College Football.
#                   
# 5.9.34 10/15/16   Account for NFL Los Angeles Rams move from St Louis.
#                   Improve game date matching for College Football.
#                   
#                   
# 5.9.33 07/28/16   Modified getCFB to automatically calculate season and week of season for use in URL.
#                   Modified getNBA to automatically calculate season used in the URL.
#                   Fixed bug where getMLB- would occassionly be displayed instead of the MLB team icon.
#                    
# 5.9.32 01/27/16   Cleanup of NFL and NBA html.
#                   Fixed CFB 2015 post season scores in 2016.
#                   Corrected code in sdtStocks that was using a hash as a reference.                    
#                    
# 5.9.31 12/06/15   Improved College Basketball clean-up of malformed JSON.
#                   Adjusted College Football to handle post season games.                   
#                    
# 5.9.30 11/15/15   Fixed College Basketball to better detect active games.
#                   Updates to correctly clear and not recreate games 
#                   on Touch, Radio, Controller screens when team selections are 
#                   cleared.
#                   Updated sub sdtCurrent to add 24 Precipitation totals to menus 
#                   for Squeeze Commander, Touch, Controller, etc.
#                   Added Game ICON for NHL.
#                   
# 5.9.29 10/15/15   Fixed College Basketball (CBB) parsing.
#                   Fixed NBA parsing.
#                   Added upcoming game times to NFL games.
#                   Added TV Network to NFL games.
#                   Cleanup unused weather.com modules.
#
# 5.9.28 09/20/15   Fixed College Football (CFB) parsing.
#                   Improved handling of NFL games that go into Over Time.
#
# 5.9.27 09/13/15   Fixed NFL parsing. Scores are now pulled from NFL.com JSON 
#                   data file.
#
# 5.9.26 08/02/15   Updated MLB parsing to handle All Star break and Post Season.
#                   i.e. - Days with no games or only a single game.
#                   Added MLB team logo png graphics for use with Custom Clock.
#                   Improved detection of Finished games in sub displayLines.                   
#                   Fixed bug introduced in 5.9.25 in sub doneDrawing.
#
# 5.9.25 04/25/15   MLB scores roll over to next day at 1AM Pacific instead of
#                   12AM Eastern.
#                   Added checks for MLB games that are Postponed, Delayed, Suspended, 
#                   and Completed Early.                    
#                   Updated function calls to decode JSON compatible with newer
#                   versions of JSON::XS.
#                   Abbreviated Diamondbacks to match MLB JSON data.
#
# 5.9.24 04/12/15   (Release Candidate 1)
#                   Fix for MLB scores
#                   Fixed Low temperature for tonight period during the day.  
#                   Remove current period long weather text for non-US locations. 
#
# 5.9.23 01/15/15   Fixed JSON parsing error caused by including an extra character  
#                   at the beginning of the JSON text.  
#
# 5.9.22 12/28/14   Fixed NBA parsing. Updated logos to current ESPN png format.
#                   Added team logos for NFL and NCAA basketball.
#                   Changed 24 hour snow total element selected
#                   from JSON data FROM: 'snwTot' TO: 'snwDep' 
#
# 5.9.21 12/15/14   Fix for NCAA Basketball scores.
#                   Added American Conference (AAC) to NCAA
#                   basketball conference selections.
#
# 5.9.20 12/12/14   Corrected display of long weather text for
#                   Duet type displays so text is in correct
#                   forecast period.
#                   Tweaked forecast display for Duet and Squeeze
#                   Commander to display all 4 available forecast
#                   periods during the day.
#
# 5.9.19 12/08/14   Fixed count in sdt10day to 9.
#                   Fixed missing sunrise/sunset from current/today.
#                   Adjusted handling of current through tomorrow night intervals.
#                   Corrected the period that data is collected from for 
#                   tomorrow/tomorrow night.
#                   Corrected scrolling of sports scores on Boom clients.
#
# 5.9.18 12/05/14   Added routine to check proper weather.com city format.
#                   Updated strings file to show proper format on settings page.
#                   Consolidated retrieval of elements from weather.com JSON file
#                   to gotWeatherToday routine.
#                   
# 5.9.17E 12/05/14  Added weekday info to 10day routine.  Completed long weather text.
# 5.9.17D 12/04/14  Added sunrise & sunset to 10day routine.
# 5.9.17C 12/02/14  Replace JSON library with JSON::XS.  Averages and 10day are now working.
# 5.9.17B 12/01/14  Adjusted to retrieve and parse weather.com elements from JSON data.
#                   NOTE: Zipcode/ city entry in settings requires full weather.com identifier.
#                        i.e. - Olathe KS = 66062:4:US  London UK = UKXX0085:1:UK
#
#                  Started weather.com JSON rewrite with Greg Brown's 5.9.14 version.             
#
#   This program is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation; either version 2 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program; if not, write to the Free Software
#   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
#   02111-1307 USA
#
# This code is derived from code with the following copyright message:
#
# SliMP3 Server Copyright (C) 2001 Sean Adams, Slim Devices Inc.
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License,
# version 2.

package Plugins::SuperDateTime::Plugin;

use strict;

use base qw(Slim::Plugin::Base);
use Slim::Utils::Misc;
use Slim::Utils::Strings qw (string);
use Slim::Networking::SimpleAsyncHTTP;
use Slim::Utils::Prefs;
use Slim::Utils::Log;
use Plugins::SuperDateTime::Settings;
use Plugins::SuperDateTime::PlayerSettings;
use lib "plugins/SuperDateTime/lib";
use HTML::TreeBuilder;
use Time::Local; 
use HTML::Entities qw(decode_entities);
use JSON::XS::VersionOneAndTwo;

my $prefs = preferences('plugin.superdatetime');

my $log = Slim::Utils::Log->addLogCategory({
    'category'     => 'plugin.superdatetime',
    'defaultLevel' => 'WARN',
    'description'  => getDisplayName(),
});

use vars qw($VERSION);
$VERSION = substr(q$Revision: 5.9.50 $,10);

$Plugins::SuperDateTime::Plugin::apiVersion = 2.0;

sub getDisplayName {
    return 'PLUGIN_SCREENSAVER_SUPERDATETIME';
}

sub enabled {
    return ($::VERSION ge '7.0');
}

my %killTicker; #Flag used to exit out of ticker mode
my $status = '';  #Used for the status indicator
my %overlay; #Used to show alarm indicator
my $errorCount = 0; #Used to keep track of network errors
my $activeClients = 0; #Number of players currently displaying SuperDateTime
my $forecastNum; #Used to keep track of if today's forecast includes just today or today and tonight.  There's probably a better way to do this but this will suffice for now...

#These preferences are used often so they're locally cached. Preset to default values.
my $showtime = 7; #How long to show the time when no games are active
my $showgame = 3; #How long to show an upcoming/completed game
my $showactivetime = 5; #How long to show the time when games are active
my $showactivegame = 3; #How long to show an active game
my $activeGames = 0; #Flag set if any games are active
my $newActiveGames; #Flag set during a data refresh if any games are active
my %scrollType = (); #Type of display scrolling between games per player

my %displayInfo; #Contains all the info shown when hitting up/down
my %displayInfoBuild; #Used while building display info in pieces

my %nowshowing; #What's now showing, 0 for time, Negative for long forecasts, etc
my %weathershowing; #Used for when the user chooses to just view the long weather forecasts via remote
my %topNowShowing; #Which item is being shown on top line during time display
my %displayLine1; #What is currently being shown on the display line 1 while cycling
my %displayLine2; #What is currently being shown on the display line 2 while cycling
my %tickline1; #Used to store previous value of display line 1 during ticker display

my %macroHash; #Used for custom macros that interfacing plugins may register

my $lat = ''; # Used to store latitude of weather.com location
my $long = ''; # Used to store longitude of weather.com location
my $dayCount = ''; # Used to store number of days in the extended forecast
my $units = ''; # Used to store units of measure preference (metric or US)  
                # based on temperature preference (celsius or fahrenheit)
my $funcptr = undef; # Used for external macros passed in for display
my $stockCount = ''; # Used to store the number of stock tickers in preferences
my $stockCounter = ''; # Used to track the number of passes through getstocks and got stocks

my %wetData = ();   #Stores weather-related data
#my %wetMapURLs = ();   #Stores available weather image URLs
my %NFLupTime = (); #Stores upcoming NFL game times

my %miscData = ();  #Stores misc data for use from jive interface (stocks)
my %sportsData = ();    #Stores all sport info for use from jive interface

#Track the average high/low for today/tomorrow
my %averages = ('last' => ''); #Used to store raw averages data and when they were last refreshed

#Used to store pointers to the data providers
my %providers =  ('1'  => \&getWeatherToday,
                  '2'  => \&getWunderground,
                  '3'  => \&getMLB,
                  '4'  => \&getNFL,
                  '5'  => \&getNBA,
                  '6'  => \&getNHL,
                  '7'  => \&getCBB,                  
                  '8'  => \&getCFB,
                  '9'  => \&getStocks,
                  '10' => \&getLongWeather,                 
                  '11' => \&getAverages);

my @WETdisplayItems1 = ();
my @WETdisplayItems2 = ();

my @WETdisplayItems1temp = ();
my @WETdisplayItems2temp = ();

my $drawEachPending = 0;
my $drawEachPendingDelay;

my @refreshTracker = (); #Used to keep track of which fields to continue to refresh
my $lastRefresh = ''; #Date that pertains to @refreshTracker data

#Arrays to contain the user selected teams to monitor for each sport and icon mappings
my @MLBteams = ();
my %MLBmap = ('Cubs'  => 10, 'White Sox'  => 11, 'Braves' => 12, 'Giants' => 13, 'Angels' => 14, 'Tigers' => 15, 'Astros' => 16, 'Reds' => 17, 'D-backs' => 18, 'Twins' => 19, 'Rays' => 20, 'Red Sox' => 21, 'Indians' => 22, 'Rangers' => 24, 'Yankees' => 25, 'Orioles' => 26, 'Blue Jays' => 27, 'Royals' => 28, 'Athletics' => 29, 'Mariners' => 30, 'Pirates' => 31, 'Mets' => 32, 'Phillies' => 33, 'Marlins' => 34, 'Nationals' => 35, 'Brewers' => 36, 'Cardinals' => 37, 'Dodgers' => 38, 'Padres' => 39, 'Rockies' => 40 ); #Graphical icon mapping
my %MLBICONmap = ('Cubs'  => 'chc', 'White Sox'  => 'chw', 'Braves' => 'atl', 'Giants' => 'sf', 'Angels' => 'laa', 'Tigers' => 'det', 'Astros' => 'hou', 'Reds' => 'cin', 'D-backs' => 'ari', 'Twins' => 'min', 'Rays' => 'tb', 'Red Sox' => 'bos', 'Indians' => 'cle', 'Rangers' => 'tex', 'Yankees' => 'nyy', 'Orioles' => 'bal', 'Blue Jays' => 'tor', 'Royals' => 'kc', 'Athletics' => 'oak', 'Mariners' => 'sea', 'Pirates' => 'pit', 'Mets' => 'nym', 'Phillies' => 'phi', 'Marlins' => 'mia', 'Nationals' => 'wsh', 'Brewers' => 'mil', 'Cardinals' => 'stl', 'Dodgers' => 'lad', 'Padres' => 'sd', 'Rockies' => 'col' ); #icon mapping for Touch, Controller etc.
my @NBAteams = ();
my %NBAteamMap = (
                        'PHI'   => '76ers',
                        'MIL'   => 'Bucks',
                        'CHI'   => 'Bulls',
                        'CLE'   => 'Cavaliers',
                        'BOS'   => 'Celtics',
                        'LAC'   => 'Clippers',
                        'MEM'   => 'Grizzlies',
                        'ATL'   => 'Hawks',
                        'MIA'   => 'Heat',
                        'CHA'   => 'Hornets',
                        'UTA'   => 'Jazz',
                        'SAC'   => 'Kings',
                        'NYK'   => 'Knicks',
                        'LAL'   => 'Lakers',
                        'ORL'   => 'Magic',
                        'DAL'   => 'Mavericks',
                        'BKN'   => 'Nets',
                        'DEN'   => 'Nuggets',
                        'IND'   => 'Pacers',
                        'NOP'   => 'Pelicans',
                        'DET'   => 'Pistons',
                        'TOR'   => 'Raptors',
                        'HOU'   => 'Rockets',
                        'SAS'   => 'Spurs',
                        'PHX'   => 'Suns',
                        'OKC'   => 'Thunder',
                        'MIN'   => 'Timberwolves',
                        'POR'   => 'Trail Blazers',
                        'GSW'   => 'Warriors',
                        'WAS'   => 'Wizards',
);

my @NHLteams = ();
my @NFLteams = ();
my %NFLmap = ('Bears'  => 10, 'Lions'  => 11, 'Packers' => 12); #Graphical icon mapping
my %NFLteamMap = (
                        'DAL' => 'Cowboys',
                        'NYG' => 'Giants',
                        'NYJ' => 'Jets',
                        'PHI' => 'Eagles',
                        'WAS' => 'Redskins',
                        'CHI' => 'Bears',
                        'GB'  => 'Packers',
                        'MIN' => 'Vikings',
                        'DET' => 'Lions',
                        'ATL' => 'Falcons',
                        'NO'  => 'Saints',
                        'TB'  => 'Buccaneers',
                        'CAR' => 'Panthers',
                        'LA'  => 'Rams',
                        'ARI' => 'Cardinals',
                        'SF'  => '49ers',
                        'SEA' => 'Seahawks',
                        'DEN' => 'Broncos',
                        'BUF' => 'Bills',
                        'NE'  => 'Patriots',
                        'MIA' => 'Dolphins',
                        'CIN' => 'Bengals',
                        'CLE' => 'Browns',
                        'PIT' => 'Steelers',
                        'BAL' => 'Ravens',
                        'TEN' => 'Titans',
                        'JAC' => 'Jaguars',
                        'HOU' => 'Texans',
                        'IND' => 'Colts',
                        'KC'  => 'Chiefs',
                        'OAK' => 'Raiders',
                        'LAC'  => 'Chargers',
                        'AFC'  => 'AFC',
                        'NFC'  => 'NFC',
);
my $NFL_HTML = ""; # Store NFL HTML file
my @CBBteams = ();
my @CFBteams = ();

#Graphical display stuff
my %xmax = ();
my %ymax = ();

my %hashDisp;

my $Gclient;

#
# Map ASCII characters to custom @Charset elements
#
my %Codepage = ( ' ' =>  0, '1' =>  1, '2' =>  2, '3' =>  3, '4' =>  4,
                 '5' =>  5, '6' =>  6, '7' =>  7, '8' =>  8, '9' =>  9,
                 '0' => 10, '-' => 11, '°' => 12, '.' => 13, '%' => 14,
                 'A' => 15, 'B' => 16, 'C' => 17, 'D' => 18, 'E' => 19,
                 'F' => 20, 'G' => 21, 'H' => 22, 'I' => 23, 'J' => 24,
                 'K' => 25, 'L' => 26, 'M' => 27, 'N' => 28, 'O' => 29,
                 'P' => 30, 'Q' => 31, 'R' => 32, 'S' => 33, 'T' => 34,
                 'U' => 35, 'V' => 36, 'W' => 37, 'X' => 38, 'Y' => 39,
                 'Z' => 40, '/' => 41, ':' => 42 );

#
# Custom 7x5 mono charset for 3-line forecast display on Squeezebox2
#
my @Charset = ('







','
  *
 **
* *
  *
  *
  *
*****
','
 ***
*   *
    *
   *
  *
 *
*****
','
 ***
*   *
    *
  **
    *
*   *
 ***
','
   *
  **
 * *
*****
   *
   *
   *
','
*****
*
*
****
    *
*   *
 ***
','
 ***
*
*
****
*   *
*   *
 ***
','
*****
    *
    *
   *
  *
 *
*
','
 ***
*   *
*   *
 ***
*   *
*   *
 ***
','
 ***
*   *
*   *
 ****
    *
    *
 ***
','
 ***
*   *
*   *
*   *
*   *
*   *
 ***
','



*****



','
 **
*  *
*  *
 **



','





  **
  **
','
**   
**  *
   *
  *
 *
*  **
   **
','
 ***
*   *
*   *
*****
*   *
*   *
*   *
','
****
*   *
*   *
****
*   *
*   *
****
','
 ***
*   *
*
*
*
*   *
 ***
','
****
*   *
*   *
*   *
*   *
*   *
****
','
*****
*
*
****
*
*
*****
','
*****
*
*
****
*
*
*
','
 ***
*   *
*
* ***
*   *
*   *
 ***
','
*   *
*   *
*   *
*****
*   *
*   *
*   *
','
 ***
  *
  *
  *
  *
  *
 ***
','
    *
    *
    *
    *
    *
*   *
 ***
','
*   *
*  *
* *
**
* *
*  *
*   *
','
*
*
*
*
*
*
*****
','
*   *
** **
* * *
*   *
*   *
*   *
*   *
','
*   *
*   *
**  *
* * *
*  **
*   *
*   *
','
 ***
*   *
*   *
*   *
*   *
*   *
 ***
','
****
*   *
*   *
****
*
*
*
','
 ***
*   *
*   *
*   *
*   *
* * *
*  **
 ** *
','
****
*   *
*   *
****
* *
*  *
*   *
','
 ****
*
*
 ***
    *
    *
****
','
*****
  *
  *
  *
  *
  *
  *
','
*   *
*   *
*   *
*   *
*   *
*   *
 *** 
','
*   *
*   *
*   *
*   *
*   *
 * *
  *
','
*   *
*   *
*   *
*   *
* * *
** **
*   *
','
*   *
*   * 
 * * 
  *  
 * * 
*   * 
*   *
','
*   *
*   *
 * *
  *
  *
  *
  *
','
*****
    *
   *
  *
 *
*
*****
','

    *
   *
  *
 *
*

','

 **
 **

 **
 **

');

#
# map standard weather.com icons to custom icons
#
my %Iconmap = ( '1'  => 2, '2'  => 2, '3'  => 2, '4'  => 2, '5'  => 23, 
                '6'  => 27,'7'  => 24,'8'  => 3, '9'  => 1, '10' => 3, 
                '11' => 25,'12' => 1, '13' => 18,'14' => 3, '15' => 19, 
                '16' => 20,'17' => 2, '18' => 26,'19' => 32,'20' => 33, 
                '21' => 10,'22' => 9, '23' => 11,'24' => 11,'25' => 30, 
                '26' => 0, '27' => 14,'28' => 6, '29' => 13,'30' => 5, 
                '31' => 12,'32' => 4, '33' => 13,'34' => 5, '35' => 2, 
                '36' => 31,'37' => 8, '38' => 8, '39' => 7, '40' => 28, 
                '41' => 21,'42' => 22,'43' => 22,'44' => 9, '45' => 15, 
                '46' => 16,'47' => 17,'48' => 29, '0' => 2, 'na' => 9,
                'NA' => 9, 'N/A' => 9 );

#
# Custom weather condition icons (40x32 pixel)
#
#234567890123456789012345678901234567890 - icon 0
my @Icons = ('





              ****
           ****  ****
        ****        **
       **            **
      **              **
     **                ** ***
     *                  *** **
  ****                   *   **
 **                           *
**                            **
*                              ***
*                                **
*                                 *
**                               **
 ***                            **
   ******************************
',
#234567890123456789012345678901234567890 - icon 1
'





              ****
           ****  ****
        ****        **
       **            **
      **              **
     **                ** ***
     *                  *** **
  ****                   *   **
 **                           *
**                            **
*                              ***
*                                **
*                                 *
**                               **
 ***                            **
   ******************************

     *         *        *
     *         *   *    *
    *    *    *    *   *
    *    *    *   *    *    *
   *    *    *    *    *    *
   *         *        *    *
  *         *         *    *
',
#234567890123456789012345678901234567890 - icon 2
'





              ****
           ****  ****
        ****        **
       **            **
      **              **
     **     **         ** ***
     *      **          *** **
  ****     **            *   **
 **        **                 *
**        **                  **
*         **                   ***
*        ** **                   **
*        ******                   *
**       *** **                  **
 ***        **                  **
   ******************************
           **
          **
     *    **   *        *
     * * **    *   *    *
    *  ****   *    *   *
    *  *****  *   *    *    *
   *    **   *    *    *    *
   *    *    *        *    *
  *         *         *    *
',
#234567890123456789012345678901234567890 - icon 3
'





              ****
           ****  ****
        ****        **
       **            **
      **              **
     **                ** ***
     *                  *** **
  ****                   *   **
 **                           *
**                            **
*                              ***
*                                **
*                                 *
**                               **
 ***                            **
   ******************************

                           * *
      * *                *  *  *
    *  *  *               * * *
     * * *      * *      * *** *
    * *** *   *  *  *     * * *
     * * *     * * *     *  *  *
    *  *  *   * *** *      * *
      * *      * * *
              *  *  *
                * *
',
#234567890123456789012345678901234567890 - icon 4
'
                     *
        *            *
         *          *
          *         *
          *         *
           *       *          *
            *      *         *
                           **
                          *
 *            *****      *
  **        *********
    **     ***********
      *   *************
          *************
         ***************
         ***************
         ***************  *******
         ***************
         ***************
    ***   *************
****      *************
           ***********
            *********
              *****      *
                          *
           *               **
          *       *          *
         *        *           *
         *        *
        *          *
       *           *
                   *
',
#234567890123456789012345678901234567890 - icon 5
'
                     *
        *            *
         *          *
          *         *
          *         *
           *       *          *
            *      *         *
                           **
                          *
 *            *****      *
  **        *********
    **     *********** ****
      *   **********  **   *
          *********         **
         *********           * **
         *******              *  *
         ******                  **
         *****                    **
         *****                     *
    ***   *****                    *
****      *************************
           ***********
            *********
              *****      *
                          *
           *               **
          *       *          *
         *        *           *
         *        *
        *          *
       *           *
                   *
',
#234567890123456789012345678901234567890 - icon 6
'
                  *       *        *
                   *      *       *
                   *      *       *
                    *     *      *
                                *
              ****     *******
           ****  **** *********
        ****        ************     **
       **            ************  **
      **              ***********
     **                **********
     *                  *** *****
  ****                   *   ****
 **                           *** *
**                            ***  **
*                              ***   **
*                                **
*                                 *
**                               **
 ***                            **
   ******************************
',
#234567890123456789012345678901234567890 - icon 7
'
                  *       *        *
                   *      *       *
                   *      *       *
                    *     *      *
                                *
              ****     *******
           ****  **** *********
        ****        ************     **
       **            ************  **
      **              ***********
     **                **********
     *                  *** *****
  ****                   *   ****
 **                           *** *
**                            ***  **
*                              ***   **
*                                **
*                                 *
**                               **
 ***                            **
   ******************************

     *         *        *
     *         *   *    *
    *    *    *    *   *
    *    *    *   *    *    *
   *    *    *    *    *    *
   *         *        *    *
  *         *         *    *
',
#234567890123456789012345678901234567890 - icon 8
'
                  *       *        *
                   *      *       *
                   *      *       *
                    *     *      *
                                *
              ****     *******
           ****  **** *********
        ****        ************     **
       **            ************  **
      **              ***********
     **     **         **********
     *      **          *** *****
  ****     **            *   ****
 **        **                 *** *
**        **                  ***  **
*         **                   ***   **
*        ** **                   **
*        ******                   *
**       *** **                  **
 ***        **                  **
   ******************************
           **
          **
     *    **   *        *
     * * **    *   *    *
    *  ****   *    *   *
    *  *****  *   *    *    *
   *    **   *    *    *    *
   *    *    *        *    *
  *         *         *    *
',
#234567890123456789012345678901234567890 - icon 9
'






                *****
              *********
             ***    ***
             *       ***
                     ***
                     ***
                    ****
                   ****
                  ****
                 ****
                 ***
                ***
                ***
                ***
                ***


                ***
                ***
                ***
',
#234567890123456789012345678901234567890 - icon 10
'




    
 
                               
**   **    *     ****** **   **
**   **   ***        ** **   **
**   **   * *       **   ** **
*******  **  *     **     ***
**   **  *****    **       *
**   **  *   *   **        *
**   ** *     * **         *
**   ** *     * ********   *
  
  *     *     *    *     *                
    *      *     *    *      *  
 *     *  *       *       * 
     *       *         *    *      
      *            *        
    *       *           *

  *       *       *        *              
                
      *       *        *          
                 
           *       *         
',
#234567890123456789012345678901234567890 - icon 11 - Windy - Thanks Yannzola
'
                       *
        *****          **
       **   **         **
      **     *         ******
      *      ****      ******
      *         **     ******
   ****          *     ******
  **           ******* **********
 **                    **********
 *                     **********
 *          ********** **********
 **                    **************
  ***                  **************
    ****************** **************
                       **************
                       ****************
         *******       *****************
        **     **     **
        *       **   **
       **    *   *  **
       *    **     **
       *    *     **
   *****    **   **
  **         ** **   ************
 **           ***
 *
 *
 *             ************************
 *
 **
  ***
    *****************************
',
#234567890123456789012345678901234567890 - icon 12
'
                     
        
         
          
          
           
          
                     
                          
              *****      
            **     **
           *     *   *
          *     * **  *
          *           *
         *          *  *
         *    *        *
         *   **   *    *  
         **   *  ***   *
         ***     *    *
          **    **    *
          ** ***      *
           ****   *  *
            **  ** **
              *****      
                          
          
         
      
        
        
       
                   
',
#234567890123456789012345678901234567890 - icon 13
'
                     
        
         
          
          
           
          
                     
                          
              *****      
            **     **
           *        ** ****
          *        *  **   *
          *       *         **
         *      **           * **
         *     *              *  *
         *    *                  **
         *   *                    **
         *   *                     *
          *   *                    *
          *   *********************
           *         *
            **     **
              *****      
                          
          
         
      
        
        
       
                   
',
#234567890123456789012345678901234567890 - icon 14
'
                  
                   
                   
                               
                         *****       
              ****     **     **
           ****  **** *         *
        ****        **           *     
       **            **          *  
      **              **         *
     **                ** ***    *
     *                  *** **   *
  ****                   *   *  *
 **                           ** 
**                            **   
*                              ***   
*                                **
*                                 *
**                               **
 ***                            **
   ******************************
',
#234567890123456789012345678901234567890 - icon 15
'
                  
                   
                   
                               
                         *****       
              ****     **     **
           ****  **** *         *
        ****        **           *     
       **            **          *  
      **              **         *
     **                ** ***    *
     *                  *** **   *
  ****                   *   *  *
 **                           ** 
**                            **   
*                              ***   
*                                **
*                                 *
**                               **
 ***                            **
   ******************************

     *         *        *
     *         *   *    *
    *    *    *    *   *
    *    *    *   *    *    *
   *    *    *    *    *    *
   *         *        *    *
  *         *         *    *
',
#234567890123456789012345678901234567890 - icon 16
'
                  
                   
                   
                               
                         *****       
              ****     **     **
           ****  **** *         *
        ****        **           *     
       **            **          *  
      **              **         *
     **                ** ***    *
     *                  *** **   *
  ****                   *   *  *
 **                           ** 
**                            **   
*                              ***   
*                                **
*                                 *
**                               **
 ***                            **
   ******************************

                           * *
      * *                *  *  *
    *  *  *               * * *
     * * *      * *      * *** *
    * *** *   *  *  *     * * *
     * * *     * * *     *  *  *
    *  *  *   * *** *      * *
      * *      * * *
              *  *  *
                * *
',
#234567890123456789012345678901234567890 - icon 17
'
                  
                   
                   
                               
                         *****       
              ****     **     **
           ****  **** *         *
        ****        **           *     
       **            **          *  
      **              **         *
     **     **         ** ***    *
     *      **          *** **   *
  ****     **            *   *  *
 **        **                 ** 
**        **                  **   
*         **                   ***   
*        ** **                   **
*        ******                   *
**       *** **                  **
 ***        **                  **
   ******************************
           **
          **
     *    **   *        *
     * * **    *   *    *
    *  ****   *    *   *
    *  *****  *   *    *    *
   *    **   *    *    *    *
   *    *    *        *    *
  *         *         *    *
',
#234567890123456789012345678901234567890 - icon 18
'





              ****
           ****  ****
        ****        **
       **            **
      **              **
     **                ** ***
     *                  *** **
  ****                   *   **
 **                           *
**                            **
*                              ***
*                                **
*                                 *
**                               **
 ***                            **
   ******************************

                         * *
                       *  *  *
                        * * *
                       * *** *
                        * * *
                       *  *  *
                         * *
                    
                     
                   
',
#234567890123456789012345678901234567890 - icon 19
'












                    * *
                  *  *  *
                   * * *
                  * *** *
                   * * *
                  *  *  * 
                    * *    * *
      * *                *  *  *
    *  *  *               * * *
     * * *      * *      * *** *
    * *** *   *  *  *     * * *
     * * *     * * *     *  *  *
    *  *  *   * *** *      * *
      * *      * * *
              *  *  *
                * *




',
#234567890123456789012345678901234567890 - icon 20
'




              ****
           ****  ****
        ****        **
       **            **
      **              **
     **                ** ***
     *                  *** **
  ****                   *   **
 **                           *
**                            **
*                              ***
*                                **
*                                 *
**                               **
 ***                            **
   ******************************
        *  *  *     * * *
         * * *     *  *  *
        * *** *      * *    * *
   * *   * * *            *  *  *
 *  *  **  *  *            * * *
  * * *   * *   * *       * *** *
 * *** *      *  *  *      * * *
  * * *        * * *      *  *  *
 *  *  *      * *** *       * *
   * *         * * *
              *  *  *
                * *
',
#234567890123456789012345678901234567890 - icon 21
'
                  *       *        *
                   *      *       *
                   *      *       *
                    *     *      *
                                *
              ****     *******
           ****  **** *********
        ****        ************     **
       **            ************  **
      **              ***********
     **                **********
     *                  *** *****
  ****                   *   ****
 **                           *** *
**                            ***  **
*                              ***   **
*                                **
*                                 *
**                               **
 ***                            **
   ******************************

                           * *
      * *                *  *  *
    *  *  *               * * *
     * * *      * *      * *** *
    * *** *   *  *  *     * * *
     * * *     * * *     *  *  *
    *  *  *   * *** *      * *
      * *      * * *
              *  *  *
                * *   
',
#234567890123456789012345678901234567890 - icon 22
'

              ****
           ****  ****
        ****        **
       **            **
      **              **
     **                ** ***
     *                  *** **
  ****                   *   **
 **                           *
**                            **
*                              ***
*                                **
*                                 *
**                               **
 ***                            **
   ******************************
  * *** *         *  *  *   * * *
   * * *           * * *   *  *  *
  *  *  *         * *** *    * *
    * *  *  *  *   * * *
          * * *   *  *  *
         * *** *    * *     * *
   * *    * * *           *  *  *
 *  *  * *  *  *           * * *
  * * *    * *  * *       * *** *
 * *** *      *  *  *      * * *
  * * *        * * *      *  *  *
 *  *  *      * *** *       * *
   * *         * * *
              *  *  *
                * *
',
#234567890123456789012345678901234567890 - icon 23
'

              ****
           ****  ****
        ****        **
       **            **
      **              **
     **                ** ***
     *                  *** **
  ****                   *   **
 **                           *
**                            **
*                              ***
*                                **
*                                 *
**                               **
 ***                            **
   ******************************
   * *** *    *    *  *  *       
    * * *     *     * * *     *        
   *  *  *   *     * *** *   *         
     * *     *      * * *    *      
  *         *      *  *  *  *    
 *          *        * *    *
    * *                   
  *  *  *    *             
   * * *    *    * *       
  * *** *   *  *  *  *   *
   * * *   *    * * *    *
  *  *  *  *   * *** *  *    
 *  * *   *     * * *   *     
*         *    *  *  * *      
*                * *   *     
',
#234567890123456789012345678901234567890 - icon 24
'

              ****
           ****  ****
        ****        **
       **            **
      **              **
     **                ** ***
     *                  *** **
  ****                   *   **
 **                           *
**                            **
*                              ***
*                                **
*                                 *
**                               **
 ***                            **
   ******************************
      *                 *  *         
      *  *  *  *  *          *          
  *  *   *   * * *     *  * *  *
 *   *  *   * *** *         *  *    
 *      *    * * *   *  *  *  *
*      *    *  *  *        *    
*  *   *      * *   *  *  *  
   *  *                      *
  *       * *      *  *     *
  *   * *  *  *         *   * 
 *    *  * * *   *  *  *   *  
 *   *  * *** *        *   *  
*    *   * * *  *  *  *   *
    *   *  *  *       *     
    *     * *  *  *  *       
',
#234567890123456789012345678901234567890 - icon 25
'





              ****
           ****  ****
        ****        **
       **            **
      **              **
     **                ** ***
     *                  *** **
  ****                   *   **
 **                           *
**                            **
*                              ***
*                                **
*                                 *
**                               **
 ***                            **
   ******************************
       *    *    *    *    *         
                             
       *    *    *    *    * 
                           
     *    *    *    *    *  
                           
     *    *    *    *    *  
                           
    *         *        *   
                                             
                      
',
#234567890123456789012345678901234567890 - icon 26
'




              ****
           ****  ****
        ****        **
       **            **
      **              **
     **                ** ***
     *                  *** **
  ****                   *   **
 **                           *
**                            **
*                              ***
*                                **
*                                 *
**                               **
 ***                            **
   ******************************
     *     *     *     *     *         
        *     *     *     *      
     *     *     *     *     * 
        *     *     *     *    
     *     *     *     *     *  
        *     *     *     *   
     *     *     *     *     *  
        *     *     *     *   
     *     *     *     *     *   
        *     *     *     *    
                       
                      
',
#234567890123456789012345678901234567890 - icon 27
'





              ****
           ****  ****
        ****        **
       **            **
      **              **
     **                ** ***
     *                  *** **
  ****                   *   **
 **                           *
**                            **
*                              ***
*                                **
*                                 *
**                               **
 ***                            **
   ******************************
         *   *  *   *     *   *
     *     *   * *    * *
     * *     * *   *    *  * *
    *    * *  * *  *   *
    * *  *    *   * *  *  * *
   *    *  * *  * *    *    *
   *         *        *    *
  *  *   *  *   *  *  *  * *                    
',
#234567890123456789012345678901234567890 - icon 28
'





              ****
           ****  ****
        ****        **
       **            **
      **              **
     **                ** ***
     *                  *** **
  ****                   *   **
 **                           *
**                            **
*                              ***
*                                **
*                                 *
**                               **
 ***                            **
   ******************************
       *    *    *    *     *
    *  *    *    *    * *   *
    * *    *  * * *  *  *  *
   *  * *  * *  * *  * *   *
   * *  * *  * * *  *  *  *  *
  *  * *  * *  * *  *  *  *  *
  * *  *    *   *  *  *  *  *
 *    *    *    *     *     *
',
#234567890123456789012345678901234567890 - icon 29
'
                  *       *        *
                   *      *       *
                   *      *       *
                    *     *      *
                                *
              ****     *******
           ****  **** *********
        ****        ************     **
       **            ************  **
      **              ***********
     **                **********
     *                  *** *****
  ****                   *   ****
 **                           *** *
**                            ***  **
*                              ***   **
*                                **
*                                 *
**                               **
 ***                            **
   ******************************
       *    *    *    *     *
    *  *    *    *    * *   *
    * *    *  * * *  *  *  *
   *  * *  * *  * *  * *   *
   * *  * *  * * *  *  *  *  *
  *  * *  * *  * *  *  *  *  *
  * *  *    *   *  *  *  *  *
 *    *    *    *     *     *
',
#234567890123456789012345678901234567890 - icon 30 Frigid - Thanks Yannzola
'


    *****                 *
   **   **                *
   *     *            *   *   *
   * *** *            *** * ***
   * *   *         *    *****    *
   * **  *         *     ***     *
   * *   *         *      *      *
   * *** *    ***  *      *      *  ***
   * *   *      ****      *      ****
   * **  *        ***     *      **
   * *   *      *** ***   *   *** ***
   * *** *    ***     *** * ***     ***
   * *   *              *****
   * **  *               ***
   * *   *              *****
   * *** *    ***     *** * ***     ***
   * *   *      *** ***   *   *** ***
   * **  *        ***     *     ***
   * *   *      ****      *      ****
   * *** *    ***  *      *      *  ***
  ** *** **        *      *      *
  * ***** *        *     ***     *
  * ***** *        *    *****    *
  * ***** *           *** * ***
  ** *** **           *   *   *
   **   **                *
    *****                 *
',
#234567890123456789012345678901234567890 - icon 31 HOT - Thanks Yannzola
'

                         *
    *****                *
   **   **               *
   *     *    *          *          *
   * *** *     *         *         *
   * *   *      *        *        *
   * *** *       *               *
   * *** *        *    *****    *
   * *** *           *********
   * *** *          ***********
   * *** *         *************
   * *** *         *************
   * *** *        ***************
   * *** *        ***************
   * *** * ****** *************** ******
   * *** *        ***************
   * *** *        ***************
   * *** *         *************
   * *** *         *************
   * *** *          ***********
   * *** *           *********
  ** *** **       *    *****    *
  * ***** *      *               *
  * ***** *     *        *        *
  * ***** *    *         *         *
  ** *** **   *          *          *
   **   **               *
    *****                *
                         *
',
#234567890123456789012345678901234567890 - icon 32 Dust - Thanks Yannzola
'

                 *******
                **     **
               **  *    *
               *        **
          ****** *  *    *
         **            * *
        **         *     *****
        *    *   *   *       **
        *  *             *    **
    *****                   *  *
   **        *   ******  *     *
  **   *  *     **    **       *
  *            **      **      *
  *       *  * *   *    *  *****
  *  *  *      *        ****   **
  *         ****    *           **
  **   *   **     *    *  *   *  *
   ***    **  *             *    *
     ******           *   *      ****
          *     * *           *     **
          **            *            **
           ***      *     *       *   *
             ******          *        *
                  *    *        *    **
                  *  *     ****    ***
                  **   *  **  ******
                   **    **
                    ******
',
#234567890123456789012345678901234567890 - icon 33 Fog - Thanks Yannzola
'
   ***********************************



   ***********************************



   ***********************************
                *********
               ***********

   ***********************************
             ***************
             ***************

   ***********************************
             ***************
   ***********************************

   ***********************************
                *********
   ***********************************

   ***********************************

   ***********************************

   ***********************************

   ***********************************
');

my $TWClogo = '
       ************************
       ************************
       ************************
       ************************
       ************************
       ************************
       *    *******************
       ** *  *** **************
       ** * * *   *************
       ** * * * ***************
       ** * * **  *************
       ************************
       * * * ****** ** ********
       * * * * *  *  *  ** *  *
       * * *    **  ** *     **
       ** * * **    ** *  ** **
       ** * **       * * *   **
       ************************
       **   **************** **
       * **  *  *   *   * ** **
       * ** * **  * * *    * **
       * ** *     * * *  *** **
       **   *     * * * *  ** *
       ************************



            * *
* * * * ** *****   *  **   **  * ** *
* * ****  * * * * *** *   *   * ** * *
** ***  *** * * * *   *   *   * ** * *
 * *  ***** *** *  ** * ** **  * * * *
';

our %mapping = ('arrow_up' => 'up',
                    'arrow_right' => 'right',
                    'arrow_left' => 'left',
                    'knob_right' => 'up',
                    'knob_left' => 'down',
                    'knob_right.repeat' => 'up',
                    'knob_left.repeat' => 'down',
                    'add.single' => 'refresh',
                    'arrow_down' => 'down',
                    'arrow_down.hold' => 'down.hold',
                    'fwd' => 'wnext',
                    'rew' => 'wprev',
                    'knob' => 'done',
                    'size.hold'  => 'size.hold');

##################################################
### Super Functions ###
##################################################
sub initPlugin {
    my $class = shift;
    $class->SUPER::initPlugin();
    
    $log->info("Initializing $VERSION.");

    Plugins::SuperDateTime::Settings->new;
    Plugins::SuperDateTime::PlayerSettings->new;

    Slim::Buttons::Common::addSaver('SCREENSAVER.superdatetime', 
                                     getScreensaverSuperDatetime(), 
                                     \&setScreensaverSuperDateTimeMode,
                                     \&leaveScreensaverSuperDateTimeMode,
                                     getDisplayName()
                                   );

    Slim::Hardware::IR::addModeDefaultMapping('SCREENSAVER.superdatetime',\%mapping);
    Slim::Hardware::IR::addModeDefaultMapping('OFF.superdatetime',\%mapping);

# Get previous settings or set default
    if ($prefs->get('city') !~ /.+\:\d\:\D\D/) { # Check for proper weather.com citycode format
        $log->error("Check your Weather.com Identifier. Your entry = " . $prefs->get('city'));
        $prefs->set('city','60614:4:US'); #Default to Chicago... cuz Chicago is where it's at! 
        $log->error("Defaulting identifier to Chicago: " . $prefs->get('city'));
    }
    &getLatLong; # Retrieve Latitude and Longitude for weather.com location

    if ($prefs->get('stock1format') eq '') {
        $prefs->set('stock1format','%n');
    }

    if ($prefs->get('stock2format') eq '') {
        $prefs->set('stock2format','%l %c %z %v');
    }

    if ($prefs->get('lang') eq '') {
        $prefs->set('lang', 'en-US');
    }

    if ($prefs->get('refresh') eq '') {
        $prefs->set('refresh','5');
    }

    if ($prefs->get('time') eq '') {
        $prefs->set('time', $showtime);
    }

    if ($prefs->get('score') eq '') {
        $prefs->set('score', $showgame);
    }

    if ($prefs->get('atime') eq '') {
        $prefs->set('atime', $showactivetime);
    }

    if ($prefs->get('ascore') eq '') {
        $prefs->set('ascore', $showactivegame);
    }

    if ($prefs->get('offset') eq '') {
        $prefs->set('offset', '00');
    }

    if ($prefs->get('temperature') eq '') {
        $prefs->set('temperature', 0);
    }

    if ($prefs->get('windunit') eq '') {
        $prefs->set('windunit', 0);
    }

    if ($prefs->get('teamlogos') eq '') {
        $prefs->set('teamlogos', 2);
    }

    if ($prefs->get('lweather') eq '') {
        $prefs->set('lweather', 1);
    }

    if ($prefs->get('drawEachDelay') eq '') {
        $prefs->set('drawEachDelay', .5);
    }
    
    if ($prefs->get('cbballconf') eq '') {
        $prefs->set('cbballconf', 0);
    }

    if ($prefs->get('cfballconf') eq '') {  
        $prefs->set('cfballconf', 0);
    }

    if ($prefs->get('errorCountMax') eq '') {   
        $prefs->set('errorCountMax', 10);
    }

    $showtime = $prefs->get('time');
    $showactivetime = $prefs->get('atime');

    $showgame = $prefs->get('score');
    $showactivegame = $prefs->get('ascore');
    
    @MLBteams = @{ $prefs->get('mlb') || [] };
    if (scalar(@MLBteams) == 0) {
        $prefs->set('mlb', \@MLBteams);
    }

    @NBAteams = @{ $prefs->get('nba') || [] };
    if (scalar(@NBAteams) == 0) {
        $prefs->set('nba', \@NBAteams);
    }

    @NHLteams = @{ $prefs->get('nhl') || [] };
    if (scalar(@NHLteams) == 0) {
        $prefs->set('nhl', \@NHLteams);
    }

    @NFLteams = @{ $prefs->get('nfl') || [] };
    if (scalar(@NFLteams) == 0) {
        $prefs->set('nfl', \@NFLteams);
    }

    @CBBteams = @{ $prefs->get('cbb') || [] };
    if (scalar(@CBBteams) == 0) {
        $prefs->set('cbb', \@CBBteams);
    }

    @CFBteams = @{ $prefs->get('cfb') || []};
    if (scalar(@CFBteams) == 0) {
        $prefs->set('cfb', \@CFBteams);
    }
    
    #        |requires Client
    #        |  |is a Query
    #        |  |  |has Tags
    #        |  |  |  |Function to call
    #        C  Q  T  F
    Slim::Control::Request::addDispatch(['SuperDateTime', '_mode'],
              [1, 1, 1, \&cliQuery]);

    $funcptr = Slim::Control::Request::addDispatch(['sdtMacroString'],
              [1, 1, 1, \&macroString]);

    Slim::Control::Request::addDispatch(['sdtVersion'],
              [1, 1, 1, \&sdtVersion]);
    
    #Experimental
    Slim::Control::Request::addDispatch(['SuperDateTimeState', 'dataRefreshState'],[0, 1, 0, undef]);
    
    Slim::Control::Request::addDispatch(['sdtTop'],[1, 1, 0, \&sdtTop]);
    Slim::Control::Request::addDispatch(['sdtCurrent'],[1, 1, 0, \&sdtCurrent]);
    Slim::Control::Request::addDispatch(['sdtForecast'],[1, 1, 0, \&sdtForecast]);
    Slim::Control::Request::addDispatch(['sdtForecastDetail','_forecastNum'],[1, 1, 0, \&sdtForecastDetail]);
    Slim::Control::Request::addDispatch(['sdt10day'],[1, 1, 0, \&sdt10day]);
    Slim::Control::Request::addDispatch(['sdtScores'],[1, 1, 0, \&sdtScores]);
    Slim::Control::Request::addDispatch(['sdtStocks'],[1, 1, 0, \&sdtStocks]);
    Slim::Control::Request::addDispatch(['sdtStockDetail','_ticker'],[1, 1, 0, \&sdtStockDetail]);
    Slim::Control::Request::addDispatch(['sdtGameList','_sport'],[1, 1, 0, \&sdtGameList]);
    
    my @menu = ({
        text   => 'SuperDateTime',
        'icon-id' => 'plugins/SuperDateTime/html/images/32.png',
        id     => 'pluginSuperDateTime',
        weight => 15,
        actions => {
                go => {
                    player => 0,
                    cmd  => [ 'sdtTop' ],
                }
        },
    });

    Slim::Utils::Timers::setTimer(undef, Time::HiRes::time() + 75, \&duetCheck);
    
    Slim::Control::Jive::registerPluginMenu(\@menu, 'extras');

}

sub sdtTop {
    my $request = shift;
    my $client = $request->client();
    my @menu = ();

    duetCheck(); #If we're in here there must be a duet-like device connected...

    push @menu, {
        text => 'Current Conditions',
        window => { menuStyle => 'album' },
        actions  => {
          go  => {
              player => 0,
              cmd    => [ 'sdtCurrent' ],
              params => {
                menu => 'sdtCurrent',
              },
          },
        },
    };
    
    push @menu, {
        text => 'Forecast',
        window => { menuStyle => 'album' },
        actions  => {
          go  => {
              player => 0,
              cmd    => [ 'sdtForecast' ],
              params => {
                menu => 'stdForecast',
              },
          },
        },
    };
    
    push @menu, {
        text => '15-Day Forecast',
        window => { menuStyle => 'album' },
        actions  => {
          go  => {
              player => 0,
              cmd    => [ 'sdt10day' ],
              params => {
                menu => 'sdt10day',
              },
          },
        },
    };  
    
    push @menu, {
        text => 'Scores',
        window => { menuStyle => 'album' },
        actions  => {
          go  => {
              player => 0,
              cmd    => [ 'sdtScores' ],
              params => {
                menu => 'sdtScores',
              },
          },
        },
    };
    
    push @menu, {
        text => 'Stocks',
        #window => { menuStyle => 'album' },
        actions  => {
          go  => {
              player => 0,
              cmd    => [ 'sdtStocks' ],
              params => {
                menu => 'sdtStocks',
              },
          },
        },
    };
    
    my $numitems = scalar(@menu);
    
    $request->addResult("count", $numitems);
    $request->addResult("offset", 0);
    my $cnt = 0;
    for my $eachPreset (@menu[0..$#menu]) {
        $request->setResultLoopHash('item_loop', $cnt, $eachPreset);
        $cnt++;
    }
    
    $request->setStatusDone();
}

sub duetCheck {
    #Look for any players that don't have a screen.  This implies they probably have a Duet that they want to utilize the plugin with
    #Duets are always active, so update plugin accordingly
    my @players = Slim::Player::Client::clients();
    if ($activeClients == 0) {
        $log->info("No active SDT clients so checking for duet only configuration.");
        for my $player (@players) {
            if ($player->display->isa('Slim::Display::NoDisplay')) {
                    $activeClients++;
                    Slim::Utils::Timers::killTimers(undef, \&refreshData); #Paranoia check
                    Slim::Utils::Timers::setTimer(undef, Time::HiRes::time() + 5, \&refreshData, $player, -1);
                    $log->info("Non-display player found, configuring SDT to always refresh data.");
            }
        }
    }
}

sub sdt10day {
    my $request = shift;
    my $client = $request->client();
    
    my @menu = ();
    my $i=1;
    $log->debug('sdt10day Count: ' . $dayCount);
    my $ForC;
    if ($prefs->get('temperature') == 1) {  #Cel
        $ForC = 'C';
    }
    else {
        $ForC = 'F';
    }
    
    while ($i <= $dayCount) { 
        push @menu, {
            'icon-id' => 'plugins/SuperDateTime/html/images/'.$wetData{'d'.$i}{'forecastIcon'}.'.png',
            text => $wetData{'d'.$i}{'day'}.' '.$wetData{'d'.$i}{'date'}.
                $wetData{'d'.$i}{'condition'}.' '.$wetData{'d'.$i}{'high'.$ForC} . '°/' .$wetData{'d'.$i}{'low'.$ForC} . '° Precip. ' . $wetData{'d'.$i}{'precip'}.'%',
        };

        $i++;
    }
    
    my $numitems = scalar(@menu);
    
    $request->addResult("base", {window => { titleStyle => 'album' }}); 
    $request->addResult("count", $numitems);
    $request->addResult("offset", 0);
    my $cnt = 0;
    for my $eachPreset (@menu[0..$#menu]) {
        $request->setResultLoopHash('item_loop', $cnt, $eachPreset);
        $cnt++;
    }
    
    $request->setStatusDone();
}

sub sdtStocks {
    my $request = shift;
    my $client = $request->client();
    
    my @stocks = split (' ',$prefs->get('stocks'));
    my $loopctr = 0;
    
    my @menu = ();

    while ($loopctr < $stockCount) {
        push @menu, {
            text => $miscData{'stocks'}{$stocks[$loopctr]}{'ticker'}. ' - '.
                        $miscData{'stocks'}{$stocks[$loopctr]}{'lasttrade'}. ' ('.$miscData{'stocks'}{$stocks[$loopctr]}{'change'}. ')',
         actions  => {
           go  => {
               player => 0,
               cmd    => [ 'sdtStockDetail', $stocks[$loopctr] ],
               params => {
                menu => 'nowhere',
               },
           },
         },
        };
        $loopctr ++;
    }
    
    my $numitems = scalar(@menu);
    
    $request->addResult("count", $numitems);
    $request->addResult("offset", 0);
    my $cnt = 0;
    for my $eachPreset (@menu[0..$#menu]) {
        $request->setResultLoopHash('item_loop', $cnt, $eachPreset);
        $cnt++;
    }
    
    $request->setStatusDone();
}

sub sdtStockDetail {
    my $request = shift;
    my $client = $request->client();
    my $ticker = $request->getParam('_ticker');

    my @menu = ();
    
    push @menu, {
        text => $miscData{'stocks'}{$ticker}{'name'}
        ,
    };

    push @menu, {
        text =>     'Prev Close: '.$miscData{'stocks'}{$ticker}{'prevclose'}
        ,
    };

    push @menu, {
        text =>     'Open: '.$miscData{'stocks'}{$ticker}{'open'}
        ,
    };

    push @menu, {
        text =>     'Last: '.$miscData{'stocks'}{$ticker}{'lasttrade'} . ' ('.$miscData{'stocks'}{$ticker}{'change'}.')'
        ,
    };

    push @menu, {
        text => 'Range: '.$miscData{'stocks'}{$ticker}{'low'}. ' - '.$miscData{'stocks'}{$ticker}{'high'}
        ,
    };

    push @menu, {
        text =>     'Volume: '.$miscData{'stocks'}{$ticker}{'volume'}
        ,
    };

    push @menu, {
        text =>     $miscData{'stocks'}{$ticker}{'lasttime'}.' '.$miscData{'stocks'}{$ticker}{'lastdate'}
        ,
    };

    my $numitems = scalar(@menu);

    $request->addResult("count", $numitems);
    $request->addResult("offset", 0);
    my $cnt = 0;
    for my $eachItem (@menu[0..$#menu]) {
        $request->setResultLoopHash('item_loop', $cnt, $eachItem);
        $cnt++;
    }
    $request->setStatusDone();
}

sub sdtForecast {
    my $request = shift;
    my $client = $request->client();
    
    my @menu = ();
    my $i = 0;
    my $mxPer = 0;
    
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);

        $mxPer = 4;

    $log->debug("Max periods = " . $mxPer . " at hour # " . $hour);
    
    my $ForC;
    if ($prefs->get('temperature') == 1) {  #Cel
        $ForC = 'C';
    }
    else {
        $ForC = 'F';
    }
        
    while ($i < $mxPer) {   
        push @menu, {
            'icon-id' => 'plugins/SuperDateTime/html/images/'.$wetData{$i}{'forecastIcon'}.'.png',
            text => $wetData{$i}{'forecastTOD'}.": ".$wetData{$i}{'skyCondition'}."\n".
                $wetData{$i}{'forecastType'} .' '. $wetData{$i}{'forecastTemp'.$ForC} . '° Precip. '. $wetData{$i}{'forecastPrec'}.'%',
                actions  => {
                      go  => {
                          player => 0,
                          cmd    => [ 'sdtForecastDetail', $i ],
                          params => {
                          menu => 'nowhere',
                          },
                },
            },
        };
                
        $i++;
    }
        
    my $numitems = scalar(@menu);
    
    $request->addResult("base", {window => { titleStyle => 'album' }}); 
    $request->addResult("count", $numitems);
    $request->addResult("offset", 0);
    my $cnt = 0;
    for my $eachPreset (@menu[0..$#menu]) {
        $request->setResultLoopHash('item_loop', $cnt, $eachPreset);
        $cnt++;
    }
    
    $request->setStatusDone();
}

sub sdtForecastDetail {
    my $request = shift;
    my $client = $request->client();
    my $forecastNum = $request->getParam('_forecastNum');
    my @menu = ();

    push @menu, {
        text => $WETdisplayItems2[$forecastNum],
    };

    my $numitems = scalar(@menu);

    $request->addResult("count", $numitems);
    $request->addResult("offset", 0);
    my $cnt = 0;
    for my $eachItem (@menu[0..$#menu]) {
        $request->setResultLoopHash('item_loop', $cnt, $eachItem);
        $cnt++;
    }
    $request->setStatusDone();
}

sub sdtCurrent {
    my $request = shift;
    my $client = $request->client();
    
    my @menu = ();

    my $ForC = '';
    if ($prefs->get('temperature') == 1) {  #Cel
        $ForC = 'C';
    }
    else {
        $ForC = 'F';
    }
    
    my $WindUnit = '';
    if ($prefs->get('windunit') == 0) {  #mi/hr
        $WindUnit = 'mh';
    }
    elsif ($prefs->get('windunit') == 1) {  #km/hr
        $WindUnit = 'kh';
    }
    elsif ($prefs->get('windunit') == 2) {  #kt/hr
        $WindUnit = 'kth';
    }
    else {  #m/s
        $WindUnit = 'ms';
    }
    
    push @menu, {
        'icon-id' => 'plugins/SuperDateTime/html/images/'.$wetData{-1}{'forecastIcon'}.'.png',
              text => $wetData{-1}{'skyCondition'}.' '.$wetData{'temperature'.$ForC}.'° ('.$wetData{'feelslike'.$ForC}.'°) '. $wetData{'windspeed_'.$WindUnit}."\n".
                      $wetData{-1}{'forecastType'}.' '. $wetData{-1}{'forecastTemp'.$ForC}.'° Precip. '.$wetData{-1}{'forecastPrec'}.'%',
         actions  => {
           go  => {
               player => 0,
               cmd    => [ 'sdtForecastDetail', 0 ],
               params => {
                menu => 'nowhere',
               },
           },
         },
    };
    push @menu, {
        'icon-id' => 'plugins/SuperDateTime/html/images/blank.png',
              text => 'Pressure: '.$wetData{'pressureIN'}.' '.$wetData{'pressureT'}."\n".
                      'Humidity: '.$wetData{'humidity'}.'° Dewpoint: '.$wetData{'dewpointF'}.'°',
    };
    push @menu, {
        'icon-id' => 'plugins/SuperDateTime/html/images/blank.png',
              text => "24 Hour Precipitation"."\n".
                        "Rain: ".$wetData{'rain'}."\"   ".
                        "Snow: ".$wetData{'snow'}."\""."\n",
    };
        
    my $numitems = scalar(@menu);
    
    $request->addResult("base", {window => { titleStyle => 'album' }}); 
    $request->addResult("count", $numitems);
    $request->addResult("offset", 0);
    my $cnt = 0;
    for my $eachItem (@menu[0..$#menu]) {
        $request->setResultLoopHash('item_loop', $cnt, $eachItem);
        $cnt++;
    }
    
    $request->setStatusDone();
}

sub sdtScores {
    my $request = shift;
    my $client = $request->client();
    
    my @menu = ();
    for my $key ( sort keys %sportsData ) {
        my $icon;
            
        $icon = $sportsData{$key}{'logoURL'};
        if (not defined $icon) {
            $icon = 'plugins/SuperDateTime/html/images/blank.png';
        }
        
        push @menu, {
                'icon-id' => $icon,
                text => $key,
                window => { menuStyle => 'album' },
                actions  => {
                           go  => {
    #7.3 menustyle=multiline to remove icons entirely
                                player => 0,
                                cmd => [ 'sdtGameList', $key ],
                                params => {
                                menu => 'nowhere',
                               },
                           },
         },
        }
        
    }   
    
    my $numitems = scalar(@menu);
    
    $request->addResult("base", {window => { titleStyle => 'album' }}); 
    $request->addResult("count", $numitems);
    $request->addResult("offset", 0);

    my $cnt = 0;
    for my $eachItem (@menu[0..$#menu]) {
        $request->setResultLoopHash('item_loop', $cnt, $eachItem);
        $cnt++;
    }
    
    $request->setStatusDone();
}

sub sdtGameList {
    my $request = shift;
    my $client = $request->client();
    my $sport = $request->getParam('_sport');

    my @menu = ();
    my $hashRef = \%sportsData;
    
    for my $key (sort keys %{$hashRef->{$sport}} ) {
        if ($key ne 'logoURL') {
            my $logo = 'plugins/SuperDateTime/html/images/blank.png';
            if (defined $sportsData{$sport}{$key}{'gameLogoURL'}) {
                $logo = $sportsData{$sport}{$key}{'gameLogoURL'};
            }
        
            push @menu, {
                'icon-id' => $logo,
#               text => "$sportsData{$sport}{$key}{'awayTeam'} $sportsData{$sport}{$key}{'awayScore'} \n $sportsData{$sport}{$key}{'homeTeam'} $sportsData{$sport}{$key}{'homeScore'} \n $sportsData{$sport}{$key}{'gameTime'}",
                text => $sportsData{$sport}{$key}{'awayTeam'}.' '.$sportsData{$sport}{$key}{'awayScore'}."\n".$sportsData{$sport}{$key}{'homeTeam'}.' '.$sportsData{$sport}{$key}{'homeScore'}.' ('.$sportsData{$sport}{$key}{'gameTime'}.')',
            };
        }
    }   

    my $numitems = scalar(@menu);

    $request->addResult("count", $numitems);
    $request->addResult("offset", 0);
    my $cnt = 0;
    for my $eachItem (@menu[0..$#menu]) {
        $request->setResultLoopHash('item_loop', $cnt, $eachItem);
        $cnt++;
    }
    $request->setStatusDone();
}

sub FtoC {
    my $temp = shift;

    $temp = ($temp-32)*5/9;
    $temp = int($temp + .5 * ($temp <=> 0)); #Funky round   
    
    return $temp;
}

sub CtoF {
    my $temp = shift;

    $temp = ($temp*9/5)+32;
    $temp = int($temp + .5 * ($temp <=> 0)); #Funky round   
    
    return $temp;
}

sub getLatLong {  #Set up Async HTTP request to retrieve Latitude and Longitude
    my $timerObj = shift; #Should be undef
    my $client = shift;
    my $refreshItem = shift;

    my $url = 'https://dsx.weather.com/wxd/v2/loc/en_US/' . $prefs->get('city') . '?apiKey=7bb1c920-7027-4289-9c96-ae5e263980bc&format=json';
    my $http = Slim::Networking::SimpleAsyncHTTP->new(\&gotLatLong,
                              \&gotErrorViaHTTP,
                              {caller => 'getLatLong', callerProc => \&getLatLong,});

                              $log->info("async request: $url");
    
    $http->get($url, 'User-Agent' => 'Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20100101 Firefox/12.0',
    'Accept-Language' => 'en-us,en;q=0.5',
    'Accept' => 'text/html',
    'Accept-Charset' => 'UTF-8');
}

sub gotLatLong {
    my $http = shift;
    
    $log->info("got " . $http->url());

    my $LatLong_json = $http->content();
    my $perldata = decode_json($LatLong_json);

    $lat = $perldata->{'lat'};
    $long = $perldata->{'long'};
    $log->debug("New Latitude: " . $lat);
    $log->debug("New Longitude: " . $long);
}


sub getAverages {  #Set up Async HTTP request for averages
    my ($days_advance, $client, $refreshItem) = @_;

    if ($wetData{0}{'forecastTOD'} ne $averages{'last'}) { #See if the averages need to be refreshed due to a period change    
        my $url = 'http://dsx.weather.com/wxd/v2/FarmingAlmanac/0/(' . $prefs->get('city') . ')?api=7bb1c920-7027-4289-9c96-ae5e263980bc&format=json';

        my $http = Slim::Networking::SimpleAsyncHTTP->new(\&gotAverages,
                                \&gotErrorViaHTTP,
                                {caller => 'getAverages',
                                 dayNum => $days_advance,
                                 client => $client,
                                 refreshItem => $refreshItem});

        $log->info("async request: $url");
        $http->get($url, 'User-Agent' => 'Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20100101 Firefox/12.0',
            'Accept-Language' => 'en-us,en;q=0.5',
            'Accept' => 'text/html',
            'Accept-Charset' => 'UTF-8');
    }
    else {
        $log->info("Skipping averages...");
        refreshData(undef, $client, $refreshItem);
    }
}

sub gotAverages {  #Average data was received
    my $http = shift;
    
    my $params = $http->params();
    my $client = $params->{'client'};
    my $refreshItem = $params->{'refreshItem'};
  
    $log->info("got " . $http->url());

    my $json = $http->content();

    # Convert JSON into a Perl data array
    my $perldata = decode_json($json); 

    # Dereference array and store historical elements - ie. Record Hi/Lo, Avg Hi/Lo Temperature
    my $history = @$perldata[0]->{'doc'}->{'FarmingAlmanacRecordData'}->{'OneDayHistorical'} ;
      
    $averages{0}{'average_high_F'} = $history->{'avgHighF'};
    $averages{0}{'record_high_F'} = $history->{'recordHighF'};
    $averages{0}{'record_high_year'} = $history->{'yearOfRecordHighTemp'};

    $averages{0}{'average_low_F'} = $history->{'avgLowF'};
    $averages{0}{'record_low_F'} = $history->{'recordLowF'};
    $averages{0}{'record_low_year'} = $history->{'yearOfRecordLowTemp'};

    #Set CURRENTLY as high values
    $wetData{-1}{'average_F'} = $averages{0}{'average_high_F'};
    $wetData{-1}{'average_C'} = FtoC($averages{0}{'average_high_F'});
    
    $wetData{-1}{'record_F'} = $averages{0}{'record_high_F'};
    $wetData{-1}{'record_C'} = FtoC($averages{0}{'record_high_F'});
    
    $wetData{-1}{'record_year'} = $averages{0}{'record_high_year'};

    $averages{'last'} = $wetData{0}{'forecastTOD'}; #update last average update indicator
    refreshData(undef, $client, $refreshItem);
}


sub drawEach {
    $log->debug("Start");
    my ($timerObj, $client, $period, $formatLoc) = @_;
        #^Should be undef
    
    my $destLoc = 0;
    
    if (defined $displayInfoBuild{$client}{'TOPdisplayItems1'}) {
        $destLoc = scalar @{$displayInfoBuild{$client}{'TOPdisplayItems1'}};
    }
    
    $log->debug("Drawing scrn $destLoc $client $period");
    
    my @show1icon  = @{ $prefs->client($client)->get('show1icon') || [] };
    my @show13line = @{ $prefs->client($client)->get('show13line') || [] };
    my @d3line1t   = @{ $prefs->client($client)->get('v3line1t') || [] };
    my @d3line1m   = @{ $prefs->client($client)->get('v3line1m') || [] };
    my @d3line1b   = @{ $prefs->client($client)->get('v3line1b') || [] };
    my @d1period   = @{ $prefs->client($client)->get('v1period') || [] };
    my @weatherformat1t = @{ $prefs->client($client)->get('weatherformat1t') || [] };
    my @weatherformat1b = @{ $prefs->client($client)->get('weatherformat1b') || [] };
    my @weatherformat2t = @{ $prefs->client($client)->get('weatherformat2t') || [] };
    my @weatherformat2b = @{ $prefs->client($client)->get('weatherformat2b') || [] };
    
    clearCanvas($client);
    
    #Draw icons
    if ($show1icon[$formatLoc] == 1) {
        drawIcon($client,0,$ymax{$client}-1, $Icons[$Iconmap{$wetData{$period}{'forecastIcon'}}]);      
        $displayInfoBuild{$client}{'hasIcon'}[$destLoc] = 1;
    }
    
    #Draw 3line stuff
    if ($show13line[$formatLoc] == 1) {
        my $line1 = uc(replaceMacrosPer($d3line1t[$formatLoc], $period, $client));
        my $line2 = uc(replaceMacrosPer($d3line1m[$formatLoc], $period, $client));
        my $line3 = uc(replaceMacrosPer($d3line1b[$formatLoc], $period, $client));      
    
        #Shorten HI/HIGH/LOW/Lo to gain screen real estate on Booms
        if($client->display->isa('Slim::Display::Boom')) {
            $line1 =~ s/^ LOW/LO/;
            $line1 =~ s/^HIGH/HI/;
            $line1 =~ s/^RAIN/RN/;
            $line1 =~ s/^PREC/PR/;
            $line2 =~ s/^ LOW/LO/;
            $line2 =~ s/^HIGH/HI/;
            $line2 =~ s/^RAIN/RN/;
            $line2 =~ s/^PREC/PR/;
            $line3 =~ s/^ LOW/LO/;
            $line3 =~ s/^RAIN/RN/;
            $line3 =~ s/^PREC/PR/;
            $line3 =~ s/^HIGH/HI/;
        }
    
        if ($show1icon[$formatLoc] == 1) {
            drawText($client,42,$ymax{$client}-25, $line3);
            drawText($client,42,$ymax{$client}-13, $line2);
            drawText($client,42,$ymax{$client}-1,  $line1);
        }
        else {
            drawText($client,0,$ymax{$client}-25, $line3);
            drawText($client,0,$ymax{$client}-13, $line2);
            drawText($client,0,$ymax{$client}-1,  $line1);
        }

        #Save the character lengths of each line
        $displayInfoBuild{$client}{'CharLen1'}[$destLoc] = length($line1);
        $displayInfoBuild{$client}{'CharLen2'}[$destLoc] = length($line2);
        $displayInfoBuild{$client}{'CharLen3'}[$destLoc] = length($line3);      
    }
    
    #If necessary can make the width calculation based on max length of 3line text
    $displayInfoBuild{$client}{'forecastG'}[$destLoc] = getFramebuf($client,$xmax{$client});
    
    push(@{$displayInfoBuild{$client}{'TOPdisplayItems1'}},  replaceMacrosPer($weatherformat1t[$formatLoc], $period, $client)); 
    push(@{$displayInfoBuild{$client}{'BOTdisplayItems1'}},  replaceMacrosPer($weatherformat1b[$formatLoc], $period, $client));
    push(@{$displayInfoBuild{$client}{'TOPdisplayItems2'}}, replaceMacrosPer($weatherformat2t[$formatLoc], $period, $client));  
    push(@{$displayInfoBuild{$client}{'BOTdisplayItems2'}}, replaceMacrosPer($weatherformat2b[$formatLoc], $period, $client));
    #$log->debug("Pending draw each timers: " . Slim::Utils::Timers::pendingTimers(undef, \&drawEach));
        
    $drawEachPending--;
    
    if ($drawEachPending == 0) {
        doneDrawing($client);
    }
    
    $log->debug("Finish");
}

sub replaceMacros {
    my $string = shift;
    my $client = shift;

    for ($string) {
        #Replace custom macros from other plugins. Do custom before default in case overriding
        for my $key ( keys %macroHash ) {
            $string =~ s/$key/$macroHash{$key}/;
            }       
        
        my $date = $client->longDateF();
        my $sdate = $client->shortDateF();
        s/%2/$date/;
        s/%!2/$sdate/;
        
        s/%t/$wetData{'temperatureF'}°/;
        s/%T/$wetData{'temperatureC'}°/;
        s/%h/$wetData{'humidity'}/;
        s/%p/$wetData{'pressureIN'}$wetData{'pressureT'}/;
        s/%P/$wetData{'pressureMB'}$wetData{'pressureT'}/;
        s/%d/$wetData{'dewpointF'}°/;
        s/%D/$wetData{'dewpointC'}°/;
        s/%f/$wetData{'feelslikeF'}°/;
        s/%F/$wetData{'feelslikeC'}°/;
        s/%w/$wetData{'windspeed_mh'}/;
        s/%W/$wetData{'windspeed_kh'}/;
        s/%q/$wetData{'windspeed_kth'}/;
        s/%Q/$wetData{'windspeed_ms'}/;     
        s/%u/$wetData{'UVindexNum'}/;
        s/%U/$wetData{'UVindexTxt'}/;
        s/%b/$wetData{'rain'}/;
        s/%B/$wetData{'snow'}/;

        #Wunderground
        s/%e/$wetData{'wu_temperatureF'}°/;
        s/%r/$wetData{'wu_temperatureFr'}°/;
        s/%E/$wetData{'wu_temperatureC'}°/;
        s/%R/$wetData{'wu_temperatureCr'}°/;
        s/%H/$wetData{'wu_humidity'}/;
        s/%l/$wetData{'wu_pressureIN'}/;
        s/%L/$wetData{'wu_pressureMB'}/;
        s/%m/$wetData{'wu_dewpointF'}°/;
        s/%M/$wetData{'wu_dewpointC'}°/;
        s/%j/$wetData{'wu_windspeed_mh'}/;
        s/%J/$wetData{'wu_windspeed_kh'}/;
        s/%k/$wetData{'wu_windspeed_kth'}/;
        s/%K/$wetData{'wu_windspeed_ms'}/;      
    }

    return $string;
}

sub replaceMacrosPer {
    my $string  = shift;
    my $location = shift;
    my $client = shift;

    $string = replaceMacros($string, $client);

    for ($string) {
        s/%a/$wetData{$location}{'average_F'}°/;
        s/%A/$wetData{$location}{'average_C'}°/;
        s/%c/$wetData{$location}{'record_F'}°/;
        s/%C/$wetData{$location}{'record_C'}°/;
        s/%g/$wetData{$location}{'record_year'}/;
        s/%s/$wetData{$location}{'sunrise'}/;
        s/%S/$wetData{$location}{'sunset'}/;

        s/%z/$wetData{$location}{'forecastType'} $wetData{$location}{'forecastTempF'}°/;
        s/%Z/$wetData{$location}{'forecastType'} $wetData{$location}{'forecastTempC'}°/;
        s/%!z/$wetData{$location}{'forecastTempF'}/;
        s/%!Z/$wetData{$location}{'forecastTempC'}/;
        s/Low/ Low/;

        s/%x/$wetData{$location}{'forecastPrec'}/;
        
        s/%y/$wetData{$location}{'forecastTOD'}/;
        s/%v/$wetData{$location}{'skyCondition'}/;
        
        #10day stuff
        s/%_3/$wetData{$location}{'day'}/;
        s/%!_3/$wetData{$location}{'shortday'}/;
        s/%_4/$wetData{$location}{'date'}/;
        s/%_5/$wetData{$location}{'highF'}°/;
        s/%_6/$wetData{$location}{'highC'}°/;
        s/%_7/$wetData{$location}{'lowF'}°/;
        s/%_8/$wetData{$location}{'lowC'}°/;
        s/%_9/$wetData{$location}{'precip'}/;
        s/%_0/$wetData{$location}{'condition'}/;
    }       

    return $string;
}

sub getWeatherToday {  #Set up Async HTTP request for Weather
    my $timerObj = shift; #Should be undef
    my $client = shift;
    my $refreshItem = shift;

    my $url = 'https://api.weather.com/v2/turbo/vt1dailyforecast?apiKey=d522aa97197fd864d36b418f39ebb323&format=json&language=' . $prefs->get('lang') . '&units=' . $units . '&geocode=' . $lat . ',' . $long;
    my $http = Slim::Networking::SimpleAsyncHTTP->new(\&gotWeatherToday,
                              \&gotErrorViaHTTP,
                              {caller => 'getWeatherToday',
                               callerProc => \&getWeatherToday,
                               client => $client,
                               refreshItem => $refreshItem});
    $log->info("async request: $url");
    
    $http->get($url, 'User-Agent' => 'Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20100101 Firefox/12.0',
    'Accept-Language' => 'en-us,en;q=0.5',
    'Accept' => 'text/html',
    'Accept-Charset' => 'UTF-8');
}

sub gotWeatherToday {  #Weather data for today was received
    my $http = shift;
    
    my $params = $http->params();
    my $client = $params->{'client'};
    my $refreshItem = $params->{'refreshItem'};

    $log->info("got " . $http->url());
    
    my $json = $http->content();

    my $perldata = decode_json($json); 

    # Store arrays
    my $dates = $perldata->{'vt1dailyforecast'}->{'validDate'} ;
    my $sunrises = $perldata->{'vt1dailyforecast'}->{'sunrise'} ;
    my $sunsets = $perldata->{'vt1dailyforecast'}->{'sunset'} ;
    my $moonIcons = $perldata->{'vt1dailyforecast'}->{'moonIcon'} ;
    my $moonPhrases = $perldata->{'vt1dailyforecast'}->{'moonPhrase'} ;
    my $moonrises = $perldata->{'vt1dailyforecast'}->{'moonrise'} ;
    my $moonsets = $perldata->{'vt1dailyforecast'}->{'moonset'} ;
    my $days = $perldata->{'vt1dailyforecast'}->{'dayOfWeek'} ;

    my $dayParts = $perldata->{'vt1dailyforecast'}->{'day'}->{'dayPartName'} ;
    my $dayPrecip = $perldata->{'vt1dailyforecast'}->{'day'}->{'precipPct'} ;
    my $highs = $perldata->{'vt1dailyforecast'}->{'day'}->{'temperature'} ;
    my $dayIcons = $perldata->{'vt1dailyforecast'}->{'day'}->{'icon'} ;
    my $dayCond = $perldata->{'vt1dailyforecast'}->{'day'}->{'phrase'} ;
    my $dayNarrative = $perldata->{'vt1dailyforecast'}->{'day'}->{'narrative'} ;
    
    my $nightParts = $perldata->{'vt1dailyforecast'}->{'night'}->{'dayPartName'} ;
    my $nightPrecip = $perldata->{'vt1dailyforecast'}->{'night'}->{'precipPct'} ;
    my $lows = $perldata->{'vt1dailyforecast'}->{'night'}->{'temperature'} ;
    my $nightIcons = $perldata->{'vt1dailyforecast'}->{'night'}->{'icon'} ;
    my $nightCond = $perldata->{'vt1dailyforecast'}->{'night'}->{'phrase'} ;
    my $nightNarrative = $perldata->{'vt1dailyforecast'}->{'night'}->{'narrative'} ;
    
    $dayCount = scalar(@$dates); # Variable established at top of plugin so it is available in sdt10day
    my $loopcnt = 0;
    my $dayPart = @$dayParts[0];
    
    $log->debug('# of Dates: ' . scalar(@$dates));

    while ($loopcnt < 4) {
        $log->debug('Date: ' . @$dates[$loopcnt]);
        $log->debug('Sunrise: ' . @$sunrises[$loopcnt]);
        $log->debug('Sunset: ' . @$sunsets[$loopcnt]);
        $log->debug('moon Icon: ' . @$moonIcons[$loopcnt]);
        $log->debug('moon Phrase: ' . @$moonPhrases[$loopcnt]);
        $log->debug('moon rise: ' . @$moonrises[$loopcnt]);
        $log->debug('moon set: ' . @$moonsets[$loopcnt]);
        $log->debug('Day: ' . @$days[$loopcnt]);

        $log->debug('Day part: ' . @$dayParts[$loopcnt]);
        $log->debug('Day precip %: ' . @$dayPrecip[$loopcnt]);
        $log->debug('High: ' . @$highs[$loopcnt]);
        $log->debug('Day Icon: ' . @$dayIcons[$loopcnt]);
        $log->debug('Day Condition: ' . @$dayCond[$loopcnt]);
        $log->debug('Day Narrative: ' . @$dayNarrative[$loopcnt]);

        $log->debug('night part: ' . @$nightParts[$loopcnt]);
        $log->debug('night precip %: ' . @$nightPrecip[$loopcnt]);
        $log->debug('Low: ' . @$lows[$loopcnt]);
        $log->debug('night Icon: ' . @$nightIcons[$loopcnt]);
        $log->debug('night Condition: ' . @$nightCond[$loopcnt]);
        $log->debug('night Narrative: ' . @$nightNarrative[$loopcnt]);
        $log->debug(' ');

#   Period defintions
#   Period  Day                 Night
#   ------  -----------------   --------------
#   -1      Current             Current         
#    0      Today               Tonight         
#    1      Tonight             Tomorrow        
#    2      Tomorrow            Tomorrow Night  
#    3      Tomorrow Night      N/A
        
        if ($loopcnt == 0) { 
            if (defined($dayPart)) {
                $log->debug('dayPart: ' . $dayPart);
                $log->debug('dayPart check Evaluated True' );
                $wetData{-1}{'forecastPrec'} = @$dayPrecip[$loopcnt];
                $wetData{0}{'forecastPrec'} = @$dayPrecip[$loopcnt];
                $wetData{-1}{'forecastType'} = 'High' ; #hi/low
                $wetData{0}{'forecastType'} = 'High' ;
                if ($units eq 'e') {
                    $wetData{-1}{'forecastTempF'} = @$highs[$loopcnt];
                    $wetData{0}{'forecastTempF'} = @$highs[$loopcnt];
                    $wetData{-1}{'forecastTempC'} = FtoC(@$highs[$loopcnt]);
                    $wetData{0}{'forecastTempC'} = FtoC(@$highs[$loopcnt]);
                }
                elsif ($units eq 'm') {
                    $wetData{-1}{'forecastTempF'} = CtoF(@$highs[$loopcnt]);
                    $wetData{0}{'forecastTempF'} = CtoF(@$highs[$loopcnt]);
                    $wetData{-1}{'forecastTempC'} = @$highs[$loopcnt];
                    $wetData{0}{'forecastTempC'} = @$highs[$loopcnt];
                }
                else {
                    $log->info('$units undefined');
                }
                $wetData{0}{'forecastIcon'} = @$dayIcons[$loopcnt];
                $wetData{0}{'skyCondition'} = @$dayCond[$loopcnt];
                $wetData{0}{'forecastIconURLSmall'} = '/plugins/SuperDateTime/html/images/' . @$dayIcons[$loopcnt] . '.png';
                $wetData{0}{'forecastTOD'} = $dayPart ;
                push(@WETdisplayItems1temp, $wetData{0}{'forecastTOD'});
                push(@WETdisplayItems2temp, @$dayNarrative[$loopcnt]);
            }
            else {
                $log->debug('dayPart: ' . $dayPart);
                $log->debug('dayPart check Evaluated False' );
                $wetData{-1}{'forecastPrec'} = @$nightPrecip[$loopcnt];
                $wetData{0}{'forecastPrec'} = @$nightPrecip[$loopcnt];
                $wetData{-1}{'forecastType'} = 'Low' ; #hi/low
                $wetData{0}{'forecastType'} = 'Low' ;
                if ($units eq 'e') {
                    $wetData{-1}{'forecastTempF'} = @$lows[$loopcnt];
                    $wetData{0}{'forecastTempF'} = @$lows[$loopcnt];
                    $wetData{-1}{'forecastTempC'} = FtoC(@$lows[$loopcnt]);
                    $wetData{0}{'forecastTempC'} = FtoC(@$lows[$loopcnt]);
                }
                else {
                    $wetData{-1}{'forecastTempF'} = CtoF(@$lows[$loopcnt]);
                    $wetData{0}{'forecastTempF'} = CtoF(@$lows[$loopcnt]);
                    $wetData{-1}{'forecastTempC'} = @$lows[$loopcnt];
                    $wetData{0}{'forecastTempC'} = @$lows[$loopcnt];
                }
                $wetData{0}{'forecastIcon'} = @$nightIcons[$loopcnt];
                $wetData{0}{'skyCondition'} = @$nightCond[$loopcnt];
                $wetData{0}{'forecastIconURLSmall'} = '/plugins/SuperDateTime/html/images/' . @$nightIcons[$loopcnt] . '.png';
                $wetData{0}{'forecastTOD'} = @$nightParts[$loopcnt] ; 
                push(@WETdisplayItems1temp, $wetData{0}{'forecastTOD'});
                push(@WETdisplayItems2temp, @$nightNarrative[$loopcnt]);
            }
        }
        elsif ($loopcnt == 1) {
            if (defined($dayPart)) {
                $wetData{$loopcnt}{'forecastPrec'} = @$nightPrecip[$loopcnt-1];
                $wetData{$loopcnt}{'forecastType'} = 'Low' ;
                if ($units eq 'e') {
                    $wetData{$loopcnt}{'forecastTempF'} = @$lows[$loopcnt-1];
                    $wetData{$loopcnt}{'forecastTempC'} = FtoC(@$lows[$loopcnt-1]);
                }
                else {
                    $wetData{$loopcnt}{'forecastTempF'} = CtoF(@$lows[$loopcnt-1]);
                    $wetData{$loopcnt}{'forecastTempC'} = @$lows[$loopcnt-1];
                }
                $wetData{$loopcnt}{'forecastIcon'} = @$nightIcons[$loopcnt-1];
                $wetData{$loopcnt}{'skyCondition'} = @$nightCond[$loopcnt-1];
                $wetData{$loopcnt}{'forecastIconURLSmall'} = '/plugins/SuperDateTime/html/images/' . @$nightIcons[$loopcnt-1] . '.png';
                $wetData{$loopcnt}{'forecastTOD'} = @$nightParts[$loopcnt-1] ; 
                push(@WETdisplayItems1temp, $wetData{$loopcnt}{'forecastTOD'});
                push(@WETdisplayItems2temp, @$nightNarrative[$loopcnt-1]);
            }
            else {
                $wetData{$loopcnt}{'forecastPrec'} = @$dayPrecip[$loopcnt];
                $wetData{$loopcnt}{'forecastType'} = 'High' ;
                if ($units eq 'e') {
                    $wetData{$loopcnt}{'forecastTempF'} = @$highs[$loopcnt];
                    $wetData{$loopcnt}{'forecastTempC'} = FtoC(@$highs[$loopcnt]);
                }
                else {
                    $wetData{$loopcnt}{'forecastTempF'} = CtoF(@$highs[$loopcnt]);
                    $wetData{$loopcnt}{'forecastTempC'} = @$highs[$loopcnt];
                }
                $wetData{$loopcnt}{'forecastIcon'} = @$dayIcons[$loopcnt];
                $wetData{$loopcnt}{'skyCondition'} = @$dayCond[$loopcnt];
                $wetData{$loopcnt}{'forecastIconURLSmall'} = '/plugins/SuperDateTime/html/images/' . @$dayIcons[$loopcnt] . '.png';
                $wetData{$loopcnt}{'forecastTOD'} = @$dayParts[$loopcnt]; 
                push(@WETdisplayItems1temp, $wetData{$loopcnt}{'forecastTOD'});
                push(@WETdisplayItems2temp, @$dayNarrative[$loopcnt]);
            }
        }
        elsif ($loopcnt == 2) {
            if (defined($dayPart)) {
                $wetData{$loopcnt}{'forecastPrec'} = @$dayPrecip[$loopcnt-1];
                $wetData{$loopcnt}{'forecastType'} = 'High' ;
                if ($units eq 'e') {
                    $wetData{$loopcnt}{'forecastTempF'} = @$highs[$loopcnt-1];
                    $wetData{$loopcnt}{'forecastTempC'} = FtoC(@$highs[$loopcnt-1]);
                }
                else {
                    $wetData{$loopcnt}{'forecastTempF'} = CtoF(@$highs[$loopcnt-1]);
                    $wetData{$loopcnt}{'forecastTempC'} = @$highs[$loopcnt-1];
                }
                $wetData{$loopcnt}{'forecastIcon'} = @$dayIcons[$loopcnt-1];
                $wetData{$loopcnt}{'skyCondition'} = @$dayCond[$loopcnt-1];
                $wetData{$loopcnt}{'forecastIconURLSmall'} = '/plugins/SuperDateTime/html/images/' . @$dayIcons[$loopcnt-1] . '.png';
                $wetData{$loopcnt}{'forecastTOD'} = @$dayParts[$loopcnt-1]; 
                push(@WETdisplayItems1temp, $wetData{$loopcnt}{'forecastTOD'});
                push(@WETdisplayItems2temp, @$dayNarrative[$loopcnt-1]);
            }
            else {
                $wetData{$loopcnt}{'forecastPrec'} = @$nightPrecip[$loopcnt-1];
                $wetData{$loopcnt}{'forecastType'} = 'Low' ;
                if ($units eq 'e') {
                    $wetData{$loopcnt}{'forecastTempF'} = @$lows[$loopcnt-1];
                    $wetData{$loopcnt}{'forecastTempC'} = FtoC(@$lows[$loopcnt-1]);
                }
                else {
                    $wetData{$loopcnt}{'forecastTempF'} = CtoF(@$lows[$loopcnt-1]);
                    $wetData{$loopcnt}{'forecastTempC'} = @$lows[$loopcnt-1];
                }
                $wetData{$loopcnt}{'forecastIcon'} = @$nightIcons[$loopcnt-1];
                $wetData{$loopcnt}{'skyCondition'} = @$nightCond[$loopcnt-1];
                $wetData{$loopcnt}{'forecastIconURLSmall'} = '/plugins/SuperDateTime/html/images/' . @$nightIcons[$loopcnt-1] . '.png';
                $wetData{$loopcnt}{'forecastTOD'} = @$nightParts[$loopcnt-1] ; 
                push(@WETdisplayItems1temp, $wetData{$loopcnt}{'forecastTOD'});
                push(@WETdisplayItems2temp, @$nightNarrative[$loopcnt-1]);
            }
        }
        elsif ($loopcnt == 3) {
            if (defined($dayPart)) {
                $wetData{$loopcnt}{'forecastPrec'} = @$nightPrecip[$loopcnt-2];
                $wetData{$loopcnt}{'forecastType'} = 'Low' ;
                if ($units eq 'e') {
                    $wetData{$loopcnt}{'forecastTempF'} = @$lows[$loopcnt-2];
                    $wetData{$loopcnt}{'forecastTempC'} = FtoC(@$lows[$loopcnt-2]);
                }
                else {
                    $wetData{$loopcnt}{'forecastTempF'} = CtoF(@$lows[$loopcnt-2]);
                    $wetData{$loopcnt}{'forecastTempC'} = @$lows[$loopcnt-2];
                }
                $wetData{$loopcnt}{'forecastIcon'} = @$nightIcons[$loopcnt-2];
                $wetData{$loopcnt}{'skyCondition'} = @$nightCond[$loopcnt-2];
                $wetData{$loopcnt}{'forecastIconURLSmall'} = '/plugins/SuperDateTime/html/images/' . @$nightIcons[$loopcnt-2] . '.png';
                $wetData{$loopcnt}{'forecastTOD'} = @$nightParts[$loopcnt-2] ; 
                push(@WETdisplayItems1temp, $wetData{$loopcnt}{'forecastTOD'});
                push(@WETdisplayItems2temp, @$nightNarrative[$loopcnt-2]);
            }
            else {
                $wetData{$loopcnt}{'forecastPrec'} = @$dayPrecip[$loopcnt-1];
                $wetData{$loopcnt}{'forecastType'} = 'High' ;
                if ($units eq 'e') {
                    $wetData{$loopcnt}{'forecastTempF'} = @$highs[$loopcnt-1];
                    $wetData{$loopcnt}{'forecastTempC'} = FtoC(@$highs[$loopcnt-1]);
                }
                else {
                    $wetData{$loopcnt}{'forecastTempF'} = CtoF(@$highs[$loopcnt-1]);
                    $wetData{$loopcnt}{'forecastTempC'} = @$highs[$loopcnt-1];
                }
                $wetData{$loopcnt}{'forecastIcon'} = @$dayIcons[$loopcnt-1];
                $wetData{$loopcnt}{'skyCondition'} = @$dayCond[$loopcnt-1];
                $wetData{$loopcnt}{'forecastIconURLSmall'} = '/plugins/SuperDateTime/html/images/' . @$dayIcons[$loopcnt-1] . '.png';
                $wetData{$loopcnt}{'forecastTOD'} = @$dayParts[$loopcnt-1]; 
                push(@WETdisplayItems1temp, $wetData{$loopcnt}{'forecastTOD'});
                push(@WETdisplayItems2temp, @$dayNarrative[$loopcnt-1]);
            }
        }
        $loopcnt++
    }
    
    # Sunrise sunset for Today.  Store in both current[-1] and today/tonight[0] periods. 
    my $sunrise = @$sunrises[0];
    my $timepos = index($sunrise, ":");
    $timepos = $timepos-2;
    my $sr = substr($sunrise, $timepos, 5);
    $wetData{-1}{'sunrise'} = $sr;
    $wetData{0}{'sunrise'} = $sr;

    my $sunset = @$sunsets[0];
    my $timepos2 = index($sunset, ":");
    $timepos2 = $timepos2-2;
    my $ss = substr($sunset, $timepos2, 5);
    $wetData{-1}{'sunset'} = $ss;
    $wetData{0}{'sunset'} = $ss;

    # Sunrise sunset for Tomorrow.  Store in both tomorrow and tomorrow night periods. 
    my $sunrise = @$sunrises[1];
    my $timepos = index($sunrise, ":");
    $timepos = $timepos-2;
    my $sr = substr($sunrise, $timepos, 5);
    if (defined($dayPart)) {
        $wetData{2}{'sunrise'} = $sr;
        $wetData{3}{'sunrise'} = $sr;
    }
    else {
        $wetData{1}{'sunrise'} = $sr;
        $wetData{2}{'sunrise'} = $sr;
    }

    my $sunset = @$sunsets[1];
    my $timepos2 = index($sunset, ":");
    $timepos2 = $timepos2-2;
    my $ss = substr($sunset, $timepos2, 5);
    if (defined($dayPart)) {
        $wetData{2}{'sunset'} = $ss;
        $wetData{3}{'sunset'} = $ss;
    }
    else {
        $wetData{1}{'sunset'} = $ss;
        $wetData{2}{'sunset'} = $ss;
    }

#   10 day stuff moved from got10day
    my %mons=("01"=>"Jan","02"=>"Feb","03"=>"Mar","04"=>"Apr","05"=>"May","06"=>"Jun","07"=>"Jul","08"=>"Aug","09"=>"Sep","10"=>"Oct","11"=>"Nov","12"=>"Dec");
    my $dayval = "" ;
    my $dv = "" ;
	my $dayNum = "";
    my $loopctr = 0;

    while ($loopctr < $dayCount) {  # 
		$dayNum = $loopctr + 1;
        $wetData{'d'.$dayNum}{'day'} = @$days[$loopctr];
        $wetData{'d'.$dayNum}{'shortday'} = substr @$days[$loopctr], 0, 3;

        $dayval = @$dates[$loopctr];
        
        if ($dayval=~/([0-9]{4})\-([0-9]{2})\-([0-9]{2}).*/) {
            $dv = "$mons{$2} $3\n";
        }
        $wetData{'d'.$dayNum}{'date'} = $dv;        

        $wetData{'d'.$dayNum}{'forecastIcon'} = @$dayIcons[$loopctr];
        $wetData{'d'.$dayNum}{'forecastIconURLSmall'} = '/plugins/SuperDateTime/html/images/' . @$dayIcons[$loopctr] . '.png';
        $wetData{'d'.$dayNum}{'condition'} = @$dayCond[$loopctr];

        if ($units eq 'e') {
            $wetData{'d'.$dayNum}{'highF'} = @$highs[$loopctr];
            $wetData{'d'.$dayNum}{'highC'} = FtoC(@$highs[$loopctr]);
            $wetData{'d'.$dayNum}{'lowF'} = @$lows[$loopctr];
            $wetData{'d'.$dayNum}{'lowC'} = FtoC(@$lows[$loopctr]);      
        }
        else {
            $wetData{'d'.$dayNum}{'highF'} = CtoF(@$highs[$loopctr]);
            $wetData{'d'.$dayNum}{'highC'} = @$highs[$loopctr];
            $wetData{'d'.$dayNum}{'lowF'} = CtoF(@$lows[$loopctr]);
            $wetData{'d'.$dayNum}{'lowC'} = @$lows[$loopctr];        
        }

        $wetData{'d'.$dayNum}{'precip'} = @$dayPrecip[$loopctr];

        my $sunrise = @$sunrises[$loopctr];
        my $timepos = index($sunrise, ":");
        $timepos = $timepos-2;
        my $sr = substr($sunrise, $timepos, 5);
        $averages{$dayNum}{'sunrise'} = $sr;

        my $sunset = @$sunsets[$loopctr];
        my $timepos2 = index($sunset, ":");
        $timepos2 = $timepos2-2;
        my $ss = substr($sunset, $timepos2, 5);
        $averages{$dayNum}{'sunset'} = $ss;
        
        $log->debug("Date Val for day " . $dayNum . " = " . $wetData{'d'.$dayNum}{'date'});
        $log->debug("Icon # for day " . $dayNum . " = " . $wetData{'d'.$dayNum}{'forecastIcon'});
        $log->debug("Condition for day " . $dayNum . " = " . $wetData{'d'.$dayNum}{'condition'});
        $log->debug("High for day " . $dayNum . " = " . $wetData{'d'.$dayNum}{'highF'});
        $log->debug("Low for day " . $dayNum . " = " . $wetData{'d'.$dayNum}{'forecastIcon'});
        $log->debug("Sunrise for day " . $dayNum . " = " . $averages{$dayNum}{'sunrise'});
        $log->debug("Sunset for day " . $dayNum . " = " . $averages{$dayNum}{'sunset'});
        $log->debug(" ");
        $loopctr++;
    }   
    refreshData(undef, $client, $refreshItem);
}

sub getWeatherNow {  #Set up Async HTTP request for Weather
    my $timerObj = shift; #Should be undef
    my $client = shift;
    my $refreshItem = shift;
    
    if ($prefs->get('temperature') eq 0) { # fahrenheit
        $units = 'e'; 
    }
    else {
        $units = 'm';
    }
    
    my $url = 'https://api.weather.com/v2/turbo/vt1observation?apiKey=d522aa97197fd864d36b418f39ebb323&units=' . $units . '&language=' . $prefs->get('lang') . '&format=json&geocode=' . $lat .',' . $long;
    my $http = Slim::Networking::SimpleAsyncHTTP->new(\&gotWeatherNow,
                              \&gotErrorViaHTTP,
                              {caller => 'getWeatherNow',
                               callerProc => \&getWeatherNow,
                               client => $client,
                               refreshItem => $refreshItem});
    $log->info("async request: $url");
    
    $http->get($url, 'User-Agent' => 'Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20100101 Firefox/12.0',
    'Accept-Language' => 'en-us,en;q=0.5',
    'Accept' => 'text/html',
    'Accept-Charset' => 'UTF-8');
}

sub gotWeatherNow {  #Weather data was received
    my $http = shift;
    
    my $params = $http->params();
    my $client = $params->{'client'};
    my $refreshItem = $params->{'refreshItem'};

    $log->info("got " . $http->url());

    my $json = $http->content();
    my $perldata = decode_json($json); 
    
#   Store current weather observations  
    $wetData{-1}{'forecastTOD'} = 'Currently';
    if ($units eq 'e'){
        $wetData{'temperatureF'} = $perldata->{'vt1observation'}->{'temperature'};
        $wetData{'temperatureC'} = FtoC($perldata->{'vt1observation'}->{'temperature'});
        $wetData{'feelslikeF'} = $perldata->{'vt1observation'}->{'feelsLike'};
        $wetData{'feelslikeC'} = FtoC($perldata->{'vt1observation'}->{'feelsLike'});
        $wetData{'dewpointF'} = $perldata->{'vt1observation'}->{'dewPoint'};
        $wetData{'dewpointC'} = FtoC($perldata->{'vt1observation'}->{'dewPoint'});
    }
    elsif ($units eq 'm') {
        $wetData{'temperatureF'} = CtoF($perldata->{'vt1observation'}->{'temperature'});
        $wetData{'temperatureC'} = $perldata->{'vt1observation'}->{'temperature'};
        $wetData{'feelslikeF'} = CtoF($perldata->{'vt1observation'}->{'feelsLike'});
        $wetData{'feelslikeC'} = $perldata->{'vt1observation'}->{'feelsLike'};
        $wetData{'dewpointF'} = CtoF($perldata->{'vt1observation'}->{'dewPoint'});
        $wetData{'dewpointC'} = $perldata->{'vt1observation'}->{'dewPoint'};
    }
    else {
        $log->error('$units undefined');
    }

    $wetData{-1}{'forecastIcon'} = $perldata->{'vt1observation'}->{'icon'};
    $wetData{-1}{'forecastIconURLSmall'} = '/plugins/SuperDateTime/html/images/' . $perldata->{'vt1observation'}->{'icon'} . '.png';
    $wetData{'windspeed_mh'} = $perldata->{'vt1observation'}->{'windSpeed'};
    $wetData{'windspeed_kh'} = ($perldata->{'vt1observation'}->{'windSpeed'})*1.609344;
    $wetData{'windspeed_kh'} = int($wetData{'windspeed_kh'} + .5 * ($wetData{'windspeed_kh'} <=> 0)); #Funky round
    $wetData{'windspeed_kth'} = ($perldata->{'vt1observation'}->{'windSpeed'})/1.1515;
    $wetData{'windspeed_kth'} = int($wetData{'windspeed_kth'} + .5 * ($wetData{'windspeed_kth'} <=> 0)); #Funky round
    $wetData{'windspeed_ms'} = $perldata->{'vt1observation'}->{'windSpeed'}*16.09344/36;
    $wetData{'windspeed_ms'} = int($wetData{'windspeed_ms'} + .5 * ($wetData{'windspeed_ms'} <=> 0)); #Funky round
    my $WindDir = $perldata->{'vt1observation'}->{'windDirCompass'};
    $wetData{'windspeed_mh'} = $WindDir . $wetData{'windspeed_mh'};
    $wetData{'windspeed_kh'} = $WindDir . $wetData{'windspeed_kh'};
    $wetData{'windspeed_ms'} = $WindDir . $wetData{'windspeed_ms'};
    $wetData{'windspeed_kth'} = $WindDir . $wetData{'windspeed_kth'};
    $wetData{-1}{'skyCondition'} = $perldata->{'vt1observation'}->{'phrase'};
    $wetData{'humidity'} = $perldata->{'vt1observation'}->{'humidity'};
    $wetData{'pressureIN'} = $perldata->{'vt1observation'}->{'altimeter'};
    $wetData{'pressureMB'} = ($perldata->{'vt1observation'}->{'altimeter'})*33.8639;
    $wetData{'pressureMB'} = int($wetData{'pressureMB'} + .5 * ($wetData{'pressureMB'} <=> 0)); #Funky round    
#   Baro Trend ### 0=steady, 1=rising, 2=dropping, 3=rising rapidly
    my $BaroTrend = $perldata->{'vt1observation'}->{'barometerCode'};
    if ($BaroTrend eq '0') {
        $wetData{'pressureT'} = '~'; #~ is not displayed in all player text locations
    }
    elsif ($BaroTrend eq '2') {
        $wetData{'pressureT'} = '-';
    }
    elsif ($BaroTrend eq '1') {
        $wetData{'pressureT'} = '+'; # + is not displayed in all player text locations
    }
    elsif ($BaroTrend eq '3') { # Rising rapidly
        $wetData{'pressureT'} = '++'; 
        $log->warn('BaroTrend Code = 3 Baro Trend Description: ' . $perldata->{'vt1observation'}->{'barometerTrend'});
    }
    else {
        $log->warn('Unknown Barometer Trend Status!!!  Code = ' . $BaroTrend);
        $log->warn('Barometer Trend Description = '.$perldata->{'vt1observation'}->{'barometerTrend'});
    }
    
#   UV index and 24hr precip/snow accumulations 
    $wetData{'UVindexNum'} = $perldata->{'vt1observation'}->{'uvIndex'};
    $wetData{'UVindexTxt'} = $perldata->{'vt1observation'}->{'uvDescription'};
    $wetData{'rain'} = $perldata->{'vt1observation'}->{'precip24Hour'};
    $wetData{'snow'} = $perldata->{'vt1observation'}->{'snowDepth'};
    
#   Debug logs
    $log->debug("Time of Day: " . $wetData{-1}{'forecastTOD'});
    $log->debug("Temperature F: " . $wetData{'temperatureF'});
    $log->debug("Temperature C: " . $wetData{'temperatureC'});
    $log->debug("ICON: " . $wetData{-1}{'forecastIcon'});
    $log->debug("ICON URL: " . $wetData{-1}{'forecastIconURLSmall'});
    $log->debug("Feels Like F: " . $wetData{'feelslikeF'});
    $log->debug("Feels Like C: " . $wetData{'feelslikeC'});
    $log->debug("Wind Speed MPH: " . $wetData{'windspeed_mh'});
    $log->debug("Wind Speed KM/H: " . $wetData{'windspeed_kh'});
    $log->debug("Wind Speed Knots/H: " . $wetData{'windspeed_kth'});
    $log->debug("Wind Speed Meters/S: " . $wetData{'windspeed_ms'});
    $log->debug("Sky Condition: " . $wetData{-1}{'skyCondition'});
    $log->debug("Humidity: " . $wetData{'humidity'});
    $log->debug("Dewpoint F: " . $wetData{'dewpointF'});
    $log->debug("Dewpoint C: " . $wetData{'dewpointC'});
    $log->debug("Barometer IN: " . $wetData{'pressureIN'});
    $log->debug("Barometer MB: " . $wetData{'pressureMB'});
    $log->debug("Trend Raw: " . $BaroTrend);
    $log->debug("Trend: " . $wetData{'pressureT'});
    $log->debug("UV Index: " . $wetData{'UVindexNum'});
    $log->debug("UV Text: " . $wetData{'UVindexTxt'});
    $log->debug("24Hr Rain Total: " . $wetData{'rain'});
    $log->debug("Snow Depth: " . $wetData{'snow'});
    
    refreshData(undef, $client, $refreshItem);
}

sub getWunderground {  #Set up Async HTTP request for Weather
    my $timerObj = shift; #Should be undef
    my $client = shift;
    my $refreshItem = shift;
    
    if ($prefs->get('wunder') ne '') { #Make sure wunderground data is needed  
        my $url = 'http://www.wunderground.com/weatherstation/WXDailyHistory.asp?ID=' . $prefs->get('wunder') . '&format=1';
        my $http = Slim::Networking::SimpleAsyncHTTP->new(\&gotWunderground,
                          \&gotErrorViaHTTP,
                          {caller => 'getWunderground',
                            callerProc => \&getWunderground,
                           client => $client,
                           refreshItem => $refreshItem});
    
        $log->info("async request: $url");
        $http->get($url, 'User-Agent' => 'Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20100101 Firefox/12.0');
    }
    else {
        $log->info("No wunderground.com value set.  Skipping...");
        refreshData(undef, $client, $refreshItem);
    }

}

sub gotWunderground {  #Weather data was received
    my $http = shift;
    
    my $params = $http->params();
    my $client = $params->{'client'};
    my $refreshItem = $params->{'refreshItem'};

    $log->info("got " . $http->url());

    my $content = $http->content();
    my $metric = ($content =~ m/TemperatureC/);
    
    my @ary=split /\n/,$content; #break large string into array

    if($ary[scalar(@ary)-2] =~ /^20\d\d-.*?,(.*?),(.*?),(.*?),(.*?),.*?,(.*?),.*?,(.*?),.*?,(.*?),(.*?),.*,/) {
        if ($metric) {
            $wetData{'wu_temperatureF'} = CtoF($1);
            $wetData{'wu_temperatureFr'} = int($wetData{'wu_temperatureF'} + .5 * ($wetData{'wu_temperatureF'} <=> 0)); #Funky round
            $wetData{'wu_temperatureC'} = $1; 
            $wetData{'wu_temperatureCr'} = int($wetData{'wu_temperatureC'} + .5 * ($wetData{'wu_temperatureC'} <=> 0)); #Funky round
            $wetData{'wu_dewpointF'} = CtoF($2);
            $wetData{'wu_dewpointC'} = $2;
        }
        else {
            $wetData{'wu_temperatureF'} = $1;
            $wetData{'wu_temperatureFr'} = int($wetData{'wu_temperatureF'} + .5 * ($wetData{'wu_temperatureF'} <=> 0)); #Funky round
            $wetData{'wu_temperatureC'} = FtoC($1); 
            $wetData{'wu_temperatureCr'} = int($wetData{'wu_temperatureC'} + .5 * ($wetData{'wu_temperatureC'} <=> 0)); #Funky round
            $wetData{'wu_dewpointF'} = $2;
            $wetData{'wu_dewpointC'} = FtoC($2);    
        }
    
        $wetData{'wu_pressureIN'} = $3;
        $wetData{'wu_pressureMB'} = $3 * 33.8639;
        $wetData{'wu_pressureMB'} = int($wetData{'wu_pressureMB'} + .5 * ($wetData{'wu_pressureMB'} <=> 0)); #Funky round   
        
        if ($5==0) {
            $wetData{'wu_windspeed_mh'}  = 'Calm';
            $wetData{'wu_windspeed_kh'}  = 'Calm';
            $wetData{'wu_windspeed_kth'} = 'Calm';
            $wetData{'wu_windspeed_ms'}  = 'Calm';
        }
        else {
            my $winddir = $4;
            if ($winddir eq 'South') {
                $winddir = 'S';
            }
            elsif ($winddir eq 'North') {
                $winddir = 'N';
            }
            elsif ($winddir eq 'East') {
                $winddir = 'E';
            }
            elsif ($winddir eq 'West') {
                $winddir = 'W';
            }
            
            $wetData{'wu_windspeed_mh'} = $winddir . $5;
            
            $wetData{'wu_windspeed_kh'} = $5*1.609344;
            $wetData{'wu_windspeed_kh'} = $wetData{'wu_windspeed_kh'} . int($wetData{'wu_windspeed_kh'} + .5 * ($wetData{'wu_windspeed_kh'} <=> 0)); #Funky round
            
            $wetData{'wu_windspeed_ms'} = $5*16.09344/36;
            $wetData{'wu_windspeed_ms'} = $wetData{'wu_windspeed_ms'} . int($wetData{'wu_windspeed_ms'} + .5 * ($wetData{'wu_windspeed_ms'} <=> 0)); #Funky round

            $wetData{'wu_windspeed_kth'} = $5/1.1515;
            $wetData{'wu_windspeed_kth'} = $wetData{'wu_windspeed_kth'} . int($wetData{'wu_windspeed_kth'} + .5 * ($wetData{'wu_windspeed_kth'} <=> 0)); #Funky round   
        }
        
        $wetData{'wu_humidity'} = $6 . '%';
    }
    refreshData(undef, $client, $refreshItem);
}

sub getStocks {  #Set up Async HTTP request for Stocks
    my $timerObj = shift; #Should be undef
    my $client = shift;
    my $refreshItem = shift;
    
    my @stocks = split (' ',$prefs->get('stocks'));
    
    if ($refreshTracker[3] == 1) { # setup loop counter on each refresh cycle
        $stockCount = scalar(@stocks);
        $stockCounter = 0;
        $refreshTracker[3] = 0;
    }

    if (@stocks) { # Skip if no stock tickers entered in preferences
        if ($stockCounter < $stockCount) { 
            my $url = 'https://query1.finance.yahoo.com/v10/finance/quoteSummary/' . $stocks[$stockCounter] . '?formatted=true&lang=en-US&region=US&modules=price%2CsummaryDetail&corsDomain=finance.yahoo.com';
            my $http = Slim::Networking::SimpleAsyncHTTP->new(\&gotStocks,
                                  \&gotErrorViaHTTP,
                                  {caller => 'getStocks',
                                   callerProc => \&getStocks,                             
                                   client => $client,
                                   refreshItem => $refreshItem});
            
            $log->info("async request: $url");
            $http->get($url, 'User-Agent' => 'Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20100101 Firefox/12.0');
        }
    }
    else {
        $log->info("No stocks selected... Skipping");
        refreshData(undef, $client, $refreshItem);
    }
}

sub gotStocks {  #Stock data was received
    my $http = shift;
    
    my $params = $http->params();
    my $client = $params->{'client'};
    my $refreshItem = $params->{'refreshItem'};
    
    $log->info("got " . $http->url());

    if ($stockCounter eq 0) {
        delete $miscData{'stocks'}; #Wipe out old stock values on first pass through on each refresh
    }
    my $Stock_json = $http->content();
    my $perldata = decode_json($Stock_json);


    my $ticker_array = $perldata->{'quoteSummary'}->{'result'}; # store array from JSON file
    my $ticker_detail = @$ticker_array[0]->{'price'}; # de-reference array
    
    my $ticker = $ticker_detail->{'symbol'}; 
    $miscData{'stocks'}{$ticker}{'ticker'} = $ticker;

    my $lasttrade = $ticker_detail->{'regularMarketPrice'}->{'fmt'};
    $miscData{'stocks'}{$ticker}{'lasttrade'} = $lasttrade;

    my $rawdate = $ticker_detail->{'regularMarketTime'};
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = gmtime($rawdate);
    $mon = sprintf('%02d',$mon + 1);
    $mday = sprintf('%02d',$mday);
    $year = $year + 1900;
    $hour = sprintf('%02d',$hour-5);
    $min = sprintf('%02d',$min);
    
    my $lastdate = $mon.'/'.$mday.'/'.$year;
    $miscData{'stocks'}{$ticker}{'lastdate'} = $lastdate;

    my $lasttime    = $hour.':'.$min;
    $miscData{'stocks'}{$ticker}{'lasttime'} = $lasttime;

    my $change      = $ticker_detail->{'regularMarketChange'}->{'fmt'};
    $miscData{'stocks'}{$ticker}{'change'} = $change;

    my $open        = $ticker_detail->{'regularMarketOpen'}->{'fmt'};
    $miscData{'stocks'}{$ticker}{'open'} = $open;

    my $high        = $ticker_detail->{'regularMarketDayHigh'}->{'fmt'};
    $miscData{'stocks'}{$ticker}{'high'} = $high;

    my $low         = $ticker_detail->{'regularMarketDayLow'}->{'fmt'};
    $miscData{'stocks'}{$ticker}{'low'} = $low;

    my $prev        = $ticker_detail->{'regularMarketPreviousClose'}->{'fmt'};
    $miscData{'stocks'}{$ticker}{'prevclose'} = $prev;

    my $pchange     = $ticker_detail->{'regularMarketChangePercent'}->{'fmt'};
    $miscData{'stocks'}{$ticker}{'pchange'} = $pchange;

    my $volume      = $ticker_detail->{'regularMarketVolume'}->{'fmt'};
    $miscData{'stocks'}{$ticker}{'volume'} = $volume;

    my $name        = $ticker_detail->{'shortName'};
    if ($ticker =~/\.L/) { # Long name is more suitable for stocks on the London exchange
        $name   = $ticker_detail->{'longName'};
    }
    $miscData{'stocks'}{$ticker}{'name'} = $name;

    $log->debug("ticker: " . $ticker);
    $log->debug("lasttrade: " . $lasttrade);
    $log->debug("lastdate: " . $lastdate);
    $log->debug("lasttime: " . $lasttime);
    $log->debug("change: " . $change);
    $log->debug("open: " . $open);
    $log->debug("high: " . $high);
    $log->debug("low: " . $low);
    $log->debug("volume: " . $volume);
    $log->debug("name: " . $name);
    $log->debug("prev: " . $prev);
    $log->debug("pchange: " . $pchange);
    
    my $line1 = $prefs->get('stock1format');
    my $line2 = $prefs->get('stock2format');

    for ($line1) {
        s/%s/$ticker/;
        s/%l/$lasttrade/;
        s/%d/$lastdate/;
        s/%t/$lasttime/;
        s/%c/$change/;
        s/%o/$open/;
        s/%h/$high/;
        s/%w/$low/;
        s/%v/$volume/;
        s/%n/$name/;
        s/%p/$prev/;
        s/%z/$pchange/;
    }
            
    for ($line2) {
        s/%s/$ticker/;
        s/%l/$lasttrade/;
        s/%d/$lastdate/;
        s/%t/$lasttime/;
        s/%c/$change/;
        s/%o/$open/;
        s/%h/$high/;
        s/%w/$low/;
        s/%v/$volume/;
        s/%n/$name/;
        s/%p/$prev/;
        s/%z/$pchange/;             
    }

    addDisplayItem('getStocks', $line1, $line2, $showgame);

    $stockCounter ++;   
    if ($stockCounter < $stockCount) { # are there more stock tickers?
        getStocks(undef, $client, $refreshItem);
    }
    else {
        refreshData(undef, $client, $refreshItem); # done
    }
}

sub refreshSoon {
    my $client = shift;

    #Save top showing preference incase server is shut down
    if (defined $topNowShowing{$client}) {
        $prefs->client($client)->set('topNowShowing', $topNowShowing{$client});
    }
    
    #Clear previous display info
    @WETdisplayItems1 =();
    @WETdisplayItems2 =();
    
    $averages{'last'} = ''; #Make sure averages/10day will get refreshed too
    for(my $i=-1; $i<2; $i++) { #Wipe individual averages just in case new weather identifier does not support them
        $wetData{$i}{'average_F'} = '';
        $wetData{$i}{'average_C'} = '';
                    
        $wetData{$i}{'record_F'} = '';
        $wetData{$i}{'record_C'} = '';
                
        $wetData{$i}{'record_year'} = '';
                    
        $wetData{$i}{'sunrise'} = '';
        $wetData{$i}{'sunset'}  = '';
    }
    
    #Need to reload updated prefs
    @MLBteams = @{ $prefs->get('mlb') || [] };
    $refreshTracker[0] = 1; #Need to refresh MLB again
    @NBAteams = @{ $prefs->get('nba') || [] };
    $refreshTracker[1] = 1; #Need to refresh NBA again
    @NHLteams = @{ $prefs->get('nhl') || [] };
    $refreshTracker[2] = 1; #Need to refresh NHL again
    @NFLteams = @{ $prefs->get('nfl') || [] };
    @CBBteams = @{ $prefs->get('cbb') || [] };
    @CFBteams = @{ $prefs->get('cfb') || [] };
    $showtime = $prefs->get('time');
    $showgame = $prefs->get('score');
    $showactivetime = $prefs->get('atime');
    $showactivegame = $prefs->get('ascore');
    
    #Update 10day forecasts for C or F based on preference
    my @players = Slim::Player::Client::clients();
    for my $player (@players) {
        my @weatherformat1b = @{ $prefs->client($player)->get('weatherformat1b') || [] };
        my @weatherformat2t = @{ $prefs->client($player)->get('weatherformat2t') || [] };
        if ($prefs->get('temperature') == 1) {  #Cel
            $weatherformat1b[1] =~ s/%_5\/%_7/%_6\/%_8/;
            $prefs->client($player)->set('weatherformat1b', \@weatherformat1b); 
            $weatherformat2t[1] =~ s/%_5\/%_7/%_6\/%_8/;
            $prefs->client($player)->set('weatherformat2t', \@weatherformat2t); 
        }
        else {
            $weatherformat1b[1] =~ s/%_6\/%_8/%_5\/%_7/;
            $prefs->client($player)->set('weatherformat1b', \@weatherformat1b);     
            $weatherformat2t[1] =~ s/%_6\/%_8/%_5\/%_7/;
            $prefs->client($player)->set('weatherformat2t', \@weatherformat2t);     
        }
    }   

    # If refreshing due to a setting change make sure weather.com identifier is still correct.  
    if ($prefs->get('city') !~ /.+\:\d\:\D\D/) { # Check for proper weather.com citycode format
        $log->error("Check your Weather.com Identifier. Your entry = " . $prefs->get('city'));
        $prefs->set('city','60614:4:US'); #Default to Chicago... cuz Chicago is where it's at! 
        $log->error("Defaulting identifier to Chicago: " . $prefs->get('city'));
    }
    getLatLong; # Retrieve Latitude and Longitude for weather.com location
    
    #No need to refresh data unless there are active clients
    if ($activeClients >0) {
        Slim::Utils::Timers::killTimers(undef, \&refreshData);
        #Refresh in 8 seconds.  In case user keeps changing settings so there are less refreshes maybe.....
        Slim::Utils::Timers::setTimer(undef, Time::HiRes::time() + 8, \&refreshData, $client, -1);
    }
}

sub refreshPlayerSettings {
    my $timerObj = shift; #Should be undef
    my $client = shift;

    my $prefs = preferences('plugin.superdatetime');

    my @show1icon = @{ $prefs->client($client)->get('show1icon') || [] };
    if (scalar(@show1icon) == 0) {
        if(!$client->display->isa('Slim::Display::Boom')) {
            $show1icon[0] = 1;
            $show1icon[1] = 1;
        }
        else {
            $show1icon[0] = 0;
            $show1icon[1] = 1;
        }
        $prefs->client($client)->set('show1icon', \@show1icon);
    }

    my @show13line = @{ $prefs->client($client)->get('show13line') || [] };
    if (scalar(@show13line) == 0) {
        $show13line[0] = 1;
        $show13line[1] = 1;
        $prefs->client($client)->set('show13line', \@show13line);
    }

    my @d3line1t = @{ $prefs->client($client)->get('v3line1t') || [] };
    if (scalar(@d3line1t) == 0) {
        $d3line1t[0] = '';
        $d3line1t[1] = '';
        $prefs->client($client)->set('v3line1t', \@d3line1t);
    }

    my @d3line1m = @{ $prefs->client($client)->get('v3line1m') || [] };
    if (scalar(@d3line1m) == 0) {
        $d3line1m[0] = '%z';
        $d3line1m[1] = ' %_4';
        $prefs->client($client)->set('v3line1m', \@d3line1m);
    }

    my @d3line1b = @{ $prefs->client($client)->get('v3line1b') || [] };
    if (scalar(@d3line1b) == 0) {
        $d3line1b[0] = 'RAIN %x';
        $d3line1b[1] = 'RAIN %_9';
        $prefs->client($client)->set('v3line1b', \@d3line1b);
    }

    my @weatherformat1b = @{ $prefs->client($client)->get('weatherformat1b') || [] };
    if (scalar(@weatherformat1b) == 0) {
        if(!$client->display->isa('Slim::Display::Boom')) {
            $weatherformat1b[0] = '%t/%h %1';
        }
        else {
            $weatherformat1b[0] = '%t %1';
        }
        $weatherformat1b[1] = '%_5/%_7';
        $prefs->client($client)->set('weatherformat1b', \@weatherformat1b);
    }
    
    my @weatherformat1t = @{ $prefs->client($client)->get('weatherformat1t') || [] };
    if (scalar(@weatherformat1t) == 0) {
        $weatherformat1t[0] = '%y: %v';
        $weatherformat1t[1] = '%_3: %_0';
        $prefs->client($client)->set('weatherformat1t', \@weatherformat1t);
    }

    my @weatherformat2b = @{ $prefs->client($client)->get('weatherformat2b') || [] };
    if (scalar(@weatherformat2b) == 0) {
        $weatherformat2b[0] = '%f  %a(%c %g)';
        $weatherformat2b[1] = '%_0';
        $prefs->client($client)->set('weatherformat2b', \@weatherformat2b);
    }

    my @weatherformat2t = @{ $prefs->client($client)->get('weatherformat2t') || [] };
    if (scalar(@weatherformat2t) == 0) {
        $weatherformat2t[0] = '%s - %S';
        $weatherformat2t[1] = '%_3: %_5/%_7';
        $prefs->client($client)->set('weatherformat2t', \@weatherformat2t);
    }

    my @d1period = @{ $prefs->client($client)->get('v1period') || [] };
    if (scalar(@d1period) == 0) {
        $d1period[0] = -1; 
        $d1period[1] = -1;
        $prefs->client($client)->set('v1period', \@d1period);
    }

    if ($prefs->client($client)->get('scroll') eq '') {
        if(!$client->display->isa('Slim::Display::Boom')) {
            $scrollType{$client} = 'Slide';
        }
        else {
            $scrollType{$client} = 'Ticker';
        }
        $prefs->client($client)->set('scroll', $scrollType{$client});
    }
    else {
        $scrollType{$client} = $prefs->client($client)->get('scroll');
    }
    
    my $fdays = $prefs->client($client)->get('fdays');
    
    if ($fdays eq '') {
        $prefs->client($client)->set('fdays', 3);
    }
    
    if ($topNowShowing{$client} <0 || $topNowShowing{$client} > $fdays +3 ) {
        $topNowShowing{$client} = 1;
        $prefs->client($client)->set('topNowShowing', 1);
    }
}

sub refreshData {
    my $timerObj = shift; #Should be undef
    my $client = shift;
    my $refreshItem = shift;
    $refreshItem = $refreshItem + 1;
    
    if ($refreshItem == 0) { #New data refresh, weather.com
        $log->info("Data refresh in process...");

        # If a graphical client was stored, use it when refreshing data.  
        # This makes sure the special fonts are used when drawing screens.
        if (defined $Gclient) { 
            $client = $Gclient;
        }

        Slim::Utils::Timers::killTimers(undef, \&stuckMonitor); #Paranoia check
        Slim::Utils::Timers::setTimer(undef, Time::HiRes::time() + (($prefs->get('refresh') * 60)*2), \&stuckMonitor, $client); #Set up stuck monitor

        my $data = {
            'state' => 'Refreshing'
        };
        Slim::Control::Request::notifyFromArray(undef,['SuperDateTimeState','dataRefreshState',$data]);

        $errorCount = 0; #Reset network error counter for new refresh
        
        refreshPlayerSettings(undef, $client); #Didnt seem to want to refresh elsewhere

        %displayInfoBuild = (); #Paranoia, should already be empty
        %macroHash = (); #Wipe out any custom macros that have been set previously

        my ($mday,$mon,$year,$hour, $isdst) = (gmtime(time-(60*60*8)))[3,4,5,2,8];  #Figure out Pacific time based on GMT time to line up with MLB, NBA, & NFL day resets
        if ($mday < 10) {
            $mday = '0' . $mday;
        }

        $mon++; #Starts at 0
        if ($mon < 10) {
            $mon = '0' . $mon;
        }
        $year = $year + 1900;
    
        $log->debug("Pacific Hour/Date:$hour/$mday");

        if ((($lastRefresh ne ($year . $mon . $mday)) && $hour >4) || $lastRefresh eq '') { #5AM EST start refreshing a new day
            @refreshTracker = ();
            #Should this be moved into their own subs.... would need separate $lastRefreshes then
            $refreshTracker[0] = 1; #Need to refresh MLB again
            $refreshTracker[1] = 1; #Need to refresh NBA again
            $refreshTracker[2] = 1; #Need to refresh NHL again
            $lastRefresh = $year.$mon.$mday;
        }
        
        $refreshTracker[3] = 1; #Need to set Stock refresh tracker

        #Update status indicator to show that a data refresh is in progress
        $status = '*';

        #Is this okay since old data is still being displayed?
        $newActiveGames = 0; #Reset active game flag for upcoming sports data refresh

        getWeatherNow(undef, $client, $refreshItem);
    }
    elsif (defined $providers{$refreshItem}) { #Dynamic provider
        $providers{$refreshItem}->(undef, $client, $refreshItem);
    }
    else {  #DONE
        if ($newActiveGames == 1) {
            $activeGames = 1;
        }
    
        $log->info("Drawing screens...");
        $log->debug("Start time:" . Time::HiRes::time());
        
        @WETdisplayItems1 = @WETdisplayItems1temp;
        @WETdisplayItems2 = @WETdisplayItems2temp;

        #Clear the temps for the next update
        @WETdisplayItems1temp = ();
        @WETdisplayItems2temp = ();

        #Refresh complete so it's safe to draw/cache icons for each up/down mode
        
        my @players = Slim::Player::Client::clients();

        #Determine time to wait between each screen drawing
        $drawEachPendingDelay = $prefs->get('drawEachDelay');
        $log->debug("drawEachPendingDelay = $drawEachPendingDelay");
        
        #Stagger the screen drawing timers so they're not blocking to other nonSDT processing
        my $cumTime = Time::HiRes::time() + .03;

        for my $player (@players) {

            #Draw default modes
            #Current 0
            $drawEachPending++;
            Slim::Utils::Timers::setTimer(undef, $cumTime, \&drawEach, $player, -1, 0);
            $cumTime = $cumTime + $drawEachPendingDelay;
            #Default 1
            $drawEachPending++;
            Slim::Utils::Timers::setTimer(undef, $cumTime, \&drawEach, $player, 0, 0);
            $cumTime = $cumTime + $drawEachPendingDelay;
            #Default 2
            $drawEachPending++;
            Slim::Utils::Timers::setTimer(undef, $cumTime, \&drawEach, $player, 1, 0);
            $cumTime = $cumTime + $drawEachPendingDelay;
            #Default 3
            $drawEachPending++;
            Slim::Utils::Timers::setTimer(undef, $cumTime, \&drawEach, $player, 2, 0);
            $cumTime = $cumTime + $drawEachPendingDelay;
        
            #Draw custom modes
            my @d1period = @{ $prefs->client($player)->get('v1period') || [] };

            for(my $i=2; $i < scalar @d1period; $i++) {
                $drawEachPending++;
                Slim::Utils::Timers::setTimer(undef, $cumTime, \&drawEach, $player, $d1period[$i], $i);
                $cumTime = $cumTime + $drawEachPendingDelay;
            }       
        
            #Draw 10 Day Forecasts for each player
            #Make sure we have a value in case player settings have never been set

            if ($prefs->client($player)->get('fdays') eq '') {
                $prefs->client($player)->set('fdays', 3);
            }

            for (my $i=1; $i <= $prefs->client($player)->get('fdays')+1; $i++) {
                $drawEachPending++;
                Slim::Utils::Timers::setTimer(undef, $cumTime, \&drawEach, $player, 'd'.$i, 1);
                $cumTime = $cumTime + $drawEachPendingDelay;
            }       
        }
    }
}

#Called when no more icons need to be drawn
sub doneDrawing {
    my $client = shift;
    
    $log->info("Done drawing screens.");
    
    $log->debug("Finish time:" . Time::HiRes::time());      

    #Icons have been drawn, replace old display data with fresh data
    %displayInfo = %displayInfoBuild;
    %displayInfoBuild = (); #Done building, no longer needed
    
    #Make non sports/stock line data available via external API
    
    my $total = 0;

    if  ($displayInfo{'cycleOrigin'}) { 
        $total = scalar @{$displayInfo{'cycleOrigin'}};
    }
    
    for(my $counter=0 ; $counter < $total; $counter++) {
        if (!($displayInfo{'cycleOrigin'}[$counter] =~ /getMLB|getNFL|getNBA|getNHL|getCBB|getCFB|getStocks|getLongWeather/)) {
            $miscData{$displayInfo{'cycleOrigin'}[$counter]}{$counter}{'line1'} = $displayInfo{'cycleItems1'}[$counter];
            $miscData{$displayInfo{'cycleOrigin'}[$counter]}{$counter}{'line2'} = $displayInfo{'cycleItems2'}[$counter];
            
            #Differentiate between long and short text
            if ($displayInfo{'cycleInts'}[$counter] eq 'L') {
                $miscData{$displayInfo{'cycleOrigin'}[$counter]}{$counter}{'type'} = 'long';
            }
            else {
                $miscData{$displayInfo{'cycleOrigin'}[$counter]}{$counter}{'type'} = 'short';
            }
        }
    }
        
    if ($status eq '*') {
        $log->info("Data refresh completed.");
        
        my $data = {
            'state' => 'Success'
        };
        Slim::Control::Request::notifyFromArray(undef,['SuperDateTimeState','dataRefreshState',$data]);

        $status = '';
    }
    else {
        $log->warn("Data refresh completed with errors.");
        my $data = {
            'state' => 'Errors'
        };
        Slim::Control::Request::notifyFromArray(undef,['SuperDateTimeState','dataRefreshState',$data]);
    }

    $activeGames = $newActiveGames;

    Slim::Utils::Timers::killTimers(undef, \&stuckMonitor); #Kill stuck monitor as plugin made it through the refresh
    Slim::Utils::Timers::killTimers(undef, \&refreshData); #Paranoia check
    Slim::Utils::Timers::setTimer(undef, Time::HiRes::time() + ($prefs->get('refresh') * 60), \&refreshData, $client, -1); #Set up next refresh timer
}

sub stuckMonitor {
    my $timerObj = shift; #Should be undef
    my $client = shift;
    
    $log->warn("Plugin appears to be stuck.  Forcing refresh...");
    Slim::Utils::Timers::killTimers(undef, \&refreshData); #Paranoia check
    Slim::Utils::Timers::setTimer(undef, Time::HiRes::time() + 3, \&refreshData, $client, -1); #Set up next refresh timer   
}

sub getMLB {  #Set up Async HTTP request for MLB
    my $timerObj = shift; #Should be undef
    my $client = shift;
    my $refreshItem = shift;

    my ($mday,$mon,$year,$hour, $isdst) = (gmtime(time-(60*60*8)))[3,4,5,2,8];  # Roll over date embedded in URL at 1AM Pacific instead of 12AM Eastern
    $mday = sprintf("%02d",$mday);
    $mon = sprintf("%02d",$mon+1);
    $year = $year+1900;
    
    if (scalar(@MLBteams)>0 && $mon <12 && $mon >2 && $refreshTracker[0] !=0) { #Make sure a baseball team is chosen and it is baseball season
        my $url = 'http://mlb.mlb.com/gdcross/components/game/mlb/year_'.$year.'/month_'.$mon.'/day_'.$mday.'/master_scoreboard.json' ;
    
        my $http = Slim::Networking::SimpleAsyncHTTP->new(\&gotMLB,
                                  \&gotErrorViaHTTP,
                                  {caller => 'getMLB',
                                    callerProc => \&getMLB,                               
                                   client => $client,
                                   refreshItem => $refreshItem});                             
        
        $log->info("aync request: $url");
        $http->get($url, 'User-Agent' => 'Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20100101 Firefox/12.0');
    }
    else {
        $log->info("Skipping MLB...");
        if (scalar(@MLBteams)>0) {
            saveCycles('getMLB');
        }
        else {
            delete $sportsData{'MLB'};
        }
        refreshData(undef, $client, $refreshItem);
    }
}

sub gotMLB {
    my $http = shift;
    
    my $params = $http->params();
    my $client = $params->{'client'};
    my $refreshItem = $params->{'refreshItem'};

    delete $sportsData{'MLB'};
    $sportsData{'MLB'}{'logoURL'} = 'plugins/SuperDateTime/html/images/MLB.png';

    $log->info("got " . $http->url());
    
    my $MLB_json = $http->content();
    my $perldata = decode_json($MLB_json);
    
#   Check JSON text for '"game":'
#   If it doesn't exist then no games today.
#   If it does exist check $games_array for ref type.
#   ARRAY = multiple games, handle with while loop.
#   HASH = single game (i.e. All Star Game).
#   Single game data is in HASH $game_array.

    if ($MLB_json =~ /\"game\"\:/) { # Check to see if there are any games.
        $log->debug("One or more games today");
        my $games_array = $perldata->{'data'}->{'games'}->{'game'}; # Store the ARRAY of games or HASH for single game.
        $log->debug("\$games_array is a: " . ref($games_array));
        if (ref($games_array) eq 'ARRAY') { # Multiple games today
            $refreshTracker[0] = 0;
            my $game_count = scalar(@$games_array); # How many games today?
            my $game_num = 0;
            $log->debug("Game count: " . $game_count);
            while ($game_num < $game_count) {
                my $game = @$games_array[$game_num]; #split array into individual games
                my $game_stat = $game->{'status'}->{'status'}; #Pregame, Preview, In Progress, Game Over, Delayed?, Postponed? 
                my $game_time = $game->{'time'}; # Eastern time zone start time 
                my $ampm = $game->{'ampm'}; 
                my $inning = $game->{'status'}->{'inning'}; # Inning#
                my $inning_st = $game->{'status'}->{'inning_state'}; # Top, Middle,Bottom, End
                my $away_team = $game->{'away_team_name'};
                my $home_team = $game->{'home_team_name'};
                my $away_score = $game->{'linescore'}->{'r'}->{'away'};
                my $home_score = $game->{'linescore'}->{'r'}->{'home'};
                my $clock_time = $game_time . " " . $ampm ;
                my $Cclock_time = convertTime($clock_time);
            
                if ($game_stat eq 'In Progress') { # active games
                    $clock_time = $inning_st." ".$inning; 
                }
                elsif ($game_stat eq 'Game Over' or $game_stat eq 'Final' or $game_stat eq 'Completed Early'){ # completed games
                    if ($inning > 9 or $game_stat eq 'Completed Early') {
                        $clock_time = 'Final '. $inning; 
                    }
                    else {
                        $clock_time = 'Final'; 
                    }
                }
                elsif ($game_stat eq 'Delayed Start' or $game_stat eq 'Postponed') { 
                    $clock_time = $game_stat;
                    $home_score = '';
                    $away_score = '';
                }
                elsif ($game_stat eq 'Delayed' or $game_stat eq 'Suspended') { # Delayed or suspended game
                    $clock_time = $game_stat.' '.$inning;
                }
                else { # upcoming games  
                    $home_score = '';
                    $away_score = '';
                }

                $Cclock_time = convertTime($clock_time);

                $log->debug("Game# " . $game_num);
                $log->debug("Status: " . $game_stat);
                $log->debug("Teams: " . $away_team . " @ " . $home_team);
                $log->debug("Inning: " . $inning);
                $log->debug("Inning Part: " . $inning_st);
                $log->debug("Raw Clock: " . $clock_time);
                $log->debug("Converted Clock: " . $Cclock_time);
                $log->debug("Score: " . $away_score . " - " . $home_score);
                $log->debug(" ");

                my $MLBICONmap = '';
                my $home_logo = $MLBICONmap{$home_team};
                my $away_logo = $MLBICONmap{$away_team};
                $home_logo = "http://a.espncdn.com/combiner/i?img=/i/teamlogos/mlb/500/scoreboard/".$home_logo.".png";
                $away_logo = "http://a.espncdn.com/combiner/i?img=/i/teamlogos/mlb/500/scoreboard/".$away_logo.".png";
                
                $sportsData{'MLB'}{$home_team.$clock_time}{'gameTime'} = convertTime($clock_time);
                $sportsData{'MLB'}{$home_team.$clock_time}{'homeTeam'} = $home_team;
                $sportsData{'MLB'}{$home_team.$clock_time}{'awayTeam'} = $away_team;
                $sportsData{'MLB'}{$home_team.$clock_time}{'homeScore'} = $home_score;
                $sportsData{'MLB'}{$home_team.$clock_time}{'awayScore'} = $away_score;
                $sportsData{'MLB'}{$home_team.$clock_time}{'homeLogoURL'} = $home_logo;
                $sportsData{'MLB'}{$home_team.$clock_time}{'awayLogoURL'} = $away_logo;
                $sportsData{'MLB'}{$home_team.$clock_time}{'gameLogoURL'} = $home_logo;

                if ((teamCheck($home_team,\@MLBteams)==1) || (teamCheck($away_team,\@MLBteams)==1)) {
                    displayLines($client, $clock_time, $away_team, $home_team, $away_score, $home_score, 'MLB', 'getMLB', \&shortenMLB, \%MLBmap);
                }
                $game_num++ ;
            }
        }
        elsif (ref($games_array) eq 'HASH') { # Single game today.
            $log->debug('Single game today');
            $refreshTracker[0] = 0;
            my $game = $games_array; 
            my $game_stat = $game->{'status'}->{'status'}; #Pregame, Preview, In Progress, Game Over, Delayed?, Postponed? 
            my $game_time = $game->{'time'}; # Eastern time zone start time 
            my $ampm = $game->{'ampm'}; 
            my $inning = $game->{'status'}->{'inning'}; # Inning#
            my $inning_st = $game->{'status'}->{'inning_state'}; # Top, Middle, Bottom, End
            my $away_team = $game->{'away_team_name'};
            my $home_team = $game->{'home_team_name'};
            my $away_score = $game->{'linescore'}->{'r'}->{'away'};
            my $home_score = $game->{'linescore'}->{'r'}->{'home'};
            my $clock_time = $game_time . " " . $ampm ;
            my $Cclock_time = convertTime($clock_time);
        
            if ($game_stat eq 'In Progress') { # active games
                $clock_time = $inning_st." ".$inning; 
            }
            elsif ($game_stat eq 'Game Over' or $game_stat eq 'Final' or $game_stat eq 'Completed Early'){ # completed games
                if ($inning > 9 or $game_stat eq 'Completed Early') {
                    $clock_time = 'Final '. $inning; 
                }
                else {
                    $clock_time = 'Final'; 
                }
            }
            elsif ($game_stat eq 'Delayed Start' or $game_stat eq 'Postponed') { 
                $clock_time = $game_stat;
                $home_score = '';
                $away_score = '';
            }
            elsif ($game_stat eq 'Delayed' or $game_stat eq 'Suspended') { # Delayed or suspended game
                $clock_time = $game_stat.' '.$inning;
            }
            else { # upcoming games  
                $home_score = '';
                $away_score = '';
            }

            $Cclock_time = convertTime($clock_time);

            $log->debug("Status: " . $game_stat);
            $log->debug("Teams: " . $away_team . " @ " . $home_team);
            $log->debug("Inning: " . $inning);
            $log->debug("Inning Part: " . $inning_st);
            $log->debug("Raw Clock: " . $clock_time);
            $log->debug("Converted Clock: " . $Cclock_time);
            $log->debug("Score: " . $away_score . " - " . $home_score);
            $log->debug(" ");

            my $MLBICONmap = '';
            my $home_logo = $MLBICONmap{$home_team};
            my $away_logo = $MLBICONmap{$away_team};
            $home_logo = "http://a.espncdn.com/combiner/i?img=/i/teamlogos/mlb/500/scoreboard/".$home_logo.".png";
            $away_logo = "http://a.espncdn.com/combiner/i?img=/i/teamlogos/mlb/500/scoreboard/".$away_logo.".png";
            
            $sportsData{'MLB'}{$home_team.$clock_time}{'gameTime'} = convertTime($clock_time);
            $sportsData{'MLB'}{$home_team.$clock_time}{'homeTeam'} = $home_team;
            $sportsData{'MLB'}{$home_team.$clock_time}{'awayTeam'} = $away_team;
            $sportsData{'MLB'}{$home_team.$clock_time}{'homeScore'} =$home_score;
            $sportsData{'MLB'}{$home_team.$clock_time}{'awayScore'} =$away_score;
            $sportsData{'MLB'}{$home_team.$clock_time}{'homeLogoURL'} = $home_logo;
            $sportsData{'MLB'}{$home_team.$clock_time}{'awayLogoURL'} = $away_logo;
            $sportsData{'MLB'}{$home_team.$clock_time}{'gameLogoURL'} = $home_logo;

            if ((teamCheck($home_team,\@MLBteams)==1) || (teamCheck($away_team,\@MLBteams)==1)) {
                displayLines($client, $clock_time, $away_team, $home_team, $away_score, $home_score, 'MLB', 'getMLB', \&shortenMLB, \%MLBmap);
            }
        }
        else {
            $status = '-';
            $log->warn("Error parsing MLB data.");
        }
    }
    else {
        $log->info("No games today");
        $refreshTracker[0] = 0;
    }
    refreshData(undef, $client, $refreshItem);  
}

sub registerProvider {
    my $subRef = shift;
    
    my $size = (scalar keys %providers) + 1;
    
    $providers{$size} = $subRef;
}

sub addDisplayItem {
    my ($origin, $item1, $item2, $int, $expires, $time) = @_;
    
    if (!defined $expires) {
        $expires = 0;
    }

    if (!defined $time) {
        $time = Time::HiRes::time();
    }
    
    push(@{$displayInfoBuild{'cycleOrigin'}}, $origin);
    push(@{$displayInfoBuild{'cycleItems1'}}, $item1);
    push(@{$displayInfoBuild{'cycleItems2'}}, $item2);  
    push(@{$displayInfoBuild{'cycleInts'}}, $int);
    push(@{$displayInfoBuild{'cycleTimeAdded'}}, $time);
    push(@{$displayInfoBuild{'cycleTimeExpires'}}, $expires);
}

#Allows plugins to add their own % macro replacement value
sub addMacro {
    my ($macro, $value) = @_;
    $macroHash{$macro} = $value;
}

#Preserves previous display info for a given source.  Optionally a time can be specified which will be compared against the 
#cycleTimeAdded value.either before (b) or after (a) based on $ba argument.
sub saveCycles {
    my ($origin, $time, $ba) = @_;

    $log->debug("Preserving previous $origin info... $ba $time");
    
    if (exists $displayInfo{'cycleOrigin'}) {
        my $total = scalar @{$displayInfo{'cycleOrigin'}};
        for(my $counter=0 ; $counter < $total; $counter++) {
            if ($displayInfo{'cycleOrigin'}[$counter] eq $origin) {
                if (defined $time) {
                    if ($ba eq 'b' && $displayInfo{'cycleTimeAdded'}[$counter] < $time) {
                        addDisplayItem($origin, $displayInfo{'cycleItems1'}[$counter], $displayInfo{'cycleItems2'}[$counter], $displayInfo{'cycleInts'}[$counter], $displayInfo{'cycleTimeExpires'}[$counter], $displayInfo{'cycleTimeAdded'}[$counter]);
                    }
                    elsif ($ba eq 'a' && $displayInfo{'cycleTimeAdded'}[$counter] > $time) {
                        addDisplayItem($origin, $displayInfo{'cycleItems1'}[$counter], $displayInfo{'cycleItems2'}[$counter], $displayInfo{'cycleInts'}[$counter], $displayInfo{'cycleTimeExpires'}[$counter], $displayInfo{'cycleTimeAdded'}[$counter]);
                    }
                }
                else {
                    addDisplayItem($origin, $displayInfo{'cycleItems1'}[$counter], $displayInfo{'cycleItems2'}[$counter], $displayInfo{'cycleInts'}[$counter], $displayInfo{'cycleTimeExpires'}[$counter], $displayInfo{'cycleTimeAdded'}[$counter]);
                }
            }
        }
    }           
}

#Preserves non-expired display info for a given source
sub processExpired {
    my $origin = shift;
    
    my $time = Time::HiRes::time();

    $log->debug("Preserving non-expired $origin info...");
    
    my $total = scalar @{$displayInfo{'cycleOrigin'}};
    for(my $counter=0 ; $counter < $total; $counter++) {
        if (($displayInfo{'cycleOrigin'}[$counter] eq $origin) && $displayInfo{'cycleTimeExpires'}[$counter] > $time) {
            addDisplayItem($origin, $displayInfo{'cycleItems1'}[$counter], $displayInfo{'cycleItems2'}[$counter], $displayInfo{'cycleInts'}[$counter], $displayInfo{'cycleTimeExpires'}[$counter], $displayInfo{'cycleTimeAdded'}[$counter]);
        }
    }
}

sub teamCheck {
    my $teamToCheck  = shift;
    my $teamArrayRef = shift;

    #Get rid of any ranking, if present (college).
    if ($teamToCheck =~ /(\(\d+\)) (.+)/) {
        $teamToCheck = $2;
    }

    $log->debug("Made it to teamcheck");
    $log->debug($teamToCheck);

    my $endingValue = scalar(@$teamArrayRef);

    for(my $counter=0 ; $counter < $endingValue; $counter++)
    {
        $log->debug("Made it to teamcheck - team loop");
        $log->debug(@$teamArrayRef[$counter]);
        if (($teamToCheck eq @$teamArrayRef[$counter]) || (@$teamArrayRef[$counter] eq '1') || (@$teamArrayRef[$counter] eq 'All') || (@$teamArrayRef[$counter] eq 'all')) {
            $log->debug("Made it to teamcheck - return 1");
            return 1;
        }
    }
    
    return 0;
}

sub displayLines {
    #Figure out/Format display lines
    my ($client, $gametime, $team1, $team2, $score1, $score2, $topline, $origin, $shortenRef, $iconHashRef) = @_;
    
    $gametime = convertTime($gametime);  #Clean up time display and convert to local time zone

    my $logoteam1 = '';
    my $logoteam2 = '';
    
    if ($prefs->get('teamlogos') == 0 || !defined $iconHashRef) { #No logos
        $logoteam1 = $shortenRef->($team1);
        $logoteam2 = $shortenRef->($team2) 
    }
    elsif ($prefs->get('teamlogos') == 1) { #Logo no text
        if (defined $iconHashRef->{$team1}) { #Are there logos for team1?
            $logoteam1 = $client->symbols("$origin-".$iconHashRef->{$team1});
        }
        else { #No logo available
            $logoteam1 = $shortenRef->($team1);
        }
            
        if (defined $iconHashRef->{$team2}) { #Are there logos for team2
            $logoteam2 = $client->symbols("$origin-".$iconHashRef->{$team2});
        }
        else { #No logo available
            $logoteam2 = $shortenRef->($team2);
        }       
    }
    else { #Logo and text
        if (defined $iconHashRef->{$team1}) { #Are there logos for team1?
            $logoteam1 = $client->symbols("$origin-".$iconHashRef->{$team1});
        }
            
        if (defined $iconHashRef->{$team2}) { #Are there logos for team2
            $logoteam2 = $client->symbols("$origin-".$iconHashRef->{$team2});
        }   
        
        $logoteam1 = $logoteam1 . $shortenRef->($team1);
        $logoteam2 = $logoteam2 . $shortenRef->($team2);
    }
        
    if (($gametime =~ m/^F/ or $gametime =~ m/^P/ or $gametime =~ m/^S/) && $showgame>0) {  #Finished game
        $log->debug('This game is finished: '.$team1.' @ '.$team2);
        addDisplayItem($origin, $topline, $logoteam1 . ' ' . $score1 . ' @ ' . $logoteam2 . ' ' . $score2 . ' - ' . $gametime, $showgame);      
    }
    elsif ($score1 eq '' && $showgame>0) {  #upcoming game
        if ($origin eq 'getMLB') {
            $refreshTracker[0] = 1;
        }
        elsif ($origin eq 'getNBA') {
            $refreshTracker[1] = 1;
        }
        elsif ($origin eq 'getNHL') {
            $refreshTracker[2] = 1;
        }
        $log->debug('This game is upcoming: '.$team1.' @ '.$team2);
        addDisplayItem($origin, $topline, $logoteam1 . ' @ ' . $logoteam2 . '-' . $gametime, $showgame);
    }
    elsif ($gametime ne 'F' && $showactivegame >0 && $score1 ne '') { #active game
        if ($origin eq 'getMLB') {
            $refreshTracker[0] = 1;
        }
        elsif ($origin eq 'getNBA') {
            $refreshTracker[1] = 1;
        }
        elsif ($origin eq 'getNHL') {
            $refreshTracker[2] = 1;
        }       
        $log->debug('This game is active: '.$team1.' @ '.$team2);
        $newActiveGames = 1;
        addDisplayItem($origin, $topline, $logoteam1 . ' ' . $score1 . ' @ ' . $logoteam2 . ' ' . $score2 . ' - ' . $gametime, $showactivegame);
    }
    else {
        $log->error('UH OH! This game status is unknown: '.$team1.' @ '.$team2);
    }
}

sub getNBA {  #Set up Async HTTP request for NBA
    my $timerObj = shift; #Should be undef
    my $client = shift;
    my $refreshItem = shift;

    my ($mday,$mon,$year,$hour, $isdst) = (gmtime(time-(60*60*8)))[3,4,5,2,8];  # Roll over date embedded in URL at 1AM Pacific instead of 12AM Eastern
    $mday = sprintf("%02d",$mday);
    $mon = sprintf("%02d",$mon+1);
    $year = $year+1900;
    my $season = $year;
    if ($mon < 07) {
        $season--
    }
    
################ Debug with other dates #####################
#   $year = 2017;
#   $mon = 12;
#   $mday = 15;
#############################################################   

    if (scalar(@NBAteams)>0 && $refreshTracker[1] !=0) { #Make sure a basketball team is chosen
        my $url = 'http://data.nba.net/prod/v2/' . $year . $mon . $mday . '/scoreboard.json';
        my $http = Slim::Networking::SimpleAsyncHTTP->new(\&gotNBA,
                                                \&gotErrorViaHTTP,
                                                {caller => 'getNBA',
                                                callerProc => \&getNBA,                                                       
                                                client => $client,
                                                refreshItem => $refreshItem});

        $log->info("async request: $url");
        $http->get($url, 'User-Agent' => 'Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20100101 Firefox/12.0');
    }
    else {
        $log->info("Skipping NBA...");
        if (scalar(@NBAteams)>0) {
            saveCycles('getNBA');
        }
        else {
            delete $sportsData{'NBA'};
        }
        refreshData(undef, $client, $refreshItem);
    }
}

sub gotNBA {
    my $http = shift;
    
    my $params = $http->params();
    my $client = $params->{'client'};
    my $refreshItem = $params->{'refreshItem'};

    delete $sportsData{'NBA'};
    $sportsData{'NBA'}{'logoURL'} = 'plugins/SuperDateTime/html/images/nba.png';

    $refreshTracker[1] = 0;
   
    $log->info("got " . $http->url());

    # Retrieve and decode NBA JSON data file
    my $NBA_json = $http->content();
    my $perldata = decode_json($NBA_json);
    
    my $games_array = $perldata->{'games'};
    my $game_count = scalar(@$games_array);
    my $game_num = 0;
    my $isDST = localtime[8];
    $log->debug("Number of games today: " . $game_count);
    
    while ($game_num < $game_count) {
        my $gameID = @$games_array[$game_num]->{'gameId'};
        my $activeGame = @$games_array[$game_num]->{'isGameActivated'};
        my $GameStatus = @$games_array[$game_num]->{'statusNum'};
        my $StartTime = @$games_array[$game_num]->{'startTimeUTC'};
        my $away_team = @$games_array[$game_num]->{'vTeam'}->{'triCode'};
        my $home_team = @$games_array[$game_num]->{'hTeam'}->{'triCode'};
        my $away_score = @$games_array[$game_num]->{'vTeam'}->{'score'};
        my $home_score = @$games_array[$game_num]->{'hTeam'}->{'score'};
        my $game_clock = @$games_array[$game_num]->{'clock'};
        my $period = @$games_array[$game_num]->{'period'}->{'current'};
        my $isHalftime = @$games_array[$game_num]->{'period'}->{'isHalftime'};
        my $isEndOfPeriod = @$games_array[$game_num]->{'period'}->{'isEndOfPeriod'};
        my $tv_array = @$games_array[$game_num]->{'watch'}->{'broadcast'}->{'broadcasters'}->{'national'};
        my $tv_network = '';
        if (@$tv_array) {
            $tv_network = @$tv_array[0]->{'shortName'};
        }
        my $NBAteamMap = '';
        my $away_team_name = $NBAteamMap{$away_team};       # Look up long team names
        my $home_team_name = $NBAteamMap{$home_team};

        my $away_logo = 'http://a.espncdn.com/combiner/i?img=/i/teamlogos/nba/500/' . $away_team . '.png'; # Use ESPN.com logos instead.
        my $home_logo = 'http://a.espncdn.com/combiner/i?img=/i/teamlogos/nba/500/' . $home_team . '.png';      
        
        my $period_time = '';
        $period_time = $game_clock;
        
        # Calculate Eastern Start Time 
        my $StartHr = '';
        my $StartMin = '';
        my $AmPm = 'AM';
        if ($StartTime =~ /.+T(\d+)\:(\d+).+/) { # Extract hours and minutes from UTC time
            $StartHr = $1;
            $StartMin = $2;
            if ($isDST) {
                $StartHr = $StartHr - 4;# convert to Eastern time
            }
            else {
                $StartHr = $StartHr - 5;
            }
            if ($StartHr < 0) {         # check for crossing to previous day
                $StartHr = $StartHr + 24;
            }
            if ($StartHr > 12) {        # convert to 12 Hr format
                $StartHr = $StartHr - 12;
                $AmPm = 'PM';
            }
            elsif ($StartHr == 0) {     # Midnight
                $StartHr = $StartHr + 12
            }
            $StartTime = $StartHr . ":" . $StartMin . ' ' . $AmPm;
        }
        
        $log->debug("GameID = " . $gameID);
        $log->debug("activeGame = " . $activeGame);
        $log->debug("Game Status = " . $GameStatus);
        $log->debug("Start Time: " . $StartTime);
        $log->debug("Start Hour: " . $StartHr);
        $log->debug("Start Minute: " . $StartMin);
        $log->debug("Away Team: " . $away_team);
        $log->debug("Away Score: " . $away_score);
        $log->debug("Home Team: " . $home_team);
        $log->debug("Home Score: " . $home_score);
        $log->debug("Period: " . $period);
        $log->debug("Game clock: " . $game_clock);
        $log->debug("Period time: " . $period_time);
        $log->debug("Half time? " . $isHalftime);
        $log->debug("End Of Period? " . $isEndOfPeriod);
        $log->debug("TV Network: " . $tv_network);
        $log->debug("Away Logo: " . $away_logo);
        $log->debug("Home Logo: " . $home_logo);
        

        $log->debug("Away team name: " . $away_team_name);
        if ($away_team_name eq "") {
            $away_team_name = $away_team; # Deal with exhibition games with non-NBA team.
        }
        $log->debug("Away team name: " . $away_team_name);

        $log->debug("Home team name: " . $home_team_name);
        if ($home_team_name eq "") {
            $home_team_name = $home_team; # Deal with exhibition games with non-NBA team.
        }
        $log->debug("Home team name: " . $home_team_name);
        
        if ($period eq 0) { # upcoming game - blank out scores
            $log->debug("Detected Upcoming Game");
            $away_score = "";
            $home_score = "";
            $game_clock = $StartTime;
        }
        elsif ($GameStatus == 3) { # finished game
            $log->debug("Detected Finished Game");
            $game_clock = 'Final';
            if ($period > 4) { # Overtime
                if ($period > 5) { # Multiple overtime
                    my $OTPeriod = $period - 4;
                    $game_clock = "Final " . $OTPeriod . "OT";
                    $log->warn("Period: " . $period);
                    $log->warn("Detected Multiple Overtime");
                    $log->warn("OT Period: " . $OTPeriod);
                    $log->warn($away_team_name.' '.$away_score.' @ '.$home_team_name.' '.$home_score.' - '.convertTime($game_clock));
                }
                else {
                    $game_clock = "FINAL OT";
                    $log->warn("Period: " . $period);
                    $log->warn("Detected Overtime");
                    $log->warn($away_team_name.' '.$away_score.' @ '.$home_team_name.' '.$home_score.' - '.convertTime($game_clock));
                }
            }
        }
        elsif ($isHalftime) { 
            $log->debug("Detected Game in Halftime");
            $game_clock = "Halftime";
        }
        elsif ($isEndOfPeriod) {
            $log->debug("Detected End of Period");
            $game_clock = "End " . $period;
        }
        else { # active game
            $log->debug("Detected Active Game");
            $game_clock = $period_time . ' ' . $period;
            if ($period > 4) { # Overtime
                if ($period > 5) { # Multiple overtime
                    my $OTPeriod = $period - 4;
                    $game_clock = $period_time . ' ' . $OTPeriod . "OT";
                    $log->warn("Period: " . $period);
                    $log->warn("Game clock: " . $game_clock);
                    $log->warn("Detected Multiple Overtime");
                    $log->warn($away_team_name.' '.$away_score.' @ '.$home_team_name.' '.$home_score.' - '.convertTime($game_clock));
                }
                else {
                    $game_clock = $period_time . ' ' . "OT";
                    $log->warn("Period: " . $period);
                    $log->warn("Detected Overtime");
                    $log->warn($away_team_name.' '.$away_score.' @ '.$home_team_name.' '.$home_score.' - '.convertTime($game_clock));
                }
            }
        }
        
        my $clock_time = $game_clock;
        $log->debug("Game time: " . $clock_time);
        $log->debug("Converted Game time: " . convertTime($clock_time));
        $log->debug($away_team_name.' '.$away_score.' @ '.$home_team_name.' '.$home_score.' - '.convertTime($clock_time));
    
        $sportsData{'NBA'}{$home_team.$clock_time}{'homeTeamCK'}  =$home_team;
        $sportsData{'NBA'}{$home_team.$clock_time}{'awayTeamCK'}  =$away_team;
        $sportsData{'NBA'}{$home_team.$clock_time}{'homeTeam'} = $home_team_name;
        $sportsData{'NBA'}{$home_team.$clock_time}{'awayTeam'} = $away_team_name;
        $sportsData{'NBA'}{$home_team.$clock_time}{'awayScore'} = $away_score;
        $sportsData{'NBA'}{$home_team.$clock_time}{'homeScore'} = $home_score;
        $sportsData{'NBA'}{$home_team.$clock_time}{'gameTime'} = convertTime($clock_time);
        $sportsData{'NBA'}{$home_team.$clock_time}{'homeLogoURL'} = $home_logo;
        $sportsData{'NBA'}{$home_team.$clock_time}{'awayLogoURL'} = $away_logo;
        $sportsData{'NBA'}{$home_team.$clock_time}{'gameLogoURL'} = $home_logo;
        
        if ((teamCheck($home_team,\@NBAteams)==1) || (teamCheck($away_team,\@NBAteams)==1)) {
            if ($tv_network eq '') {
                displayLines($client, $clock_time, $away_team_name, $home_team_name, $away_score, $home_score, 'NBA', 'getNBA', \&shortenNBA, undef);
            }
            else {
                displayLines($client, $clock_time, $away_team_name, $home_team_name, $away_score, $home_score, 'NBA ('.$tv_network.')', 'getNBA', \&shortenNBA, undef);
            }
        }
        
        $log->debug(" "); #To improve log file readability - add line between games
        $game_num++ ;
    }
    refreshData(undef, $client, $refreshItem);  
}

sub rtrim($) {
    my $string = shift;
    $string =~ s/\s+$//;
    return $string;
}

sub getCBB {  #Set up Async HTTP request for CBB
    my $timerObj = shift; #Should be undef
    my $client = shift;
    my $refreshItem = shift;

#   Extract year, month, day for JSON URL   & day of the year for checking in season status 
    my ($mday,$mon,$year,$hour, $isdst, $yday) = (gmtime(time-(60*60*8)))[3,4,5,2,8,7]; # Roll over date embedded in URL at 1AM Pacific instead of 12AM Eastern
    $year = $year+1900;
    $mon = sprintf("%02d",$mon+1);
    $mday = sprintf("%02d",$mday);

######## Test other dates ########
#   $year   = '2018';   #yyyy
#   $mon    = '11';     #mm
#   $mday   = '06';     #dd
#   $yday   = '309';
##################################  

#   Calculate the beginning of the season.  i.e 2nd Friday of November 
#   Starting with the 2018-2019 season, the NCAA moved the start of the 
#   season to the Tuesday preceding the 2nd friday of November.
    my $season = $year;
    if ($mon < 5) {
        $season--
    }
    my $StartDate = timelocal(00,00,12,1,10,$season); #Start with the 1st of November in the season year.
    my $dow = (localtime($StartDate))[6]; # Determine the Day of Week
    my $AdjustDays = $dow-5; # Calculate the adjustment days needed to get to Friday
    my $FirstFriday = ($StartDate - ($AdjustDays*86400)); # Find the first Friday.  PS - 86400 seconds per day.
    my ($ckDay, $ckMon, $ckYear, $cbbSDay) = (localtime($FirstFriday))[3,4,5,7];
    $ckYear = $ckYear+1900;
    $ckMon = sprintf("%02d",$ckMon+1);
    $ckDay = sprintf("%02d",$ckDay);
    $cbbSDay = $cbbSDay + 4; # Start with the 1st Friday of November and add 4 to find the following Tuesday    

    $log->debug("AdjustDays: " . $AdjustDays);
    $log->debug("First Friday: " . $ckMon."-".$ckDay."-".$ckYear);
    $log->debug("Start day: " . $cbbSDay);
    
    if (scalar(@CBBteams)>0 && ($yday >= $cbbSDay || $mon < 5)) { #Make sure a college basketball team is entered & we're in season
        my $url = 'http://data.ncaa.com/casablanca/scoreboard/basketball-men/d1/'.$year.'/'.$mon.'/'.$mday.'/scoreboard.json';
        my $http = Slim::Networking::SimpleAsyncHTTP->new(\&gotCBB,
                                                    \&gotErrorViaHTTP,
                                                    {caller => 'getCBB',
                                                    callerProc => \&getCBB,                                                   
                                                    client => $client,
                                                    refreshItem => $refreshItem});
    
        $log->info("async request: $url");
        $http->get($url, 'User-Agent' => 'Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20100101 Firefox/12.0');
    }
    else {
        $log->info("Skipping CBB...");
        if (scalar(@CBBteams)>0) {
            saveCycles('getCBB');
        }
        else {
            delete $sportsData{'College Basketball'};
        }
        refreshData(undef, $client, $refreshItem);
    }
}

sub gotCBB {
    my $http = shift;
    
    my $params = $http->params();
    my $client = $params->{'client'};
    my $refreshItem = $params->{'refreshItem'};
   
    delete $sportsData{'College Basketball'};
    $sportsData{'College Basketball'}{'logoURL'} = 'plugins/SuperDateTime/html/images/NCAA.png';
    
    $log->info("got " . $http->url());
    my $json = $http->content();

    # Trim down to the body of the JSON data    
    my $size = length($json);
    my $begin = index($json, "[");
    my $end = rindex($json, "]");
    $end = $end-$size;
    $end=$end+1;
    my $CBB_json =  substr $json, $begin, $end;
    $CBB_json =~ s/\,\s*\,/\,/g; # Remove malformed JSON text.

    my $perldata = decode_json($CBB_json);
    
    my $PREiconURL = 'http://i.turner.ncaa.com/dr/ncaa/ncaa7/release/sites/default/files/images/logos/schools/' ; #The 1st part of the URL for team logos.
    my $POSTiconURL = '.70.png' ; # Last part of URL for team logos

    my @games =  @$perldata; # Number of games today
    my $game_count = scalar(@games);
    $log->debug("Number of games today: ". $game_count);
    my $game_num = 0;
    while ($game_num < $game_count) {
        $log->debug("Game # ". $game_num);
        my $away_team = $games[$game_num]->{'game'}->{'away'}->{'names'}->{'short'};
        my $home_team = $games[$game_num]->{'game'}->{'home'}->{'names'}->{'short'};
        my $away_score = $games[$game_num]->{'game'}->{'away'}->{'score'};
        my $home_score = $games[$game_num]->{'game'}->{'home'}->{'score'};
        my $startTime = $games[$game_num]->{'game'}->{'startTime'}; # Start time - Eastern timezone 
        my $gameStat = $games[$game_num]->{'game'}->{'gameState'}; # Final, possibly Inprogress?  Undefined before start.
        my $currPeriod = $games[$game_num]->{'game'}->{'currentPeriod'}; # Shows the current period.  This is also where overtime is noted as "Final (OT)" on finished games.
        my $finalMessage = $games[$game_num]->{'game'}->{'finalMessage'}; # New for 2018 - 2019
        my $clockTime = $games[$game_num]->{'game'}->{'contestClock'}; 
        my $away_icon = $games[$game_num]->{'game'}->{'away'}->{'names'}->{'seo'};
        my $away_FL = substr($away_icon,0,1);
        my $home_icon = $games[$game_num]->{'game'}->{'home'}->{'names'}->{'seo'};
        my $home_FL = substr($home_icon,0,1);
        $away_icon = $PREiconURL.$away_FL.'/'.$away_icon.$POSTiconURL;
        $home_icon = $PREiconURL.$home_FL.'/'.$home_icon.$POSTiconURL;

        $log->debug('Away team: ' . $away_team);
        $log->debug('Home team: ' . $home_team);
        $log->debug('Away score: ' . $away_score);
        $log->debug('Home score: ' . $home_score);
        $log->debug('Start Time: ' . $startTime);
        $log->debug('Game Status: ' . $gameStat);
        $log->debug('Period: ' . $currPeriod);
        $log->debug('Final message: ' . $finalMessage);
        $log->debug('Clock Time: ' . $clockTime);
        $log->debug('Away icon URL: ' . $away_icon);
        $log->debug('Home icon URL: ' . $home_icon);
        
        my $clock_time;

########### Sort out Active, Final, Overtime, Upcoming games ##############
        
        if (($gameStat eq "In-Progress") or ($gameStat eq "live")) {
            $log->debug("Active game");
            if ($currPeriod =~/OT/i) {
                $log->debug("Overtime");
                $clock_time = $clockTime.' OT';
                if ($currPeriod =~/(\d+)/) { # Double or Triple overtime
                    $log->debug("Multiple Overtime");
                    $clock_time = $clockTime.' '.$1.'OT';
                }      
            }
            elsif ($currPeriod =~ m/(\d)/) { #Active games - Gametime = timeclock/period
                $log->debug("Period # Detected");
                my $Period = $1;
                $clock_time = $clockTime.'/'.$Period;
                if ($currPeriod =~ /end/i) {
                    $log->debug("End Detected");
                    $clock_time = 'End '.$Period;
                }
            }
            elsif ($currPeriod =~/half/i) { #Halftime - Gametime = Halftime
                $log->debug("Halftime");
                $clock_time = "Halftime";
            }
        }
        elsif ($currPeriod =~/final/i || $gameStat =~/final/i) { #Finished
            $log->debug("Finished game");
            $clock_time = "Final";
            if ($currPeriod =~/OT/i) { # Overtime
                $log->debug("Overtime");
                if ($currPeriod =~/(\d+)/) { # Double or triple overtime
                    $log->debug("Multiple Overtime");
                    $clock_time = "Final ".$1."OT";
                }
                else {
                    $clock_time = "Final OT";
                }
            }
        }
        elsif ($gameStat eq "postponed") { #Postponed games
            $log->debug("Postponed game");
#           $away_score = '';
#           $home_score = '';
            $clock_time = "Postponed";
        }
        else { #Upcoming games - Blank out scores, Gametime = Startime
            $log->debug("Upcoming game");
            $away_score = '';
            $home_score = '';
            $clock_time = $startTime;
        }

        $log->debug("Clock time: ".$clock_time);
        $log->debug($away_team. " ". $away_score. " @ ". $home_team. " ". $home_score. " - ". convertTime($clock_time));

        $sportsData{'College Basketball'}{$home_team.$clock_time}{'homeTeam'}  =$home_team;
        $sportsData{'College Basketball'}{$home_team.$clock_time}{'awayTeam'}  =$away_team;
        $sportsData{'College Basketball'}{$home_team.$clock_time}{'homeLogoURL'} = $home_icon;
        $sportsData{'College Basketball'}{$home_team.$clock_time}{'awayLogoURL'} = $away_icon;
        $sportsData{'College Basketball'}{$home_team.$clock_time}{'gameLogoURL'} = $home_icon;
        $sportsData{'College Basketball'}{$home_team.$clock_time}{'homeScore'} = $home_score;
        $sportsData{'College Basketball'}{$home_team.$clock_time}{'awayScore'} = $away_score;
        $sportsData{'College Basketball'}{$home_team.$clock_time}{'gameTime'}  =convertTime($clock_time);
    
        if ((teamCheck($home_team,\@CBBteams)==1) || (teamCheck($away_team,\@CBBteams)==1)) {
            displayLines($client, $clock_time, $away_team, $home_team, $away_score, $home_score, 'NCAA Basketball', 'getCBB', \&shortenCBB, undef);
        }
        
        $game_num++
    } 
    
    refreshData(undef, $client, $refreshItem);  
}


sub getCFB {  #Set up Async HTTP request for college football
    my $timerObj = shift; #Should be undef
    my $client = shift;
    my $refreshItem = shift;
    
    my @dateArray = gmtime(time-(60*60*8)); #Use 1AM Pacific when determining date.  This allows late games to finish before rolling to new date.

    my $mon = $dateArray[4];
    my $year = $dateArray[5];
    my $mday =$dateArray[3];
    $year = $year + 1900;
    $mon = sprintf("%02d",$mon+1);
    $mday = sprintf("%02d",$mday);

    # Calculate Season
    my $season = $year;
    if ($mon < 3) {
        $season--
    }

    # Calculate start of season
    # Starting day of the season. Each week of the CFB season runs from Tuesday through Monday. Starting with the Tuesday preceding the first Monday of September.
    my $AdjustDays; # Used to store the number of days to subtract from the 7th to find the 1st Monday.
    my $StartDate = timelocal(00,00,12,7,8,$season); #Start with the 7th of September in the season year.
    my $dow = (localtime($StartDate))[6]; # Figure out which day of the week it is.
    if ($dow>0) {  
        $AdjustDays = $dow-1;
    }
    else {
        $AdjustDays = 6;
    }
    my $FirstMonday = ($StartDate - ($AdjustDays*86400)); # Find the first Monday by subtracting the correct number of days.  PS - 86400 seconds per day.

    my ($ckDay, $ckMon, $ckYear, $cfbSDay) = (localtime($FirstMonday))[3,4,5,7];
    $ckYear = $ckYear+1900;
    $ckMon = sprintf("%02d",$ckMon+1);
    $ckDay = sprintf("%02d",$ckDay);

    $cfbSDay = $cfbSDay - 6; # Start with the 1st Monday of September and subtract 6 to find the prior Tuesday
    
    # Calculate week of season
    my $currYDay = $dateArray[7];
    my $cfbWeek = int((($currYDay-$cfbSDay)/7)+1); # Calculate which week of the season we are in.
    $cfbWeek = sprintf("%02d",$cfbWeek);
    if ($cfbWeek > 15 or $cfbWeek < -10) { # Account for post season play.
        $cfbWeek = 'P';
    }
    elsif ($cfbWeek < 1) { # Some seasons start games prior to the calculated start of the season, but include them in the 1st week's JSON file.  For example 2016.
        $cfbWeek = '01';
    }
    
    if (scalar(@CFBteams)>0) { #Make sure at least one team is entered
		my $url = 'https://data.ncaa.com/casablanca/scoreboard/football/fbs/' . $season . '/' . $cfbWeek . '/scoreboard.json'; 

        my $http = Slim::Networking::SimpleAsyncHTTP->new(\&gotCFB,
                                              \&gotErrorViaHTTP,
                                              {caller => 'getCFB',
                                            callerProc => \&getCFB,                                           
                                               client => $client,
                                               refreshItem => $refreshItem});
                                                          
        $log->info("aync request: $url");
        $http->get($url, 'User-Agent' => 'Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20100101 Firefox/12.0');
    }
    else {
        $log->info("Skipping CFB...");
        delete $sportsData{'College Football'};
        refreshData(undef, $client, $refreshItem);
    }
}

sub gotCFB {
    my $http = shift;
    
    my $params = $http->params();
    my $client = $params->{'client'};
    my $refreshItem = $params->{'refreshItem'};

    delete $sportsData{'College Football'};
    $sportsData{'College Football'}{'logoURL'} = 'plugins/SuperDateTime/html/images/NCAA.png';
  
    $log->info("got " . $http->url());

    my $json = $http->content();

    # Trim down to the body of the JSON data    
    my $size = length($json);
    my $begin = index($json, "[");
    my $end = rindex($json, "]");
    $end = $end-$size;
    $end=$end+1;
    my $CFB_json =  substr $json, $begin, $end;

    my $perldata = decode_json($CFB_json);

    # Preparation for comparison to game date.
    my @dateArray = gmtime(time-(60*60*8)); # Use 1AM Pacific for determining date so late games can finish before rolling over to new date.

    my $mday = $dateArray[3];
    $mday = sprintf("%02d",$mday);
    my $year = $dateArray[5]+1900;
	my $mon = $dateArray[4]+1;
	$mon = sprintf("%02d",$mon);

    my $currDate = $mon . "-" . $mday . "-" . $year;

#####################################################	
#	$currDate = '12-01-2018';  # Check other dates
#####################################################

    my $PREiconURL = 'http://i.turner.ncaa.com/dr/ncaa/ncaa7/release/sites/default/files/images/logos/schools/' ; #The 1st part of the URL for team logos.
    my $POSTiconURL = '.70.png' ; # Last part of URL for team logos

    my @games =  @$perldata;
    my $game_count = scalar(@games); #How many games this week
    $log->info("Games this week: " . $game_count);
    
    my $game_num = 0;

    while ($game_num < $game_count) {
        $log->info("Game#: " . $game_num);
		my $gameDate = $games[$game_num]->{'game'}->{'startDate'};
		my $away_team = $games[$game_num]->{'game'}->{'away'}->{'names'}->{'short'};
		my $home_team = $games[$game_num]->{'game'}->{'home'}->{'names'}->{'short'};
		my $away_score = $games[$game_num]->{'game'}->{'away'}->{'score'};
		my $home_score = $games[$game_num]->{'game'}->{'home'}->{'score'};
		my $startTime = $games[$game_num]->{'game'}->{'startTime'}; # Start time - Eastern timezone 
		my $gameStat = $games[$game_num]->{'game'}->{'gameState'}; # pre, live, final, cancelled #
		my $currPeriod = $games[$game_num]->{'game'}->{'currentPeriod'}; # Shows the current qtr.  This is also where overtime is noted as "Final (OT)" on finished games.
		my $clockTime = $games[$game_num]->{'game'}->{'contestClock'};
		my $finalMess = $games[$game_num]->{'game'}->{'finalMessage'};
        my $away_icon = $games[$game_num]->{'game'}->{'away'}->{'names'}->{'seo'};
        my $away_FL = substr($away_icon,0,1);
        my $home_icon = $games[$game_num]->{'game'}->{'home'}->{'names'}->{'seo'};
        my $home_FL = substr($home_icon,0,1);
        $away_icon = $PREiconURL.$away_FL.'/'.$away_icon.$POSTiconURL;
        $home_icon = $PREiconURL.$home_FL.'/'.$home_icon.$POSTiconURL;
                
		$log->info('Game #: ' . $game_num);
		$log->info('Away team: ' . $away_team);
		$log->info('Home team: ' . $home_team);
		$log->info('Date Today: ' . $currDate);
		$log->info('Game Date: ' . $gameDate);
		$log->info('Start Time: ' . $startTime);
		$log->info('Game Status: ' . $gameStat);
		$log->info('Period: ' . $currPeriod);
		$log->info('Clock Time: ' . $clockTime);
		$log->info('Final Message: ' . $finalMess);
		
		if ($gameDate eq $currDate) { 
					
			my $clock_time;
			
			if ($gameStat eq "live") {
				$log->info("Active game");
				if ($currPeriod =~/OT/i) {
					$log->info("Overtime");
					$log->info('Game Status: ' . $gameStat);
					$log->info('Period: ' . $currPeriod);
					$log->info('Clock Time: ' . $clockTime);
					$log->info('Final Message: ' . $finalMess);
					$clock_time = "OT";
					$log->info($startTime. "- ". $away_team. " ". $away_score. " @ ". $home_team. " ". $home_score. " - ". convertTime($clock_time));
					if ($currPeriod =~/(\d+)/) {
						$log->info("Multiple Overtime");
						$clock_time = $1."OT";
						$log->info($startTime. "- ". $away_team. " ". $away_score. " @ ". $home_team. " ". $home_score. " - ". convertTime($clock_time));
					}      
				}
				elsif ($currPeriod =~ m/(\d)/) { #Active games - Gametime = timeclock/period
					$log->info("Period # Detected");
					my $Period = $1;
					$clock_time = $clockTime.'/'.$Period;
					if ($currPeriod =~ /end/i) {
						$log->info("End Detected");
						$clock_time = 'End '.$Period;
					}
				}
				elsif ($currPeriod =~/half/i) { #Halftime - Gametime = Halftime
					$log->info("Halftime");
					$clock_time = "Halftime";
				}
			}
			elsif (($currPeriod =~/final/i) or ($gameStat =~/final/i)) { #Finished
				$log->info("Finished game");
				$clock_time = "Final";
				if ($finalMess =~/\d+/i or $finalMess =~/OT/i) { # Either OT or number in Final Message = Overtime
					my $OTPeriod = '';
					$log->info('Game Status: ' . $gameStat);
					$log->info('Period: ' . $currPeriod);
					$log->info('Clock Time: ' . $clockTime);
					$log->info('Final Message: ' . $finalMess);
					if ($finalMess =~/OT/) {
						if ($finalMess =~/(\d+)/) { # OT with number = number of OT periods
							$OTPeriod = $1;
							$log->info('Final Message Displaying # of OT Periods: '.$1);
						}
						else { # OT without number = single overtime
							$clock_time = "Final OT";
						}
					}
					elsif ($finalMess =~/(\d+)/) { # Number without OT = number of total periods
						$OTPeriod = $1 - 4; # Total periods - Regular game periods = Overtime periods
						$log->info('Final Message Displaying Total Periods: '.$1);
					}
					if ($OTPeriod > 1) {
						$log->info("Multiple Overtime");
						$clock_time = "Final ".$OTPeriod."OT";
						$log->info($startTime. "- ". $away_team. " ". $away_score. " @ ". $home_team. " ". $home_score. " - ". convertTime($clock_time));
					}
					else { # OT without number = single overtime
						$clock_time = "Final OT";
						$log->info($startTime. "- ". $away_team. " ". $away_score. " @ ". $home_team. " ". $home_score. " - ". convertTime($clock_time));
					}
				}
			}
			elsif ($gameStat =~/pre/i) {  # Upcoming games - Blank out scores, Gametime = Startime
				$log->info("Upcoming game");
				$away_score = '';
				$home_score = '';
				$clock_time = $startTime;
			}
			elsif ($gameStat =~/cancel/i) {  
				$log->info("Canceled game");
				$away_score = '';
				$home_score = '';
				$clock_time = 'Canceled';
			}
			elsif ($gameStat =~/delayed/i) {  
				$log->info("Game delayed");
				$clock_time = 'Delayed';
			}
			else { # Not sure... Setup as upcoming game - Blank out scores, Gametime = Startime
				$log->warn("Uncertain CFB game status");
				$away_score = '';
				$home_score = '';
				$clock_time = $startTime;
				$log->warn('Start Time: ' . $startTime);
				$log->warn('Game Status: ' . $gameStat);
				$log->warn('Period: ' . $currPeriod);
				$log->warn('Clock Time: ' . $clockTime);
				$log->warn($startTime. "- ". $away_team. " ". $away_score. " @ ". $home_team. " ". $home_score. " - ". convertTime($clock_time));
				$log->warn($away_team. " iconURL = ". $away_icon);
				$log->warn($home_team. " iconURL = ". $home_icon);
			}

			$log->info("Clock time: ".$clock_time);
			
			$sportsData{'College Football'}{$home_team.$clock_time}{'homeTeam'}  =$home_team;
			$sportsData{'College Football'}{$home_team.$clock_time}{'awayTeam'}  =$away_team;
			$sportsData{'College Football'}{$home_team.$clock_time}{'homeScore'} =$home_score;
			$sportsData{'College Football'}{$home_team.$clock_time}{'awayScore'} =$away_score;
			$sportsData{'College Football'}{$home_team.$clock_time}{'gameTime'}  =convertTime($clock_time);
			$sportsData{'College Football'}{$home_team.$clock_time}{'homeLogoURL'} = $home_icon;
			$sportsData{'College Football'}{$home_team.$clock_time}{'awayLogoURL'} = $away_icon;
			$sportsData{'College Football'}{$home_team.$clock_time}{'gameLogoURL'} = $home_icon;

			if ((teamCheck($home_team,\@CFBteams)==1) || (teamCheck($away_team,\@CFBteams)==1)) {
				displayLines($client, $clock_time, $away_team, $home_team, $away_score, $home_score, 'NCAA Football', 'getCFB', \&shortenCFB);
			}
			
			$log->info($startTime. "- ". $away_team. " ". $away_score. " @ ". $home_team. " ". $home_score. " - ". convertTime($clock_time));
			$log->info($away_team. " iconURL = ". $away_icon);
			$log->info($home_team. " iconURL = ". $home_icon);
			$log->info(" ");
        }        
        $game_num++ 
    }
    refreshData(undef, $client, $refreshItem);  
}

sub getNHL {  #Set up Async HTTP request for NHL
    my $timerObj = shift; #Should be undef
    my $client = shift;
    my $refreshItem = shift;
    
    if (scalar(@NHLteams)>0 && $refreshTracker[2] !=0) { #Make sure a hockey team is chosen  
        my $url = 'http://sports.espn.go.com/nhl/scoreboard?date=' . $lastRefresh;
        my $http = Slim::Networking::SimpleAsyncHTTP->new(\&gotNHL,
                                                        \&gotErrorViaHTTP,
                                                        {caller => 'getNHL',
                                                        callerProc => \&getNHL,                                                       
                                                        client => $client,
                                                        refreshItem => $refreshItem});
        $log->info("aync request: $url");
        $http->get($url, 'User-Agent' => 'Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20100101 Firefox/12.0');
    }
    else {
        $log->info("Skipping NHL...");
        if (scalar(@NHLteams)>0) {
            saveCycles('getNHL');
        }
        else {
            delete $sportsData{'NHL'};
        }
        refreshData(undef, $client, $refreshItem);
    }
}

sub gotNHL {
    my $http = shift;
    
    my $params = $http->params();
    my $client = $params->{'client'};
    my $refreshItem = $params->{'refreshItem'};

    delete $sportsData{'NHL'};
    $sportsData{'NHL'}{'logoURL'} = 'plugins/SuperDateTime/html/images/NHL.png';
    
    $refreshTracker[2] = 0;

    $log->info("got " . $http->url());

    my $content = $http->content();
        
    my $tree = HTML::TreeBuilder->new; # empty tree
    
    $tree->parse($content);
    $tree->eof();
    
    my @game_divs = $tree->look_down( "_tag", "div", "class", "mod-content" );

    for my $game_div ( @game_divs ) {

        next unless $game_div->look_down( "_tag", "div", "id", qr{gameHeader} );

        my @outcome = $game_div->look_down( "_tag", "li", "id", qr{statusLine1} );
        my @qtr     = $game_div->look_down( "_tag", "span", "id", qr{statusLine2Left} );
        my @clock   = $game_div->look_down( "_tag", "span", "id", qr{statusLine2Right} );
        my @teams = $game_div->look_down( "_tag", "a", "href", qr{/nhl/team/_/name/} );
        my @scores  = $game_div->look_down( "_tag", "span", "id", qr{(home|away)HeaderScore} );
        
        my( $outcome_txt ) = $outcome[ 0 ]->content_list;
        my( $qtr_txt )     = $qtr[ 0 ]->content_list;
        my( $clock_time )  = $clock[ 0 ]->content_list;
        my( $away_team )   = $teams[ 0 ]->content_list;
        my( $home_team )   = $teams[ 1 ]->content_list;
        my( $away_score )  = $scores[ 0 ]->content_list;
        my( $home_score )  = $scores[ 1 ]->content_list;

        my $home_logo = $teams[1]->as_HTML;
        my $away_logo = $teams[0]->as_HTML;
        
        $home_logo =~ m/name\/(\w+)\//;
        $home_logo = 'http://a.espncdn.com/combiner/i?img=/i/teamlogos/nhl/500/' . $1 . '.png';     
        $away_logo =~ m/name\/(\w+)\//;
        $away_logo = 'http://a.espncdn.com/combiner/i?img=/i/teamlogos/nhl/500/' . $1 . '.png';
        
        $outcome_txt = ''
            unless defined $outcome_txt && $outcome_txt =~ /\w/;
        $qtr_txt = ''
            unless defined $qtr_txt && $qtr_txt =~ /\w/;
        $clock_time = ''
            unless defined $clock_time && $clock_time =~ /\d/;

        if( $clock_time ne '' ) {
            $clock_time = "$clock_time $qtr_txt";
        } elsif( $outcome_txt =~ /final/i ) {
            $clock_time = $outcome_txt;
        } else {
            $clock_time = $qtr_txt;
        }

        $sportsData{'NHL'}{$home_team.$clock_time}{'homeTeam'} = $home_team;
        $sportsData{'NHL'}{$home_team.$clock_time}{'awayTeam'} = $away_team;
        $sportsData{'NHL'}{$home_team.$clock_time}{'homeLogoURL'} = $home_logo;
        $sportsData{'NHL'}{$home_team.$clock_time}{'awayLogoURL'} = $away_logo;
        $sportsData{'NHL'}{$home_team.$clock_time}{'gameLogoURL'} = $home_logo;
        
        #Check to see if home score is a numeric, otherwise there isn't a score yet and set to blanks
        if( $home_score =~ /^\d/ ) {
            $sportsData{'NHL'}{$home_team.$clock_time}{'homeScore'} =$home_score;
            $sportsData{'NHL'}{$home_team.$clock_time}{'awayScore'} =$away_score;
        }
        else {
            $sportsData{'NHL'}{$home_team.$clock_time}{'homeScore'} = '';
            $sportsData{'NHL'}{$home_team.$clock_time}{'awayScore'} = '';
            $home_score = '';
            $away_score = '';
        }
            
        $sportsData{'NHL'}{$home_team.$clock_time}{'gameTime'}  =convertTime($clock_time);

        if ((teamCheck($home_team,\@NHLteams)==1) || (teamCheck($away_team,\@NHLteams)==1)) {
            displayLines($client, $clock_time, $away_team, $home_team, $away_score, $home_score, 'NHL', 'getNHL', \&shortenNHL, undef);
        }
    } 

    $tree = $tree->delete;

    refreshData(undef, $client, $refreshItem);
}

sub getLongWeather {
    my $timerObj = shift; #Should be undef
    my $client = shift;
    my $refreshItem = shift;
    
    my $weatherInterval = currentWeatherInterval();
    
    for (my $i = 0; $i < scalar @WETdisplayItems1; $i++) {
        #Check to see if they care to see the weather right now
        if ($weatherInterval >0) {
            if ($weatherInterval <5) {
                addDisplayItem('getLongWeather', $WETdisplayItems1[$i], $WETdisplayItems2[$i], 'L');
            }
            #Add to external API
            $miscData{'getLongWeather'}{$i}{'line1'} = $WETdisplayItems1[$i];
            $miscData{'getLongWeather'}{$i}{'line2'} = $WETdisplayItems2[$i];
            $miscData{'getLongWeather'}{$i}{'type'} = 'long';
        }
    }
    refreshData(undef, $client, $refreshItem);
}

sub getNFL {  #Set up Async HTTP request for NFL
    my $timerObj = shift; #Should be undef
    my $client = shift;
    my $refreshItem = shift;
    
    if (scalar(@NFLteams)>0 && $NFL_HTML eq '') { #Make sure a NFL team is chosen and $NFL_HTML is empty
        my $url2 = 'http://www.nfl.com/scores'; 
        my $http = Slim::Networking::SimpleAsyncHTTP->new(\&gotNFL_HTML,
                                                  \&gotErrorViaHTTP,
                                                  {caller => 'getNFL',
                                               callerProc => \&getNFL,                                                
                                                   client => $client,
                                                   refreshItem => $refreshItem});
        $log->info("async request: $url2");
        $http->get($url2, 'User-Agent' => 'Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20100101 Firefox/12.0');
    }
    elsif (scalar(@NFLteams)>0) { #Make sure a NFL team is chosen  
        my $url = 'http://www.nfl.com/liveupdate/scores/scores.json' ;
    
        my $http = Slim::Networking::SimpleAsyncHTTP->new(\&gotNFL,
                                                  \&gotErrorViaHTTP,
                                                  {caller => 'getNFL',
                                               callerProc => \&getNFL,                                                
                                                   client => $client,
                                                   refreshItem => $refreshItem});

        $log->info("async request: $url");
        $http->get($url, 'User-Agent' => 'Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20100101 Firefox/12.0');
    }
    else {
        $log->info("Skipping NFL...");
        delete $sportsData{'NFL'};
        $NFL_HTML = '';
        refreshData(undef, $client, $refreshItem);
    }
}

sub gotNFL_HTML {
    my $http = shift;
    my $params = $http->params();
    my $client = $params->{'client'};
    my $refreshItem = $params->{'refreshItem'};

    $log->info("got " . $http->url());

    $NFL_HTML = $http->content();

    my $tree = HTML::TreeBuilder->new;
    $tree->parse($NFL_HTML);
    $tree->eof();
    
    my $gamedata = $tree->look_down( "_tag", "body");
    my @gamedata1 = $gamedata->look_down("_tag","script");
    my $scr_count = scalar(@gamedata1);
    my $NFL_time_json = '';
    for (my $i = 0; $i < $scr_count; $i++){
        if (@gamedata1[$i]->as_HTML =~ /_INITIAL_DATA__\s\=\s(.*)\;\n/) {
            $log->debug($1);
            $NFL_time_json = decode_json($1);
        }
    }

    my $NFL_games = $NFL_time_json->{'uiState'}->{'scoreStripGames'}; # Store array of games
    my $gamecnt = scalar(@$NFL_games);
    my $NFLgameID = '';
    my $upcomingTime = '';
    for (my $i = 0; $i < $gamecnt; $i++) {
        my $games = @$NFL_games[$i]; #split array into individual games
        $NFLgameID = $games->{'id'};
        $upcomingTime = $games->{'status'}->{'upcomingGameTimeEastern'};
        if ($upcomingTime =~ /(\d+:\d+ \w\w)/) {
            $upcomingTime = $1;
        }
        $NFLupTime{$NFLgameID} = $upcomingTime;
        $log->debug($NFLgameID.' = '.$upcomingTime);
    }

    $tree->delete;
    
    # Now go back to getNFL to retrieve JSON and proceed to gotNFL
    getNFL(undef, $client, $refreshItem);
}

sub gotNFL {
    my $http = shift;
    
    my $params = $http->params();
    my $client = $params->{'client'};
    my $refreshItem = $params->{'refreshItem'};

    delete $sportsData{'NFL'};
    $sportsData{'NFL'}{'logoURL'} = 'plugins/SuperDateTime/html/images/nfl.png';
   
    $log->info("got " . $http->url());

    # Get NFL JSON data and decode it
    my $NFL_json = $http->content();
    my $perldata = decode_json($NFL_json);
  
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)= (gmtime(time-(60*60*8))); #Change date at 1AM Pacific to allow late games to complete before changeover.
    $year = $year+1900;
    $mon = sprintf("%02d",$mon+1); # month starts at 0
    $mday = sprintf("%02d",$mday);

    my $today = $year.$mon.$mday;
#   $today = '20181007';    # Use this line to test other dates
    $log->debug("Today's date = ", $today);

    my @games = keys %$perldata; #extract game keys and store in array
    my $game_count = scalar(@games);
    $log->debug("Game count: ", $game_count);
    my $game_num = 0;

    while ($game_num < $game_count) {
        my $game = $games[$game_num]; #store individual game key
        my $gamedate = substr($game,0,8); #extract date of game
        my $game_stat = $perldata->{$game}->{'qtr'}; #If defined = Pregame, qtr #, or Final.  Undefined = Upcoming game.    
        my $game_time = $perldata->{$game}->{'clock'}; #  
        my $clock_time = $game_time; 
        my $away_team = $perldata->{$game}->{'away'}->{'abbr'};
        my $home_team = $perldata->{$game}->{'home'}->{'abbr'};
        my $away_score = $perldata->{$game}->{'away'}->{'score'}->{'T'};
        my $home_score = $perldata->{$game}->{'home'}->{'score'}->{'T'};
        my $NFLteamMap = '';
        my $away_team_name = $NFLteamMap{$away_team};
        my $home_team_name = $NFLteamMap{$home_team};
        my $tv_network = $perldata->{$game}->{'media'}->{'tv'};
        $log->debug("Game#: ", $game_num);
        $log->debug("GameID: ", $game);
        $log->debug("Gamedate: ", $gamedate);
        if ($game_stat) {
            $log->debug("Status: ", $game_stat);
        }
        $log->debug($away_team, " @ ", $home_team);
        
        if ($gamedate eq $today) { # Only display games occuring today
            
            if ($game_stat =~ m/\d/) { # Active game -- Consider checking for "Pregame" ???
                $log->debug("Active game");
                $clock_time = $game_time." ".$game_stat; 
            }
            elsif ($game_stat eq "Halftime") {
                $log->debug("Active game - Halftime");
                $clock_time = $game_stat;
            }
            elsif ($game_stat eq 'Game Over' or $game_stat =~ /Final/i){ #Finished game
                $log->debug("Finished game");
                $clock_time = 'Final'; 
                if ($game_stat =~ /overtime/i) {
                    $log->debug("Overtime");
                    $clock_time = 'Final OT';
                }
            }
            else { # upcoming games
                $log->debug("Upcoming game");
                $away_score = '';
                $home_score = '';
                $clock_time = $NFLupTime{$game};
                $log->debug($clock_time);
            }

            my $home_logo = lc($home_team);
            my $away_logo = lc($away_team);
            $home_logo = 'http://a.espncdn.com/combiner/i?img=/i/teamlogos/nfl/500/' . $home_logo . '.png';     
            $away_logo = 'http://a.espncdn.com/combiner/i?img=/i/teamlogos/nfl/500/' . $away_logo . '.png';
            
            $log->debug("Status: " . $game_stat . " ");
            $log->debug("Game time: " . $game_time . " ");
            $log->debug("Clock: ", $clock_time);
            $log->debug("CClock: ", convertTime($clock_time));
            $log->debug("Away team & score: ", $away_team, " " , $away_score);
            $log->debug("Home team & score: ", $home_team, " ", $home_score);
            $log->debug("Home logo URL = " . $home_logo);
            $log->debug("Away logo URL = " . $away_logo);

            $sportsData{'NFL'}{$home_team.$clock_time}{'homeTeamCK'}  =$home_team;
            $sportsData{'NFL'}{$home_team.$clock_time}{'awayTeamCK'}  =$away_team;
            $sportsData{'NFL'}{$home_team.$clock_time}{'homeTeam'}  =$home_team_name;
            $sportsData{'NFL'}{$home_team.$clock_time}{'awayTeam'}  =$away_team_name;
            $sportsData{'NFL'}{$home_team.$clock_time}{'awayScore'} =$away_score;
            $sportsData{'NFL'}{$home_team.$clock_time}{'homeScore'} =$home_score;
            $sportsData{'NFL'}{$home_team.$clock_time}{'gameTime'}  =convertTime($clock_time);
            $sportsData{'NFL'}{$home_team.$clock_time}{'homeLogoURL'} = $home_logo;
            $sportsData{'NFL'}{$home_team.$clock_time}{'awayLogoURL'} = $away_logo;
            $sportsData{'NFL'}{$home_team.$clock_time}{'gameLogoURL'} = $home_logo;
        
            if ((teamCheck($home_team,\@NFLteams)==1) || (teamCheck($away_team,\@NFLteams)==1)) {
                displayLines($client, $clock_time, $away_team_name, $home_team_name, $away_score, $home_score, 'NFL ('.$tv_network.')', 'getNFL', \&shortenNFL, \%NFLmap);
            }
        }
        $log->debug(" "); #To improve log file readability - add line between games
        $game_num++ ;
    }
    $NFL_HTML = '';
    refreshData(undef, $client, $refreshItem);  
}

sub convertTime {
    my $gametime = shift;
    $log->debug("Incoming time = $gametime");
    my $hour = 0;
    my $minute = 0;
    my $ampm = '';
    my $offset = $prefs->get('offset');
    
    if ($gametime =~ /(\d+:\d+), (\d+).*Period/) { #Active NHL game
        $gametime = $1 . '/' . $2;
    }
    elsif (($gametime =~ /(\d+).*End/)||($gametime =~ /End (\d+)/)) { #NHL/NFL/CFB game, end of qtr/per
        $gametime = 'E'.$1;
    }
    elsif ($gametime =~ /(\d+):(\d+)\s*(\d*ot)/i) { #Time remaining in OT
        $hour = $1;
        $minute = $2;
        my $ot = uc($3);
        $gametime = $hour . ':' . $minute . "/" . $ot;
    }
    elsif ($gametime =~ /Final.(\d+)OT/i) { #CFB Multiple OT Final
        $gametime = 'F/' . $1.'OT';
    }
    elsif ($gametime =~ /(\d+)OT/i) { #CFB Multiple OT Active
        $gametime = $1.'OT';
    }
    elsif ($gametime =~ /Final.*(SO|OT)/i) { #OT Final or NHL Sudden OT Final 
        $gametime = 'F/' . $1;
    }
    elsif ($gametime =~ /(\D)\D+(\d+)/) { #Active MLB game, shorten inning info
        $gametime = $1 . $2;
    }
    elsif ($gametime =~ /(\d*\d+:\d\d) (\d)/) { #Active NFL game
        $gametime = $1 . '/' . $2;
    }
    elsif ($gametime =~ /(\d*\d+\.\d) (\d)/) { #Last seconds of NBA period
        $gametime = $1 . '/' . $2;
    }
    elsif ($gametime =~ /(\d+):(\d+)\s*(\d*ot)/i) { #Time remaining in OT
        $hour = $1;
        $minute = $2;
        my $ot = uc($3);
        $gametime = $hour . ':' . $minute . "/" . $ot;
    }
    elsif ($gametime =~ /OT/) { #CFB OT Active
        $gametime = 'OT';
    }
    elsif ($gametime =~ /(\d+):(\d+)\s*(\w\w)/) { #Future game, convert timezone
        $hour = $1;
        $minute = $2;
        $ampm = lc($3);
        while ($offset != 0) {
            if ($offset >0) {
                $offset = $offset -1;
                $hour = $hour +1;
                if ($hour == 13) {
                    $hour = 1;
                }
                elsif ($hour == 12) {
                    if ($ampm eq 'am') {
                        $ampm = 'pm';
                    }
                    else {
                        $ampm = 'am';
                    }
                }
            }
            else {
                $offset = $offset +1;
                    $hour = $hour -1;
                    if ($hour == 0) {
                    $hour = 12;
                }
                elsif ($hour == 11) {
                    if ($ampm eq 'am') {
                        $ampm = 'pm';
                    }
                    else {
                        $ampm = 'am';
                    }
                }
            }
        } 
        #$gametime = $hour . ':' . $minute . $ampm;
        if ($ampm eq 'pm' && $hour != 12) {
            $hour = $hour + 12;
        }
        elsif ($ampm eq 'am' && $hour == 12) { #Midnight
            $hour = 0;
        }
        $gametime = Slim::Utils::DateTime::timeF(timelocal(0,$minute,$hour,1,1,2010));
    }
    elsif ($gametime =~ /TBA/i) {
        $gametime = 'TBA';
    }
    elsif ($gametime =~ /(\D)\D.*/) { #Final or Delayed MLB game
        $gametime = $1;
    }
    $log->debug("Converted Gametime = $gametime");
    return $gametime;
}

sub shortenMLB {
  #No MLB teams need shortening?
  my $long = shift;

  return $long;
}

sub shortenNBA {
  my $long = shift;
  
  if( $long eq "Timberwolves" ) {
      $long = "TWolves";
  } elsif( $long eq "Trail Blazers" ) {
      $long = "TBlazers";
  }

  return $long;
}

sub shortenCBB {
    my $long = shift;
  
#   YOU CAN MODIFY THIS LIKE THE EXAMPLE BELOW TO SHORTEN YOUR TEAM NAMES...
    if ($long =~ m/^Illinois$/) { $long = 'Illini';}
    elsif ($long=~ m/^Notre Dame/) { $long = 'ND';}
    elsif ($long=~ m/^Southern Methodist/) { $long = 'SMU';}
    elsif ($long=~ m/^Ohio State/) { $long = 'OSU';}
    elsif ($long=~ m/^Washington State/) { $long = 'WSU';}
    elsif ($long=~ m/^Boston College/) { $long = 'BC';}
    elsif ($long=~ m/^Wisconsin$/) { $long = 'Wisc.';}
    elsif ($long=~ m/^Bowling Green$/) { $long = 'BGSU';}
    elsif ($long=~ m/^Brigham Young/) { $long = 'BYU';}
    elsif ($long=~ m/^Northwestern/) { $long = 'NW';}
    elsif ($long=~ m/^San Diego State/) { $long = 'SDSU';}
    elsif ($long=~ m/^San Jose State/) { $long = 'SJSU';}

    return $long;
}

sub shortenCFB {
    my $long = shift;
  
#   YOU CAN MODIFY THIS LIKE THE EXAMPLES BELOW TO SHORTEN YOUR TEAM NAMES...
    if ($long =~ m/^Illinois$/) { $long = 'Illini';}
    elsif ($long=~ m/^Notre Dame/) { $long = 'ND';}
    elsif ($long=~ m/^Southern Methodist/) { $long = 'SMU';}
    elsif ($long=~ m/^Ohio State/) { $long = 'OSU';}
    elsif ($long=~ m/^Washington State/) { $long = 'WSU';}
    elsif ($long=~ m/^Boston College/) { $long = 'BC';}
    elsif ($long=~ m/^Wisconsin$/) { $long = 'Wisc.';}
    elsif ($long=~ m/^Bowling Green$/) { $long = 'BGSU';}
    elsif ($long=~ m/^Brigham Young/) { $long = 'BYU';}
    elsif ($long=~ m/^Northwestern/) { $long = 'NW';}
    elsif ($long=~ m/^San Diego State/) { $long = 'SDSU';}
    elsif ($long=~ m/^San Jose State/) { $long = 'SJSU';}

    return $long;
}

sub shortenNHL {
    my $long = shift;
  
    if ($long =~ m/^Vancouver/) { $long = 'Canucks';}
    elsif ($long=~ m/^Edmonton/) { $long = 'Oilers';}
    elsif ($long =~ m/^New Jersey/) { $long = 'Devils';}
    elsif ($long =~ m/^NY Rangers/) { $long = 'Rangers';}
    elsif ($long =~ m/^Philadelphia/) { $long = 'Flyers';}
    elsif ($long =~ m/^NY Islanders/) { $long = 'Islanders';}
    elsif ($long =~ m/^Pittsburgh/) { $long = 'Penguins';}
    #elsif ($long =~ m/^Montreal/) { $long = 'Canadiens';}
    #elsif ($long =~ m/^Ottawa/) { $long = 'Senators';}
    elsif ($long =~ m/^Buffalo/) { $long = 'Sabres';}
    elsif ($long =~ m/^Boston/) { $long = 'Bruins';}
    #elsif ($long =~ m/^Toronto/) { $long = 'Maple Leafs';}
    #elsif ($long =~ m/^Florida/) { $long = 'Panthers';}
    #elsif ($long =~ m/^Atlanta/) { $long = 'Thrashers';}
    #elsif ($long =~ m/^Tampa Bay/) { $long = 'Lightning';}
    elsif ($long =~ m/^Washington/) { $long = 'Capitals';}
    #elsif ($long =~ m/^Carolina/) { $long = 'Hurricanes';}
    #elsif ($long =~ m/^Detroit/) { $long = 'Red Wings';}
    #elsif ($long =~ m/^Nashville/) { $long = 'Predators';}
    #elsif ($long =~ m/^Chicago/) { $long = 'Black Hawks';}
    #elsif ($long =~ m/^Columbus/) { $long = 'Blue Jackets';}
    elsif ($long =~ m/^St. Louis/) { $long = 'Blues';}
    elsif ($long =~ m/^Minnesota/) { $long = 'Wild';}
    #elsif ($long =~ m/^Colorado/) { $long = 'Avalanche';}
    elsif ($long =~ m/^Calgary/) { $long = 'Flames';}
    elsif ($long =~ m/^Anaheim/) { $long = 'Ducks';}
    elsif ($long =~ m/^Dallas/) { $long = 'Stars';}
    elsif ($long =~ m/^Los Angeles/) { $long = 'Kings';}
    elsif ($long =~ m/^San Jose/) { $long = 'Sharks';}
    #elsif ($long =~ m/^Phoenix/) { $long = 'Coyotes';}
    
    return $long;
}

sub shortenNFL {
  my $long = shift;
  
  if ($long =~ m/^Chicago/) { $long = 'Bears';}
  elsif ($long=~ m/^Green Bay/) { $long = 'Packers';}
  elsif ($long=~ m/^Indianapolis/) { $long = 'Colts';}
  elsif ($long=~ m/^Philadelphia/) { $long = 'Eagles';}
  elsif ($long=~ m/^Pittsburgh/) { $long = 'Steelers';}
  elsif ($long=~ m/^New Orleans/) { $long = 'Saints';}
  elsif ($long=~ m/^New England/) { $long = 'Patriots';}
  elsif ($long=~ m/^San Francisco/) { $long = '49ers';}
  elsif ($long=~ m/^Jacksonville/) { $long = 'Jaguars';}
  elsif ($long=~ m/^Tennessee/) { $long = 'Titans';}
  #elsif ($long=~ m/^Tampa Bay/) { $long = 'Buccaneers';}
  elsif ($long=~ m/^Washington/) { $long = 'Redskins';}
  elsif ($long=~ m/^New York Jets/) { $long = 'Jets';}
  elsif ($long=~ m/^New York Giants/) { $long = 'Giants';}
  elsif ($long=~ m/^Cleveland/) { $long = 'Browns';}
  elsif ($long=~ m/^St. Louis/) { $long = 'Rams';}
  elsif ($long=~ m/^Kansas City/) { $long = 'Chiefs';}
  elsif ($long=~ m/^Minnesota/) { $long = 'Vikings';}
  elsif ($long=~ m/^Baltimore/) { $long = 'Ravens';}
  elsif ($long=~ m/^Buffalo/) { $long = 'Bills';}
  elsif ($long=~ m/^Houston/) { $long = 'Texans';}


  return $long;
}

sub setMode() {
    my $class  = shift;
    my $client = shift;

    $client->lines(\&lines);

    # setting this param will call client->update() frequently
    $client->modeParam('modeUpdateInterval', 1); # seconds

}

sub getFunctions {
    return {
        'up' => sub  {
            my $client = shift;
            my $button = shift;
            $client->bumpUp() if ($button !~ /repeat/);
        },
        'down' => sub  {
            my $client = shift;
            my $button = shift;
            $client->bumpDown() if ($button !~ /repeat/);;
        },
        'left' => sub  {
            my $client = shift;
            Slim::Buttons::Common::popModeRight($client);
        },
        'right' => sub  {
            my $client = shift;
            
            my $saver = Slim::Player::Source::playmode($client) eq 'play' ? 'screensaver' : 'idlesaver';
        
            if ($prefs->client($client)->get($saver) ne 'SCREENSAVER.superdatetime') {
                $prefs->client($client)->set($saver,'SCREENSAVER.superdatetime');
            } else {
                $prefs->client($client)->set($saver, $Slim::Player::Player::defaultPrefs->{$saver});
            }
        },
        'stop' => sub {
            my $client = shift;
            Slim::Buttons::Common::pushMode($client, 'SCREENSAVER.superdatetime');
        },
        'showme' => sub { #Function to force screensaver into screensaver mode
            my $client = shift;
            Slim::Buttons::Common::pushMode($client, 'SCREENSAVER.superdatetime');
        }   
    };
}

sub lines {
    my $client = shift;
    
    my $saver = Slim::Player::Source::playmode($client) eq 'play' ? 'screensaver' : 'idlesaver';
    my $line2 = $client->string('SETUP_SCREENSAVER_USE');
    my $overlay2 = Slim::Buttons::Common::checkBoxOverlay($client, $prefs->client($client)->get($saver) eq 'SCREENSAVER.superdatetime');
    
    return {
        'line'    => [ $client->string('PLUGIN_SCREENSAVER_SUPERDATETIME'), $line2 ],
        'overlay' => [ undef, $overlay2 ]
    };
}

our %screensaverSuperDateTimeFunctions = (
    'done' => sub  {
                    my ($client, $funct, $functarg) = @_;
                    Slim::Buttons::Common::popMode($client);
                    $client->update();
                    #pass along ir code to new mode if requested
                    if (defined $functarg && $functarg eq 'passback') {
                        Slim::Hardware::IR::resendButton($client);
                    }
    },
    'up' => sub  {
        my $client = shift;
        
        $weathershowing{$client} = (); #Reset weather showing in case up was hit while displaying weather
        
        if ($scrollType{$client} eq 'Ticker') { #Set flag to reset out of ticker mode
            $killTicker{$client} = 1;
        }
        
        if ($nowshowing{$client}{'itemNum'} == 0) { #Is the time currently showing?
            if($topNowShowing{$client} == (scalar @{$displayInfo{$client}{'TOPdisplayItems1'}}-1)) {
                $topNowShowing{$client} = 0;
            }
            else {
                $topNowShowing{$client}++;
            }
        }
        else {
            $nowshowing{$client}{'itemNum'} = 0; #Show the time
        }
        
        killClientTimers($client);
        Slim::Utils::Timers::setTimer($client, Time::HiRes::time() + 10, \&nextDisplayItem);
                
        $client->update(); #Refresh the display
    },
    'down' => sub  {
        my $client = shift;
        
        $weathershowing{$client} = (); #Reset weather showing in case down was hit while displaying weather

        if ($scrollType{$client} eq 'Ticker') { #Set flag to reset out of ticker mode
            $killTicker{$client} = 1;
        }
        
        if ($nowshowing{$client}{'itemNum'} == 0) { #Is the time currently showing?
            if($topNowShowing{$client} == 0) {
                $topNowShowing{$client} = scalar @{$displayInfo{$client}{'TOPdisplayItems1'}}-1;
            }
            else {
                $topNowShowing{$client}--;
            }
        }
        else {
            $nowshowing{$client}{'itemNum'} = 0; #Show the time
        }
        
        killClientTimers($client);          
        Slim::Utils::Timers::setTimer($client, Time::HiRes::time() + 10, \&nextDisplayItem);    
        
        $client->update(); #Refresh the display
    },
    'down.hold' => sub  {
        my $client = shift;
        
        $weathershowing{$client} = 1; #Reset weather showing in case up was hit while displaying weather
        
        if ($scrollType{$client} eq 'Ticker') { #Set flag to reset out of ticker mode
            $killTicker{$client} = 1;
        }
        
        if ($nowshowing{$client}{'itemNum'} == 0) { #Is the time currently showing?
            $topNowShowing{$client} = 0;
        }
        else {
            $nowshowing{$client}{'itemNum'} = 0; #Show the time
        }
        
        killClientTimers($client);
        Slim::Utils::Timers::setTimer($client, Time::HiRes::time() + 10, \&nextDisplayItem);
                
        $client->update(); #Refresh the display
    },  
    'refresh' => sub  {
        my $client = shift;

        $client->showBriefly( {
            line => ['Refreshing data...']
        },
        {
            scroll => 1,
            block  => 1,
        } );        

        Slim::Utils::Timers::killTimers(undef, \&refreshData);
        $averages{'last'} = ''; #Make sure averages/10day will get refreshed too
        refreshData(undef, $client, -1);
    },  
    'wnext' => sub  {
        my $client = shift;

        if (scalar @WETdisplayItems2 >0) { #Make sure there are some long forecasts to show
            killClientTimers($client);
            nextWeatherItem($client,1);
        }
        else {
            $client->bumpLeft();
        }
    },
    'wprev' => sub  {
        my $client = shift;
        
        if (scalar @WETdisplayItems2 >0) { #Make sure there are some long forecasts to show
            killClientTimers($client);
            nextWeatherItem($client,-1);
        }
        else {
            $client->bumpRight();
        }
    },  
    'right' => sub  {
        my $client = shift;
        
        if (totalGames() >0) { #Are there display items?
            killClientTimers($client);
            nextDisplayItem($client);
        }
        else {
            $client->bumpLeft();
        }
        
    },  
    'left' => sub  {
        my $client = shift;

        if (totalGames() >0) { #Are there display items?
            killClientTimers($client);
            prevDisplayItem($client);
        }
        else {
            $client->bumpRight();
        }
    },
    'size.hold' => sub  {
        my $client = shift;
        if ($client->power()) { #Client power is on
            Slim::Buttons::Common::popModeRight($client); #Bring client back to where they were b4 screensaver
        }
    },  
    
);

sub currentWeatherInterval {
    if (scalar @WETdisplayItems2 > 0) {
        my $lweather = $prefs->get('lweather');
        if ($lweather == 4) {
            return 1;
        }
        elsif ($lweather == 5) {
            return 5;
        }
        elsif ($activeGames == 1 && $lweather == 2) {
            return 1;
        }
        elsif ($activeGames == 0 && $lweather == 3) {
            return 1;
        }
        else {
            return 0;
        }
    }
    else {
        return 0;
    }
}

sub totalGames {
    my $total = 0;
    
    if (defined $displayInfo{'cycleItems1'}) {
        $total = scalar @{$displayInfo{'cycleItems1'}};
    }

    return $total;  
}

sub getScreensaverSuperDatetime {

    return \%screensaverSuperDateTimeFunctions;
}

sub setScreensaverSuperDateTimeMode() {
    my $client = shift;
    
    my $key;
    my $value;
    $killTicker{$client} = 0;
    
    if( $client && $client->isa( "Slim::Player::Squeezebox2")) {
        while (($key, $value) = each(%NFLmap)){ #Store NFL team icons as a special font.
            Slim::Display::Graphics::setCustomChar( 'getNFL-'.$value, chr(hex $value), 'nfl.2' );
        }
    
        while (($key, $value) = each(%MLBmap)){ #Store MLB team icons as a special font.
            Slim::Display::Graphics::setCustomChar( 'getMLB-'.$value, chr(hex $value), 'mlb.2' );
            $log->debug("Setting the graphic MLB icon: ". $key . " " . $value); 
        }
    
        #Add 'special' character for spacing
        Slim::Display::Graphics::setCustomChar( 'getMLB-41', chr(hex 41), 'mlb.2' );
        
        $Gclient = $client; #capture the graphical client for use in the refreshData routine.
    }
    
    $activeClients++;

    #Set default for top line per client
    if ($prefs->client($client)->get('topNowShowing') ne '') {
        $topNowShowing{$client} = $prefs->client($client)->get('topNowShowing');
    }
    else {
        $topNowShowing{$client} = 1;
        $prefs->client($client)->set('topNowShowing', 1);
    }

    refreshPlayerSettings(undef, $client);

    if ($activeClients == 1) {
        Slim::Utils::Timers::killTimers(undef, \&refreshData); #Just in case there's a rogue timer
        Slim::Utils::Timers::setTimer(undef, Time::HiRes::time() + 6, \&refreshData, $client, -1);
    }

    $nowshowing{$client}{'itemNum'} = 0; #Start on time display
    Slim::Utils::Timers::setTimer($client, Time::HiRes::time() + 10, \&nextDisplayItem);
            
    $client->lines(\&screensaverSuperDateTimelines);
    
    #Slim::Utils::Timers::listTimers();
    # setting this param will call client->update() frequently
    $client->modeParam('modeUpdateInterval', 1); # seconds #7.0

    #Graphical forecasts code...
    # get display size for player if at least Squeezebox2
    if( $client && $client->isa( "Slim::Player::Squeezebox2")) {
        $xmax{$client} = $client->display()->displayWidth();
        $ymax{$client} = $client->display()->bytesPerColumn() * 8;
        
        $log->debug("Found graphic display $xmax{$client} x $ymax{$client} ($client)");
    }
    # only use text on SqueezeboxG and SLIMP3
    else {
        $xmax{$client} = 0;
        $ymax{$client} = 0;
    }
        
    if (scalar $displayInfo{$client}{'forecastG'}==0 && ($client->display->vfdmodel() eq Slim::Display::Squeezebox2->vfdmodel())) {  #Only set the weather channel logo the first time
        clearCanvas($client); #Show weatherchannel logo at startup
        drawIcon($client,29,$ymax{$client}-1,$TWClogo);;
        $displayInfo{$client}{'forecastG'}[0] = getFramebuf($client,75); #75 gfx width
        $displayInfo{$client}{'forecastG'}[1] = $displayInfo{$client}{'forecastG'}[0];
        $displayInfo{$client}{'forecastG'}[2] = $displayInfo{$client}{'forecastG'}[0];
        $displayInfo{$client}{'forecastG'}[3] = $displayInfo{$client}{'forecastG'}[0];
    }
}

sub leaveScreensaverSuperDateTimeMode {
    my $client = shift;
    
    #Save top showing preference incase server is shut down
    $prefs->client($client)->set('topNowShowing', $topNowShowing{$client});
    
    $activeClients--;
    
    if ($activeClients == 0) {
        Slim::Utils::Timers::killTimers(undef, \&refreshData);
    }
    
    killClientTimers($client);
    Slim::Utils::Timers::killTimers($client, \&_flashAlarm);
}

sub gotErrorViaHTTP {
    my $http = shift;
    my $params = $http->params();
    my $caller = $params->{'caller'};
    my $callerProc = $params->{'callerProc'};
    my $client = $params->{'client'};
    my $refreshItem = $params->{'refreshItem'};

    $log->warn("error getting " . $http->url());
    $log->warn($http->error());
    $errorCount++;

    if ($errorCount >10) {
        $log->warn("Network error count reached during $caller.");
        $status = '?';
        saveCycles($caller);
        refreshData(undef, $client, $refreshItem);
    }
    elsif ($caller eq "getAverages") {#Special case
        $log->info("Trying getAverages again.");
        getAverages($params->{'dayNum'}, $client, $refreshItem);
    }
    elsif (defined $callerProc) {
        $log->info("Trying $caller again.");    
        Slim::Utils::Timers::setTimer(undef, Time::HiRes::time() + 3, $callerProc, $client, $refreshItem);
    }
}

sub nextWeatherItem {
    my $client = shift;
    my $caller = shift;
    
    $killTicker{$client} = 3;

    if (defined $weathershowing{$client}) {
        if ($caller == -1) {
            if ($weathershowing{$client} == 1) {
                $weathershowing{$client} = scalar @WETdisplayItems1;
            }
            else {
                $weathershowing{$client}--;
            }
        }
        else {
            if ($weathershowing{$client} == scalar @WETdisplayItems1) {
                $weathershowing{$client} = 1;
            }
            else {
                $weathershowing{$client}++;
            }
        }
    }
    else {
        if ($caller == -1) {
            $weathershowing{$client} = scalar @WETdisplayItems1;
        }
        else {
            $weathershowing{$client} = 1;
        }
    }
    $displayLine1{$client} = $WETdisplayItems1[$weathershowing{$client}-1];
    $displayLine2{$client} = $WETdisplayItems2[$weathershowing{$client}-1];
    $nowshowing{$client}{'itemNum'} = -1; #Don't display the time...

    if ($weathershowing{$client} == scalar @WETdisplayItems1) {
        #Need to give time for display lines to be called (+2)
        Slim::Utils::Timers::setTimer($client, Time::HiRes::time() + 2, \&setWeatherTimer,2);
    }
    else {
        #Need to give time for display lines to be called (+2)
        Slim::Utils::Timers::setTimer($client, Time::HiRes::time() + 2, \&setWeatherTimer,1);
    }

    #Update display
    if ($scrollType{$client} eq 'Basic') {
        $client->update(); #Refresh the display
    }
    else {
        if ($caller == -1) {
            if ($client->display->hasScreen2()) {
                my $prevHash = $client->curDisplay();
                delete $prevHash->{'screen1'};
                    
                my $hash = $client->curLines();
                delete $hash->{'screen1'};
                $client->pushRight($prevHash, $hash);
            }
            else {
                $client->pushRight();
            }
        }
        else {
            if ($client->display->hasScreen2()) {
                my $prevHash = $client->curDisplay();
                delete $prevHash->{'screen1'};
                    
                my $hash = $client->curLines();
                delete $hash->{'screen1'};
                $client->pushLeft($prevHash, $hash);
            }
            else {
                $client->pushLeft();
            }
        }
    }   
}

sub nextDisplayItem {
    my $client = shift;
    my $timerInterval = 0;
    $nowshowing{$client}{'justify'} = 'center'; #Default

    if ($nowshowing{$client}{'itemNum'} < 0) {#Showing weather
        $nowshowing{$client}{'itemNum'} = 0;
        $timerInterval = $showtime;
    }
    elsif (defined($displayInfo{'cycleItems1'}[$nowshowing{$client}{'itemNum'}])) {
        $displayLine1{$client} = $displayInfo{'cycleItems1'}[$nowshowing{$client}{'itemNum'}];
        $displayLine2{$client} = $displayInfo{'cycleItems2'}[$nowshowing{$client}{'itemNum'}];
        $timerInterval = $displayInfo{'cycleInts'}[$nowshowing{$client}{'itemNum'}];
        
        #Special logic to left justify text so that it scrolls
        if ($timerInterval eq 'L') {
            $timerInterval = 5; #Set a min to show in case it's less than a full line of text, make this configurable or L5 (left 5sec minimum)Make sure at least 3seconds???
            $nowshowing{$client}{'justify'} = 'line';
        }

        $nowshowing{$client}{'itemNum'}++;
    }
    else { #TIME
        $nowshowing{$client}{'itemNum'} = 0;
        
        if (($activeGames == 1) && ($showactivetime == 0)) { #Don't show time when active games
            return nextDisplayItem($client);
        }
        #This probably needs to be re-evaluated...
        elsif ((($activeGames == 0) && ($showtime == 0)) && #Don't show time when no active games
                ((totalGames() + scalar @WETdisplayItems2) >0)) #make sure there are some games to show
        { 
            return nextDisplayItem($client);
        }
        else { #Show the time
            if ($activeGames == 0) {
                $timerInterval = $showtime;
            }
            else {
                $timerInterval = $showactivetime;
            }
        }       
    }
        
    if ($scrollType{$client} eq 'Ticker' && $killTicker{$client} == 0) {
        my $tickerScreen;
        if ($client->display->hasScreen2()) {
            $tickerScreen = 2;
        }
        else {
            $tickerScreen = 1;
        }
        
        my ($complete, $queue) = $client->scrollTickerTimeLeft($tickerScreen);
        if ($nowshowing{$client}{'itemNum'} == 0) {  #NEED TO ONLY OCCUR IF TICKER MODE
            #Why do we include timerinterval in this???
            Slim::Utils::Timers::setTimer($client, Time::HiRes::time() + $timerInterval + $complete, \&nextDisplayItem);
        }
    }
   else {
        #Make sure there are items besides the time showing
        if (totalGames() >0) {
            #Update display
            if ($scrollType{$client} eq 'Basic') {
                $client->update(); #Refresh the display
            }
            else {              
                if ($client->display->hasScreen2()) {
                    my $prevHash = $client->curDisplay();
                    delete $prevHash->{'screen1'};
                    
                    my $hash = $client->curLines();
                    delete $hash->{'screen1'};
                    $client->pushLeft($prevHash, $hash);
                }
                else {
                    $client->pushLeft();
                }               
            }
        }

        if ($nowshowing{$client}{'itemNum'} < 0) { #Weather forecast
            #Need to give time for display lines to be called (+2)
            Slim::Utils::Timers::setTimer($client, Time::HiRes::time() + 2.5, \&setWeatherTimer);
        }
        elsif ($nowshowing{$client}{'justify'} eq 'line'){
            #Want to give enough time to text to scroll, but have to set a timer to wait for it to actually start scrolling
            #Should we add a min check for anything or just pass in what they specify as the minimum???
            Slim::Utils::Timers::setTimer($client, Time::HiRes::time() + 2.5, \&setLongTextTimer);
        }
        else {
            Slim::Utils::Timers::setTimer($client, Time::HiRes::time() + $timerInterval, \&nextDisplayItem);
        }
    }

    $killTicker{$client} = 0;
}

sub setWeatherTimer {
    #This creates a timer to set the nextDisplayItem timer for a weather forecast.
    #This is necessary because display length is based on how long it takes to scroll...
    my $client = shift;
    my $caller = shift;
    
    my $tickerScreen;
    if ($client->display->hasScreen2()) {
        $tickerScreen = 2;
    }
    else {
        $tickerScreen = 1;
    }   
    my ($complete, $queue) = $client->scrollTickerTimeLeft($tickerScreen);
    
    if ($caller == 1) { #User viewing weather via fast forward/reverse buttons
        Slim::Utils::Timers::setTimer($client, Time::HiRes::time() + $complete + preferences('server')->client($client)->get('scrollPause'), \&nextWeatherItem);
    }
    elsif ($caller == 2) { #User viewing weather via fast forward/reverse buttons and at last item
        Slim::Utils::Timers::setTimer($client, Time::HiRes::time() + $complete + preferences('server')->client($client)->get('scrollPause'), \&nextDisplayItem);
    }
    else { #Viewing weather forecast via left/right buttons or regular display intervals
        Slim::Utils::Timers::setTimer($client, Time::HiRes::time() + $complete + preferences('server')->client($client)->get('scrollPause'), \&nextDisplayItem);
    }
}

sub setLongTextTimer {
    #This creates a timer to set the nextDisplayItem timer for a long text item
    #This is necessary because display length is based on how long it takes to scroll...
    my $client = shift;
    
    my $tickerScreen;
    if ($client->display->hasScreen2()) {
        $tickerScreen = 2;
    }
    else {
        $tickerScreen = 1;
    }   
    
    my ($complete, $queue) = $client->scrollTickerTimeLeft($tickerScreen);
    #Need to add some logic for min length
    Slim::Utils::Timers::setTimer($client, Time::HiRes::time() + $complete + preferences('server')->client($client)->get('scrollPause'), \&nextDisplayItem);
}

#Used during ticker display mode to set the top display line to the text at halfway point
sub topLineSet {

    my $client = shift;
    my $topLine = shift;
    
    $tickline1{$client} = $topLine; 
}

sub prevDisplayItem {
    my $client = shift;
    my $timerInterval;

    $nowshowing{$client}{'justify'} = 'center'; #Default

    if ($nowshowing{$client}{'itemNum'} == 0) {
        if (defined($displayInfo{'cycleItems1'})) {
            $nowshowing{$client}{'itemNum'} = scalar @{$displayInfo{'cycleOrigin'}};
            $displayLine1{$client} = $displayInfo{'cycleItems1'}[$nowshowing{$client}{'itemNum'}-1];
            $displayLine2{$client} = $displayInfo{'cycleItems2'}[$nowshowing{$client}{'itemNum'}-1];
            $timerInterval = $displayInfo{'cycleInts'}[$nowshowing{$client}{'itemNum'}-1];

            #Special logic to left justify text so that it scrolls
            if ($timerInterval eq 'L') {
                $timerInterval = 5; #Set a min to show in case it's less than a full line of text, make this configurable or L5 (left 5sec minimum)Make sure at least 3seconds???
                $nowshowing{$client}{'justify'} = 'line';
            }
        }
        else {
            $timerInterval = 10;
        }
    }
    elsif ($nowshowing{$client}{'itemNum'} <= 1) {
        $nowshowing{$client}{'itemNum'} = 0;
        
        if ($activeGames == 0) {
            $timerInterval = $showtime;
        }
        else {
            $timerInterval = $showactivetime;
        }                               
    }
    else {
        $nowshowing{$client}{'itemNum'}--;
        $displayLine1{$client} = $displayInfo{'cycleItems1'}[$nowshowing{$client}{'itemNum'}-1];
        $displayLine2{$client} = $displayInfo{'cycleItems2'}[$nowshowing{$client}{'itemNum'}-1];
        $timerInterval = $displayInfo{'cycleInts'}[$nowshowing{$client}{'itemNum'}-1];  

        #Special logic to left justify text so that it scrolls
        if ($timerInterval eq 'L') {
            $timerInterval = 5; #Set a min to show in case it's less than a full line of text, make this configurable or L5 (left 5sec minimum)Make sure at least 3seconds???
            $nowshowing{$client}{'justify'} = 'line';
        }
    }

    #Update display
    if ($scrollType{$client} eq 'Basic') {
        $client->update(); #Refresh the display
    }
    else {
        if ($client->display->hasScreen2()) {
            my $hash = screensaverSuperDateTimelines($client);
            delete $hash->{'screen1'};
            #my $curHash = $client->curDisplay();
            #delete $curHash->{'screen2'};
            $client->pushRight(undef, $hash);
        }
        else {
            $client->pushRight();
        }
    }

    if ($nowshowing{$client}{'itemNum'} < 0) { #Weather forecast
        #Need to give time for display lines to be called (+2)
        Slim::Utils::Timers::setTimer($client, Time::HiRes::time() + 2, \&setWeatherTimer);
    }
    elsif ($nowshowing{$client}{'justify'} eq 'line'){
        #Want to give enough time to text to scroll, but have to set a timer to wait for it to actually start scrolling
        Slim::Utils::Timers::setTimer($client, Time::HiRes::time() + 2.5, \&setLongTextTimer);
    }   
    else {
        Slim::Utils::Timers::setTimer($client, Time::HiRes::time() + $timerInterval, \&nextDisplayItem);
    }
}

sub killClientTimers {
    my $client = shift;

    Slim::Utils::Timers::killTimers($client, \&nextWeatherItem);
    Slim::Utils::Timers::killTimers($client, \&setWeatherTimer);
    Slim::Utils::Timers::killTimers($client, \&nextDisplayItem);
    Slim::Utils::Timers::killTimers($client, \&setLongTextTimer);
    Slim::Utils::Timers::killTimers($client, \&topLineSet);
}

sub clearCanvas {
    my $client = shift;

    for( my $xi = 0; $xi < $xmax{$client}; $xi++) {
        for( my $yi = 0; $yi < $ymax{$client}; $yi++) {
            $hashDisp{$client}[$xi][$yi] = 0;
        }
    }
}

sub drawIcon {
    my $client = shift;
    my $xpos = shift;
    my $ypos = shift;
    my $icon = shift;

    if ($xmax{$client} && $ymax{$client}) {
        my $firstline = 1;
        my $xs = $xpos < 0 ? 0 : $xpos;
        my $yi = $ypos > $ymax{$client} ? $ymax{$client} : $ypos;
        for my $line (split('\n',$icon)) {
            # first line must be skipped (empty)
            if ($firstline) {
                $firstline = 0;
                next;
            }
            chomp $line;
            for( my $xi = $xs; $xi < length($line)+$xs && $xi < $xmax{$client} && $yi >= 0; $xi++) {
                if (substr($line,$xi-$xs,1) eq "*") {
                    $hashDisp{$client}[$xi][$yi] = 1;
                }
            }
            $yi--;
        }
    }
}

sub drawText {
    my $client = shift;
    my $xpos = shift;
    my $ypos = shift;
    my $text = shift;

    if ($xmax{$client} && $ymax{$client}) {
        for (my $ci = 0; $ci < length($text); $ci++) {
            my $c = substr($text,$ci,1);
            my $firstline = 1;
            my $xs = $xpos < 0 ? 0 : $xpos + $ci*6;
            my $yi = $ypos > $ymax{$client} ? $ymax{$client} : $ypos;
            for my $line (split('\n',$Charset[$Codepage{$c}])) {
                # first line must be skipped (empty)
                if ($firstline) {
                    $firstline = 0;
                    next;
                }
                chomp $line;
                for( my $xi = $xs; $xi < length($line)+$xs && $xi < $xmax{$client} && $yi >= 0; $xi++) {
                    if (substr($line,$xi-$xs,1) eq "*") {
                        $hashDisp{$client}[$xi][$yi] = 1;
                    }
                }
                $yi--;
            }
        }
    }
}

# convert %hashDisp into line framebuffer format
sub getFramebuf {
    my $client = shift;
    my $width = shift;
    my $line1 = "";
    
    for( my $x = 0; $x < $width && $x < $xmax{$client}; $x++) {
        my $byte;
        for( my $y = $ymax{$client}; $y > 0; $y -= 8) {
            $byte = ($hashDisp{$client}[$x][$y-1] << 7)
                  + ($hashDisp{$client}[$x][$y-2] << 6)
                  + ($hashDisp{$client}[$x][$y-3] << 5)
                  + ($hashDisp{$client}[$x][$y-4] << 4)
                  + ($hashDisp{$client}[$x][$y-5] << 3)
                  + ($hashDisp{$client}[$x][$y-6] << 2)
                  + ($hashDisp{$client}[$x][$y-7] << 1)
                  +  $hashDisp{$client}[$x][$y-8];
            $line1 .= pack("C", $byte);
        }
    }
    return $line1;
}

sub screensaverSuperDateTimelines {
    my $client = shift;
    my $args   = shift;
    
    my $bottomPad = '';
    
    my $flash  = $args->{'flash'}; # set when called from animation callback
    
    my $narrow = $client->display->isa('Slim::Display::Boom');
    my $currentAlarm = Slim::Utils::Alarm->getCurrentAlarm($client);
    my $nextAlarm = Slim::Utils::Alarm->getNextAlarm($client);
    # show alarm symbol if active or set for next 24 hours
    my $alarmOn = defined $currentAlarm || ( defined $nextAlarm && ($nextAlarm->nextDue - time < 86400) );
    $overlay{$client} = undef;
    if ($alarmOn && !$flash) {
        if (defined $currentAlarm && $currentAlarm->snoozeActive) {
            $overlay{$client} = $client->symbols('sleep');
        } else {
            $overlay{$client} = $client->symbols('bell');
            # Include the next alarm time in the overlay if there's room
            if (!$narrow && !defined $currentAlarm) {
                # Remove seconds from alarm time
                my $timeStr = Slim::Utils::DateTime::timeF($nextAlarm->time % 86400, $prefs->client($client)->timeformat, 1);
                $timeStr =~ s/(\d?\d\D\d\d)\D\d\d/$1/;
                $overlay{$client} .=  " $timeStr";
            }
        }
    }

    my $s2line1;
    my $s2line2;

    my $lastTicker = 0; #Flag set to indicate showing last ticker item
    my $hash;

    if ($nowshowing{$client}{'itemNum'} == 0 || ($client->display->hasScreen2())) { #Show time and temperature  
        my $time;
        if (defined($Plugins::FuzzyTime::Plugin::apiVersion)) {
            $time = Plugins::FuzzyTime::Public::timeF($client,undef,preferences('plugin.datetime')->get('timeformat'));
        }
        else {
            $time = $client->timeF();
        }
                    
        if (defined($displayInfo{$client}{'TOPdisplayItems1'}[$topNowShowing{$client}])) { #Show next forecast
            #Figure out how much extra spacing is necessary from the 3line text to the lower line       
            my $max;
            if ($displayInfo{$client}{'CharLen2'}[$topNowShowing{$client}] > $displayInfo{$client}{'CharLen3'}[$topNowShowing{$client}]) {
                $max = $displayInfo{$client}{'CharLen2'}[$topNowShowing{$client}];
            }
            else {
                $max = $displayInfo{$client}{'CharLen3'}[$topNowShowing{$client}];
            }
        
            #If they're using a large font, include top line in maximum for spacing
            if ($client->textSize() == 2) { #Large text
                if ($displayInfo{$client}{'CharLen1'}[$topNowShowing{$client}] > $max) {
                    $max = $displayInfo{$client}{'CharLen1'}[$topNowShowing{$client}];
                }
            }
            
            if ($max >2) {
                $max = $max - 1;
            }
                    
            #Create a text string with the proper number of blank spaces        
            for (my $count=1; $count< $max; $count++)
            {
                $bottomPad = $bottomPad . $client->symbols("getMLB-41");
            }

            if ($displayInfo{$client}{'hasIcon'}[$topNowShowing{$client}] == 1) {
                $bottomPad = ' ' . $bottomPad . $client->symbols("getMLB-41"). $client->symbols("getMLB-41") . $client->symbols("getMLB-41") . $client->symbols("getMLB-41") . $client->symbols("getMLB-41");
            }
    
            $s2line1 = $displayInfo{$client}{'TOPdisplayItems1'}[$topNowShowing{$client}];
            $s2line1 =~ s/%1/$time/;
            $s2line2 = $bottomPad . $displayInfo{$client}{'BOTdisplayItems1'}[$topNowShowing{$client}];
            $s2line2 =~ s/%1/$time/;
            
            if ($nowshowing{$client}{'itemNum'} == 0) {
                $displayLine1{$client} = $s2line1;
                $displayLine2{$client} = $s2line2;
            }
        }
        else { #Show the time/date
            $displayLine1{$client} = $client->longDateF();
            $displayLine2{$client} = $time;
            $s2line1 = $displayLine1{$client};
            $s2line2 = $displayLine2{$client};
        }
    }

    if ($scrollType{$client} eq 'Ticker' && $killTicker{$client} !=3) { #TICKERS
        my $tickerScreen;
        if ($client->display->hasScreen2()) {
            $tickerScreen = 2;
        }
        else {
            $tickerScreen = 1;
        }       
        my ($complete, $queue) = $client->scrollTickerTimeLeft($tickerScreen);

        if ($nowshowing{$client}{'itemNum'} == 0) { #Time
            if ($complete == 0 || $killTicker{$client} == 1) { #Show the time
                $killTicker{$client} = 0; #Reset kill ticker in case it's toggeled
                if ($bottomPad ne '') {
                    $hash = {
                        'overlay' => [$overlay{$client} . $status, undef],
                        'center'  => [$displayLine1{$client}, $displayLine2{$client}],
                        # It's incorrect to center the bottom line, but if I don't and the text is larger than what will fit
                        # on the screen SC will start to scroll it, which totally messes the ticker logic up because it will
                        # think there's an active ticker when it's actually just the time display.
                        #'center'  => [$displayLine1{$client}, undef],
                        #'line'    => [ undef, $displayLine2{$client} ],            
                    };
                }
                else {
                    $hash = { #No icon or 3line so center everything
                        'overlay' => [ $overlay{$client} . $status, undef ],
                        'center'  => [ $displayLine1{$client}, $displayLine2{$client} ],
                    };
                }
            }
            else { #Last ticker item still displaying
                $lastTicker = 1;
                $hash = {
                    'overlay'  => [ $overlay{$client} . $status, undef],
                    'center'   => [ $tickline1{$client}, undef ],
                    'ticker'   => [ undef, undef ],
                };
            }
        }   
        elsif ($queue <1 && $complete >0) { #Queue empty, item is still showing
            nextDisplayItem($client);
            if ($nowshowing{$client}{'itemNum'} != 0) { #Add item to ticker

                Slim::Utils::Timers::setTimer($client, Time::HiRes::time() + ($complete*.5), \&topLineSet, $displayLine1{$client});
                        
                $hash = { 
                    'overlay' => [ $overlay{$client} . $status, undef ],
                    'center'  => [ $tickline1{$client}, undef ],
                    'ticker'  => [ undef, $displayLine2{$client} ],
                };
            }
            else { #Last ticker item about to show time
                $lastTicker = 1;
                $hash = {
                    'overlay' => [ $overlay{$client} . $status, undef ],
                    'center'  => [ $tickline1{$client}, undef ],
                    'ticker'  => [ undef, undef ],
                };      
            }
        }
        elsif ($complete > 0) { #Showing a ticker item
            $hash = {
                'overlay' => [ $overlay{$client} . $status, undef ],
                'center'  => [ $tickline1{$client}, undef ],
                'ticker'  => [ undef, undef ],
            };
        }
        else {  #Add first ticker item
            $tickline1{$client} = $displayLine1{$client};
                $hash = {
                    'overlay' => [ $overlay{$client} . $status, undef ],
                    'center'  => [ $tickline1{$client}, undef ],
                    'ticker'  => [ undef, $displayLine2{$client} ],
                };
        }
    }
    else {  #BASIC OR SLIDE
        if ($client->textSize() != 2) { #Not large text
            if ($nowshowing{$client}{'itemNum'} == 0 &&  $bottomPad ne '') { #Time with special spacing             
                $hash = {
                    'overlay' => [ $overlay{$client} . $status, undef ],
                    'center'  => [ $displayLine1{$client}, undef ],
                    'line'    => [ undef, $displayLine2{$client} ],                         
                };
            }
            elsif ($nowshowing{$client}{'itemNum'} == 0) { #Time without special spacing
                $hash = {
                    'overlay' => [ $overlay{$client} . $status, undef ],
                    'center'  => [ $displayLine1{$client}, $displayLine2{$client} ],                            
                };
            }           
            elsif ($nowshowing{$client}{'itemNum'} < 0) { #Weather with scrolling
                $hash = {
                    'overlay' => [ $overlay{$client} . $status ],
                    'center'  => [ $displayLine1{$client} ],
                    'line'    => [ undef, $displayLine2{$client} ],
                };
            }
            else {
                if ($nowshowing{$client}{'justify'} eq 'line') {
                    $hash = {  #Game left justify text to allow for scrolling
                        'overlay' => [ $overlay{$client} . $status, undef ],
                        'center'  => [ $displayLine1{$client}, undef ],
                        'line'    => [ undef, $displayLine2{$client} ],
                    };              
                }
                else {
                    $hash = {  #Game center text # Changed these lines to make game text scroll correctly on Boom.
                        'overlay' => [ $overlay{$client} . $status, undef ],
#                       'center'  => [ $displayLine1{$client}, $displayLine2{$client} ],
                        'center'  => [ $displayLine1{$client}, undef ],
                        'line'    => [ undef, $displayLine2{$client} ],
                    };
                }
            } 
       } #End of not large text
       else { #Large text
        if ($nowshowing{$client}{'itemNum'} == 0) { #Time
                    $hash = {
                        'overlay' => [ undef, $overlay{$client} . $status ],
                        'center'  => [ undef, $displayLine2{$client}],
                    };
            }
            else { #Sport scores/stocks in large text
                $hash = {
                    'overlay' => [ undef, $overlay{$client} . $status ],
                    $nowshowing{$client}{'justify'} => [ undef, $displayLine2{$client}],
                };
            }
       }
    }
    
    my $dispHash;
    if ($client->display->hasScreen2()) { #Dual screens
        my $time;
        if (defined($Plugins::FuzzyTime::Plugin::apiVersion)) {
            $time = Plugins::FuzzyTime::Public::timeF($client,undef,preferences('plugin.datetime')->get('timeformat'));
        }
        else {
            $time = $client->timeF();
        }
                
        my $timeHash;
        if ($bottomPad ne '') { #Time with special spacing              
            $timeHash = {
                'center' => [ $s2line1, undef ],
                'line'   => [ undef, $s2line2 ],
            };
        }
        else {
            $timeHash = {
                'center'  => [ $s2line1, $s2line2 ],
            };      
        }

        if ($nowshowing{$client}{'itemNum'} != 0 || $lastTicker == 1) { #Not time
            $dispHash->{'screen2'} = $hash;
        }
        else {
            my $line1 = $displayInfo{$client}{'TOPdisplayItems2'}[$topNowShowing{$client}];
            $line1 =~ s/%1/$time/; #Add the time if its included
            
            my $line2 = $displayInfo{$client}{'BOTdisplayItems2'}[$topNowShowing{$client}];
            $line2 =~ s/%1/$time/; #Add the time if its included
            
            my $screen2;
            if ($client->textSize() != 2) { #Not large text
                $screen2 = {
                        'overlay' => [ $overlay{$client} . $status, undef ],
                        'center'  => [ $line1, $line2 ],
                };
            }
            else {
                $screen2 = {
                    'overlay' => [ undef, $overlay{$client} . $status ],
                    'center'  => [ $line1, $line2 ],
                };
            }
            
            $dispHash->{'screen2'} = $screen2;
        }
        
        if ($xmax{$client} && $ymax{$client}) {
            $timeHash->{'bits'} = $displayInfo{$client}{'forecastG'}[$topNowShowing{$client}];
        }
        $dispHash->{'screen1'} = $timeHash;
    }
    else { #Single screen
        $hash->{'fonts'} = { 'graphic-280x16'  => { 'overlay' => [ 'small.1' ]},
                                   'graphic-320x32'  => { 'overlay' => [ 'standard.1' ]},
                                   'text' =>            { 'displayoverlays' => 1 },
                                 };

        if ($xmax{$client} && $ymax{$client} && $nowshowing{$client}{'itemNum'} == 0 && $lastTicker == 0) {
            $hash->{'bits'} = $displayInfo{$client}{'forecastG'}[$topNowShowing{$client}];
        }
        $dispHash->{'screen1'} = $hash;
    }
    
    if ($currentAlarm && !$flash) {
        # schedule another update to remove the alarm symbol during alarm
        Slim::Utils::Timers::setTimer($client, Time::HiRes::time + 0.5, \&_flashAlarm);
    }
    
    return $dispHash;       
}

sub _flashAlarm {
    my $client = shift;
    
    $client->update( screensaverSuperDateTimelines($client, { flash => 1 }) );
}

sub cliQuery {
    my $request = shift;
    my $client = $request->client();

    #Get mode param
    my $mode = $request->getParam('_mode');
    
    $log->debug("Inside CLI request: $mode");
    
    if ($mode eq 'all') {
        $request->addResult( "wetData", \%wetData );
        $request->addResult( "sportsData", \%sportsData );
        $request->addResult( "miscData", \%miscData );
    }
    elsif ($mode eq 'sports') {
        $request->addResult( "sportsData", \%sportsData );  
    }
    elsif ($mode eq 'selsports') {  
        my %selSportsData = ();

        for my $sport ( keys %sportsData ) {
            for my $game ( keys %{ $sportsData{$sport} } ) {
                #Skip the sport logos as they're not actually games
                if($game eq 'logoURL') {
                        $selSportsData{$sport}{$game} = $sportsData{$sport}{$game};
                        next;
                    }
                
                #Use dynamic var names instead?
                if ($sport eq 'MLB') {
                    if (scalar @MLBteams >0) {
                        if ((teamCheck($sportsData{$sport}{$game}{'homeTeam'},\@MLBteams)==1) || (teamCheck($sportsData{$sport}{$game}{'awayTeam'},\@MLBteams)==1)) {
                            $selSportsData{$sport}{$game} = $sportsData{$sport}{$game};
                        }
                    }
                }
                elsif ($sport eq 'NBA') {
                    if (scalar @NBAteams >0) {
                        if ((teamCheck($sportsData{$sport}{$game}{'homeTeamCK'},\@NBAteams)==1) || (teamCheck($sportsData{$sport}{$game}{'awayTeamCK'},\@NBAteams)==1)) {
                            $selSportsData{$sport}{$game} = $sportsData{$sport}{$game};
                        }
                    }
                }
                elsif ($sport eq 'NFL') {
                    if (scalar @NFLteams >0) {
                        if ((teamCheck($sportsData{$sport}{$game}{'homeTeamCK'},\@NFLteams)==1) || (teamCheck($sportsData{$sport}{$game}{'awayTeamCK'},\@NFLteams)==1)) {
                            $selSportsData{$sport}{$game} = $sportsData{$sport}{$game};
                        }
                    }
                }
                elsif ($sport eq 'NHL') {
                    if (scalar @NHLteams >0) {
                        if ((teamCheck($sportsData{$sport}{$game}{'homeTeam'},\@NHLteams)==1) || (teamCheck($sportsData{$sport}{$game}{'awayTeam'},\@NHLteams)==1)) {
                            $selSportsData{$sport}{$game} = $sportsData{$sport}{$game};
                        }
                    }
                }
                elsif ($sport eq 'College Basketball') {
                    if (scalar @CBBteams >0) {
                        if ((teamCheck($sportsData{$sport}{$game}{'homeTeam'},\@CBBteams)==1) || (teamCheck($sportsData{$sport}{$game}{'awayTeam'},\@CBBteams)==1)) {
                            $selSportsData{$sport}{$game} = $sportsData{$sport}{$game};
                        }
                    }
                }
                elsif ($sport eq 'College Football') {
                    if (scalar @CFBteams >0) {
                        if ((teamCheck($sportsData{$sport}{$game}{'homeTeam'},\@CFBteams)==1) || (teamCheck($sportsData{$sport}{$game}{'awayTeam'},\@CFBteams)==1)) {
                            $selSportsData{$sport}{$game} = $sportsData{$sport}{$game};
                        }
                    }
                }
                else { #Custom sport
                    $log->info('Why am I here? Sport = ' . $sport);
                    $selSportsData{$sport}{$game} = $sportsData{$sport}{$game};
                }
            }
        }

        $request->addResult( "selsports", \%selSportsData );    
    }   
    elsif ($mode eq 'weather') {
        $request->addResult( "wetData", \%wetData );
    }
    elsif ($mode eq 'misc') {
        $request->addResult( "miscData", \%miscData );
    }
    else {
        $log->warn("Unknown CLI request: $mode");
    }

    $request->setStatusDone();
}

sub macroString {
    my $request = shift;
    my $client = $request->client();

    $log->debug("Inside CLI request macroString");

    my $format = $request->getParam('format');
    my $period = $request->getParam('period');
    
    #Default period to 0 if not provided
    if (!defined $period) {$period = -1;}
    $log->debug("Incoming string: $format Period: $period");
    my $macroString = replaceMacrosPer($format, $period, $client);
    
    $log->debug("Outgoing string: $macroString");
    $request->addResult( "macroString", $macroString );

    if (defined $funcptr && ref($funcptr) eq 'CODE') {
        $log->debug('Calling next function');
        $request->addParam('format', $macroString);
        eval { &{$funcptr}($request) };

        # arrange for some useful logging if we fail
        if ($@) {
            $log->error('Error while trying to run function coderef: [' . $@ . ']');
            $request->setStatusBadDispatch();
            $request->dump('Request');
        }
    }
    else {
        $log->debug('Done');
        $request->setStatusDone();
    }
}

sub sdtVersion {
    my $request = shift;
    my $client = $request->client();

    $log->debug("Inside CLI request sdtVersion");
        
        $request->addResult( "sdtVersion", $VERSION );

    $request->setStatusDone();
}

#External API to add a custom sport score
#Should only be called during a dataRefresh
sub addCustomSportScore(\%) {
    my $params = shift;
    
    $sportsData{$params->{'sport'}}{$params->{'gameID'}}{'gameTime'} = $params->{'gameTime'};
    $sportsData{$params->{'sport'}}{$params->{'gameID'}}{'homeTeam'} = $params->{'homeTeam'};
    $sportsData{$params->{'sport'}}{$params->{'gameID'}}{'homeScore'} = $params->{'homeScore'};
    $sportsData{$params->{'sport'}}{$params->{'gameID'}}{'awayTeam'} = $params->{'awayTeam'};
    $sportsData{$params->{'sport'}}{$params->{'gameID'}}{'awayScore'} = $params->{'awayScore'};
    
    if (defined $params->{'gameLogoURL'}) {
        $sportsData{$params->{'sport'}}{$params->{'gameID'}}{'gameLogoURL'} = $params->{'gameLogoURL'};
    }

    if (defined $params->{'homeLogoURL'}) {
        $sportsData{$params->{'sport'}}{$params->{'gameID'}}{'homeLogoURL'} = $params->{'homeLogoURL'};
    }
    
    if (defined $params->{'awayLogoURL'}) {
        $sportsData{$params->{'sport'}}{$params->{'gameID'}}{'awayLogoURL'} = $params->{'awayLogoURL'};
    }
}

#External API to add an icon for a custom sport
sub addCustomSportLogo {
    my $sport = shift;
    my $imgURL = shift;

    $sportsData{$sport}{'logoURL'} = $imgURL;
}

#External API to remove all sports scores and icon for a particular custom sport
#Should only be called during a dataRefresh
sub delCustomSport {
    my $sport = shift;
    
    delete $sportsData{$sport};
}

#External API to remove sports scores for a particular custom sport
#Should only be called during a dataRefresh
sub delCustomSportScore {
    my $sport = shift;
    my $gameID = shift;
    
    delete $sportsData{$sport}{$gameID};
}

#External API to add a custom display text by hash ref
#Should only be called during a dataRefresh
sub addCustomDisplayItemHash {
    my $group = shift;
    my $itemID = shift;
    my $itemHash_ref = shift;
    
    #Copy item hash into a new hash
    my %hash = %$itemHash_ref;

    $miscData{$group}{$itemID} = \%hash;
}

#External API to remove all display items for a custom group
#Should only be called during a dataRefresh
sub delCustomDisplayGroup {
    my $group = shift;
    
    delete $miscData{$group};
}

#External API to remove display items for a particular custom group
#Should only be called during a dataRefresh
sub delCustomDisplayGroupItem {
    my $group = shift;
    my $itemID = shift;
    
    delete $miscData{$group}{$itemID};
}



1;

__END__

# Local Variables:
# tab-width:4
# indent-tabs-mode:t
# End:
