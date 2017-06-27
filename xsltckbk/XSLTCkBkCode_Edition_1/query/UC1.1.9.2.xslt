<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>
<!-- Create a flat list of all the title-author pairs, with each pair enclosed in a "result" element.  -->

<!--
<results>
  {
    for $b in document("http://www.bn.com")/bib/book,
        $t in $b/title,
        $a in $b/author
    return
        <result>
            { $t }    
            { $a }
        </result>
  }
</results>
-->
	
<xsl:template match="/">
<results>
  <xsl:apply-templates select="bib/book/author"/>
</results>
</xsl:template>

<xsl:template match="author">
  <result>
    <xsl:copy-of select="./preceding-sibling::title"/>
    <xsl:copy-of select="."/>
  </result>
</xsl:template>

</xsl:stylesheet>
