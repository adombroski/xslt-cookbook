<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>


	<xsl:template match="/">
	
	<result>
		<xsl:call-template name="reverse">
			<xsl:with-param name="input" select=" '012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789' "/>
		</xsl:call-template>
	</result>
	
	</xsl:template>
	
	
	<xsl:template name="reverse">
		<xsl:param name="input"/>
		<xsl:variable name="len" select="string-length($input)"/>
		<xsl:choose>
			<xsl:when test="$len &lt; 2">
				<xsl:value-of select="$input"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="mid" select="floor($len div 2)"/>
				<xsl:variable name="temp1">
					<xsl:call-template name="reverse">
						<xsl:with-param name="input" select="substring($input,1,$mid)"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="temp2">
					<xsl:call-template name="reverse">
						<xsl:with-param name="input" select="substring($input,$mid+1,$mid+1)"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:value-of select="concat($temp2,$temp1)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>

