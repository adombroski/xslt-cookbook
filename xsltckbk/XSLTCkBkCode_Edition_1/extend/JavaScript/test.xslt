<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:xalan="http://xml.apache.org/xslt"
xmlns:test="http://www.ora.com/XSLTCookbook/extend/test" 
extension-element-prefixes="test">
  
<xsl:output method="xml"/>

<xalan:component prefix="test" elements="test">
  <xalan:script lang="javascript">
<![CDATA[
    function test(ctx, elem)
    {
      child = elem.getFirstChild() ;
      return child ;
    } 
]]>
  </xalan:script>
</xalan:component>

<xsl:template match="/">
<foo>
  <test:test>
    <Malidy>
      <FirstPart>part1</FirstPart>
      <SecondPart>part2</SecondPart>
    </Malidy>
  </test:test>
</foo>  
</xsl:template>

</xsl:stylesheet>
