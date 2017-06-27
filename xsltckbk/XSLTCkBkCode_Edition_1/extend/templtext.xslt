<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:ckbk="http://com.ora.xsltckbk.CkBkElementFactory" extension-element-prefixes="ckbk">

<xsl:output method="text"/>

<xsl:template match="/">
  <xsl:variable name="class" select="'MyClass'"/>
  <ckbk:templtext>
  class \$class\
  {
  public:
    \$class\() ;
  }
  </ckbk:templtext>
</xsl:template>

</xsl:stylesheet>
  