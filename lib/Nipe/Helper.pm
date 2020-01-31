package Nipe::Helper;

use strict;
use warnings;

sub new {
	print "
		\rCore Commands
		\r==============
		\r\tCommand       Description
		\r\t-------       -----------
		\r\tinstall       Install dependencies
		\r\t  -f          Overwrite Tor config file in /etc/tor/torrc
		\r\t  -c <file>   Specify a custom location to install Tor's config file
		\r\tstart         Start routing
		\r\t  -c <file>   Specify a custom Tor config file to be used by Nipe
		\r\tstop          Stop routing
		\r\trestart       Restart the Nipe process
		\r\tstatus        See status

		\rCopyright (c) 2015 - 2020 | Heitor Gouvêa\n\n";
}

1;