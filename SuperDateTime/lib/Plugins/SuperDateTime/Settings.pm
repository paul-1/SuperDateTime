package Plugins::SuperDateTime::Settings;

# SlimServer Copyright (C) 2001-2006 Slim Devices Inc.
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License,
# version 2.

use strict;
use base qw(Slim::Web::Settings);

use Slim::Utils::Log;
use Slim::Utils::Prefs;

my $prefs = preferences('plugin.superdatetime');

my $log = Slim::Utils::Log->addLogCategory({
	'category'     => 'plugin.superdatetime',
	'defaultLevel' => 'WARN',
#	'defaultLevel' => 'DEBUG',
	'description'  => 'SuperDateTime blah blah blah',
});

my %mlbTeams = (
                        'Angels'	=> 'Angels',
                        'Astros'	=> 'Astros',
                        'Athletics'	=> 'Athletics',
                        'Blue Jays'	=> 'Blue Jays',
                        'Braves'	=> 'Braves',
                        'Brewers'	=> 'Brewers',
                        'Cardinals'	=> 'Cardinals',
                        'Cubs'		=> 'Cubs',
                        'D-backs'	=> 'Diamondbacks',
                        'Dodgers'	=> 'Dodgers',
                        'Giants'	=> 'Giants',
                        'Indians'	=> 'Indians',
                        'Mariners'	=> 'Mariners',
                        'Marlins'	=> 'Marlins',
                        'Mets'		=> 'Mets',
                        'Nationals'	=> 'Nationals',
                        'Orioles'	=> 'Orioles',
                        'Padres'	=> 'Padres',
                        'Phillies'	=> 'Phillies',
                        'Pirates'	=> 'Pirates',
                        'Rangers'	=> 'Rangers',
                        'Rays'		=> 'Rays',
                        'Red Sox'	=> 'Red Sox',
                        'Reds'		=> 'Reds',
                        'Rockies'	=> 'Rockies',
                        'Royals'	=> 'Royals',
                        'Tigers'	=> 'Tigers',
                        'Twins'		=> 'Twins',
                        'White Sox'	=> 'White Sox',
                        'Yankees'	=> 'Yankees',
						'0'			=> 'None',
						'1'			=> 'All'
);

my %nbaTeams = (
                        'PHI'	=> '76ers',
                        'MIL'	=> 'Bucks',
                        'CHI'	=> 'Bulls',
                        'CLE'	=> 'Cavaliers',
                        'BOS'	=> 'Celtics',
                        'LAC'	=> 'Clippers',
                        'MEM'	=> 'Grizzlies',
                        'ATL'	=> 'Hawks',
                        'MIA'	=> 'Heat',
						'CHA'	=> 'Hornets',
                        'UTA'	=> 'Jazz',
                        'SAC'	=> 'Kings',
                        'NYK'	=> 'Knicks',
                        'LAL'	=> 'Lakers',
                        'ORL'	=> 'Magic',
                        'DAL'	=> 'Mavericks',
                        'BKN'	=> 'Nets',
                        'DEN'	=> 'Nuggets',
                        'IND'	=> 'Pacers',
                        'NOP'	=> 'Pelicans',
                        'DET'	=> 'Pistons',
                        'TOR'	=> 'Raptors',
                        'HOU'	=> 'Rockets',
                        'SAS'	=> 'Spurs',
                        'PHX'	=> 'Suns',
                        'OKC'	=> 'Thunder',
                        'MIN'	=> 'Timberwolves',
                        'POR'	=> 'Trail Blazers',
                        'GSW'	=> 'Warriors',
                        'WAS'	=> 'Wizards',
                        '0'		=> 'None',
                        '1'		=> 'All'
);

