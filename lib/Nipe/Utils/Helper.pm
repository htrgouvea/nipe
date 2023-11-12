package Nipe::Utils::Helper {
	use strict;
	use warnings;

	sub new {
		return "
            \rCore Commands
            \r==============
            \r\tCommand       Description
            \r\t-------       -----------
            \r\tinstall       Install dependencies
            \r\tstart         Start routing
            \r\tstop          Stop routing
            \r\trestart       Restart the Nipe circuit
            \r\tstatus        See status\n\n";
	}
}

1;