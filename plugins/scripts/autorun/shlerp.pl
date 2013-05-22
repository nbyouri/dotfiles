use strict;

use vars qw($VERSION %IRSSI);
$VERSION = "1.0";
%IRSSI = (
    authors     => "jjumbii",
    name        => "shlerp",
    description => "turns your messages into shlerp code",
    license     => "UnixHub",
    changed     => "$VERSION",
    commands	=> "shlerp"
);

use Irssi;

use vars qw(%codes %spell);

%codes = (
	A=>"@#!)",
	B=>"!)(*",
	C=>"':'|",
	D=>"'<>'",
	E=>"!(@#",
	F=>"{#%]",
	G=>"!@#%",
	H=>"^-+@",
	I=>"!,{:",
	J=>":%)@",
	K=>":!%@",
	L=>"'<(>",
	M=>")(@%",
	N=>"&#^)",
	O=>"!%&@",
	P=>";'!@",
	Q=>"();{",
	R=>"*;''",
	S=>"`)&%",
	T=>"|{(*",
	U=>")(*@",
	V=>"*';:",
	W=>"{!@~",
	X=>"^&*^",
	Y=>".^!%",
	Z=>"[|!*",
	0=>"+%@%",
	1=>"+@#%",
	2=>"+)(*",
	3=>"+^(_",
	4=>"+@!&",
	5=>"+.''",
	6=>"+@#(",
	7=>"+{]|",
	8=>"+!@^",
	9=>"+*'#",
	' '=>" ",
	'.'=>".",
	','=>",",
	'?'=>"?",
	':'=>":",
	';'=>";",
	'-'=>"-",
	'_'=>"_",
	'"'=>"'",
	"'"=>"'",
	'/'=>"/",
    '('=>"(",
    ')'=>")",
	'='=>"=",
	'@'=>'@'
);

sub text2morse ($) {
    my ($text) = @_;
    my $result;
    my %deumlaut = ('ä' => 'Ä',
		    'ö' => 'Ö',
		    'ü' => 'Ü',
		    'ß' => 'ss'
		   );
    $text =~ s/$_/$deumlaut{$_}/ foreach keys %deumlaut;
    foreach (split(//, $text)) {
	if (defined $codes{uc $_}) {
	    $result .= $codes{uc $_}." ";
	} elsif (Irssi::settings_get_bool('morse_kill_unknown_characters')) {
	    $result .= " ";
	} else {
	    $result .= $_." ";
	}
    }
    return $result;
}

sub morse2text ($) {
    my ($morse) = @_;
    my (%table, $result);
    $table{$codes{$_}} = $_ foreach keys %codes;
    foreach (split(/ /, $morse)) {
	if (defined $table{$_}) {
	    $result .= $table{$_};
	} else {
	    $result .= $_." ";
	}
    }
    $result =~ s/ +/ /g;
    return $result;
}

sub cmd_morse ($$$) {
    my ($arg, $server, $witem) = @_;
	my $win = $witem ? $witem->window : Irssi::active_win;
    if ($witem && ($witem->{type} eq 'CHANNEL' || $witem->{type} eq 'QUERY')) {
		$win->print("%gme%n >>%y ".$arg);
		$witem->command('MSG '.$witem->{name}.' '."::: ".text2morse($arg));
    } else {
	print CLIENTCRAP "%B>>%n ".text2morse($arg);
    }
}

sub sig_public{
	my ($server, $msg, $nick, $address, $target) = @_;
	
	return if $nick eq $server->{nick};
	
	my $witem = $server->window_item_find($target);
	my $win = $witem ? $witem->window : Irssi::active_win;
	my $iscode = substr $msg, 0, 3;
	
	if($iscode eq ":::"){
		my $code = substr $msg, 4;
		$win->print("%r".$nick."%n >>%y ".morse2text($code));
	}else{

	}
}

Irssi::command_bind('shlerp', \&cmd_morse);
Irssi::command_bind('deshlerp', \&cmd_demorse);

Irssi::settings_add_bool($IRSSI{name}, 'morse_kill_unknown_characters', 0);
Irssi::settings_add_str($IRSSI{name}, 'morse_spelling_alphabet', "ICAO");

Irssi::signal_add_last('message public', 'sig_public');
print "%B>>%n ".$IRSSI{name}." ".$VERSION." loaded";
