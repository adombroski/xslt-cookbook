<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:xalan="http://xml.apache.org/xslt"
xmlns:rep="http://www.ora.com/XSLTCookbook/extend/repeat" 
extension-element-prefixes="rep">
  
<xsl:output method="xml"/>

<xalan:component prefix="rep" elements="repeat">
  <xalan:script lang="javascript">
<![CDATA[
    function repeat(ctx, elem)
    {
      //Get the attribute value n as an integer
      n = parseInt(elem.getAttribute("n")) ;
      //get the transformer which is required to execute nodes
      xformer = ctx.getTransformer() ;
      //Execute content of repeat element n times
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
  <tests>
    <!--Use to duplicate text-->
    <test1><rep:repeat n="10">a</rep:repeat></test1>
    <!--Use to duplicate structure-->
    <test2>
      <rep:repeat n="10">
        <Malady>
          <FirstPart>Shim's</FirstPart>
          <SecondPart>Syndrome</SecondPart>
        </Malady>
      </rep:repeat>
    </test2>
    <!--Use to repeat the execution of xslt code -->
    <!--(which is really what we've been doing in test1 and test2)-->
    <test3>
      <rep:repeat n="10">
        <xsl:for-each select="*">
          <xsl:copy/>
        </xsl:for-each>
      </rep:repeat>
    </test3>
  </tests>
</xsl:template>

</xsl:stylesheet>
