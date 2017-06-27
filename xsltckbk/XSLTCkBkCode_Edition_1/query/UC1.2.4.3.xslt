<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

<!-- How many sections are in Book1, and how many figures? -->


<!--
<section_count>{ count(document("book1.xml")//section) }</section_count>, 
<figure_count>{ count(document("book1.xml")//figure) }</figure_count> 
-->
	
<xsl:template match="/">
  <section-count><xsl:value-of select="count(//section)"/></section-count>
  <figure-count><xsl:value-of select="count(//figure)"/></figure-count>
</xsl:template>

</xsl:stylesheet>
