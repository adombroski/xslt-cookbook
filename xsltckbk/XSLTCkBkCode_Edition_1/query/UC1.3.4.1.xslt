<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>

<!--
In the Procedure section of Report1, what Instruments were used in the second Incision? 


for $s in document("report1.xml")//section[section.title = "Procedure"]
return ($s//incision)[2]/instrument

-->

<xsl:template match="section[section.title = 'Procedure']">
<xsl:copy-of select="(.//incision)[2]/instrument"/>
</xsl:template>

</xsl:stylesheet>
