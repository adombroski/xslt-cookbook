<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:saxon="http://icl.com/saxon"
extension-element-prefixes="saxon">

<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

<xsl:variable name="countFoo" select="0" saxon:assignable="yes"/>

<xsl:template match="/">
  <xsl:call-template name="foo"/>
  <xsl:call-template name="foo"/>
  <xsl:call-template name="foo"/>
  <xsl:call-template name="foo"/>
</xsl:template>

<xsl:template name="foo">
    <saxon:assign name="countFoo" select="$countFoo + 1"/>
    <xsl:comment>This is invocation number <xsl:value-of select="$countFoo"/> of template foo.</xsl:comment>	  
</xsl:template>

</xsl:stylesheet>
