<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.1" 
                         xmlns:emath="http://www.exslt.org/math" 
                         xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                         xmlns:tree="http://www.ora.com/XSLTCookbook/ns/tree" 
                         xmlns:Math="java:java.lang.Math"
                          extension-element-prefixes="Math" 
                          exclude-result-prefixes="Math emath">
                          
  <xsl:script implements-prefix="Math" 
                   xmlns:Math="java:java.lang.Math"
                    language="java" 
                    src="java:java.lang.Math"/>
  
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
      <xsl:apply-templates mode="layout"/>
    </xsl:variable>
    
    <xsl:variable name="maxPos" 
                         select="Math:max($treeWithLayout/*/@tree:WEIGHT * ($nodeWidth + $horzSpace),
                                                      $treeWithLayout/*/@tree:MAXDEPTH * ($nodeHeight + $vertSpace))"/>
                                                      
    <xsl:variable name="maxDim" select="Math:max($width,$height)"/>
    
    <xsl:variable name="scale" select="$maxDim div ($maxPos + 1)"/>

    
    <!--Pass 2 creates SVG -->  
    <svg height="{$height}" width="{$width}">
      <g transform="scale({$scale})">
        <xsl:apply-templates select="$treeWithLayout/*" mode="draw">
          <xsl:with-param name="x" select="0"/>
          <xsl:with-param name="y" select="0"/>
          <xsl:with-param name="width" select="$width div $scale"/>
          <xsl:with-param name="height" select="$height div $scale"/>
        </xsl:apply-templates>
      </g>
    </svg>
  </xsl:template>
  
  <!--Layout nodes with children -->
  <xsl:template match="node()[*]" mode="layout">
    <xsl:variable name="subTree">
      <xsl:apply-templates mode="layout"/>
    </xsl:variable>
    
    <!--Non-leaf nodes are assigned the sum of their child weights -->
    <xsl:variable name="thisWeight" 
                         select="sum($subTree/*/@tree:WEIGHT)"/>
                         
    <xsl:variable name="maxDepth">
      <xsl:call-template name="emath:max">
        <xsl:with-param name="nodes" 
                                   select="$subTree/*/@tree:MAXDEPTH"/>
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
      <xsl:copy-of select="$subTree"/>
    </xsl:copy>
    
  </xsl:template>
  
  <!--Layout leaf nodes -->
  <xsl:template match="*" mode="layout">
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
    <g>
    
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
        <xsl:with-param name="children" select="$subTree/g/rect"/>
      </xsl:call-template>
      
      <xsl:copy-of select="$subTree"/>
      
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
    <xsl:call-template name="drawSquareConnections">
      <xsl:with-param name="xParent" select="$xParent"/>
      <xsl:with-param name="yParent" select="$yParent"/>
      <xsl:with-param name="widthParent" select="$widthParent"/>
      <xsl:with-param name="heightParent" select="$heightParent"/>
      <xsl:with-param name="children" select="$children"/>
    </xsl:call-template>
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
