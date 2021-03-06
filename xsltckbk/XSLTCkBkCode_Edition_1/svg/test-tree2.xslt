<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.1" 
  xmlns:emath="http://www.exslt.org/math" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:Math="java:java.lang.Math" extension-element-prefixes="Math" exclude-result-prefixes="Math emath">
  
  <xsl:script implements-prefix="Math"
                   xmlns:Math="java:java.lang.Math"
                   language="java"
                   src="java:java.lang.Math"/>

  <xsl:include href="../math/math.max.xslt"/>

  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" 
    doctype-public="-//W3C//DTD SVG 1.0/EN"
    doctype-system="http://www.w3.org/TR/2001/REC-SVG-20010904/DTD/svg10.dtd"/>
  
  <xsl:variable name="width" select="1000"/>
  <xsl:variable name="height" select="500"/>
  
  <xsl:template match="/">
  
  <svg width="{$width}" height="{$height}">

    <xsl:variable name="subTree">
      <xsl:apply-templates/>
    </xsl:variable>
    
    <xsl:variable name="maxPos" select="Math:max(number($subTree/g/@MAXX),number($subTree/g/@MAXY))"/>
    <xsl:variable name="maxDim" select="Math:max($width,$height)"/>
    
    <g transform="scale({$maxDim div ($maxPos + 1)})">
      <xsl:copy-of select="$subTree/g/*"/>
    </g>
    
  </svg>
  </xsl:template>	
  
  <xsl:template match="node()[*]">
  
    <xsl:variable name="subTree">
        <xsl:apply-templates/>
    </xsl:variable>
  
    <xsl:variable name="thisX" select="sum($subTree/*/@THISX) div count($subTree/*)"/>
    <xsl:variable name="maxX" select="$subTree/*[last()]/@MAXX"/>
    <xsl:variable name="thisY" select="2 * count(ancestor-or-self::*)"/>
    <xsl:variable name="maxY">
      <xsl:call-template name="emath:max">
        <xsl:with-param name="nodes" select="$subTree/*/@MAXY"/>
      </xsl:call-template>
    </xsl:variable>
    
    <g THISX="{$thisX}" MAXX="{$maxX}" MAXY="{$maxY}">
      <rect x="{$thisX - 1}" y="{$thisY - 1}" width="1" height="1" style="fill: none; stroke: black; stroke-width:0.1"/>
      <xsl:call-template name="drawSquareConnections">
      	<xsl:with-param name="xParent" select="$thisX - 1"/>
      	<xsl:with-param name="yParent" select="$thisY - 1"/>
      	<xsl:with-param name="widthParent" select="1"/>
      	<xsl:with-param name="heightParent" select="1"/>
      	<xsl:with-param name="children" select="$subTree/g/rect"/>
      </xsl:call-template>
      <xsl:copy-of select="$subTree"/>
    </g>
    
  </xsl:template>
  
  <xsl:template match="*">
  
    <xsl:variable name="maxX" select="2 * (count( preceding::*[not(child::*)] ) + 1) "/>
    <xsl:variable name="maxY" select="2 * count(ancestor-or-self::*) "/>
    
    <g THISX="{$maxX}" MAXX="{$maxX}" MAXY="{$maxY}">
      <rect x="{$maxX - 1}" y="{$maxY - 1}" width="1" height="1" style="fill: none; stroke: black; stroke-width:0.1;"/>
    </g>  
    
  </xsl:template>

  <xsl:template name="drawStraightConnections">
    <xsl:param name="xParent"/>
    <xsl:param name="yParent"/>
    <xsl:param name="widthParent"/>
    <xsl:param name="heightParent"/>
    <xsl:param name="children"/>
    <xsl:for-each select="$children">
       <line x1="{$xParent + $widthParent div 2}" y1="{$yParent + $heightParent}" x2="{@x + 0.5}" y2="{@y}" style="stroke: black;     stroke-width:0.1;"/>  
    </xsl:for-each>
  </xsl:template>

  
  <xsl:template name="drawSquareConnections">
    <xsl:param name="xParent"/>
    <xsl:param name="yParent"/>
    <xsl:param name="widthParent"/>
    <xsl:param name="heightParent"/>
    <xsl:param name="children"/>
    
    <xsl:variable name="midY" select="($children[1]/@y + ($yParent + $heightParent)) div 2"/>
    <line x1="{$xParent + $widthParent div 2}" y1="{$yParent + $heightParent}" 
            x2="{$xParent + $widthParent div 2}" y2="{$midY}" style="stroke: black; stroke-width:0.1;"/>
    <line x1="{$children[1]/@x + $children[1]/@width div 2}" y1="{$midY}"
            x2="{$children[last()]/@x + $children[1]/@width div 2}" y2="{$midY}" style="stroke: black; stroke-width:0.1;"/> 
    <xsl:for-each select="$children">
       <line x1="{@x + 0.5}" y1="{$midY}" x2="{@x + 0.5}" y2="{@y}" style="stroke: black; stroke-width:0.1;"/>  
    </xsl:for-each>
  </xsl:template>

	
</xsl:stylesheet>
