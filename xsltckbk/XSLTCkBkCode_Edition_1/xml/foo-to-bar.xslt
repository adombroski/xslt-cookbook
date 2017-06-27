<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:foo="http://www.ora.com/XMLCookbook/namespaces/foo"
 xmlns:bar="http://www.ora.com/XMLCookbook/namespaces/bar">

<xsl:import href="copy.xslt"/>

<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

<xsl:strip-space elements="*"/>

<xsl:template match="foo:*">
  <xsl:element name="bar:{local-name()}">
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>	


</xsl:stylesheet>
