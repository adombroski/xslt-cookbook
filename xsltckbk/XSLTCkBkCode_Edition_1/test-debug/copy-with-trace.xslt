<?xml version="1.0" encoding="utf-8"?><xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:trace="http://www.obqo.de/XSL/Trace" version="1.0">

<xsl:template match="/ | node() | @* | comment() | processing-instruction()"><alias:param xmlns:alias="http://www.w3.org/1999/XSL/Transform" name="trace:callstack"/><alias:variable xmlns:alias="http://www.w3.org/1999/XSL/Transform" name="trace:current" select="concat($trace:callstack,                          '/1')"/><alias:message xmlns:alias="http://www.w3.org/1999/XSL/Transform"><alias:call-template name="trace:getPath"/><alias:text>
   stack: </alias:text><alias:value-of select="$trace:current"/><alias:text> (</alias:text><alias:text>match="/ | node() | @* | comment() | processing-instruction()"</alias:text><alias:text>)</alias:text></alias:message>
  <xsl:copy>
    <xsl:apply-templates select="@* | node()"><alias:with-param xmlns:alias="http://www.w3.org/1999/XSL/Transform" name="trace:callstack" select="$trace:current"/></xsl:apply-templates>
  </xsl:copy>
</xsl:template>

<xsl:template xmlns:alias="http://www.w3.org/TransformAlias" name="trace:getPath">
    <xsl:text>node: </xsl:text>
    <xsl:for-each select="ancestor::*">
      <xsl:value-of select="concat('/', name(), '[',             count(preceding-sibling::*[name()=name(current())])+1, ']')"/>
    </xsl:for-each>      
    <xsl:apply-templates select="." mode="trace:getCurrent"/>
  </xsl:template><xsl:template xmlns:alias="http://www.w3.org/TransformAlias" match="*" mode="trace:getCurrent">
    <xsl:value-of select="concat('/', name(), '[',           count(preceding-sibling::*[name()=name(current())])+1, ']')"/>
  </xsl:template><xsl:template xmlns:alias="http://www.w3.org/TransformAlias" match="@*" mode="trace:getCurrent">
    <xsl:value-of select="concat('/@', name())"/>
  </xsl:template><xsl:template xmlns:alias="http://www.w3.org/TransformAlias" match="text()" mode="trace:getCurrent">
    <xsl:value-of select="concat('/text()[', count(preceding-sibling::text())+1, ']')"/>
  </xsl:template><xsl:template xmlns:alias="http://www.w3.org/TransformAlias" match="comment()" mode="trace:getCurrent">
    <xsl:value-of select="concat('/comment()[',                          count(preceding-sibling::comment())+1, ']')"/>
  </xsl:template><xsl:template xmlns:alias="http://www.w3.org/TransformAlias" match="processing-instruction()" mode="trace:getCurrent">
    <xsl:value-of select="concat('/processing-instruction()[',           count(preceding-sibling::processing-instruction())+1, ']')"/>
  </xsl:template><alias:template xmlns:alias="http://www.w3.org/1999/XSL/Transform" match="*" priority="-2">
    <xsl:param xmlns:alias="http://www.w3.org/TransformAlias" name="trace:callstack"/>
    <xsl:message xmlns:alias="http://www.w3.org/TransformAlias">
      <xsl:call-template name="trace:getPath"/>
      <xsl:text>
   default rule applied</xsl:text>
    </xsl:message>
    <xsl:apply-templates xmlns:alias="http://www.w3.org/TransformAlias">
      <xsl:with-param name="trace:callstack" select="$trace:callstack"/>
    </xsl:apply-templates>
  </alias:template></xsl:stylesheet>