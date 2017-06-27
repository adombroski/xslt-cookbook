<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>

<!--
In Report1, find "Procedure" sections where no Anesthesia element occurs before the first Incision? 

for $p in //procedure
where some $i in $proc//incision satisfies
        empty($proc//anesthesia[. precedes $i])
return $p 

The above is wrong because there is no element named procedure!
We presume sections with title procedure are desired.
-->

<xsl:template match="section[section.title = 'Procedure']">
  <xsl:variable name="i1" select="(.//incision)[1]"/>
  <xsl:if test=".//anesthesia[count(./preceding::incision | $i1) = count(./preceding::incision)]">
    <xsl:copy-of select="current()"/>
  </xsl:if> 
</xsl:template>

</xsl:stylesheet>
