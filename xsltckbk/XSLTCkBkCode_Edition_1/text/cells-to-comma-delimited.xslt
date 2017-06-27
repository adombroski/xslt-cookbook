<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:c="http://www.ora.com/XSLTCookbook/namespaces/cells" xmlns:exsl="http://exslt.org/common" extension-element-prefixes="exsl">

  <xsl:output method="text"/>

  <xsl:variable name="columns" select=" '_ABCDEFGHIJKLMNOPQRSTUVWXYZ' "/>
  
  <xsl:template match="/">

    <xsl:variable name="cells">
      <xsl:apply-templates/>
    </xsl:variable>
    
    <xsl:variable name="cells-sorted">
      <xsl:for-each select="exsl:node-set($cells)/c:cell">
        <xsl:sort select="@row" data-type="number"/>
        <xsl:sort select="@col" data-type="text"/>
        <xsl:copy-of select="."/>
      </xsl:for-each>
    </xsl:variable>
   
    <xsl:apply-templates select="exsl:node-set($cells-sorted)/c:cell"/>
   
  </xsl:template>

  <xsl:template match="c:cell">
    <xsl:choose>
      <xsl:when test="preceding-sibling::c:cell[1]/@row != @row">
        <xsl:variable name="skip-rows">
          <xsl:choose>
            <xsl:when test="preceding-sibling::c:cell[1]/@row">
              <xsl:value-of select="@row - preceding-sibling::c:cell[1]/@row"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="@row - 1"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:call-template name="skip-rows">
          <xsl:with-param name="skip" select="$skip-rows"/>
        </xsl:call-template>

        <xsl:variable name="current-col" select="string-length(substring-before($columns,@col))"/>
        <xsl:call-template name="skip-cols">
          <xsl:with-param name="skip" select="$current-col - 1"/>
        </xsl:call-template>
        <xsl:value-of select="@value"/>,<xsl:text/>
      </xsl:when>
      
      <xsl:otherwise>
        
        <xsl:variable name="skip-cols">
          <xsl:variable name="current-col" select="string-length(substring-before($columns,@col))"/>
          
          <xsl:choose>
            <xsl:when test="preceding-sibling::c:cell[1]/@col">
              <xsl:variable name="prev-col" select="string-length(substring-before($columns,preceding-sibling::c:cell[1]/@col))"/>
              <xsl:value-of select="$current-col - $prev-col - 1"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$current-col - 1"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        
        <xsl:call-template name="skip-cols">
          <xsl:with-param name="skip" select="$skip-cols"/>
        </xsl:call-template>
        
        <xsl:value-of select="@value"/>,<xsl:text/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

<xsl:template name="skip-rows">
  <xsl:param name="skip"/>
  <xsl:choose>
    <xsl:when test="$skip > 0">
      <xsl:text>&#xa;</xsl:text>
      <xsl:call-template name="skip-rows">
        <xsl:with-param name="skip" select="$skip - 1"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise/>
  </xsl:choose>
</xsl:template>

<xsl:template name="skip-cols">
  <xsl:param name="skip"/>
  <xsl:choose>
    <xsl:when test="$skip > 0">
      <xsl:text>,</xsl:text>
      <xsl:call-template name="skip-cols">
        <xsl:with-param name="skip" select="$skip - 1"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise/>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
