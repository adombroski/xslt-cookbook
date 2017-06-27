<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="someElement[someChild = 'someValue']">
  <xsl:param name="myParam"/>
  <!-- This is not an effective debugging technique. If you run a test and see nothing
        it might be because the template was never matched or it might be because it was 
        matched with $myParam empty -->
  <xsl:message><xsl:value-of select="$myParam"/></xsl:message>
</xsl:template>

<xsl:template match="someElement[someChild = 'someOtherValue']">
  <xsl:param name="myParam"/>
  <!-- This is better -->
  <xsl:message>Matched someElement[someChild = 'someOtherValue']</xsl:message>
  <xsl:message>$myParam=[<xsl:value-of select="$myParam"/>]</xsl:message>
</xsl:template>


</xsl:stylesheet>
