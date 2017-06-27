<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:xslx="http://com.ora.xsltckbk.CkBkElementFactory" 
 extension-element-prefixes="xslx">

<xsl:template match="/">
  <xslx:set-context select="foo/bar">
    <xsl:value-of select="."/>
  </xslx:set-context>
</xsl:template>

</xsl:stylesheet>
  