<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:math="http://exslt.org/math" extension-element-prefixes="math" id="math:math.log">


<!-- Computes log10 (base 10l) of number-->
<xsl:template name="math:log10">
	<xsl:param name="number" select="1"/>

	<xsl:param name="n" select="0"/> <!-- book keeping for whole part of result -->
	
	<xsl:choose>
		<xsl:when test="$number &lt;= 0"> <!-- Logarithms are undefined for 0 and negative numbers -->
			<xsl:value-of select="NaN"/>
		</xsl:when>
		<xsl:when test="$number &lt; 1">  <!-- Fractional numbers have negative logs -->
			<xsl:call-template name="math:log10">
				<xsl:with-param name="number" select="$number * 10"/>
				<xsl:with-param name="n" select="$n - 1"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:when test="$number > 10"> <!-- Numbers greater than 10 have logs greater than 1 -->
			<xsl:call-template name="math:log10">
				<xsl:with-param name="number" select="$number div 10"/>
				<xsl:with-param name="n" select="$n + 1"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:when test="$number = 10"> 
			<xsl:value-of select="$n + 1"/>
		</xsl:when>
		<xsl:otherwise>		<!-- We only need to know how to compute for numbers in range [1,10) -->
			<xsl:call-template name="math:log10-util">
				<xsl:with-param name="number" select="$number"/>
				<xsl:with-param name="n" select="$n"/>
			</xsl:call-template>
		</xsl:otherwise>
	</xsl:choose>
	
</xsl:template>


<!-- Computes log (natural) of number-->
<xsl:template name="math:log">
	<xsl:param name="number" select="1"/>

	<xsl:variable name="log10-e" select="0.4342944819"/>
	<xsl:variable name="log10">
		<xsl:call-template name="math:log10">
			<xsl:with-param name="number" select="$number"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:value-of select="$log10 div $log10-e"/>
</xsl:template>

<!-- Computes log to base b of number-->
<xsl:template name="math:log-b">
	<xsl:param name="number" select="1"/>
	<xsl:param name="base" select="2"/>

	<xsl:variable name="log10-base">
		<xsl:call-template name="math:log10">
			<xsl:with-param name="number" select="$base"/>
		</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="log10">
		<xsl:call-template name="math:log10">
			<xsl:with-param name="number" select="$number"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:value-of select="$log10 div $log10-base"/>
</xsl:template>


<!-- Computes log10 of numbers in the range [1,10) and returns the result + n-->
<xsl:template name="math:log10-util">
	<xsl:param name="number"/>
	
	<xsl:param name="n"/>
	
	<xsl:param name="frac" select="0"/> <!-- book keeping variable for fractional part -->
	<xsl:param name="k" select="0"/>      <!-- iteration counter -->
	<xsl:param name="divisor" select="2"/> <!-- sucessive powers of 2 used to build up frac -->
	<xsl:param name="maxiter" select="38"/> <!-- Number of iterations. 38 is more than sufficient to get at least 10 dec place prec -->

	<xsl:variable name="x" select="$number * $number"/>
	
	<xsl:choose>
		<xsl:when test="$k >= $maxiter">
			<!-- Round to 10 decimal places -->
			<xsl:value-of select="$n + round($frac * 10000000000) div 10000000000"/> 
		</xsl:when>
		<xsl:when test="$x &lt; 10">
			<xsl:call-template name="math:log10-util">
				<xsl:with-param name="number" select="$x"/>
				<xsl:with-param name="n" select="$n"/>
				<xsl:with-param name="k" select="$k + 1"/>
				<xsl:with-param name="divisor" select="$divisor * 2"/>
				<xsl:with-param name="frac" select="$frac"/>
				<xsl:with-param name="maxiter" select="$maxiter"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:call-template name="math:log10-util">
				<xsl:with-param name="number" select="$x div 10"/>
				<xsl:with-param name="n" select="$n"/>
				<xsl:with-param name="k" select="$k + 1"/>
				<xsl:with-param name="divisor" select="$divisor * 2"/>
				<xsl:with-param name="frac" select="$frac + (1 div $divisor)"/>
				<xsl:with-param name="maxiter" select="$maxiter"/>
			</xsl:call-template>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- TEST CODE: DO NOT REMOVE! -->
