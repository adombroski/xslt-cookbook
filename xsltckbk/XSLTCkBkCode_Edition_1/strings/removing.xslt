<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="text"/>
  <xsl:template match="/">

    <!--Stripping characters -->
    <xsl:variable name="input1" select=" 'The spaces will disappear making this
                                     string difficult to read
                                     I fear' "/>
   <xsl:value-of select="translate($input1,' &#x9;&#xa;&#xd;', '')"/>
  <xsl:text>&#xa;</xsl:text>
  
    <!--Stripping all but specific characters -->
    <xsl:variable name="input2" select=" 'I am 8 years old' "/>
    <xsl:value-of select="translate($input2, translate($input2,'0123456789',''),'')"/>
  <xsl:text>&#xa;</xsl:text>

    <!--Nomalizing characters other than whitespace -->
    <xsl:variable name="input3" select=" '---this --is-- the way we normalize non-whitespace---' "/>
    <xsl:value-of select="translate(normalize-space(translate($input3,'- ',' -')),'- ',' -')"/>

  <xsl:text>&#xa;</xsl:text>

  </xsl:template>

</xsl:stylesheet>
