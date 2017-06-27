#!c:/perl/bin/perl 
print "Content-type: text/html\n\n" ;
system "saxon StockServices.wsdl wsdlServiceList.xslt" ;

