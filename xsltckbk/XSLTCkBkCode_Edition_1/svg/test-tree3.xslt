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

  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" 
    doctype-public="-//W3C//DTD SVG 1.0/EN"
    doctype-system="http://www.w3.org/TR/2001/REC-SVG-20010904/DTD/svg10.dtd"/>

  <!-- These parameters control the proportions of the tree and its nodes -->  
  <xsl:variable name="width" select="500"/>
  <xsl:variable name="height" select="500"/>
  <xsl:variable name="nodeWidth" select="2"/>
  <xsl:variable name="nodeHeight" select="1"/>
  <xsl:variable name="horzSpace" select="0.5"/>
  <xsl:variable name="vertSpace" select="1"/>
  <xsl:variable name="strokeWidth" select="0.1"/>
  
  <xsl:template match="/">
  
  <svg width="{$width}" height="{$height}">

    <!-- Capture the subtree of this node in a variable -->
    <xsl:variable name="subTree">
      <xsl:apply-templates/>
    </xsl:variable>

    <!--maxPos is the max of the furthest X or Y coordinate used in rendering a node -->    
    <xsl:variable name="maxPos" 
                         select="Math:max(number($subTree/g/@tree:MAXX),
                                                      number($subTree/g/@tree:MAXY))"/>
    <xsl:variable name="maxDim" select="Math:max($width,$height)"/>

    <!--We scale the tree so all nodes will fit in the coordinate system -->
    <g transform="scale({$maxDim div ($maxPos + 1)})">
      <!-- Use exsl:node-set($subTree) if your XSLT processor is version 1.0 -->    
      <xsl:copy-of select="$subTree/g/*"/>                 
    </g>
    
  </svg>
  </xsl:template>	


  <!-- This matches all non-leaf nodes -->  
  <xsl:template match="node()[*]">
  
    <xsl:variable name="subTree">
        <xsl:apply-templates/>
    </xsl:variable>
  
    <!-- Position this node horizontally based on the average -->
    <!-- position of its children -->
    <xsl:variable name="thisX" 
                         select="sum($subTree/*/@tree:THISX) 
                                      div count($subTree/*)"/>

    <xsl:variable name="maxX" select="$subTree/*[last()]/@tree:MAXX"/>

    <!-- Position this node vertically based on its level -->
    <xsl:variable name="thisY" select="($vertSpace + $nodeHeight) * count(ancestor-or-self::*)"/>

    <xsl:variable name="maxY">
      <xsl:call-template name="emath:max">
        <!-- Use exsl:node-set($subTree) if your XSLT processor is version 1.0 -->
        <xsl:with-param name="nodes" select="$subTree/*/@tree:MAXY"/> 
      </xsl:call-template>
    </xsl:variable>
    
    <!-- We place the parent and its children and the connectors in a group -->
    <!-- We also add bookkeeping attributes to the group as a means of -->
    <!--passing information up the tree -->
    <g tree:THISX="{$thisX}" tree:MAXX="{$maxX}" tree:MAXY="{$maxY}">
      <rect x="{$thisX - $nodeWidth}" 
               y="{$thisY - $nodeHeight}" 
               width="{$nodeWidth}" 
               height="{$nodeHeight}" 
               style="fill: none; stroke: black; stroke-width:{$strokeWidth}"/>

      <!--Draw connecting line between current node and its children -->        
      <xsl:call-template name="drawConnections">
      	<xsl:with-param name="xParent" select="$thisX - $nodeWidth"/>
      	<xsl:with-param name="yParent" select="$thisY - $nodeHeight"/>
      	<xsl:with-param name="widthParent" select="$nodeWidth"/>
      	<xsl:with-param name="heightParent" select="$nodeHeight"/>
      	<xsl:with-param name="children" select="$subTree/g/rect"/>
      </xsl:call-template>
      
      <!--Copy the SVG of the sub tree -->
      <xsl:copy-of select="$subTree"/>
    </g>
    
  </xsl:template>
  
  <!-- This matches all leaf nodes -->  
  <xsl:template match="*">
  
    <!-- Position leaf nodes horizontally based on the number of preceding leaf nodes -->
    <xsl:variable name="maxX" 
                         select="($horzSpace + $nodeWidth) * (count( preceding::*[not(child::*)] ) + 1) "/>
                         
    <!-- Position this node vertically based on its level -->
    <xsl:variable name="maxY" 
                         select="($vertSpace + $nodeHeight) * count(ancestor-or-self::*) "/>
    
    <g tree:THISX="{$maxX}" tree:MAXX="{$maxX}" tree:MAXY="{$maxY}">
      <rect x="{$maxX - $nodeWidth}" 
               y="{$maxY - $nodeHeight}" 
               width="{$nodeWidth}" 
               height="{$nodeHeight}" 
               style="fill: none; stroke: black; stroke-width:{$strokeWidth};"/>
    </g>  
    
  </xsl:template>

  <!-- Override in importing stylesheet if you want straight or some custom type of connection -->
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

  <!-- Straight connections take the shortest path from center of parent bottom -->
  <!-- to center of child top -->
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

  <!-- Square connections take the shortest path using only horizontal -->
  <!-- and vertical lines from center of parent bottom to center of child top -->
  <xsl:template name="drawSquareConnections">
    <xsl:param name="xParent"/>
    <xsl:param name="yParent"/>
    <xsl:param name="widthParent"/>
    <xsl:param name="heightParent"/>
    <xsl:param name="children"/>
    
    <xsl:variable name="midY" select="($children[1]/@y + ($yParent + $heightParent)) div 2"/>
    
    <!--vertical parent line -->
    <line x1="{$xParent + $widthParent div 2}" 
            y1="{$yParent + $heightParent}" 
            x2="{$xParent + $widthParent div 2}" 
            y2="{$midY}" 
            style="stroke: black; stroke-width:{$strokeWidth};"/>
    
    <!--central horizontal line -->
    <line x1="{$children[1]/@x + $children[1]/@width div 2}" 
            y1="{$midY}"
            x2="{$children[last()]/@x + $children[1]/@width div 2}" 
            y2="{$midY}" 
            style="stroke: black; stroke-width:{$strokeWidth};"/> 
            
    <!--vertical child lines -->
    <xsl:for-each select="$children">
       <line x1="{@x + $nodeWidth div 2}" 
               y1="{$midY}" 
               x2="{@x + $nodeWidth div 2}" 
               y2="{@y}" 
               style="stroke: black; stroke-width:{$strokeWidth};"/>  
    </xsl:for-each>
    
  </xsl:template>

	
</xsl:stylesheet>
