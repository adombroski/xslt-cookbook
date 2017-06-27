<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                                                xmlns:dbg="http://www.ora.com/XSLTCookbook/ns/debug">

<xsl:param name="debugOn" select="true()"/>

<xsl:template match="node()" mode="dbg:trace" name="dbg:trace">
<xsl:param name="tag" select=" 'trace' "/>
<xsl:if test="$debugOn">
  <xsl:message>
       <xsl:value-of select="$tag"/>: <xsl:call-template name="dbg:expand-path"/> 
  </xsl:message>
</xsl:if>
</xsl:template> 

<!--Expand the xapth to the current node -->
<xsl:template name="dbg:expand-path">
  <xsl:apply-templates select="." mode="dbg:expand-path"/>
</xsl:template>

<!-- Root -->
<xsl:template match="/" mode="dbg:expand-path">
  <xsl:text>/</xsl:text>
</xsl:template> 

<!--Top level node -->
<xsl:template match="/*" mode="dbg:expand-path">
  <xsl:text>/</xsl:text><xsl:value-of select="name()"/>
</xsl:template> 

<!--Nodes with node parents -->
<xsl:template match="*/*" mode="dbg:expand-path">
  <xsl:apply-templates select=".." mode="dbg:expand-path"/>/<xsl:value-of select="name()"/>[<xsl:value-of select="count(preceding-sibling::*[name() = name(current())]) + 1"/>]<xsl:text/>
</xsl:template> 

<!--Attribute nodes -->
<xsl:template match="@*" mode="dbg:expand-path">
  <xsl:apply-templates select=".." mode="dbg:expand-path"/>/@<xsl:value-of select="name()"/>
</xsl:template> 

<!-- Text nodes (normalized for clarity) -->
<xsl:template match="text()" mode="dbg:expand-path">nomailized-text(<xsl:value-of select="normalize-space(.)"/>)</xsl:template> 

</xsl:stylesheet>
