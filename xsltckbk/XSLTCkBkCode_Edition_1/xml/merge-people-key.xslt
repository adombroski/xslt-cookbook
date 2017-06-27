<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:merge="http:www.ora.com/XSLTCookbook/mnamespaces/merge">

<xsl:include href="merge-simple-using-key.xslt"/>

<xsl:key name="merge:key" match="person" use="concat(@lastname,@firstname)"/>

<xsl:output method="xml" indent="yes"/>

<xsl:template name="merge:key-value">
  <xsl:value-of select="concat(@lastname,@firstname)"/>
</xsl:template>

</xsl:stylesheet>
