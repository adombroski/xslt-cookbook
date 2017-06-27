<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text"/>
	
	<xsl:template match="/">
	<xsl:call-template name="search-and-replace-whole-words-only">
		<xsl:with-param name="input" select="text"/>
		<xsl:with-param name="search-string" select=" 'the' "/>
		<xsl:with-param name="replace-string" select=" 'da' "/>
	</xsl:call-template>
</xsl:template>

<xsl:template name="search-and-replace-whole-words-only">
	<xsl:param name="input"/>
	<xsl:param name="search-string"/>
	<xsl:param name="replace-string"/>
	<xsl:variable name="punc" select="concat('&#x9;&#xA;&#xD;&#x20;.,;:()[]!?$@&amp;&quot;',&quot;&apos;&quot;)"/>
	<xsl:choose>
		<!-- See if the input contains the search string -->
		<xsl:when test="contains($input,$search-string)">
		<!-- If so, then test that the before and after characters are word 
		delimiters. -->
			<xsl:variable name="before" 	
				select="substring-before($input,$search-string)"/>
			<xsl:variable name="before-char" 	
				select="substring(concat(' ',$before),string-length($before) + 1,1)"/>
			<xsl:variable name="after" 	
				select="substring-after($input,$search-string)"/>
			<xsl:variable name="after-char" 	
				select="substring($after,1,1)"/>
			<xsl:value-of select="$before"/>
			
			<xsl:choose>
				<xsl:when test="contains($punc,$before-char) and contains($punc,$after-char)"> 
					<xsl:value-of select="$replace-string"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$search-string"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:call-template name="search-and-replace-whole-words-only">
				<xsl:with-param name="input" select="$after"/>
				<xsl:with-param name="search-string" select="$search-string"/>
				<xsl:with-param name="replace-string" select="$replace-string"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<!-- There are no more occurences of the search string so 
			just return the current input string -->
			<xsl:value-of select="$input"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>
