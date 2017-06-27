<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:math="http://www.exslt.org/math" exclude-result-prefixes="math" xmlns:test="http://www.ora.com/XSLTCookbook/test">

<!-- EXSLT impl for reference 
<xsl:template name="math:min">
   <xsl:param name="nodes" select="/.." />
   <xsl:choose>
      <xsl:when test="not($nodes)">NaN</xsl:when>
      <xsl:otherwise>
         <xsl:for-each select="$nodes">
            <xsl:sort data-type="number" />
            <xsl:if test="position() = 1">
               <xsl:value-of select="number(.)" />
            </xsl:if>
         </xsl:for-each>
      </xsl:otherwise>
   </xsl:choose>
</xsl:template>
-->

<xsl:template name="math:min-max">
  <xsl:param name="nodes" select="/.."/>
  <xsl:param name="nodes-for-max" select="$nodes"/>
  <xsl:param name="min"/>
  <xsl:param name="max"/>
  <xsl:variable name="count1" select="count($nodes)"/>
  <xsl:variable name="aNode1" select="$nodes[ceiling($count1 div 2)]"/>
  <xsl:variable name="count2" select="count($nodes-for-max)"/>
  <xsl:variable name="aNode2" select="$nodes-for-max[ceiling($count2 div 2)]"/>
  <xsl:choose>
    <xsl:when test="not($count1) and not($count2)">
      <xsl:value-of select="concat(number($min),',',number($max))"/>
    </xsl:when>
    <xsl:when test="number($aNode1) != number($aNode1) and number($aNode2) != number($aNode2)">
      <xsl:value-of select="concat(number($aNode1),',',number($aNode2))"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="math:min-max">
        <xsl:with-param name="nodes" select="$nodes[not(. >= number($aNode1))]"/>
        <xsl:with-param name="nodes-for-max" select="$nodes-for-max[not(. &lt;= number($aNode2))]"/>
        <xsl:with-param name="min">
          <xsl:choose>
            <xsl:when test="not($min) or $aNode1 &lt; $min">
              <xsl:value-of select="$aNode1"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$min"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
        <xsl:with-param name="max">
          <xsl:choose>
            <xsl:when test="not($max) or $aNode2 > $max">
              <xsl:value-of select="$aNode2"/>
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

<!--
-->

  <!-- TEST CODE: DO NOT REMOVE! 
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
  -->
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
