<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	
<xsl:template match="/">
  <xsl:call-template name="test">
  </xsl:call-template>
</xsl:template>

<xsl:template name="test">
  <xsl:param name="foo">
    <xsl:message>foo not set</xsl:message>
  </xsl:param>
</xsl:template>

<xsl:template name="f:sayHello"
              match="xsl:template[@name='f:sayHello']">
  <xsl:text>Hello!&#xa;</xsl:text>
</xsl:template>

<xsl:template name="f:sayGoodbye"
              match="xsl:template[@name='f:sayGoodbye']">
  <xsl:text>Goodbye!&#xa;</xsl:text>
</xsl:template>

</xsl:stylesheet>
