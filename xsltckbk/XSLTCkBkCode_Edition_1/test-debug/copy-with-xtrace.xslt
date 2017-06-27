<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                                                 xmlns:dbg="http://www.ora.com/XSLTCookbook/ns/debug">

<xsl:include href="trace.xslt"/>

<xsl:template match="/ | node() | @* | comment() | processing-instruction()">
  <xsl:call-template name="dbg:trace"/>
  <xsl:copy>
    <xsl:apply-templates select="@* | node()"/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
