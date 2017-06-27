<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>
<!-- For each book in the bibliography, list the title and authors, grouped inside a "result" element -->

<!--
<results>
  {
    for $b in document("http://www.bn.com")/bib/book
    return
        <result>
            { $b/title }
            {
                for $a in $b/author
                return $a
            }
        </result>
  }
</results>
-->
	
<xsl:template match="bib">
  <results>
    <xsl:for-each select="book">
    <result>
      <xsl:copy-of select="title"/>
      <xsl:copy-of select="author"/>
    </result>
   </xsl:for-each>
  </results>
</xsl:template>

</xsl:stylesheet>
