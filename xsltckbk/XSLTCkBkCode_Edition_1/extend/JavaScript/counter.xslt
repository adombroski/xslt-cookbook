<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:xalan="http://xml.apache.org/xslt"
xmlns:count="http://www.ora.com/XSLTCookbook/extend/counter">
  
<xsl:output method="text"/>

<xalan:component prefix="count" functions="nextCount resetCount">
  <xalan:script lang="javascript">

    var counter = 0 ;
    
    function nextCount() 
    {
      return counter++ ;
    }

    function resetCount() 
    {
      counter = 0  ;
      return "" ;
    }
    
  </xalan:script>
</xalan:component>

<xsl:template match="/">
  Count: <xsl:value-of select="count:nextCount()"/>
  Count: <xsl:value-of select="count:nextCount()"/>
  Count: <xsl:value-of select="count:nextCount()"/>
  Count: <xsl:value-of select="count:nextCount()"/>
  Count: <xsl:value-of select="count:nextCount()"/>
  <xsl:value-of select="count:resetCount()"/>
  Count: <xsl:value-of select="count:nextCount()"/>
</xsl:template>
	
</xsl:stylesheet>
