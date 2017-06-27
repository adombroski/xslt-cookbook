<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
 xmlns:test="test" xmlns:vset="http:/www.ora.com/XSLTCookbook/namespaces/vset">

 <xsl:import href="vset.ops.xslt"/>

 
 <xsl:output method="text"/>
	
  <test:test>
  </test:test>	

  <test:test>
  </test:test>	

  <xsl:template match="node() | @*" mode="vset:element-equality">
    <xsl:param name="other"/>
    <xsl:if test="local-name() = local-name($other)">  
      <xsl:value-of select="true()"/>
    </xsl:if>
  </xsl:template>
  
  
  <xsl:template match="/">
   <xsl:call-template name="vset:equal">
     <xsl:with-param name="nodes1" select="document('')/*/test:test[1]/*"/>
     <xsl:with-param name="nodes2" select="document('')/*/test:test[2]/*"/>
   </xsl:call-template> 
  </xsl:template>

</xsl:stylesheet>
