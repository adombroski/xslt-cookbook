<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:math="http://www.exslt.org/math" exclude-result-prefixes="math"
xmlns:test="http://www.ora.com/XSLTCookbook/test" id="math:math.max">

<xsl:template name="math:max">
	<xsl:param name="nodes" select="/.."/>
	<xsl:param name="max"/>
  <xsl:variable name="count" select="count($nodes)"/>
  <xsl:variable name="aNode" select="$nodes[ceiling($count div 2)]"/>
  <xsl:choose>
    <xsl:when test="not($count)">
      <xsl:value-of select="number($max)"/>
    </xsl:when>
    <xsl:when test="number($aNode) != number($aNode)">
      <xsl:value-of select="number($aNode)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="math:max">
        <xsl:with-param name="nodes" select="$nodes[not(. &lt;= number($aNode))]"/>
        <xsl:with-param name="max">
          <xsl:choose>
            <xsl:when test="not($max) or $aNode > $max">
              <xsl:value-of select="$aNode"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$max"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- TEST CODE: DO NOT REMOVE! -->
<xsl:template match="/xsl:stylesheet[@id='math:math.max'] | xsl:include[@href='math.max.xslt']">
<xsl:message>
TESTING math.max
</xsl:message>

<xsl:for-each select="document('')/*/test:test">
	<xsl:variable name="ans">
		<xsl:call-template name="math:max">
			<xsl:with-param name="nodes" select="test:data"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:if test="$ans != @ans">
		<xsl:message>
			math:max TEST <xsl:value-of select="@num"/> FAILED [<xsl:value-of select="$ans"/>]
		</xsl:message>
	</xsl:if>
</xsl:for-each>

<!-- Test with Infinity -->
<xsl:variable name="ans1">
	<xsl:call-template name="math:max">
		<xsl:with-param name="nodes" select="document('')/*/test:test[@num=1]/test:data"/>
		<xsl:with-param name="max" select="1 div 0"/>
	</xsl:call-template>
</xsl:variable>
<xsl:if test="$ans1 != Infinity">
	<xsl:message>
		math:max Infinity Test FAILED [<xsl:value-of select="$ans1"/>]
	</xsl:message>
</xsl:if>

<!-- Test with -Infinity -->
<xsl:variable name="ans2">
	<xsl:call-template name="math:max">
		<xsl:with-param name="nodes" select="document('')/*/test:test[@num=1]/test:data"/>
		<xsl:with-param name="max" select="-1 div 0"/>
	</xsl:call-template>
</xsl:variable>
<xsl:if test="$ans2 != document('')/*/test:test[@num=1]/@ans">
	<xsl:message>
		math:max -Infinity Test FAILED [<xsl:value-of select="$ans2"/>]
	</xsl:message>
</xsl:if>

</xsl:template>

<test:test num="1" ans="9" xmlns="http://www.ora.com/XSLTCookbook/test">
	<data>9</data>
	<data>8</data>
	<data>7</data>
	<data>6</data>
	<data>5</data>
	<data>4</data>
	<data>3</data>
	<data>2</data>
	<data>1</data>
</test:test>

<test:test num="2" ans="1" xmlns="http://www.ora.com/XSLTCookbook/test">
	<data>1</data>
</test:test>


<test:test num="3" ans="1" xmlns="http://www.ora.com/XSLTCookbook/test">
	<data>-1</data>
	<data>1</data>
</test:test>

<test:test num="4" ans="0" xmlns="http://www.ora.com/XSLTCookbook/test">
	<data>0</data>
	<data>0</data>
</test:test>

<test:test num="5" ans="NaN" xmlns="http://www.ora.com/XSLTCookbook/test">
	<data>foo</data>
	<data>1</data>
</test:test>

<test:test num="6" ans="NaN" xmlns="http://www.ora.com/XSLTCookbook/test">
	<data>1</data>
	<data>foo</data>
</test:test>

<test:test num="7" ans="NaN" xmlns="http://www.ora.com/XSLTCookbook/test">
</test:test>

</xsl:stylesheet>
