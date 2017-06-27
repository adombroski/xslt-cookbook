<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

<!-- Prepare a (nested) table of contents for Book1, listing all the sections and their titles. Preserve the original attributes of each <section> element, if any. -->


<!--
<toc>
  {
    let $b := document("book1.xml")
    return
        filter($b//section | $b//section/title | $b//section/title/text())
  }
</toc>
-->
	
<xsl:template match="book">
  <toc>
    <xsl:apply-templates/>
  </toc>
</xsl:template>

<!-- Copy element of toc -->
<xsl:template match="section | section/title | section/title/text()">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>

<!-- Supress other elements -->
<xsl:template match="* | text()"/>

</xsl:stylesheet>
