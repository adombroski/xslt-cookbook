<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
                         xmlns:emath="http://www.exslt.org/math" 
                         xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                         xmlns:tree="http://www.ora.com/XSLTCookbook/ns/tree" 
                         xmlns:Math="xalan://java.lang.Math"
                         xmlns:xalan="http://xml.apache.org/xalan"
                         xmlns:common="http://exslt.org/common"
                         extension-element-prefixes="Math" 
                         exclude-result-prefixes="Math emath">
                          
<xalan:component prefix="Math" functions="max">
 <xalan:script lang="javaclass" src="xalan://java.lang.Math"/>
</xalan:component>
  
  <xsl:include href="../math/math.max.xslt"/>
  
  <xsl:output method="xml" version="1.0" 
                    encoding="UTF-8" 
                    indent="yes" 
                    doctype-public="-//W3C//DTD SVG 1.0/EN" 
                    doctype-system="http://www.w3.org/TR/2001/REC-SVG-20010904/DTD/svg10.dtd"/>
                    
  <xsl:variable name="width" select="500"/>
  <xsl:variable name="height" select="500"/>
  <xsl:variable name="nodeWidth" select="2"/>
  <xsl:variable name="nodeHeight" select="1"/>
  <xsl:variable name="horzSpace" select="0.5"/>
  <xsl:variable name="vertSpace" select="1"/>
  <xsl:variable name="strokeWidth" select="0.1"/>
  
  <xsl:template match="/">

    <!--Pass 1 copies input with added bookkeeping attributes -->  
    <xsl:variable name="treeWithLayout">
      <xsl:apply-templates  mode="layout"/>
    </xsl:variable>

    <xsl:variable name="treeWithLayoutNS" select="xalan:nodeset($treeWithLayout)"/>
   
    <xsl:variable name="maxPos" 
                         select="Math:max($treeWithLayoutNS/*/@tree:WEIGHT * ($nodeWidth + $horzSpace),
                                                      $treeWithLayoutNS/*/@tree:MAXDEPTH * ($nodeHeight + $vertSpace))"/>
                                                      
    <xsl:variable name="maxDim" select="Math:max($width,$height)"/>
    
    <xsl:variable name="scale" select="$maxDim div ($maxPos + 1)"/>
    
    
    <!--Pass 2 creates SVG -->  
    <svg height="{$height}" width="{$width}">

  <xsl:copy-of select="$treeWithLayoutNS"/>
  
<!--      
      <g transform="scale({$scale})">
        <xsl:apply-templates select="$treeWithLayoutNS/*" mode="draw">
          <xsl:with-param name="x" select="0"/>
          <xsl:with-param name="y" select="0"/>
          <xsl:with-param name="width" select="$width div $scale"/>
          <xsl:with-param name="height" select="$height div $scale"/>
        </xsl:apply-templates>
      </g>
-->      
    </svg>
  </xsl:template>
  
  <!--Layout nodes with children -->
  <xsl:template match="*[*]" mode="layout" priority="10">

    <xsl:variable name="subTree">
      <xsl:apply-templates mode="layout"/>
    </xsl:variable>

    <xsl:variable name="subTreeNS" select="xalan:nodeset($subTree)"/>
    
    <!--Non-leaf nodes are assigned the sum of their child weights -->
    <xsl:variable name="thisWeight" 
                         select="sum($subTreeNS/*/@tree:WEIGHT)"/>

    <xsl:message>[<xsl:value-of select="$subTreeNS/*/@tree:WEIGHT"/>]</xsl:message>   
                         
    <xsl:variable name="maxDepth">
      <xsl:call-template name="emath:max">
        <xsl:with-param name="nodes" 
                                   select="$subTreeNS/*/@tree:MAXDEPTH"/>
      </xsl:call-template>
    </xsl:variable>

    
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:attribute name="tree:WEIGHT">
        <xsl:value-of select="$thisWeight"/>
      </xsl:attribute>
      <xsl:attribute name="tree:MAXDEPTH">
        <xsl:value-of select="$maxDepth"/>
      </xsl:attribute>
      <xsl:copy-of select="$subTreeNS"/>
    </xsl:copy>
    
  </xsl:template>
  
  <!--Layout leaf nodes -->
  <xsl:template match="*" mode="layout" >
    <xsl:variable name="depth" select="count(ancestor-or-self::*) "/>
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <!--Leaf nodes are assigned weight 1 -->
      <xsl:attribute name="tree:WEIGHT">
        <xsl:value-of select="1"/>
      </xsl:attribute>
      <xsl:attribute name="tree:MAXDEPTH">
        <xsl:value-of select="$depth"/>
      </xsl:attribute>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="text()" mode="layout"/>
  
  <!--Draw non-leaf nodes -->
  <xsl:template match="node()[*]" mode="draw">
    <xsl:param name="x"/>
    <xsl:param name="y"/>
    <xsl:param name="width"/>
    <xsl:variable name="thisX" 
                         select="$x + $width div 2 - ($nodeWidth+$horzSpace) div 2"/>
                         
    <xsl:variable name="subTree">
      <xsl:call-template name="drawSubtree">
        <xsl:with-param name="nodes" select="*"/>
        <xsl:with-param name="weight" select="@tree:WEIGHT"/>
        <xsl:with-param name="x" select="$x"/>
        <xsl:with-param name="y" select="$y + $nodeHeight + $vertSpace"/>
        <xsl:with-param name="width" select="$width"/>
      </xsl:call-template>
    </xsl:variable>
    
    <xsl:variable name="subTreeNS" select="xalan:nodeset($subTree)"/>

    <g>

      <xsl:copy-of select="$subTreeNS"/>
    
      <rect x="{$thisX}" 
               y="{$y}"
               width="{$nodeWidth}" 
               height="{$nodeHeight}" 
               style="fill: none; stroke: black; stroke-width:{$strokeWidth};"/>
      
      <xsl:call-template name="drawConnections">
        <xsl:with-param name="xParent" select="$thisX"/>
        <xsl:with-param name="yParent" select="$y"/>
        <xsl:with-param name="widthParent" select="$nodeWidth"/>
        <xsl:with-param name="heightParent" select="$nodeHeight"/>
        <xsl:with-param name="children" select="$subTreeNS/g/rect"/>
      </xsl:call-template>
      
     
    </g>
    
  </xsl:template>
  
  
  <!--Draw leaf nodes -->
  <xsl:template match="*" mode="draw">
    <xsl:param name="x"/>
    <xsl:param name="y"/>
    <xsl:param name="width"/>
    
    <xsl:variable name="thisX" 
                         select="$x + $width div 2 - ($nodeWidth+$horzSpace) div 2"/>
                         

                         
    <g>
      <rect x="{$thisX}" 
               y="{$y}" 
               width="{$nodeWidth}" 
               height="{$nodeHeight}" 
               style="fill: none; stroke: black; stroke-width:{$strokeWidth};"/>
    </g>
  </xsl:template>
  
  <!-- Recursive routine for drawing subtree -->
  <!-- Allocates horz space based on weight given to node -->
  <xsl:template name="drawSubtree">
    <xsl:param name="nodes" select="/.."/>
    <xsl:param name="weight"/>
    <xsl:param name="x"/>
    <xsl:param name="y"/>
    <xsl:param name="width"/>
    
    <xsl:if test="$nodes">
      <xsl:variable name="node" select="$nodes[1]"/>
      <xsl:variable name="ratio" select="$node/@tree:WEIGHT div $weight"/>

      <!--Draw node and its children in sub partition of space-->
      <!--based on current x and width allocation -->
      <xsl:apply-templates select="$node" mode="draw">
        <xsl:with-param name="x" select="$x"/>
        <xsl:with-param name="y" select="$y"/>
        <xsl:with-param name="width" select="$width * $ratio"/>
      </xsl:apply-templates>

      <!-- Process remaining nodes -->
      <xsl:call-template name="drawSubtree">
        <xsl:with-param name="nodes" select="$nodes[position() > 1]"/>
        <xsl:with-param name="weight" select="$weight"/>
        <xsl:with-param name="x" select="$x + $width * $ratio"/>
        <xsl:with-param name="y" select="$y"/>
        <xsl:with-param name="width" select="$width"/>
      </xsl:call-template>
    </xsl:if>
    
  </xsl:template>
  
  <!-- Override in importing stylesheet if you want straight or some -->
  <!-- custom type of connection -->
  <xsl:template name="drawConnections">
    <xsl:param name="xParent"/>
    <xsl:param name="yParent"/>
    <xsl:param name="widthParent"/>
    <xsl:param name="heightParent"/>
    <xsl:param name="children"/>

    
  <xsl:if test="$children">
    <xsl:call-template name="drawSquareConnections">
      <xsl:with-param name="xParent" select="$xParent"/>
      <xsl:with-param name="yParent" select="$yParent"/>
      <xsl:with-param name="widthParent" select="$widthParent"/>
      <xsl:with-param name="heightParent" select="$heightParent"/>
      <xsl:with-param name="children" select="$children"/>
    </xsl:call-template>
 </xsl:if>       
  </xsl:template>
  
  <xsl:template name="drawStraightConnections">
    <xsl:param name="xParent"/>
    <xsl:param name="yParent"/>
    <xsl:param name="widthParent"/>
    <xsl:param name="heightParent"/>
    <xsl:param name="children"/>


    <xsl:for-each select="$children">
      <line x1="{$xParent + $widthParent div 2}" 
              y1="{$yParent + $heightParent}" 
              x2="{@x + $nodeWidth div 2}" 
              y2="{@y}" 
              style="stroke: black; stroke-width:{$strokeWidth};"/>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template name="drawSquareConnections">


    <xsl:param name="xParent"/>
    <xsl:param name="yParent"/>
    <xsl:param name="widthParent"/>
    <xsl:param name="heightParent"/>
    <xsl:param name="children"/>


    <xsl:variable name="midY" 
                         select="($children[1]/@y + ($yParent + $heightParent)) div 2"/>

    <line x1="{$xParent + $widthParent div 2}" 
            y1="{$yParent + $heightParent}" 
            x2="{$xParent + $widthParent div 2}" 
            y2="{$midY}" 
            style="stroke: black; stroke-width:{$strokeWidth};"/>
            
    <line x1="{$children[1]/@x + $children[1]/@width div 2}"
            y1="{$midY}" 
            x2="{$children[last()]/@x + $children[1]/@width div 2}" 
            y2="{$midY}" 
            style="stroke: black; stroke-width:{$strokeWidth};"/>
            
    <xsl:for-each select="$children">
      <line x1="{@x + $nodeWidth div 2}" 
              y1="{$midY}" 
              x2="{@x + $nodeWidth div 2}" 
              y2="{@y}" 
              style="stroke: black; stroke-width:{$strokeWidth};"/>
    </xsl:for-each>

    
  </xsl:template>
  
</xsl:stylesheet>
