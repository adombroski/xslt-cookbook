<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>

<!--
In the Procedure section of Report1, what are the first two Instruments to be used? 


for $s in document("report1.xml")//section[section.title = "Procedure"]
return ($s//instrument)[position()<=2]
-->

<xsl:template match="section[section.title = 'Procedure']">
<xsl:copy-of select="(.//instrument)[position() &lt;= 2]"/>
</xsl:template>

</xsl:stylesheet>