<xsl:template match="xsl:stylesheet[@id='math:math.log'] | xsl:include[@href='math.log.xslt'] ">

<xsl:message>
TESTING math.log
</xsl:message>

<xsl:variable name="test1">
	<xsl:call-template name="math:log10">
		<xsl:with-param name="number" select="1"/>
	</xsl:call-template>
</xsl:variable>
<xsl:if test="$test1 != 0">
	<xsl:message>
	math:abs TEST1 FAILED! log10(0) != 0 [<xsl:value-of select="$test1"/>]
	</xsl:message>
</xsl:if>

<xsl:variable name="test2">
	<xsl:call-template name="math:log10">
		<xsl:with-param name="number" select="10"/>
	</xsl:call-template>
</xsl:variable>
<xsl:if test="$test2 != 1">
	<xsl:message>
	math:abs TEST2 FAILED! log10(10) != 1 [<xsl:value-of select="$test2"/>]
	</xsl:message>
</xsl:if>

<xsl:variable name="test3">
	<xsl:call-template name="math:log10">
		<xsl:with-param name="number" select="0.1"/>
	</xsl:call-template>
</xsl:variable>
<xsl:if test="$test3 != -1">
	<xsl:message>
	math:abs TEST3 FAILED! log10(0.1) != -1 [<xsl:value-of select="$test3"/>]
	</xsl:message>
</xsl:if>

<xsl:variable name="test4">
	<xsl:call-template name="math:log10">
		<xsl:with-param name="number" select="500"/>
	</xsl:call-template>
</xsl:variable>
<xsl:if test="$test4 - 2.6989700043360188047862611052755 > 0.0000000001 or $test4 - 2.6989700043360188047862611052755 &lt; -0.0000000001">
	<xsl:message>
	math:abs TEST4 FAILED! log10(500) != 2.6989700043360188047862611052755 within 1e-10 [<xsl:value-of select="$test4"/>]
	</xsl:message>
</xsl:if>

<xsl:variable name="test5">
	<xsl:call-template name="math:log10">
		<xsl:with-param name="number" select="1000000000000"/>
	</xsl:call-template>
</xsl:variable>
<xsl:if test="$test5 != 12">
	<xsl:message>
	math:abs TEST5 FAILED! log10(1000000000000) != 12 [<xsl:value-of select="$test5"/>]
	</xsl:message>
</xsl:if>

<xsl:variable name="test6">
	<xsl:call-template name="math:log10">
		<xsl:with-param name="number" select="0.000000000001"/>
	</xsl:call-template>
</xsl:variable>
<xsl:if test="$test6 != -12">
	<xsl:message>
	math:abs TEST6 FAILED! log10(0.000000000001) != -12 [<xsl:value-of select="$test6"/>]
	</xsl:message>
</xsl:if>

<xsl:variable name="test7">
	<xsl:call-template name="math:log10">
		<xsl:with-param name="number" select="0"/>
	</xsl:call-template>
</xsl:variable>
<xsl:if test="$test7 != NaN">
	<xsl:message>
	math:abs TEST7 FAILED! log10(0) != NaN [<xsl:value-of select="$test7"/>]
	</xsl:message>
</xsl:if>

<xsl:variable name="test8">
	<xsl:call-template name="math:log10">
		<xsl:with-param name="number" select="-1"/>
	</xsl:call-template>
</xsl:variable>
<xsl:if test="$test8 != NaN">
	<xsl:message>
	math:abs TEST8 FAILED! log10(-1) != NaN [<xsl:value-of select="$test8"/>]
	</xsl:message>
</xsl:if>

<xsl:variable name="test9">
	<xsl:call-template name="math:log">
		<xsl:with-param name="number" select="2.71828182846"/>
	</xsl:call-template>
</xsl:variable>
<xsl:if test="$test9 != 1">
	<xsl:message>
	math:abs TEST9 FAILED! log(e) !=1 [<xsl:value-of select="$test9"/>]
	</xsl:message>
</xsl:if>

</xsl:template>


</xsl:stylesheet>
