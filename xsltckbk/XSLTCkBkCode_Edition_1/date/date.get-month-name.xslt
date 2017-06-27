<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:date="http://www.ora.com/XSLTCookbook/dates">

<xsl:include href="date-conversion.xsl"/>

<xsl:template name="date:get-month-name">
	<xsl:param name="month"/>
	<xsl:param name="country" select=" 'us' "/>

	<xsl:value-of select="$date:months[@country=$country and 
		@m=$month]/@name"/>
</xsl:template>

</xsl:stylesheet>