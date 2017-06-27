<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>
<!-- For each author in the bibliography, list the author's name and the titles of all books by that author, grouped inside a "result" element.
  -->

<!--
<results>
  {
    for $a in distinct-values(document("http://www.bn.com")//author)
    return
        <result>
            { $a }
            {
                for $b in document("http://www.bn.com")/bib/book
		where value-equals($b/author,$a)
                return $b/title
            }
        </result>
  }
</results>
-->

<xsl:template match="/">
<results>
  <xsl:for-each select="//author[not(.=preceding::author)]">
    <result>
      <xsl:copy-of select="."/>
      <xsl:for-each select="/bib/book[author=current()]">
        <xsl:copy-of select="title"/>
      </xsl:for-each>
    </result>
  </xsl:for-each>
  </results>
  
</xsl:template>
	
</xsl:stylesheet>