my %nflTeams = (
						'SF'  	=> '49ers',
						'CHI' 	=> 'Bears',
						'CIN' 	=> 'Bengals',
						'BUF' 	=> 'Bills',
						'DEN' 	=> 'Broncos',
						'CLE' 	=> 'Browns',
						'TB'  	=> 'Buccaneers',
						'ARI' 	=> 'Cardinals',
						'LAC'  	=> 'Chargers',
						'KC'  	=> 'Chiefs',
						'IND' 	=> 'Colts',
						'DAL' 	=> 'Cowboys',
						'MIA' 	=> 'Dolphins',
						'PHI' 	=> 'Eagles',
						'ATL' 	=> 'Falcons',
						'NYG' 	=> 'Giants',
						'JAC' 	=> 'Jaguars',
						'NYJ' 	=> 'Jets',
						'DET' 	=> 'Lions',
						'GB'  	=> 'Packers',
						'CAR' 	=> 'Panthers',
						'NE'  	=> 'Patriots',
						'OAK' 	=> 'Raiders',
						'LA' 	=> 'Rams',
						'BAL' 	=> 'Ravens',
						'WAS' 	=> 'Redskins',
						'NO'  	=> 'Saints',
						'SEA' 	=> 'Seahawks',
						'PIT' 	=> 'Steelers',
						'HOU' 	=> 'Texans',
						'TEN' 	=> 'Titans',
						'MIN' 	=> 'Vikings',
						'0'   	=> 'None',
						'1'   	=> 'All'
);

my %nhlTeams = (
                        'Avalanche'    => 'Avalanche',
                        'Blackhawks'   => 'Blackhawks',
                        'Blue Jackets' => 'Blue Jackets',
                        'Blues'        => 'Blues',
                        'Bruins'       => 'Bruins',
                        'Canadiens'    => 'Canadiens',
                        'Canucks'      => 'Canucks',
                        'Capitals'     => 'Capitals',
                        'Coyotes'      => 'Coyotes',
                        'Devils'       => 'Devils',
                        'Ducks'        => 'Ducks',
                        'Flames'       => 'Flames',
                        'Flyers'       => 'Flyers',
                        'Hurricanes'   => 'Hurricanes',
                        'Islanders'    => 'Islanders',
                        'Jets'	       => 'Jets',
                        'Kings'        => 'Kings',
                        'Lightning'    => 'Lightning',
                        'Maple Leafs'  => 'Maple Leafs',
                        'Oilers'       => 'Oilers',
                        'Panthers'     => 'Panthers',
                        'Penguins'     => 'Penguins',
                        'Predators'    => 'Predators',
                        'Rangers'      => 'Rangers',
                        'Red Wings'    => 'Red Wings',
                        'Sabres'       => 'Sabres',
                        'Senators'     => 'Senators',
                        'Sharks'       => 'Sharks',
                        'Stars'        => 'Stars',
                        'Wild'         => 'Wild',
			'0' => 'None',
			'1' => 'All'
);

my %cfballconf = (
			'0' => 'None',
			'80' => 'All Div I-A',
			'1' => 'ACC',
			'4' => 'Big 12',
			'10' => 'Big East',			
			'5' => 'Big Ten',			
			'12' => 'C-USA',
			'46' => 'A-Sun',
			'18' => 'IA Indep.',
			'15' => 'MAC',
			'17' => 'MWC',
			'9' => 'Pac-10',
			'37' => 'S. Belt',
			'8' => 'SEC',
			'16' => 'WAC',
			'81' => 'All Div I-AA',
			'19' => 'A 10',
			'20' => 'Big Sky',
			'40' => 'Big South',
			'21' => 'Gateway',
			'43' => 'Great West',
			'32' => 'IAA Indep.',
			'22' => 'Ivy',
			'23' => 'MAAC',
			'24' => 'MEAC',
			'25' => 'NEC',
			'26' => 'OVC',
			'27' => 'Patriot',
			'28' => 'Pioneer',
			'29' => 'Southern',
			'30' => 'Southland',
			'31' => 'SWAC',
			'1000' => 'Top-25'
);

