<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
<xsl:strip-space elements="*"/>

  <xsl:param name="doc2file"/>
  
  <xsl:variable name="doc2"	 select="document($doc2file)"/>
  <xsl:variable name="thisDocsClasses" select="/*/*"/>
  
<xsl:template match="/*">
  <xsl:copy>
    <!-- Merge common sections between source doc and doc2. Also includes
          sections unique to source doc. -->
    <xsl:for-each select="*">
      <xsl:copy>
        <xsl:copy-of select="*"/>
        <xsl:copy-of select="$doc2/*/*[name() = name(current())]/*"/>
      </xsl:copy>
    </xsl:for-each>

    <!-- Merge sections unique to doc2 -->
    <xsl:for-each select="$doc2/*/*">
      <xsl:if test="not($thisDocsClasses[name() = name(current())])">
        <xsl:copy-of select="."/>
      </xsl:if>
    </xsl:for-each>
  </xsl:copy>
</xsl:template>
  
</xsl:stylesheet>
