<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>

<!-- In the document "books.xml", find all section or chapter titles that contain the word "XML", regardless of the level of nesting. -->

<!--
<results>
  {
    for $t in document("books.xml")//chapter/title 
              union document("books.xml")//section/title
    where contains($t/text(), "XML")
    return $t
  }
</results>
-->

<xsl:template match="/">
<results>
  <xsl:copy-of select="(//chapter/title | //section/title)[contains(.,'XML')]"/>
</results>
</xsl:template>

</xsl:stylesheet>
