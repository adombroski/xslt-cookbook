<?xml version="1.0" encoding="utf-8"?><xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:trace="http://www.obqo.de/XSL/Trace" version="1.0">
	<xsl:output method="text"/>
	<xsl:strip-space elements="*"/>
	
	<xsl:template match="/employee" priority="10"><alias:param xmlns:alias="http://www.w3.org/1999/XSL/Transform" name="trace:callstack"/><alias:variable xmlns:alias="http://www.w3.org/1999/XSL/Transform" name="trace:current" select="concat($trace:callstack,                          '/1')"/><alias:message xmlns:alias="http://www.w3.org/1999/XSL/Transform"><trace:trace><trace:path><alias:call-template name="trace:getPath"/></trace:path><trace:stack><alias:value-of select="$trace:current"/></trace:stack><trace:match>/employee</trace:match></trace:trace></alias:message>
		<xsl:apply-templates><alias:with-param xmlns:alias="http://www.w3.org/1999/XSL/Transform" name="trace:callstack" select="$trace:current"/></xsl:apply-templates>
		<xsl:value-of select="@name"/><xsl:text> is the head of the company. </xsl:text>
		<xsl:call-template name="reportsTo"><alias:with-param xmlns:alias="http://www.w3.org/1999/XSL/Transform" name="trace:callstack" select="$trace:current"/></xsl:call-template>
		<xsl:call-template name="HimHer"><alias:with-param xmlns:alias="http://www.w3.org/1999/XSL/Transform" name="trace:callstack" select="$trace:current"/></xsl:call-template> <xsl:text>. </xsl:text>
		<xsl:text>

</xsl:text>
	</xsl:template>
	
	<xsl:template match="employee[employee]"><alias:param xmlns:alias="http://www.w3.org/1999/XSL/Transform" name="trace:callstack"/><alias:variable xmlns:alias="http://www.w3.org/1999/XSL/Transform" name="trace:current" select="concat($trace:callstack,                          '/2')"/><alias:message xmlns:alias="http://www.w3.org/1999/XSL/Transform"><trace:trace><trace:path><alias:call-template name="trace:getPath"/></trace:path><trace:stack><alias:value-of select="$trace:current"/></trace:stack><trace:match>employee[employee]</trace:match></trace:trace></alias:message>
		<xsl:apply-templates><alias:with-param xmlns:alias="http://www.w3.org/1999/XSL/Transform" name="trace:callstack" select="$trace:current"/></xsl:apply-templates>
		<xsl:value-of select="@name"/><xsl:text> is a manager. </xsl:text>
		<xsl:call-template name="reportsTo"><alias:with-param xmlns:alias="http://www.w3.org/1999/XSL/Transform" name="trace:callstack" select="$trace:current"/></xsl:call-template>
		<xsl:call-template name="HimHer"><alias:with-param xmlns:alias="http://www.w3.org/1999/XSL/Transform" name="trace:callstack" select="$trace:current"/></xsl:call-template> <xsl:text>. </xsl:text>
		<xsl:text>

</xsl:text>
	</xsl:template>

	<xsl:template match="employee"><alias:param xmlns:alias="http://www.w3.org/1999/XSL/Transform" name="trace:callstack"/><alias:variable xmlns:alias="http://www.w3.org/1999/XSL/Transform" name="trace:current" select="concat($trace:callstack,                          '/3')"/><alias:message xmlns:alias="http://www.w3.org/1999/XSL/Transform"><trace:trace><trace:path><alias:call-template name="trace:getPath"/></trace:path><trace:stack><alias:value-of select="$trace:current"/></trace:stack><trace:match>employee</trace:match></trace:trace></alias:message>
		<xsl:text>Nobody reports to </xsl:text><xsl:value-of select="@name"/><xsl:text>. 
</xsl:text>
	</xsl:template>

	<xsl:template name="HimHer"><alias:param xmlns:alias="http://www.w3.org/1999/XSL/Transform" name="trace:callstack"/><alias:variable xmlns:alias="http://www.w3.org/1999/XSL/Transform" name="trace:current" select="concat($trace:callstack,'/HimHer')"/><alias:message xmlns:alias="http://www.w3.org/1999/XSL/Transform"><trace:trace><trace:path><alias:call-template name="trace:getPath"/></trace:path><trace:stack><alias:value-of select="$trace:current"/></trace:stack></trace:trace></alias:message>
		<xsl:choose>
			<xsl:when test="@sex = 'male' ">
				<xsl:text>him</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>her</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="reportsTo"><alias:param xmlns:alias="http://www.w3.org/1999/XSL/Transform" name="trace:callstack"/><alias:variable xmlns:alias="http://www.w3.org/1999/XSL/Transform" name="trace:current" select="concat($trace:callstack,'/reportsTo')"/><alias:message xmlns:alias="http://www.w3.org/1999/XSL/Transform"><trace:trace><trace:path><alias:call-template name="trace:getPath"/></trace:path><trace:stack><alias:value-of select="$trace:current"/></trace:stack></trace:trace></alias:message>
		<xsl:for-each select="*">
			<xsl:choose>
				<xsl:when test="position() &lt; last() - 1 and last() &gt; 2">
					<xsl:value-of select="@name"/><xsl:text>, </xsl:text>
				</xsl:when>
				<xsl:when test="position() = last() - 1  and last() &gt; 1">
					<xsl:value-of select="@name"/><xsl:text> and </xsl:text>
				</xsl:when>
				<xsl:when test="position() = last() and last() = 1">
					<xsl:value-of select="@name"/><xsl:text> reports to </xsl:text>
				</xsl:when>
				<xsl:when test="position() = last()">
					<xsl:value-of select="@name"/><xsl:text> report to </xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="@name"/>
				</xsl:otherwise>
			</xsl:choose> 
		</xsl:for-each>
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