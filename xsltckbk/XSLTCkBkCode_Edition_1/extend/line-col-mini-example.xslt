<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
 xmlns:xalan="http://xml.apache.org/xslt"
 xmlns:info="xalan://org.apache.xalan.lib.NodeInfo">

  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	
  <xsl:template match="foo">
    <xsl:comment>Matched a foo on line <xsl:value-of select="info:lineNumber()"/> and column <xsl:value-of select="info:columnNumber()"/>.</xsl:comment>
    <!-- ... -->
  </xsl:template>	
	
</xsl:stylesheet>
