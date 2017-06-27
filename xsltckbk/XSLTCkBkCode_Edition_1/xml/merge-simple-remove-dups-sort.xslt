<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"  
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:exsl="http://exslt.org/common" extension-element-prefixes="exsl">

<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

<xsl:param name="doc2"/> 

<xsl:variable name="all">
  <xsl:for-each select="/*/person | document($doc2)/*/person">
    <xsl:sort select="concat(@lastname,@firstname)"/>
	<xsl:copy-of select="."/>
  </xsl:for-each>
</xsl:variable>

<xsl:template match="/">
	
<people>
	<xsl:for-each select="exsl:node-set($all)/person">
		<xsl:variable name="pos" select="position()"/>
		<xsl:if test="$pos = 1 or 
					concat(@lastname,@firstname) != 
						concat($all/person[$pos - 1]/@lastname, $all/person[$pos - 1]/@firstname)">
			<xsl:copy-of select="."/>
		</xsl:if>
	</xsl:for-each>
</people>
	
</xsl:template>

</xsl:stylesheet>