<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:math="http://www.ora.com/XSLTCookbook/math" extension-element-prefixes="math test"
 xmlns:test="http://www.ora.com/XSLTCookbook/test" id="math:math.fact">

<xsl:template name="math:fact">
	<xsl:param name="number" select="0"/>
	<xsl:param name="result" select="1"/>
	<xsl:choose>
		<xsl:when test="$number &lt; 0 or floor($number) != $number">
			<xsl:value-of select="'NaN'"/>
		</xsl:when>
		<xsl:when test="$number &lt; 2">
			<xsl:value-of select="$result"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:call-template name="math:fact">
				<xsl:with-param name="number" select="$number - 1"/>
				<xsl:with-param name="result" select="$number * $result"/>
			</xsl:call-template>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template> 


<xsl:template match="xsl:stylesheet[@id='math:math.fact'] | xsl:include[@href='math.fact.xslt']">
<xsl:message>
TESTING math.fact
</xsl:message>

	<xsl:for-each select="document('')/*/test:test">
		<xsl:variable name="ans">
			<xsl:call-template name="math:fact">
				<xsl:with-param name="number" select="test:number"/>
			</xsl:call-template>
		</xsl:variable>
		<!-- Uncomment for visual inspection
		<xsl:message>
			fact(<xsl:value-of select="test:number"/>) = [<xsl:value-of select="$ans"/>]
		</xsl:message>
		-->
		<xsl:if test="$ans != @ans">
			<xsl:message>
				math:fact TEST <xsl:value-of select="@num"/> FAILED [<xsl:value-of select="$ans"/>]
			</xsl:message>
		</xsl:if>
	</xsl:for-each>
</xsl:template>


<test:test num="1" ans="1" xmlns="http://www.ora.com/XSLTCookbook/test">
	<number>1</number>
</test:test>

<test:test num="2" ans="1" xmlns="http://www.ora.com/XSLTCookbook/test">
	<number>1</number>
</test:test>

<test:test num="3" ans="2" xmlns="http://www.ora.com/XSLTCookbook/test">
	<number>2</number>
</test:test>

<test:test num="4" ans="3628800" xmlns="http://www.ora.com/XSLTCookbook/test">
	<number>10</number>
</test:test>

<test:test num="5" ans="NaN" xmlns="http://www.ora.com/XSLTCookbook/test">
	<number>1.5</number>
</test:test>

<test:test num="6" ans="NaN" xmlns="http://www.ora.com/XSLTCookbook/test">
	<number>-1</number>
</test:test>

<test:test num="7" ans="NaN" xmlns="http://www.ora.com/XSLTCookbook/test">
	<number>NaN</number>
</test:test>

<test:test num="8" ans="NaN" xmlns="http://www.ora.com/XSLTCookbook/test">
	<number>0.1</number>
</test:test>

<test:test num="9" ans="NaN" xmlns="http://www.ora.com/XSLTCookbook/test">
	<number>foo</number>
</test:test>

</xsl:stylesheet>
