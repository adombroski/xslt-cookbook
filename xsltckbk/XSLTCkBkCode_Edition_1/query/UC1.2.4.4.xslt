<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

<!-- How many sections are in Book1, and how many figures? -->


<!--
<top_section_count>
 { 
   count(document("book1.xml")/book/section) 
 }
</top_section_count>
-->
	
<xsl:template match="book">
  <top_section_count><xsl:value-of select="count(section)"/></top_section_count>
</xsl:template>

</xsl:stylesheet>
