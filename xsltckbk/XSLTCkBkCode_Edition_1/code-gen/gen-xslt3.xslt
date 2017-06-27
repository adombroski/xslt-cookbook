<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:xslx="http://www.ora.com/XSLTCookbook/ExtendedXSLT"
 xmlns:xso="dummy" >

<!-- Reuse the identity transform to copy -->
<!-- regular XSLT form source to destiniation -->
<xsl:import href="../util/copy.xslt"/>

<!-- Let the processor do the formatting via indent = yes -->
<xsl:output method="xml" version="1.0" encoding="UTF-8" />

<!--We use xso as a alias when we need to output literal xslt elements -->
<xsl:namespace-alias stylesheet-prefix="xso" result-prefix="xsl"/>
	
<xsl:template match="xsl:stylesheet | xsl:transform">
   <xso:stylesheet>
    <!--The first pass handles the if-elsif-else translation -->
    <!--and the conversion of xslx:loop to named template calls -->
    <xsl:apply-templates select="@* | node()"/>
    
    <!--The second pass handles the conversion of xslx:loop -->
    <!-- to recusive named templates -->
    <xsl:apply-templates mode="loop-body" select="//xslx:loop"/> 
    
  </xso:stylesheet>
</xsl:template>	

<!--We look for xslx:if's that have matching xslx:elsif or xslx:else -->
<xsl:template match="xslx:if[following-sibling::xslx:else or following-sibling::xslx:elsif]">
  <xsl:variable name="idIf" select="generate-id()"/>
  <xso:choose>
    <xso:when test="{@test}">
      <xsl:apply-templates select="@* | node()"/>
    </xso:when>
    <!-- We process the xsl:eslif and xslx:else in a special mode as part of the xsl:choose -->
    <!-- We must make sure to only pick up the ones whose preceding xslx:if is this xslx:if -->
    <xsl:apply-templates select="following-sibling::xslx:else[generate-id(preceding-sibling::xslx:if[1]) = $idIf] | 
                                                   following-sibling::xslx:elsif[generate-id(preceding-sibling::xslx:if[1]) = $idIf]" 
                                                   mode="choose"/>
  </xso:choose>
</xsl:template>

<!--Ignore xslx:elsif and xslx:else in normal mode -->
<xsl:template match="xslx:elsif | xslx:else"/>

<!--An xslx:elsif becomes a xsl:when -->
<xsl:template match="xslx:elsif"  mode="choose">
 <xso:when test="{@test}">
   <xsl:apply-templates select="@* | node()"/>
 </xso:when>
</xsl:template>

<!--An xslx:else becomes a xsl:otherwise -->
<xsl:template match="xslx:else" mode="choose">
 <xso:otherwise>
   <xsl:apply-templates/>
 </xso:otherwise>
</xsl:template>


<!-- An xslx:loop becomes a call to a named template -->
<xsl:template match="xslx:loop">
  <!-- Each template is given the name loop-N where N is position -->
  <!-- of this loop relative to previous loops at any level -->
  <xsl:variable name="name">
    <xsl:text>loop-</xsl:text>
    <xsl:number count="xslx:loop" level="any"/>
  </xsl:variable> 
  
  <xso:call-template name="{$name}">
    <xsl:for-each select="ancestor::xslx:loop">
      <xso:with-param name="{@param}" select="${@param}"/>
    </xsl:for-each>
    <xso:with-param name="{@param}" select="{@init}"/>
  </xso:call-template>  
 
</xsl:template>

<!-- Mode loop-body is used on the 2nd pass. -->
<!-- Here recursive templates are generated to do the looping.  -->

<xsl:template match="xslx:loop" mode="loop-body">
  <xsl:variable name="name">
    <xsl:text>loop-</xsl:text>
    <xsl:value-of select="position()"/>
  </xsl:variable> 
  
  <xso:template name="{$name}">
    <!--If this loop is nested in another it must -->
    <!--"see" the outter loop parameters so we generate these here -->
    <xsl:for-each select="ancestor::xslx:loop">
      <xso:param name="{@param}"/>
    </xsl:for-each>
    <!--The local loop parameter -->
    <xso:param name="{@param}"/>
    <!--Generate the recusion control test -->
    <xso:if test="{@test}">
      <!-- Apply template in normal mode to handle -->
      <!-- calls to nested loops while copying everything else. -->
      <xsl:apply-templates/>
      <!--This is the recursive call that applies -->
      <!--the incr to the loop param -->
      <xso:call-template name="{$name}">
        <xsl:for-each select="ancestor::xslx:loop">
          <xso:with-param name="{@param}" select="${@param}"/>
        </xsl:for-each>
        <xso:with-param name="{@param}" select="${@param} + {@incr}"/>
      </xso:call-template>
    </xso:if>
  </xso:template>
</xsl:template>

</xsl:stylesheet>
