package Nipe::Component::Engine::Newnym {
	use strict;
	use warnings;
	use English qw(-no_match_vars);
	use IO::Socket::UNIX;
	use Readonly;
	use Time::HiRes ();
	use Nipe::Component::Utils::Status;

	our $VERSION = '0.0.1';

	Readonly my $CIRCUIT_DELAY => 3;

	my $CONTROL_SOCKET = '/run/tor/control';
	my $COOKIE_FILE    = '/run/tor/control.authcookie';

	sub new {
		my $cookie_hex = q{};

		if (-r $COOKIE_FILE) {
			open my $fh, '<:raw', $COOKIE_FILE or return "\n[!] ERROR: cannot read tor control cookie.\n\n";
			local $INPUT_RECORD_SEPARATOR = undef;
			my $cookie = <$fh>;
			close $fh or return "\n[!] ERROR: cannot read tor control cookie.\n\n";
			$cookie_hex = unpack 'H*', $cookie;
		}

		my $socket = IO::Socket::UNIX -> new(Peer => $CONTROL_SOCKET, Type => SOCK_STREAM())
			or return "\n[!] ERROR: cannot reach tor control socket (is nipe started?).\n\n";

		my $authenticate = $cookie_hex ? "AUTHENTICATE $cookie_hex\r\n" : "AUTHENTICATE\r\n";
		print {$socket} $authenticate;
		my $auth = <$socket>;

		if (!defined $auth || $auth !~ /^250/smx) {
			return "\n[!] ERROR: tor control authentication failed.\n\n";
		}

		print {$socket} "SIGNAL NEWNYM\r\n";
		my $response = <$socket>;

		if (defined $response && $response =~ /^250/smx) {
			Time::HiRes::sleep($CIRCUIT_DELAY);
			return Nipe::Component::Utils::Status -> new();
		}

		return "\n[!] ERROR: tor refused the NEWNYM signal.\n\n";
	}
}

1;
