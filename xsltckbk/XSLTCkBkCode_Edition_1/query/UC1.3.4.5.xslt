<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>

<!--
In Report1, what happened between the first Incision and the second Incision? 

Solution in XQuery:

<critical_sequence>
 {
    let $proc := //procedure[1]
    for $n in $proc//node()
    where $n follows ($proc//incision)[1]
      and $n precedes ($proc//incision)[2]
    return $n
 }
</critical_sequence> 
-->

<xsl:template match="report">
<critical_sequence>
  <!-- i1 = First incision in the entire report -->
  <xsl:variable name="i1" select="(.//incision)[1]"/>
  <!-- i2 = Second incision in the entire report -->
  <xsl:variable name="i2" select="(.//incision)[2]"/>
  <!-- copy all sibling nodes following i1 that don't have a preceding element i2 and are not themeseves i2 -->
  <xsl:for-each select="$i1/following-sibling::node()[not(./preceding::incision = $i2) and not(. = $i2)]">
    <xsl:copy-of select="."/>
  </xsl:for-each>
</critical_sequence> 
</xsl:template>

</xsl:stylesheet>
