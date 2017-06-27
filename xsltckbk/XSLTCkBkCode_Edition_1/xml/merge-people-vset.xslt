<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:vset="http:/www.ora.com/XSLTCookbook/namespaces/vset">

<xsl:import href="merge-using-vset-union.xslt"/>

<xsl:template match="person" mode="vset:element-equality">
  <xsl:param name="other"/>
  <xsl:if test="concat(@lastname,@firstname) = concat($other/@lastname,$other/@firstname)">  
    <xsl:value-of select="true()"/>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>
