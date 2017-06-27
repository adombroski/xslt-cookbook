<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text"/>
	
<xsl:template match="foo">
  <xsl:if test="bar">
    <xsl:text>You often will find a bar in the neiggborhood of foo</xsl:text>
  </xsl:if>
  <xsl:elsif test="baz">
    <xsl:text>A baz is a sure sign of geekdom</xsl:text>
  </xsl:elsif>
  <xsl:else>
    <xsl:loop param="i" init="0" test="$i &lt; 10" incr="1">
      <xsl:text>Hmmm, nothing to say here but I'll say it 10 times.</xsl:text>
    </xsl:loop>
  </xsl:else>
  <xsl:loop param="i" init="10" test="$i >= 0" incr="-1">
    <xsl:loop param="j" init="10" test="$j >= 0" incr="-1">
      <xsl:text>&#xa;</xsl:text>
      <xsl:value-of select="$i * $j"/>
    </xsl:loop>
  </xsl:loop>
</xsl:template>

</xsl:stylesheet>
