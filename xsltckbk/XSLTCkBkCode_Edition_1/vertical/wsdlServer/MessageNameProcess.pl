#!c:/perl/bin/perl 
use XML::LibXSLT;
use XML::LibXML ;

my $parser = XML::LibXML->new() ;
my $xslt = XML::LibXSLT->new() ;
my $stylesheet = $xslt->parse_stylesheet_file('wsdlServiceList.xslt') ;
my $source_doc = $parser->parse_file("StockServices.wsdl") ;
my $result = $stylesheet->transform($source_doc) ;

print "Content-type: text/html\n\n" ;
print $stylesheet->output)string($result) ;
