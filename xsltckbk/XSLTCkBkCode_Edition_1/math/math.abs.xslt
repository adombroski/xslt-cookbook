<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:math="http://exslt.org/math" extension-element-prefixes="math" id="math:math.abs">

<!-- The obscure but brief way -->

<xsl:template name="math:abs">
	<xsl:param name="number"/>
	<xsl:value-of select="(1 - 2*($number&lt;0)) * $number"/>
</xsl:template>

<!-- The long-winded way -->

<xsl:template name="math:abs2">
	<xsl:param name="number"/>
	<xsl:choose>
		<xsl:when test="$number &lt; 0">
			<xsl:value-of select="$number * -1"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$number"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!--TEST CODE -->
<xsl:template match="xsl:stylesheet[@id='math:math.abs'] | xsl:include[@href='math.abs.xslt']">

<xsl:message>
TESTING math.abs
</xsl:message>

	<xsl:variable name="test1">
		<xsl:call-template name="math:abs">
			<xsl:with-param name="number" select="0"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:if test="$test1 != 0">
		<xsl:message>
		math:abs TEST1 FAILED! abs(0) != 0 [<xsl:value-of select="$test1"/>]
		</xsl:message>
	</xsl:if>

	<xsl:variable name="test2">
		<xsl:call-template name="math:abs">
			<xsl:with-param name="number" select="1"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:if test="$test2 != 1">
		<xsl:message>
		math:abs TEST2 FAILED! abs(1) != 1 [<xsl:value-of select="$test2"/>]
		</xsl:message>
	</xsl:if>

	<xsl:variable name="test3">
		<xsl:call-template name="math:abs">
			<xsl:with-param name="number" select="-1"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:if test="$test3 != 1">
		<xsl:message>
		math:abs TEST3 FAILED! abs(-1) != 1 [<xsl:value-of select="$test3"/>]
		</xsl:message>
	</xsl:if>

	<xsl:variable name="test4">
		<xsl:call-template name="math:abs">
			<xsl:with-param name="number" select="NaN"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:if test="number($test4)">
		<xsl:message>
		math:abs TEST4 FAILED! abs(NaN) != NaN [<xsl:value-of select="$test4"/>]
		</xsl:message>
	</xsl:if>

	<xsl:variable name="test5">
		<xsl:call-template name="math:abs">
			<xsl:with-param name="number" select="1 div 0"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:if test="$test5 != Infinity">
		<xsl:message>
		math:abs TEST5 FAILED! abs(infinity) != infinity [<xsl:value-of select="$test5"/>]
		</xsl:message>
	</xsl:if>

	<xsl:variable name="test6">
		<xsl:call-template name="math:abs">
			<xsl:with-param name="number" select="-1 div 0"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:if test="$test6 != Infinity">
		<xsl:message>
		math:abs TEST6 FAILED! abs(-infinity) != infinity [<xsl:value-of select="$test6"/>]
		</xsl:message>
	</xsl:if>

	<!-- Test abs2 -->

	<xsl:variable name="test2-1">
		<xsl:call-template name="math:abs2">
			<xsl:with-param name="number" select="0"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:if test="$test2-1 != 0">
		<xsl:message>
		math:abs2 test2-1 FAILED! abs2(0) != 0 [<xsl:value-of select="$test2-1"/>]
		</xsl:message>
	</xsl:if>

	<xsl:variable name="test2-2">
		<xsl:call-template name="math:abs2">
			<xsl:with-param name="number" select="1"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:if test="$test2-2 != 1">
		<xsl:message>
		math:abs2 test2-2 FAILED! abs2(1) != 1 [<xsl:value-of select="$test2-2"/>]
		</xsl:message>
	</xsl:if>

	<xsl:variable name="test2-3">
		<xsl:call-template name="math:abs2">
			<xsl:with-param name="number" select="-1"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:if test="$test2-3 != 1">
		<xsl:message>
		math:abs2 test2-3 FAILED! abs2(-1) != 1 [<xsl:value-of select="$test2-3"/>]
		</xsl:message>
	</xsl:if>

	<xsl:variable name="test2-4">
		<xsl:call-template name="math:abs2">
			<xsl:with-param name="number" select="NaN"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:if test="number($test2-4)">
		<xsl:message>
		math:abs2 test2-4 FAILED! abs2(NaN) != NaN [<xsl:value-of select="$test2-4"/>]
		</xsl:message>
	</xsl:if>

	<xsl:variable name="test2-5">
		<xsl:call-template name="math:abs2">
			<xsl:with-param name="number" select="1 div 0"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:if test="$test2-5 != Infinity">
		<xsl:message>
		math:abs2 test2-5 FAILED! abs2(infinity) != infinity [<xsl:value-of select="$test2-5"/>]
		</xsl:message>
	</xsl:if>

	<xsl:variable name="test2-6">
		<xsl:call-template name="math:abs2">
			<xsl:with-param name="number" select="-1 div 0"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:if test="$test2-6 != Infinity">
		<xsl:message>
		math:abs2 test2-6 FAILED! abs2(-infinity) != infinity [<xsl:value-of select="$test2-6"/>]
		</xsl:message>
	</xsl:if>
</xsl:template>


</xsl:stylesheet>
