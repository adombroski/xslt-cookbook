<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:import href="msgIds.xslt"/>

 <xsl:variable name="constant-type" select=" 'public static final int' "/>

  <xsl:template name="constants-start">
  <xsl:text>final public class MESSAGE_IDS &#xa;</xsl:text> 
  <xsl:text>{&#xa;</xsl:text>
  </xsl:template>

  <xsl:template name="constants-end">
  <xsl:text>&#xa;&#xa;}&#xa;</xsl:text> 
  </xsl:template>

</xsl:stylesheet>
