#!c:/perl/bin/perl 
print "Content-type: text/html\n\n" ;
system "saxon StockServices2.wsdl wsdlServiceList2.xslt" ;

