<?xml version="1.0"?>
<!-- edited with XML Spy v4.3 U (http://www.xmlspy.com) by Salvatore R Mangano (Man Machine Interfaces) -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
 xmlns:math="http://exslt.org/math" extension-element-prefixes="math" id="math:math.sqrt">

<xsl:template name="math:sqrt">
	<!-- The number you want to find the square root of -->
	<xsl:param name="number" select="0"/>
	<!-- The current 'try'.  This is used internally. -->
	<xsl:param name="try" select="($number &lt; 100) +
								   ($number >= 100 and $number &lt; 1000) * 10 +
								   ($number >= 1000 and $number &lt; 10000) * 31 +
								   ($number >= 10000) * 100"/>
	<!-- The current iteration, checked against maxiter to limit loop count -->
	<xsl:param name="iter" select="1"/>
	<!-- Set this up to ensure against infinite loops -->
	<xsl:param name="maxiter" select="10"/>
	<!-- This template was written by Nate Austin using Sir Isaac Newton's
      method of finding roots -->
	<xsl:choose>
		<xsl:when test="$try * $try = $number or $iter > $maxiter">
			<xsl:value-of select="$try"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:call-template name="math:sqrt">
				<xsl:with-param name="number" select="$number"/>
				<xsl:with-param name="try" select="$try - (($try * $try - $number) div (2 * $try))"/>
				<xsl:with-param name="iter" select="$iter + 1"/>
				<xsl:with-param name="maxiter" select="$maxiter"/>
			</xsl:call-template>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- TEST CODE: DO NOT REMOVE! -->
<xsl:template match="xsl:stylesheet[@id='math:math.sqrt'] | xsl:include[@href='math.sqrt.xslt']">
<xsl:message>
TESTING math:sqrt
</xsl:message>
<xsl:call-template name="test"/>
</xsl:template>

<xsl:template name="test">
	<xsl:param name="x" select="1"/>
	<xsl:param name="max" select="10000"/>
	<xsl:choose>
		<xsl:when test="$max >= $x">
				<xsl:variable name="root">
					<xsl:call-template name="math:sqrt">
						<xsl:with-param name="number" select="$x"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:if test="$x - $root * $root > 0.0000000001 or $x - $root * $root &lt; -0.0000000001">
					<xsl:message>
						math:sqrt TEST FAILED! sqrt(<xsl:value-of select="$x"/>) not within 1e-10 error tollerence  [<xsl:value-of select="$root"/>]
					</xsl:message>
				</xsl:if>
			<xsl:call-template name="test">
				<xsl:with-param name="x" select="$x + 1"/>
			</xsl:call-template>
		</xsl:when>
	</xsl:choose>
</xsl:template>


</xsl:stylesheet>
