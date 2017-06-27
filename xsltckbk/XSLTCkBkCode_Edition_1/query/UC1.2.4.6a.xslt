<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

<!--
Make a nested list of the section elements in Book1, preserving their original attributes and hierarchy. Inside each section element, include the title of the section and an element that includes the number of figures immediately contained in the section. 


define function section_summary(element $s) returns element
{
    <section>
        { $s/@* }
        { $s/title }
        <figcount>{ count($s/figure) }</figcount>
        {
            for $ss in $s/section
            return section_summary($ss)
        }
    </section>
}

<toc>
  {
    for $s in document("book1.xmll")//section
    return section_summary($s)
  }
</toc>
-->

<!-- This does what Xquery states and results in ans given in W3C doc but does not seem to fullfile the English requirments. See UC1.2.4.6.xslt -->
<xsl:template match="book">
<toc>
  <xsl:for-each select="//section">
    <xsl:sort select="count(./ancestor::section)"/>
    <xsl:apply-templates select="."/>
  </xsl:for-each>
</toc>
</xsl:template>

<xsl:template match="section">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:copy-of select="title"/>
    <figcount><xsl:value-of select="count(figure)"/></figcount>
    <xsl:apply-templates select="section"/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
