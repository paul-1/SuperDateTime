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
# 5.9.49 02/18/19   Fixed certain NCAA team ICONs that were not displaying correctly. 
#                   Added handling for Postponed College Basketball games.                  
#                   Cleaned up "Extras" display on Touch/Radio/Controller.
#
# 5.9.48 11/30/18   NCAA updated url for college football. 
#                   Improved ICON resolution for college basketball.
#
# 5.9.47 11/07/18   Improved halftime and overtime detection in 
#                   NCAA Basketball(CBB) games.
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