my %cbballconf = (
			'0' => 'None',
			'50' => 'All',
			'1' => 'Am. East',
			'2' => 'ACC',
			'62' => 'American',
			'3' => 'A Ten',			
			'4' => 'Big East',			
			'7' => 'Big Ten',
			'46' => 'A-Sun',
			'8' => 'Big 12',
			'5' => 'Big Sky',
			'6' => 'B. South',
			'9' => 'B. West',
			'10' => 'CAA',
			'11' => 'C-USA',
			'43' => 'Indep.',
			'45' => 'HOR',
			'12' => 'Ivy',
			'13' => 'MAAC',
			'15' => 'Mid-Con',
			'14' => 'MAC',
			'16' => 'MEAC',
			'18' => 'MVC',
			'44' => 'MWC',
			'19' => 'NEC',
			'20' => 'OVC',
			'21' => 'Pac-10',
			'22' => 'Patriot',
			'23' => 'SEC',
			'24' => 'Southern',
			'25' => 'Southland',
			'26' => 'SWAC',
			'27' => 'S. Belt',
			'29' => 'WCC',
			'30' => 'WAC',
			'1000' => 'Top-25'			
);

sub name {
        return 'PLUGIN_SCREENSAVER_SUPERDATETIME';
}

sub page {
        return 'plugins/SuperDateTime/settings/basic.html';
}

sub handler {
   my ($class, $client, $params) = @_;

	my @prefs2 = qw(
		city
		wunder
      temperature
      windunit
      offset
      stocks
      stock1format
      stock2format
      teamlogos
      mlb
      nba
      nhl
      nfl
      cbballconf
      cbb
      cfballconf
      cfb
      refresh
	  lang
      time
      atime
      score
      ascore
      lweather
#      lalerts
      drawEachDelay
#      getWeatherImgs
	);
	
	my $cityChanged = 0;
	
	for my $pref (@prefs2) {
		if ($params->{'saveSettings'}) {
			if ($pref eq 'cfb') {
				# Remove empties.
				my @teams = grep { $_ ne '' } @{$params->{'cfb'}};
				$prefs->set('cfb', \@teams);
			}
			elsif ($pref eq 'cbb') {
				# Remove empties.
				my @teams = grep { $_ ne '' } @{$params->{'cbb'}};
				$prefs->set('cbb', \@teams);
			}
			elsif ($pref eq 'mlb') {
				# Remove empties.
				my @teams = grep { $_ ne '0' } @{$params->{'mlb'}};
				$prefs->set('mlb', \@teams);
			}
			elsif ($pref eq 'nfl') {
				# Remove empties.
				my @teams = grep { $_ ne '0' } @{$params->{'nfl'}};
				$prefs->set('nfl', \@teams);
			}			
			elsif ($pref eq 'nba') {
				# Remove empties.
				my @teams = grep { $_ ne '0' } @{$params->{'nba'}};
				$prefs->set('nba', \@teams);
			}
			elsif ($pref eq 'nhl') {
				# Remove empties.
				my @teams = grep { $_ ne '0' } @{$params->{'nhl'}};
				$prefs->set('nhl', \@teams);
			}
			elsif ($pref eq 'v1period') {
				#Remove hidden one that forces array saving- is there a better way to do this?
				my @items = grep { $_ ne 'deleteme' } @{$params->{'v1period'}};
				$prefs->set('v1period', \@items);
			}
			elsif ($pref eq 'city') {
				if ($prefs->get($pref) ne $params->{$pref}) {
					$prefs->set($pref, $params->{$pref});
					$cityChanged = 1;
					
				}
			}						
			else {
				$prefs->set($pref, $params->{$pref});
			}			
		}
		$params->{'prefs'}->{$pref} = $prefs->get($pref);
   	}

	if ($params->{'saveSettings'}) {
		Plugins::SuperDateTime::Plugin::refreshSoon($client);
	}

	$params->{'mlbTeams'} = \%mlbTeams;
	$params->{'nflTeams'} = \%nflTeams;
	$params->{'nbaTeams'} = \%nbaTeams;
	$params->{'nhlTeams'} = \%nhlTeams;
	$params->{'cfballconf'} = \%cfballconf;
	$params->{'cbballconf'} = \%cbballconf;
	
	return $class->SUPER::handler($client, $params);
}

1;

__END__
