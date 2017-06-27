<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="gen-C-switch.xslt"	/>
  <xsl:param name="process" select=" 'StockServer' "/>
  
  <xsl:output method="text"/>
  
  <xsl:template match="/">
    
    <xsl:call-template name="gen-C-Switch">
      <xsl:with-param name="variable" select=" 'x' "/> 
      <xsl:with-param name="cases" select="//Message[Receivers/ProcessRef = $process]/Name"/>
      <xsl:with-param name="actions" select="//Message[Receivers/ProcessRef = $process]"/>
      <xsl:with-param name="genBreak" select="true()"/>
    </xsl:call-template>
    
  </xsl:template>


  <xsl:template name="gen-C-Switch-caseBody">
    <xsl:param name="case"/>
    <xsl:param name="action"/>
    <xsl:param name="baseIndent"/>
    
    <xsl:value-of select="$baseIndent"/>
    <xsl:text>return </xsl:text>
    <xsl:value-of select="$action/Name"/>(*static_cast&lt;const <xsl:value-of select="$action/DataTypeName"/>
    <xsl:text>*&gt;(msg.getData())).process() ;&#xa;</xsl:text>
  </xsl:template>
	 
</xsl:stylesheet>
