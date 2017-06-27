<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:math="http://exslt.org/math" extension-element-prefixes="math test"
 xmlns:test="http://www.ora.com/XSLTCookbook/test" id="math:math.exp">


<xsl:import href="math.power.xslt"/>
<xsl:import href="math.constant.xslt"/>

<xsl:template name="math:exp">
	<xsl:param name="power" select="1"/>
	<xsl:call-template name="math:power-f">
		<xsl:with-param name="power" select="$power"/>
		<xsl:with-param name="base" select="$math:E"/>
	</xsl:call-template>
</xsl:template>

<!-- TEST CODE: DO NOT REMOVE! -->
<xsl:template match="xsl:stylesheet[@id='math:math.exp'] | xsl:include[@href='math.exp.xslt'] ">
<xsl:message>
TESTING math.exp
</xsl:message>

	<xsl:for-each select="document('')/*/test:test">
		<xsl:variable name="ans">
			<xsl:call-template name="math:exp">
				<xsl:with-param name="power" select="test:power"/>
			</xsl:call-template>
		</xsl:variable>
		<!-- Uncomment for visual inspection
		<xsl:message>
			exp(<xsl:value-of select="test:power"/>) = [<xsl:value-of select="$ans"/>]
		</xsl:message>
		-->
		<xsl:if test="$ans - @ans > 0.000000001 or $ans - @ans &lt; -0.000000001">
			<xsl:message>
				math:exp TEST <xsl:value-of select="@num"/> FAILED [<xsl:value-of select="$ans"/>]
			</xsl:message>
		</xsl:if>
	</xsl:for-each>
</xsl:template>


<test:test num="1" ans="2.7182818284590452353602874713527" xmlns="http://www.ora.com/XSLTCookbook/test">
	<power>1</power>
</test:test>

<test:test num="2" ans="1" xmlns="http://www.ora.com/XSLTCookbook/test">
	<power>0</power>
</test:test>

<test:test num="3" ans="0.36787944117144232159552377016146" xmlns="http://www.ora.com/XSLTCookbook/test">
	<power>-1</power>
</test:test>

<test:test num="4" ans="1.6487212707001281468486507878142" xmlns="http://www.ora.com/XSLTCookbook/test">
	<power>0.5</power>
</test:test>

<test:test num="5" ans="4.4816890703380648226020554601193" xmlns="http://www.ora.com/XSLTCookbook/test">
	<power>1.5</power>
</test:test>

<test:test num="6" ans="0.22313016014842982893328047076401" xmlns="http://www.ora.com/XSLTCookbook/test">
	<power>-1.5</power>
</test:test>

<test:test num="7" ans="NaN" xmlns="http://www.ora.com/XSLTCookbook/test">
	<power>NaN</power>
</test:test>

<test:test num="8" ans="NaN" xmlns="http://www.ora.com/XSLTCookbook/test">
	<power>1</power>
</test:test>

<test:test num="9" ans="22026.465794806716516957900645284" xmlns="http://www.ora.com/XSLTCookbook/test">
	<power>10</power>
</test:test>

<test:test num="10" ans="1" xmlns="http://www.ora.com/XSLTCookbook/test">
	<power>0</power>
</test:test>

<!--

<test:test num="4" ans="NaN" xmlns="http://www.ora.com/XSLTCookbook/test">
	<data>NaN</data>
</test:test>

<test:test num="5" ans="NaN" xmlns="http://www.ora.com/XSLTCookbook/test">
</test:test>
-->

</xsl:stylesheet>
