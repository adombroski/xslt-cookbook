<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

<!--
Make a flat list of the section elements in Book1. In place of its original attributes, each section element should have two attributes, containing the title of the section and the number of figures immediately contained in the section. 

<section_list>
  {
    for $s in document("book1.xml")//section
    let $f := $s/figure
    return
        <section title={ $s/title/text() } figcount={ count($f) }/>
  }
</section_list> 
-->
	
<xsl:template match="book">
<section_list>
  <xsl:for-each select=".//section">
    <section title="{title}" figcount="{count(figure)}"/>
  </xsl:for-each>
</section_list>
</xsl:template>

</xsl:stylesheet>
