<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:xslx="http://www.ora.com/XSLTCookbook/ExtendedXSLT" >

<xsl:output method="text"/>
	
<xsl:template match="foo">
  <xslx:if test="bar">
    <xsl:text>You often will find a bar in the neighborhood of foo!</xsl:text>
  </xslx:if>
  <xslx:elsif test="baz">
    <xsl:text>A baz is a sure sign of geekdom</xsl:text>
  </xslx:elsif>
  <xslx:else>
    <xslx:loop param="i" init="0" test="$i &lt; 10" incr="1">
      <xsl:text>Hmmm, nothing to say here but I'll say it 10 times.</xsl:text>
    </xslx:loop>
  </xslx:else>
  <xslx:loop param="i" init="10" test="$i >= 0" incr="-1">
    <xslx:loop param="j" init="10" test="$j >= 0" incr="-1">
      <xsl:text>&#xa;</xsl:text>
      <xsl:value-of select="$i * $j"/>
    </xslx:loop>
  </xslx:loop>
  <xslx:if test="foo">
  	<xsl:text>foo foo! Nobody says foo foo!</xsl:text>
  </xslx:if>
  <xslx:else>
  	<xsl:text>Well, okay then!</xsl:text>
  </xslx:else>
</xsl:template>

</xsl:stylesheet>
