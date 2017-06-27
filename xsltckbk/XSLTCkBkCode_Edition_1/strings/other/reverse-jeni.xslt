<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  
  	<xsl:template match="/">
	
	<result>
		<xsl:call-template name="reverse">
			<xsl:with-param name="input" select="text"/>
		</xsl:call-template>
	</result>
	
	</xsl:template>

  <xsl:template name="reverse">
    <xsl:param name="input"/>
    <xsl:param name="len" select="string-length($input)"/>
    <xsl:param name="rest"/>
    <xsl:choose>
      <xsl:when test="$len &lt; 2">
        <xsl:value-of select="concat($input, $rest)"/>
      </xsl:when>
      <xsl:when test="$len = 2">
        <xsl:value-of select="concat(substring($input, 2, 1),substring($input, 1, 1), $rest)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="substring($input, $len)"/>
        <xsl:call-template name="reverse">
          <xsl:with-param name="input" select="substring($input, 2, $len - 2)"/>
          <xsl:with-param name="len" select="$len - 2"/>
          <xsl:with-param name="rest" select="concat(substring($input, 1, 1), $rest)"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
