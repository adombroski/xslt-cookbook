<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:math="http://www.ora.com/XSLTCookbook/math" id="math:math.roman">

<math:romans>
<math:roman value="1">i</math:roman>
<math:roman value="1">I</math:roman>
<math:roman value="5">v</math:roman>
<math:roman value="5">V</math:roman>
<math:roman value="10">x</math:roman>
<math:roman value="10">X</math:roman>
<math:roman value="50">l</math:roman>
<math:roman value="50">L</math:roman>
<math:roman value="100">c</math:roman>
<math:roman value="100">C</math:roman>
<math:roman value="500">d</math:roman>
<math:roman value="500">D</math:roman>
<math:roman value="1000">m</math:roman>
<math:roman value="1000">M</math:roman>
</math:romans>

<xsl:variable name="math:roman-nums" select="document('')/*/*/math:roman"/>


<xsl:template name="math:roman-to-number">
  <xsl:param name="roman"/>
  
  <xsl:variable name="valid-roman-chars">
    <xsl:value-of select="document('')/*/math:romans"/>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="translate($roman,$valid-roman-chars,'')">NaN</xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="math:roman-to-number-impl">
        <xsl:with-param name="roman" select="$roman"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>  
</xsl:template>

<xsl:template name="math:roman-to-number-impl">
  <xsl:param name="roman"/>
  <xsl:param name="value" select="0"/>
  
  <xsl:variable name="len" select="string-length($roman)"/>
  
  <xsl:choose>
    <xsl:when test="not($len)">
      <xsl:value-of select="$value"/>
    </xsl:when>
    <xsl:when test="$len = 1">
      <xsl:value-of select="$value + $math:roman-nums[. = $roman]/@value"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="roman-num"  select="$math:roman-nums[. = substring($roman, 1, 1)]"/>
      <xsl:choose>
        <xsl:when test="$roman-num/following-sibling::math:roman = substring($roman, 2, 1)">
          <xsl:call-template name="math:roman-to-number-impl">
            <xsl:with-param name="roman" select="substring($roman,2,$len - 1)"/>
            <xsl:with-param name="value" select="$value - $roman-num/@value"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="math:roman-to-number-impl">
            <xsl:with-param name="roman" select="substring($roman,2,$len - 1)"/>
            <xsl:with-param name="value" select="$value + $roman-num/@value"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
  
</xsl:template>

<!-- TEST CODE: DO NOT REMOVE! -->
<xsl:template match="xsl:stylesheet[@id='math:math.roman'] | xsl:include[@href='math.roman.xslt']">

<xsl:message>
TESTING math:roman
</xsl:message>

<xsl:call-template name="test-roman">
  <xsl:with-param name="f" select=" 'i' "/>
</xsl:call-template>

<xsl:call-template name="test-roman">
  <xsl:with-param name="f" select=" 'I' "/>
</xsl:call-template>

</xsl:template>

<xsl:template name="test-roman">
	<xsl:param name="f" select="'i'"/>
	<xsl:param name="x" select="1"/>
	<xsl:param name="max" select="900"/>
	<xsl:choose>
		<xsl:when test="$max >= $x">
		             <xsl:variable name="roman">
				  <xsl:number value="$x" format="{$f}"/>
		             </xsl:variable>
				<xsl:variable name="number">
					<xsl:call-template name="math:roman-to-number">
						<xsl:with-param name="roman" select="$roman"/>
					</xsl:call-template>
				</xsl:variable>
				<!-- Uncomment for visual inspection
				<xsl:message><xsl:value-of select="$roman"/> = <xsl:value-of select="$number"/></xsl:message>
				-->
				<xsl:if test="$x != $number">
					<xsl:message>
						math:roman TEST FAILED! roman(<xsl:value-of select="$roman"/>) != <xsl:value-of select="$x"/> [<xsl:value-of select="$number"/>]
					</xsl:message>
				</xsl:if>
			<xsl:call-template name="test-roman">
				<xsl:with-param name="x" select="$x + 1"/>
				<xsl:with-param name="f" select="$f"/>
			</xsl:call-template>
		</xsl:when>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>
