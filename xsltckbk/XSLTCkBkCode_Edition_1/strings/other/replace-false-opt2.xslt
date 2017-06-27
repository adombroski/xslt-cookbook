<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

<xsl:template match="/">
	<xsl:call-template name="search-and-replace">
		<xsl:with-param name="input" select="text"/>
		<xsl:with-param name="search-string" select=" '1' "/>
		<xsl:with-param name="replace-string" select=" '2' "/>
	</xsl:call-template>
</xsl:template>

<xsl:template name="search-and-replace">
	<xsl:param name="input"/>
	<xsl:param name="search-string"/>
	<xsl:param name="replace-string"/>
	<!-- Find the length of the sub-string before the search string and store it in a 
	variable -->
	<xsl:variable name="temp" select="string-length(substring-before($input,$search-string))"/>
	<xsl:choose>
	<!-- If $temp is not 0 or the input starts with the search 
		string then we know we have to do a replace. This eliminates the 
		need to use contains(). -->
		<xsl:when test="$temp or starts-with($input,$search-string)">
			<xsl:value-of select="substring($input,1,$temp)"/>
			<xsl:value-of select="$replace-string"/>
				<!-- We eliminate the need to call substring-after
				by using  temp and the length of the search string 
				to extract the remaining string in the recursive 
				call. -->
			<xsl:call-template name="search-and-replace">
				<xsl:with-param name="input" select="substring($input,$temp+string-length($search-string)+1)"/>
				<xsl:with-param name="search-string" select="$search-string"/>
				<xsl:with-param name="replace-string" select="$replace-string"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$input"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>
