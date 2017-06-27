<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>

<!-- For each book with an author, return the book with its title and authors. For each book with an editor, return a reference with the book title and the editor's affiliation.  -->

<!--
<bib>
    {
        for $b in document("www.bn.com/bib.xml")//book[author]
        return
            <book>
                { $b/title }
                { $b/author }
            </book>
    }
    {
        for $b in document("www.bn.com/bib.xml")//book[editor]
        return
            <reference>
                { $b/title }
                <org>{ $b/editor/affiliation/text() }</org>
            </reference>
    }
</bib> 
-->

	
<xsl:template match="bib">
<xsl:copy>
  <xsl:for-each select="book[author]">
    <xsl:copy>
      <xsl:copy-of select="title"/>
      <xsl:copy-of select="author"/>
    </xsl:copy>
  </xsl:for-each>
 
  <xsl:for-each select="book[editor]">
    <reference>
      <xsl:copy-of select="title"/>
      <org><xsl:value-of select="editor/affiliation"/></org>
    </reference>
  </xsl:for-each>
  </xsl:copy>
</xsl:template>


</xsl:stylesheet>
