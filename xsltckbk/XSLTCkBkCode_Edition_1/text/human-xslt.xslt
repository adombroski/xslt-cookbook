<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE stylesheet [
<!ENTITY CBDIR "/MyProjects/XSLT Cookbook">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:str="http://www.ora.com/XSLTCookbook/namespaces/strings">


<xsl:output method="text"/>
	
<xsl:strip-space elements="*"/>

<xsl:include href="&CBDIR;/strings/str.dup.xslt"/>

<xsl:template match="xsl:*[*]">
  <xsl:param name="indent" select="0"/>
  <xsl:variable name="indent-string">
    <xsl:call-template name="str:dup">
      <xsl:with-param name="input" select=" '  ' "/>
      <xsl:with-param name="count" select="$indent"/>
    </xsl:call-template> 
  </xsl:variable>
  
  <xsl:value-of select="$indent-string"/>
  <xsl:value-of select="local-name()"/><xsl:text> </xsl:text>
  <xsl:apply-templates select="@*"/>
  <xsl:text>&#xa;</xsl:text>
  <xsl:value-of select="$indent-string"/>
  <xsl:text>{&#xa;</xsl:text>
  <xsl:apply-templates>
    <xsl:with-param name="indent" select="$indent+1"/>
  </xsl:apply-templates>
  <xsl:text>&#xa;</xsl:text>
  <xsl:value-of select="$indent-string"/>
  <xsl:text>}</xsl:text>
  <xsl:if test="position() != last()">
    <xsl:text>&#xa;&#xa;</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="xsl:*">
  <xsl:param name="indent" select="0"/>
  <xsl:variable name="indent-string">
    <xsl:call-template name="str:dup">
      <xsl:with-param name="input" select=" '  ' "/>
      <xsl:with-param name="count" select="$indent"/>
    </xsl:call-template> 
  </xsl:variable>
  
  <xsl:value-of select="$indent-string"/>
  <xsl:value-of select="local-name()"/><xsl:text> </xsl:text>
  <xsl:apply-templates select="@*"/>
  <xsl:text>&#xa;</xsl:text>
  <xsl:if test="../../xsl:stylesheet and position() != last()">
    <xsl:text>&#xa;</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="xsl:text[1]">
  <xsl:param name="indent" select="0"/>
  <xsl:variable name="indent-string">
    <xsl:call-template name="str:dup">
      <xsl:with-param name="input" select=" '  ' "/>
      <xsl:with-param name="count" select="$indent"/>
    </xsl:call-template> 
  </xsl:variable>
  
  <xsl:value-of select="$indent-string"/>
  <xsl:text>"</xsl:text><xsl:value-of select="."/>"<xsl:text/>
</xsl:template>

<xsl:template match="xsl:text">
<xsl:text>"</xsl:text><xsl:value-of select="."/>"<xsl:text/>
</xsl:template>

<xsl:template match="xsl:value-of[1]">
  <xsl:param name="indent" select="0"/>
  <xsl:variable name="indent-string">
    <xsl:call-template name="str:dup">
      <xsl:with-param name="input" select=" '  ' "/>
      <xsl:with-param name="count" select="$indent"/>
    </xsl:call-template> 
  </xsl:variable>
  
  <xsl:value-of select="$indent-string"/>
  <xsl:text>value-of(</xsl:text><xsl:value-of select="@select"/><xsl:text>)</xsl:text>
</xsl:template>

<xsl:template match="xsl:value-of">
<xsl:text>value-of(</xsl:text><xsl:value-of select="@select"/><xsl:text>)</xsl:text>
</xsl:template>

<xsl:template match="xsl:choose" priority="10">
  <xsl:param name="indent" select="0"/>
  <xsl:apply-templates>
    <xsl:with-param name="indent" select="$indent"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="xsl:when" priority="10">
  <xsl:param name="indent" select="0"/>

  <xsl:variable name="indent-string">
    <xsl:call-template name="str:dup">
      <xsl:with-param name="input" select=" '  ' "/>
      <xsl:with-param name="count" select="$indent"/>
    </xsl:call-template> 
  </xsl:variable>
  
  <xsl:value-of select="$indent-string"/>
  <xsl:choose>
    <xsl:when test="position() = 1">
    <xsl:text>if </xsl:text><xsl:value-of select="@test"/><xsl:text>&#xa;</xsl:text>
    </xsl:when>
    <xsl:otherwise>
    <xsl:text>elsif </xsl:text><xsl:value-of select="@test"/><xsl:text>&#xa;</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
  
  <xsl:value-of select="$indent-string"/>
  <xsl:text>{&#xa;</xsl:text>
  <xsl:apply-templates>
    <xsl:with-param name="indent" select="$indent+1"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="xsl:otherwise" priority="10">
  <xsl:param name="indent" select="0"/>

  <xsl:variable name="indent-string">
    <xsl:call-template name="str:dup">
      <xsl:with-param name="input" select=" '  ' "/>
      <xsl:with-param name="count" select="$indent"/>
    </xsl:call-template> 
  </xsl:variable>
  
  <xsl:value-of select="$indent-string"/>
  <xsl:choose>
    <xsl:when test="position() = 1">
    <xsl:text>if true&#xa;</xsl:text>
    </xsl:when>
    <xsl:otherwise>
    <xsl:text>else </xsl:text><xsl:value-of select="@test"/><xsl:text>&#xa;</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
  
  <xsl:value-of select="$indent-string"/>
  <xsl:text>{&#xa;</xsl:text>
  <xsl:apply-templates>
    <xsl:with-param name="indent" select="$indent+1"/>
  </xsl:apply-templates>
</xsl:template>


<xsl:template match="@*[last()]">
  <xsl:value-of select="name()"/>=<xsl:value-of select="."/>
</xsl:template>

<xsl:template match="@*">
  <xsl:value-of select="name()"/>=<xsl:value-of select="."/><xsl:text>, </xsl:text>
</xsl:template>

<xsl:template match="text()" priority="10">
  <xsl:param name="indent" select="0"/>
  <xsl:variable name="indent-string">
    <xsl:call-template name="str:dup">
      <xsl:with-param name="input" select=" '  ' "/>
      <xsl:with-param name="count" select="$indent"/>
    </xsl:call-template> 
  </xsl:variable>
  <xsl:if test="position() = 1">
    <xsl:value-of select="$indent-string"/>
  </xsl:if>
  <xsl:value-of select="."/>
</xsl:template>	

<xsl:template match="*" priority="-1">
  <xsl:param name="indent" select="0"/>

  <xsl:variable name="indent-string">
    <xsl:call-template name="str:dup">
      <xsl:with-param name="input" select=" '  ' "/>
      <xsl:with-param name="count" select="$indent"/>
    </xsl:call-template> 
  </xsl:variable>
  <xsl:value-of select="$indent-string"/>
  <xsl:text>&lt;</xsl:text><xsl:value-of select="name()"/><xsl:text> </xsl:text>
  <xsl:for-each select="@*">
    <xsl:value-of select="name()"/>="<xsl:value-of select="."/><xsl:text>" </xsl:text>
  </xsl:for-each>
  <xsl:text>&gt;&#xa;</xsl:text>
  <xsl:apply-templates>
    <xsl:with-param name="indent" select="$indent+1"/>
  </xsl:apply-templates>
  <xsl:text>&#xa;</xsl:text>
  <xsl:value-of select="$indent-string"/>
  <xsl:text>&lt;/</xsl:text><xsl:value-of select="name()"/><xsl:text>&gt;&#xa;</xsl:text>
</xsl:template>

</xsl:stylesheet>
