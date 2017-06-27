<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:str="http://www.ora.com/XSLTCookbook/namespaces/strings" >


<xsl:output method="text"/>

<xsl:template match="/">
  
  <xsl:text>Success&#xa;</xsl:text>
  
  <xsl:call-template name="str:ends-with">
    <xsl:with-param name="value" select=" 'Happy New Year' "/>
    <xsl:with-param name="substr" select=" 'ear' "/>  
  </xsl:call-template>

  <xsl:text>&#xa;Failure (next line should be empty)&#xa;</xsl:text>
  
  <xsl:call-template name="str:ends-with">
    <xsl:with-param name="value" select=" 'Happy New Year' "/>  
    <xsl:with-param name="substr" select=" 'hang over' "/>  
  </xsl:call-template>
</xsl:template>

<!--In XSLT 2.0 it would be better to make this a function. Otherwise, it is more convenient to use the test directly rather than make a named template as I have done. -->
<xsl:template name="str:ends-with">
  <xsl:param name="value"/>
  <xsl:param name="substr"/>
  <xsl:if test="substring($value, (string-length($value) - string-length($substr)) + 1) = $substr">
    <xsl:value-of select="true()"/>
  </xsl:if>
</xsl:template>


</xsl:stylesheet>
