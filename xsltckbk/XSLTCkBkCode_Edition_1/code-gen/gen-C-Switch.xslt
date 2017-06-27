<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xslt [
  <!--Used to control code intenting -->
  <!ENTITY INDENT "    ">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template name="gen-C-Switch">
    <xsl:param name="variable"/>
    <xsl:param name="cases" select="/.."/>
    <xsl:param name="actions" select="/.."/>
    <xsl:param name="default"/>
    <xsl:param name="baseIndent" select="'&INDENT;'"/>
    <xsl:param name="genBreak" select="true()"/>

    <xsl:value-of select="$baseIndent"/>
    <xsl:text>switch (</xsl:text>
    <xsl:value-of select="$variable"/>
    <xsl:text>)&#xa;</xsl:text>
    <xsl:value-of select="$baseIndent"/>
    <xsl:text>{&#xa;</xsl:text>
    
    <xsl:for-each select="$cases">
      <xsl:variable name="pos" select="position()"/>

      <xsl:value-of select="$baseIndent"/>
      <xsl:text>&INDENT;case </xsl:text>
      <xsl:value-of select="."/>
      <xsl:text>:&#xa;</xsl:text>
      <xsl:call-template name="gen-C-Switch-caseBody">
        <xsl:with-param name="case" select="."/>
        <xsl:with-param name="action" select="$actions[$pos]"/>
        <xsl:with-param name="baseIndent"
                                      select="concat('&INDENT;&INDENT;',$baseIndent)"/>
      </xsl:call-template>
      <xsl:if test="$genBreak">
        <xsl:value-of select="$baseIndent"/>
        <xsl:text>&INDENT;&INDENT;break;</xsl:text>
      </xsl:if>      
      <xsl:text>&#xa;</xsl:text>
    </xsl:for-each>
  
    <xsl:if test="$default">
      <xsl:value-of select="$baseIndent"/>
      <xsl:text>&INDENT;default:</xsl:text>
      <xsl:text>:&#xa;</xsl:text>
      <xsl:call-template name="gen-C-Switch-default-caseBody">
        <xsl:with-param name="action" select="$default"/>
        <xsl:with-param name="baseIndent" 
                                      select="concat('&INDENT;&INDENT;',$baseIndent)"/>
      </xsl:call-template>
      <xsl:text>&#xa;</xsl:text>
    </xsl:if>
    <xsl:value-of select="$baseIndent"/>
    <xsl:text>}&#xa;</xsl:text>
  </xsl:template>	

    
  <!-- This generates a null statement by default. -->
  <!-- Override to generate code for the case --> 
  <xsl:template name="gen-C-Switch-caseBody">
    <xsl:param name="case"/>
    <xsl:param name="action"/>
    <xsl:param name="baseIndent"/>
    
    <xsl:value-of select="$baseIndent"/>
    <xsl:text>;</xsl:text>
  </xsl:template>

  <!-- This invokes the regular case body generator. --> 
  <!-- Overide to do something special for the default case. -->
  <xsl:template name="gen-C-Switch-default-caseBody">
    <xsl:param name="action"/>
    <xsl:param name="baseIndent"/>
    
    <xsl:call-template name="gen-C-Switch-caseBody">
      <xsl:with-param name="action" select="$action"/>
      <xsl:with-param name="baseIndent" select="$baseIndent"/>
    </xsl:call-template>
  </xsl:template>

</xsl:stylesheet>

