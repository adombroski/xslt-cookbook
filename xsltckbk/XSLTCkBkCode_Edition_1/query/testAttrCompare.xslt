<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="text"/>

<xsl:template match="testAttrCompare">
  
  <xsl:variable name="foo1">
    <xsl:for-each select="foo[1]//@*">
      <xsl:sort select="name()"/>
      <xsl:value-of select="."/>
    </xsl:for-each>
 </xsl:variable> 
 
  <xsl:variable name="foo2">
    <xsl:for-each select="foo[2]//@*">
      <xsl:sort select="name()"/>
      <xsl:value-of select="."/>
    </xsl:for-each>
 </xsl:variable> 

  <xsl:if test="$foo1 = $foo2">
    <xsl:value-of select="true()"/>
   </xsl:if>
  
</xsl:template>

</xsl:stylesheet>
