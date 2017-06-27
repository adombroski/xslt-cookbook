<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>

<!--
In Report1, what Instruments were used in the first two Actions after the second Incision? 

let $i2 := (document("report1.xml")//incision)[2]
for $a in (document("report1.xml")//action)[. follows $i2][position()<=2]
return $a//instrument
-->

<xsl:template match="report">
<!-- i2 = Second incision in the entire report -->
<xsl:variable name="i2" select="(.//incision)[2]"/>
<!-- Of all the actions following i2 get the instruments used in the first two -->
<xsl:copy-of select="($i2/following::action)[position() &lt;= 2]/instrument"/>
</xsl:template>

</xsl:stylesheet>
