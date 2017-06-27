<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:xalan="http://xml.apache.org/xslt"
xmlns:dup="http://www.ora.com/XSLTCookbook/extend/dup" 
extension-element-prefixes="dup">
  
<xsl:output method="xml"/>

<xalan:component prefix="dup" elements="duplicate">
  <xalan:script lang="javascript">
<![CDATA[
    function duplicate(ctx, elem)
    {
      //Get the attribute value n as an integer
      n = parseInt(elem.getAttribute("n")) ;
      //get the transformer which is required to execute nodes
      xformer = ctx.getTransformer() ;
      for(var ii=0; ii < n; ++ii)
      {
        node = elem.getFirstChild() ;
        while(node)
        {
          node.execute(xformer) ;
          node = node.getNextSibling() ;
        }
      }
      //The return value is inserted into the output
      //so return null to prevent this
      return null ;
    } 
]]>
  </xalan:script>
</xalan:component>

<xsl:template match="/">
  <foo>
    <dup:duplicate n="10">
      <Malady>
        <FirstPart>Shim's</FirstPart>
        <SecondPart>Syndrome</SecondPart>
        <xsl:for-each select="*">
          <xsl:copy/>
        </xsl:for-each>
      </Malady>
    </dup:duplicate>
  </foo>
</xsl:template>

</xsl:stylesheet>
