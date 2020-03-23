package Nipe::Utils::Helper;

use strict;
use warnings;

sub new {
	print "
		\rCore Commands
		\r==============
		\r\tCommand       Description
		\r\t-------       -----------
		\r\tinstall       Install dependencies
		\r\tstart         Start routing
		\r\tstop          Stop routing
		\r\trestart       Restart the Nipe process
		\r\tstatus        See status\n\n";
}

1;