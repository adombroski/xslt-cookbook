<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:math="http://exslt.org/math" extension-element-prefixes="math" id="math:math.constant">

<!--Important Constants -->
<math:constant name="PI" 					whole-len='2'>3.141592653589793</math:constant>
<math:constant name="E" 					whole-len='2'>2.718281828459045</math:constant>
<math:constant name="SQRRT2" 			whole-len='2'>1.414213562373095</math:constant>
<math:constant name="LN2" 					whole-len='2'>0.693147180559945</math:constant>
<math:constant name="LN10" 				whole-len='2'>2.302585092994046</math:constant>
<math:constant name="LOG2E" 				whole-len='2'>1.442695040888963</math:constant>
<math:constant name="SQRT1_2" 			whole-len='2'>0.707106781186548</math:constant>

<!-- Convenience variables when full precision is needed -->
<xsl:variable name="math:PI" select="number(document('')/*/math:constant[@name='PI'])"/>
<xsl:variable name="math:E" select="number(document('')/*/math:constant[@name='E'])"/>
<xsl:variable name="math:SQRRT2" select="number(document('')/*/math:constant[@name='SQRRT2'])"/>
<xsl:variable name="math:LN2" select="number(document('')/*/math:constant[@name='LN2'])"/>
<xsl:variable name="math:LOG2E" select="number(document('')/*/math:constant[@name='LOG2E'])"/>
<xsl:variable name="math:SQRT1_2" select="number(document('')/*/math:constant[@name='SQRT1_2'])"/>

<!-- Return a constant of specified name and precision -->
<xsl:template name="math:constant">
	<xsl:param name="name"/>
	<xsl:param name="precision" select="2"/>
	
	<xsl:variable name="prec" select="($precision &lt; 0 or $precision > 15) * 15 + 
										($precision >= 0 and $precision &lt;= 15) * $precision"/>

       <xsl:variable name="r" select="number(substring('1000000000000000',1,$prec+1))"/>
	<xsl:value-of select="floor(document('')/*/math:constant[@name=$name] * $r) div $r"/>
       
	<!-- Another way to do it
	<xsl:for-each select="document('')/*/math:constant[@name=$name]">
		<xsl:value-of select="number(substring(.,1,$prec+@whole-len))"/>
	</xsl:for-each>
	-->
</xsl:template>
<!-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->




<!-- TEST CODE: DO NOT REMOVE! -->
<xsl:template match="/xsl:stylesheet[@id='math:math.constant'] | xsl:include[@href='math.constant.xslt']">
<xsl:message>
TESTING math.constant
</xsl:message>
<xsl:call-template name="test"/>

<xsl:variable name="testPI">
	<xsl:call-template name="math:constant">
		<xsl:with-param name="name" select=" 'PI' "/>
		<xsl:with-param name="precision" select="-1"/>
	</xsl:call-template>
</xsl:variable>
<xsl:if test="$testPI != $math:PI">
<xsl:message>
Error in constant PI [<xsl:value-of select="$testPI"/>][<xsl:value-of select="$math:PI"/>]
</xsl:message>
</xsl:if>

<xsl:variable name="testE">
	<xsl:call-template name="math:constant">
		<xsl:with-param name="name" select=" 'E' "/>
		<xsl:with-param name="precision" select="-1"/>
	</xsl:call-template>
</xsl:variable>
<xsl:if test="$testE != $math:E">
<xsl:message>
Error in constant E [<xsl:value-of select="$testE"/>][<xsl:value-of select="$math:E"/>]
</xsl:message>
</xsl:if>

<xsl:variable name="testSQRRT2">
	<xsl:call-template name="math:constant">
		<xsl:with-param name="name" select=" 'SQRRT2' "/>
		<xsl:with-param name="precision" select="-1"/>
	</xsl:call-template>
</xsl:variable>
<xsl:if test="$testSQRRT2 != $math:SQRRT2">
<xsl:message>
Error in constant SQRRT2 [<xsl:value-of select="$testSQRRT2"/>][<xsl:value-of select="$math:SQRRT2"/>]
</xsl:message>
</xsl:if>

<xsl:variable name="testLN2">
	<xsl:call-template name="math:constant">
		<xsl:with-param name="name" select=" 'LN2' "/>
		<xsl:with-param name="precision" select="-1"/>
	</xsl:call-template>
</xsl:variable>
<xsl:if test="$testLN2 != $math:LN2">
<xsl:message>
Error in constant LN2 [<xsl:value-of select="$testLN2"/>][<xsl:value-of select="$math:LN2"/>]
</xsl:message>
</xsl:if>

<xsl:variable name="testLOG2E">
	<xsl:call-template name="math:constant">
		<xsl:with-param name="name" select=" 'LOG2E' "/>
		<xsl:with-param name="precision" select="-1"/>
	</xsl:call-template>
</xsl:variable>
<xsl:if test="$testLOG2E != $math:LOG2E">
<xsl:message>
Error in constant LOG2E [<xsl:value-of select="$testLOG2E"/>][<xsl:value-of select="$math:LOG2E"/>]
</xsl:message>
</xsl:if>

<xsl:variable name="testSQRT1_2">
	<xsl:call-template name="math:constant">
		<xsl:with-param name="name" select=" 'SQRT1_2' "/>
		<xsl:with-param name="precision" select="-1"/>
	</xsl:call-template>
</xsl:variable>
<xsl:if test="$testSQRT1_2 != $math:SQRT1_2">
<xsl:message>
Error in constant SQRT1_2 [<xsl:value-of select="$testSQRT1_2"/>][<xsl:value-of select="$math:SQRT1_2"/>]
</xsl:message>
</xsl:if>


</xsl:template>

<xsl:template name="test">
<xsl:param name="prec" select="0"/>
<xsl:param name="max-prec" select="17"/>

<xsl:if test="$max-prec >= $prec">
	<xsl:for-each select="document('')/*/math:constant">
		<xsl:variable name="value">
			<xsl:call-template name="math:constant">
				<xsl:with-param name="name" select="@name"/>
				<xsl:with-param name="precision" select="$prec"/>
			</xsl:call-template>
		</xsl:variable>

		<!-- REMOVE COMMENT FOR VISUAL INSPECTION
		<xsl:message>
			[<xsl:value-of select="$value"/>]
		</xsl:message>
		-->
		
		<xsl:if test="$value != number(substring(.,1,$prec+@whole-len))">
			<xsl:message>
			math:constant(<xsl:value-of select="@name"/>,<xsl:value-of select="$prec"/>) failed. [<xsl:value-of select="$value"/>][<xsl:value-of select="substring(.,1,$prec+@whole-len)"/>]
			</xsl:message>
		</xsl:if>
	</xsl:for-each>
	<xsl:call-template name="test">
		<xsl:with-param name="prec" select="$prec + 1"/>
	</xsl:call-template>
</xsl:if>
</xsl:template>


</xsl:stylesheet>
