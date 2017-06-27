<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:str="http://exslt.org/strings"
                extension-element-prefixes="str">

<xsl:template match="/">
	<result>
		<xsl:variable name="test">
			<xsl:call-template name="dup">
				<xsl:with-param name="input" select=" 'Sal' "/>
				<xsl:with-param name="count" select="10001"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:value-of select="$test"/><xsl:text> </xsl:text><xsl:value-of select="string-length($test)"/>
	</result>
</xsl:template>


<xsl:template name="dup">
	<xsl:param name="input"/>
	<xsl:param name="count" select="1"/>
   <xsl:choose>
      <xsl:when test="not($count) or not($input)" />
      <xsl:otherwise>
         <xsl:variable name="string" 
                       select="concat($input, $input, $input, $input, $input, 
                                      $input, $input, $input, $input, $input)" />
         <xsl:choose>
            <xsl:when test="string-length($string) > $count * string-length($input)">
               <xsl:value-of select="substring($string, 1, $count * string-length($input))" />
            </xsl:when>
            <xsl:otherwise>
               <xsl:call-template name="dup">
                  <xsl:with-param name="input" select="$string" />
                  <xsl:with-param name="count" select="$count div 10" />
               </xsl:call-template>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:otherwise>
   </xsl:choose>
</xsl:template>

</xsl:stylesheet>