package Nipe::Component::Utils::Helper {
	use strict;
	use warnings;

    our $VERSION = '0.0.3';

	sub new {
		return <<~'END_HELP';

			Core Commands
			==============
				Command       Description
				-------       -----------
				install       Install dependencies
				start         Start routing
				stop          Stop routing
				restart       Restart the Nipe circuit
				status        See status

			END_HELP
	}
}

1;