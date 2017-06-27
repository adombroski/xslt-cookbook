<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:math="http://www.exslt.org/math" exclude-result-prefixes="math" xmlns:test="http://www.ora.com/XSLTCookbook/test">

<xsl:template name="math:min">
  <xsl:param name="nodes" select="/.."/>
  <xsl:param name="min" select="number('NaN')"/>
  <xsl:choose>
    <xsl:when test="not($nodes)">
      <xsl:value-of select="number($min)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="aNode" select="$nodes[1]"/>
      <xsl:call-template name="math:min">
        <xsl:with-param name="nodes" select="$nodes[position() > 1]"/>
        <xsl:with-param name="min">
          <xsl:choose>
            <xsl:when test="$aNode &lt; $min or number($aNode) != number($aNode) or string($min) = 'NaN'">
              <xsl:value-of select="$aNode"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$min"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
  
  <!-- TEST CODE: DO NOT REMOVE! -->
  <xsl:template match="/ | xsl:include[@href='math.min.xslt'] " priority="-1000">
    <xsl:message>
TESTING math.min
</xsl:message>
    <xsl:for-each select="document('')/*/test:test">
      <xsl:variable name="ans">
        <xsl:call-template name="math:min">
          <xsl:with-param name="nodes" select="test:data"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:if test="$ans != @ans">
        <xsl:message>
			math:min TEST <xsl:value-of select="@num"/> FAILED [<xsl:value-of select="$ans"/>]
		</xsl:message>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
  <test:test num="1" ans="1" xmlns="http://www.ora.com/XSLTCookbook/test">
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
  <test:test num="3" ans="-1" xmlns="http://www.ora.com/XSLTCookbook/test">
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
  <test:test num="7" ans="-1" xmlns="http://www.ora.com/XSLTCookbook/test">
    <data>1</data>
    <data>0</data>
    <data>0</data>
    <data>-1</data>
  </test:test>
  <test:test num="7.1" ans="NaN" xmlns="http://www.ora.com/XSLTCookbook/test">
    <data>1</data>
    <data>0</data>
    <data>0</data>
    <data>-1</data>
    <data>foo</data>
  </test:test>
  <test:test num="7.2" ans="NaN" xmlns="http://www.ora.com/XSLTCookbook/test">
    <data>foo</data>
    <data>1</data>
    <data>0</data>
    <data>0</data>
    <data>-1</data>
    <data>foo</data>
  </test:test>
  <test:test num="8" ans="NaN" xmlns="http://www.ora.com/XSLTCookbook/test"/>
  <!-- Yes, 2. This is because IEEE can't possibly store 1.999...9 exactly -->
  <test:test num="9" ans="2" xmlns="http://www.ora.com/XSLTCookbook/test">
    <data>1.999999999999999999999999999999999999999999</data>
    <data>2</data>
  </test:test>
  <!-- Yes, 2. This is because IEEE can't possibly store 1.999...9 exactly -->
  <test:test num="9.1" ans="2" xmlns="http://www.ora.com/XSLTCookbook/test">
    <data>1.999999999999999999999999999999999999999999</data>
    <data>1.9999999999999999</data>
  </test:test>
  <test:test num="9.1" ans="1.999999999999999" xmlns="http://www.ora.com/XSLTCookbook/test">
    <data>1.999999999999999999999999999999999999999999</data>
    <data>1.999999999999999</data>
  </test:test>
</xsl:stylesheet>
