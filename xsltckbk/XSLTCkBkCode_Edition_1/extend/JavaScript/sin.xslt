<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:xalan="http://xml.apache.org/xslt"
xmlns:trig="http://www.ora.com/XSLTCookbook/extend/trig">
  
<xsl:output method="text"/>

<xalan:component prefix="trig" functions="sin nextCount">
  <xalan:script lang="javascript">
    var counter = 0 ;
    
    function sin (arg){ return Math.sin(arg);} 
    function nextCount() 
    {
      return counter++ ;
    }
  </xalan:script>
</xalan:component>

<xsl:template match="/">
  Count: <xsl:value-of select="trig:nextCount()"/>
  Count: <xsl:value-of select="trig:nextCount()"/>
  Count: <xsl:value-of select="trig:nextCount()"/>
  Count: <xsl:value-of select="trig:nextCount()"/>
  Count: <xsl:value-of select="trig:nextCount()"/>
</xsl:template>
	
</xsl:stylesheet>
