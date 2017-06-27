<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
 version="1.0" 
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:xslx="http://com.ora.xsltckbk.CkBkElementFactory" 
 extension-element-prefixes="xslx">

<xsl:output method="text"/>

<xsl:template match="class">
<xslx:templtext>
class \name\ <xsl:apply-templates select="bases"/> 
{
public:

  \name\() ;
  ~\name\() ;
  \name\(const \name\&amp; other) ;
  \name\&amp; operator =(const \name\&amp; other) ;
} ;
</xslx:templtext>
</xsl:template>	

<xsl:template match="bases">
<xslx:templtext>: public \base%', public '\</xslx:templtext>
</xsl:template>

<xsl:template match="text()"/>

</xsl:stylesheet>
