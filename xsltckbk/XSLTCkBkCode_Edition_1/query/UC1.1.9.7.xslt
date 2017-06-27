<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>
<!--List the titles and years of all books published by Addison-Wesley after 1991, in alphabetic order. -->

<!--
<bib>
  {
    for $b in document("www.bn.com/bib.xml")//book
    where $b/publisher = "Addison-Wesley" and $b/@year > "1991"
    return
        <book>
            { $b/@year }
            { $b/title }
        </book>
    sortby (title)
  }
</bib>
  -->

<xsl:template match="bib">
  <xsl:copy>
    <xsl:for-each select="book[publisher = 'Addison-Wesley' and @year > 1991]">
      <xsl:sort select="title"/>
      <xsl:copy>
        <xsl:copy-of select="@year"/>
        <xsl:copy-of select="title"/>
      </xsl:copy>
    </xsl:for-each>
  </xsl:copy>
</xsl:template>	

</xsl:stylesheet>
