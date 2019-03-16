package Plugins::SuperDateTime::PlayerSettings;

# SqueezeCenter Copyright (c) 2001-2007 Logitech.
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License,
# version 2.

use strict;
use base qw(Slim::Web::Settings);

use Slim::Utils::Prefs;
use Slim::Utils::DateTime;

my $prefs = preferences('plugin.superdatetime');

sub needsClient {
	return 1;
}

sub name {
	return Slim::Web::HTTP::CSRF->protectName('PLUGIN_SUPERDATETIME_PLAYER_SETTINGS');

}

sub page {
	return Slim::Web::HTTP::CSRF->protectURI('plugins/SuperDateTime/settings/player.html');
}

sub prefs {
	my ($class,$client) = @_;
	return ($prefs->client($client), qw(scroll fdays));
}

sub handler {
	my ($class, $client, $params) = @_;

	my @prefs2 = qw(
		show1icon
		show13line
		v3line1t
		v3line1m
		v3line1b
		v1period
      weatherformat1t
      weatherformat1b
      weatherformat2t
      weatherformat2b
	);

	for my $pref (@prefs2) {
		if ($params->{'saveSettings'}) {
			if ($pref eq 'v1period') {
				#Remove hidden one that forces array saving- is there a better way to do this?
				my @items = grep { $_ ne 'deleteme' } @{$params->{'v1period'}};
				$prefs->client($client)->set('v1period', \@items);
			}
			elsif ($pref eq 'weatherformat1t') {
				#Remove hidden one that forces array saving- is there a better way to do this?
				my @items = grep { $_ ne 'deleteme' } @{$params->{'weatherformat1t'}};
				$prefs->client($client)->set('weatherformat1t', \@items);
			}
			elsif ($pref eq 'weatherformat1b') {
				#Remove hidden one that forces array saving- is there a better way to do this?
				my @items = grep { $_ ne 'deleteme' } @{$params->{'weatherformat1b'}};
				$prefs->client($client)->set('weatherformat1b', \@items);
			}
			elsif ($pref eq 'v3line1t') {			
				#Remove hidden one that forces array saving- is there a better way to do this?
				my @items = grep { $_ ne 'deleteme' } @{$params->{'v3line1t'}};
				$prefs->client($client)->set('v3line1t', \@items);
			}
			elsif ($pref eq 'v3line1m') {
				#Remove hidden one that forces array saving- is there a better way to do this?
				my @items = grep { $_ ne 'deleteme' } @{$params->{'v3line1m'}};
				$prefs->client($client)->set('v3line1m', \@items);
			}
			elsif ($pref eq 'v3line1b') {
				#Remove hidden one that forces array saving- is there a better way to do this?
				my @items = grep { $_ ne 'deleteme' } @{$params->{'v3line1b'}};
				$prefs->client($client)->set('v3line1b', \@items);
			}
			elsif ($pref eq 'weatherformat2t') {
				#Remove hidden one that forces array saving- is there a better way to do this?
				my @items = grep { $_ ne 'deleteme' } @{$params->{'weatherformat2t'}};
				$prefs->client($client)->set('weatherformat2t', \@items);
			}	
			elsif ($pref eq 'weatherformat2b') {
				#Remove hidden one that forces array saving- is there a better way to do this?
				my @items = grep { $_ ne 'deleteme' } @{$params->{'weatherformat2b'}};
				$prefs->client($client)->set('weatherformat2b', \@items);
			}
			elsif ($pref eq 'show1icon') {
				#Remove hidden one that forces array saving- is there a better way to do this?
				my @items = grep { $_ ne 'deleteme' } @{$params->{'show1icon'}};
				$prefs->client($client)->set('show1icon', \@items);
			}
			elsif ($pref eq 'show13line') {
				#Remove hidden one that forces array saving- is there a better way to do this?
				my @items = grep { $_ ne 'deleteme' } @{$params->{'show13line'}};
				$prefs->client($client)->set('show13line', \@items);
			}			
			else {
				$prefs->set($pref, $params->{$pref});
			}
		}

		$params->{'prefs'}->{$pref} = $prefs->client($client)->get($pref);
   }	
   
	if ($params->{'saveSettings'}) {
		Plugins::SuperDateTime::Plugin::refreshSoon($client);
	}	
	
	return $class->SUPER::handler($client, $params);
}

sub getPrefs {
	return $prefs;
}

1;

__END__
