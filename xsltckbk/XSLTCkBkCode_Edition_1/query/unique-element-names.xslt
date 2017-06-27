<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:doc1="doc1" xmlns:doc2="doc2" xmlns:vset="http:/www.ora.com/XSLTCookbook/namespaces/vset" extension-element-prefixes="vset">

  <xsl:import href="vset.ops.xslt"/> 

  <xsl:output method="text" />
  
  <xsl:template match="/">
    <xsl:text>&#xa;The elements in common are: </xsl:text>
    <xsl:call-template name="vset:intersection">
      <xsl:with-param name="nodes1" select="//*"/>
      <xsl:with-param name="nodes2" select="document('doc2.xml')//*"/>
    </xsl:call-template>  

    <xsl:text>&#xa;The elements only in doc1 are: </xsl:text>
    <xsl:call-template name="vset:difference">
      <xsl:with-param name="nodes1" select="//*"/>
      <xsl:with-param name="nodes2" select="document('doc2.xml')//*"/>
    </xsl:call-template>  

    <xsl:text>&#xa;The elements only in doc2 are: </xsl:text>
    <xsl:call-template name="vset:difference">
      <xsl:with-param name="nodes1" select="document('doc2.xml')//*"/>
      <xsl:with-param name="nodes2" select="//*"/>
    </xsl:call-template>  
    <xsl:text>&#xa;</xsl:text>

  </xsl:template>
  
  <xsl:template match="*" mode="vset:intersection">
     <xsl:value-of select="local-name(.)"/>
     <xsl:if test="position() != last()">
       <xsl:text>, </xsl:text>
     </xsl:if>
  </xsl:template>

  <xsl:template match="*" mode="vset:difference">
     <xsl:value-of select="local-name(.)"/>
     <xsl:if test="position() != last()">
       <xsl:text>, </xsl:text>
     </xsl:if>
  </xsl:template>
      	
  <xsl:template match="doc1:* | doc2:*" mode="vset:element-equality">
   <xsl:param name="other"/>
    <xsl:if test="local-name(.) = local-name($other)">  
      <xsl:value-of select="true()"/>
    </xsl:if>
  </xsl:template>
      
</xsl:stylesheet>
