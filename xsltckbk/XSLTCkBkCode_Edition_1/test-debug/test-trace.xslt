<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dbg="http://www.ora.com/XSLTCookbook/ns/debug">

<xsl:include href="xtrace.xslt"/>

<xsl:template match="someElement[someChild = 'someValue']">
  <xsl:call-template name="dbg:trace"/>
</xsl:template>

<xsl:template match="someElement[someChild = 'someOtherValue']">
  <xsl:call-template name="dbg:trace"/>
</xsl:template>


</xsl:stylesheet>
