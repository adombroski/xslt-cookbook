<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:xso="dummy" exclude-result-prefixes="xso">

<!-- Reuse the identity transform to copy -->
<!-- regular XSLT form source to destiniation -->
<xsl:import href="../util/copy.xslt"/>

<!-- Let the processor do the formatting via indent = yes -->
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
<xsl:strip-space elements="*"/>
<xsl:preserve-space elements="xsl:text"/>

<!--We use xso as a alias when we need to output literal xslt elements -->
<xsl:namespace-alias stylesheet-prefix="xso" result-prefix="xsl"/>
	
<xsl:template match="xsl:stylesheet">
  <xso:stylesheet>
  
    <!--The first pass handles the if-elsif-else translation -->
    <!--and the conversion of xsl:loop to named template calls -->
    <xsl:apply-templates select="@* | node()"/>
    
    <!--The second pass handles the conversion of xsl:loop -->
    <!-- to recusive named templates -->
    <xsl:apply-templates mode="loop-body"/> 
    
  </xso:stylesheet>
</xsl:template>	

<!--We look for xsl:if's that have matching xsl:elsif or xsl:else -->
<xsl:template match="xsl:if[following-sibling::xsl:else or following-sibling::xsl:elsif]">
  <xso:choose>
    <xso:when test="{@test}">
      <xsl:apply-templates select="@* | node()"/>
    </xso:when>
    <!-- We process the xsl:eslif and xsl:else in a special mode as part of the xsl:choose -->
    <xsl:apply-templates select="following-sibling::xsl:else | following-sibling::xsl:elsif" mode="choose"/>
  </xso:choose>
</xsl:template>

<!--Ignore xsl:elsif and xsl:else in normal mode -->
<xsl:template match="xsl:elsif | xsl:else"/>

<!--An xsl:elsif becomes a xsl:when -->
<xsl:template match="xsl:elsif"  mode="choose">
 <xso:when test="{@test}">
   <xsl:apply-templates select="@* | node()"/>
 </xso:when>
</xsl:template>

<!--An xsl:else becomes a xsl:otherwise -->
<xsl:template match="xsl:else" mode="choose">
 <xso:otherwise>
   <xsl:apply-templates/>
 </xso:otherwise>
</xsl:template>


<!-- An xsl:loop becomes a call to a named template -->
<xsl:template match="xsl:loop">
  <!-- Each template is given the name loop-N where N is position -->
  <!-- of this loop relative to previous loops at any level -->
  <xsl:variable name="name">
    <xsl:text>loop-</xsl:text>
    <xsl:number count="xsl:loop" level="any"/>
  </xsl:variable> 
  <xso:call-template name="{$name}">
    <xso:with-param name="{@param}" select="{@init}"/>
  </xso:call-template>
</xsl:template>

<!-- Mode loop-body is used on the 2nd pass. -->
<!-- Here recursive templates are generated to do the looping.  -->

<xsl:template match="xsl:loop" mode="loop-body">
  <xsl:variable name="name">
    <xsl:text>loop-</xsl:text>
    <xsl:number count="xsl:loop" level="any"/>
  </xsl:variable> 
  
  <xso:template name="{$name}">
    <!--If this loop is nested in another it must -->
    <!--"see" the outter loop parameters so we generate these here -->
    <xsl:for-each select="ancestor::xsl:loop">
      <xso:param name="{@param}"/>
    </xsl:for-each>
    <!--The local loop parameter -->
    <xso:param name="{@param}"/>
    <!--Generate the recusion control test -->
    <xso:if test="{@test}">
      <!-- Use a special mode to handle calls to nested loops -->
      <xsl:apply-templates mode="nested"/>
      <!--This is the recursive call that applies -->
      <!--the incr to the loop param -->
      <xso:call-template name="{$name}">
        <xsl:for-each select="ancestor::xsl:loop">
          <xso:with-param name="{@param}" select="${@param}"/>
        </xsl:for-each>
        <xso:with-param name="{@param}" select="${@param} + {@incr}"/>
      </xso:call-template>
    </xso:if>
  </xso:template>
  <!-- Here we recurse to capture the bodies of nested loops -->
  <xsl:apply-templates mode="loop-body"/>
</xsl:template>

<!-- Ignore text nodes -->
<xsl:template match="text()" mode="loop-body"/>

<!-- Nested loops become calls as in normal mode. Except they -->
<!-- must also pass the outter parms to the inner loop -->
<xsl:template match="xsl:loop" mode="nested">
  
  <xsl:variable name="name">
    <xsl:text>loop-</xsl:text>
    <xsl:number count="xsl:loop" level="any"/>
  </xsl:variable> 

  <xso:call-template name="{$name}">
    <xsl:for-each select="ancestor::xsl:loop">
      <xso:with-param name="{@param}" select="${@param}"/>
    </xsl:for-each>
    <xso:with-param name="{@param}" select="{@init}"/>
  </xso:call-template>

</xsl:template>

<xsl:template match="node()|@*" mode="nested">
  <xsl:copy>
    <xsl:apply-templates select="@* | node()" mode="nested"/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
