#!c:/perl/bin/perl 

read (STDIN, $query_string, $ENV{'CONTENT_LENGTH'});

print "Content-type: text/html\n\n" ;
print "<html> <head><title>response</title> </head> <body><h1>Response</h1>$query_string</body></html>\n" ;
