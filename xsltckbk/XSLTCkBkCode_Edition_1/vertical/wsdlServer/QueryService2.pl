#!/perl/bin/perl

use warnings;

use strict;
use CGI qw(:standard);

my $query = new CGI ;

my $service = $query->param('service');
my $port = $query->param('port');
my $binding = $query->param('binding');
my $portType = $query->param('portType');

print $query->header('text/html');

system "saxon StockServices2.wsdl QueryService2.xslt service=$service port=$port binding=$binding portType=$portType"

