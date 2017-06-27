<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:math="http://www.exslt.org/math" exclude-result-prefixes="math test" xmlns:test="http://www.ora.com/XSLTCookbook/test">

  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	
  <xsl:include href="math.lowest.xslt"/>
	
  <xsl:template match="/">
    <results>
      <xsl:copy>
        <xsl:call-template name="math:lowest">
          <xsl:with-param name="nodes" select="*/*"/>
        </xsl:call-template>
      </xsl:copy>
    </results>
  </xsl:template>
	
	
	
</xsl:stylesheet>
