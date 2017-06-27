<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:math="http://exslt.org/math" 
	xmlns:test="http://www.ora.com/XSLTCookbook/test"
	extension-element-prefixes="math test" id="math:math.power">

<xsl:import href="math.log.xslt"/>


<xsl:template name="math:power">
	<xsl:param name="base"/>
	<xsl:param name="power"/>
	<xsl:param name="result" select="1"/>
	<xsl:choose>
		<xsl:when test="number($base) != $base or number($power) != $power">
			<xsl:value-of select="'NaN'"/>
		</xsl:when>
		<xsl:when test="$power = 0">
			<xsl:value-of select="$result"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:call-template name="math:power">
				<xsl:with-param name="base" select="$base * $base"/>
				<xsl:with-param name="power" select="floor($power div 2)"/>
				<xsl:with-param name="result" select="$result * $base * ($power mod 2) + $result * not($power mod 2)"/>
			</xsl:call-template>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="math:power-f">
	<xsl:param name="base"/>
	<xsl:param name="power"/>
	
	<xsl:choose>
		<xsl:when test="number($base) != $base or number($power) != $power">
			<xsl:value-of select="'NaN'"/>
		</xsl:when>
		<xsl:when test="$power &lt; 0">
			<xsl:variable name="result">
				<xsl:call-template name="math:power-f">
					<xsl:with-param name="base" select="$base"/>
					<xsl:with-param name="power" select="-1 * $power"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:value-of select="1 div $result"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:variable name="powerN" select="floor($power)"/>
			<xsl:variable name="resultN">
				<xsl:call-template name="math:power">
					<xsl:with-param name="base" select="$base"/>
					<xsl:with-param name="power" select="$powerN"/>
				</xsl:call-template>
			</xsl:variable>		
			<xsl:choose>
				<xsl:when test="$power - $powerN">
					<xsl:variable name="resultF">
						<xsl:call-template name="math:power-frac">
							<xsl:with-param name="base" select="$base"/>
							<xsl:with-param name="power" select="$power - $powerN"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:value-of select="$resultN * $resultF"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$resultN"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="math:power-frac">
	<xsl:param name="base"/>
	<xsl:param name="power"/>

	<xsl:param name="n" select="1"/>
	<xsl:param name="ln_base">
		<xsl:call-template name="math:log">
			<xsl:with-param name="number" select="$base"/>
		</xsl:call-template>
	</xsl:param>
	<xsl:param name="ln_base_n" select="$ln_base"/>
	<xsl:param name="power_n" select="$power"/>
	<xsl:param name="n_fact" select="$n"/>
	<xsl:param name="result" select="1"/>
	 
	 <xsl:choose>
			<xsl:when test="20 >= $n">
			<xsl:call-template name="math:power-frac">
				<xsl:with-param name="base" select="$base"/>
				<xsl:with-param name="power" select="$power"/>
				<xsl:with-param name="n" select="$n + 1"/>
				<xsl:with-param name="ln_base" select="$ln_base "/>
				<xsl:with-param name="ln_base_n" select="$ln_base_n * $ln_base"/>
				<xsl:with-param name="power_n" select="$power_n * $power"/>
				<xsl:with-param name="n_fact" select="$n_fact * ($n+1)"/>
				<xsl:with-param name="result" select="$result + ($power_n * $ln_base_n) div $n_fact"/>
			</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="round($result * 1000000000) div 1000000000"/>
			</xsl:otherwise>
		</xsl:choose>
</xsl:template>	

<!-- TEST CODE: DO NOT REMOVE! -->
<xsl:template match="xsl:stylesheet[@id='math:math.power'] | xsl:include[@href='math.power.xslt'] " >

<xsl:message>
TESTING math.power
</xsl:message>

	<xsl:for-each select="document('')/*/test:test">
		<xsl:variable name="ans">
			<xsl:call-template name="math:power-f">
				<xsl:with-param name="power" select="test:power"/>
				<xsl:with-param name="base" select="test:base"/>
			</xsl:call-template>
		</xsl:variable>
		<!-- Uncomment for visual inspection
		<xsl:message>
			pow(<xsl:value-of select="test:base"/>,<xsl:value-of select="test:power"/>) = [<xsl:value-of select="$ans"/>]
		</xsl:message>
		-->
		<xsl:if test="$ans - @ans > 0.000000001 or $ans - @ans &lt; -0.000000001">
			<xsl:message>
				math:power TEST <xsl:value-of select="@num"/> FAILED [<xsl:value-of select="$ans"/>]
			</xsl:message>
		</xsl:if>
	</xsl:for-each>

</xsl:template>	

<test:test num="1" ans="2.7182818284590452353602874713527" xmlns="http://www.ora.com/XSLTCookbook/test">
	<power>1</power>
	<base>2.718281828459045</base>
</test:test>

<test:test num="2" ans="1" xmlns="http://www.ora.com/XSLTCookbook/test">
	<power>0</power>
	<base>2.718281828459045</base>
</test:test>

<test:test num="3" ans="0.36787944117144232159552377016146" xmlns="http://www.ora.com/XSLTCookbook/test">
	<power>-1</power>
	<base>2.718281828459045</base>
</test:test>

<test:test num="4" ans="1.6487212707001281468486507878142" xmlns="http://www.ora.com/XSLTCookbook/test">
	<power>0.5</power>
	<base>2.718281828459045</base>
</test:test>

<test:test num="5" ans="4.4816890703380648226020554601193" xmlns="http://www.ora.com/XSLTCookbook/test">
	<power>1.5</power>
	<base>2.718281828459045</base>
</test:test>

<test:test num="6" ans="0.22313016014842982893328047076401" xmlns="http://www.ora.com/XSLTCookbook/test">
	<power>-1.5</power>
	<base>2.718281828459045</base>
</test:test>

<test:test num="7" ans="NaN" xmlns="http://www.ora.com/XSLTCookbook/test">
	<power>NaN</power>
	<base>2.718281828459045</base>
</test:test>

<test:test num="8" ans="NaN" xmlns="http://www.ora.com/XSLTCookbook/test">
	<power>1</power>
	<base>NaN</base>
</test:test>

<test:test num="9" ans="0" xmlns="http://www.ora.com/XSLTCookbook/test">
	<power>10</power>
	<base>0</base>
</test:test>

<test:test num="10" ans="1" xmlns="http://www.ora.com/XSLTCookbook/test">
	<power>0</power>
	<base>0</base>
</test:test>


</xsl:stylesheet>
