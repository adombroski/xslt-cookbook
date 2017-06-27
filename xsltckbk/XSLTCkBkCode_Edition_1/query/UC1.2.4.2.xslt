<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

<!-- Prepare a (flat) figure list for Book1, listing all the figures and their titles. Preserve the original attributes of each <figure> element, if any. -->


<!--
<figlist>
  {
    for $f in document("book1.xml")//figure
    return
        <figure>
            { $f/@* }
            { $f/title }
        </figure>
  }
</figlist> 
-->
	
<xsl:template match="book">
  <figlist>
    <xsl:for-each select=".//figure">
      <xsl:copy>
        <xsl:copy-of select="@*"/>
        <xsl:copy-of select="title"/>
      </xsl:copy>
    </xsl:for-each>
  </figlist>
</xsl:template>

</xsl:stylesheet>
