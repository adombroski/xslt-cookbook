<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:xalan="http://xml.apache.org/xslt"
xmlns:count="http://www.ora.com/XSLTCookbook/extend/counter">
  
<xsl:output method="text"/>

<xalan:component prefix="count" functions="counter nextCount resetCount makeCounter">
  <xalan:script lang="javascript">

    
    function counter(initValue)
    {
      this.value = initValue ;
    } 
       
    function nextCount(ctr) 
    {
      return ctr.value++ ;
    }

    function resetCount(ctr, value) 
    {
      ctr.value = value  ;
      return "" ;
    }

    function makeCounter(initValue)
    {
      return new counter(initValue) ;
    }
    
  </xalan:script>
</xalan:component>

<xsl:template match="/">
  <xsl:variable name="aCounter" select="count:makeCounter(0)"/>
  Count: <xsl:value-of select="count:nextCount($aCounter)"/>
  Count: <xsl:value-of select="count:nextCount($aCounter)"/>
  Count: <xsl:value-of select="count:nextCount($aCounter)"/>
  Count: <xsl:value-of select="count:nextCount($aCounter)"/>
  <xsl:value-of select="count:resetCount($aCounter,0)"/>
  Count: <xsl:value-of select="count:nextCount($aCounter)"/>
</xsl:template>
	
</xsl:stylesheet>
