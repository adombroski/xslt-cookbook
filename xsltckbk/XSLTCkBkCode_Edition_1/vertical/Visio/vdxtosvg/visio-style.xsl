<?xml version='1.0'?>
<!-- $Id: visio-style.xsl,v 1.6 2002/07/20 16:56:01 jabreen Exp $ -->
<!-- ======================================================================
     
     Copyright (c) 2002 John Breen

     Permission is hereby granted, free of charge, to any person
     obtaining a copy of this software and associated documentation
     files (the "Software"), to deal in the Software without
     restriction, including without limitation the rights to use,
     copy, modify, merge, publish, distribute, sublicense, and/or sell
     copies of the Software, and to permit persons to whom the
     Software is furnished to do so, subject to the following
     conditions:

     The above copyright notice and this permission notice shall be
     included in all copies or substantial portions of the Software.

     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
     EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
     OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
     NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
     HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
     WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
     FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
     OTHER DEALINGS IN THE SOFTWARE.

     ======================================================================

     XSL include file that encapsulates the fixed style elements of
     MicroSoft Visio

     This file is meant to be included in a top-level XSLT stylesheet
     ====================================================================== -->
<!-- ======================================================================
     Implementation notes:

     1) Visio's patterns are in device units; i.e., if one zooms in on a
     shape, the pattern stays the same size.  Doing this in SVG would
     take much more effort than it's worth IMHO, so I'm basing the
     pattern dimensions on 16 lines/inch with pattern 3 (roughly what
     you'd get on a TBD dpi device).

     2) SVG 1.0 doesn't have any capability for parameterizing patterns.
     Therefore, each combination of foreground and background colors has
     to be a different defined pattern.  To manage this, the shape of the
     pattern will be defined as a symbol, and a custom pattern will be
     defined per symbol with the foreground and background colors defined
     by the fill and stroke, respectively (what Visio calls the background
     for a pattern will be the stroke in these patterns).
     ====================================================================== -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:v="urn:schemas-microsoft-com:office:visio"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:math="java.lang.Math"
  xmlns:saxon="http://icl.com/saxon"
  exclude-result-prefixes="v math"
  xmlns="http://www.w3.org/2000/svg"
  version="1.0">

  <!-- ============= Parameters =========================================== -->
  <!-- Size of standard pattern box -->
  <xsl:param name="patternSize" select="4"/>
  <!-- Number of pattern boxes per $userScale units -->
  <xsl:param name="patternsPerUserScale" select="8"/>

  <!-- ============= Predefined pattern foregrounds ======================= -->
  <!-- Note that some of the lines extend past their bounds; this
       avoids endcap problems -->
  <!-- Width of diagonal lines is sqrt(2)/4 or sqrt(2)/8 so that the
       diagonal width is 0.5 -->
  <xsl:template name="predefined-pattern-fgnds">
    <defs>
      <symbol id="pdpatfg1" width="100" height="100">
        <rect width="100" height="100" stroke="none"/>
        <polyline points="0 0, 100 100" stroke-width="10"/>
      </symbol>
      <symbol id="pdpatfg2">
        <rect width="4" height="4" stroke="none"/>
        <polyline points="-0.5,1 1,-0.5" stroke-width="0.3535534"/>
        <polyline points="-0.5,3 3,-0.5" stroke-width="0.3535534"/>
        <polyline points="0,4.5 4.5,0" stroke-width="0.3535534"/>
        <polyline points="2,4.5 4.5,2" stroke-width="0.3535534"/>
      </symbol>
      <symbol id="pdpatfg3">
        <rect width="4" height="4" stroke="none"/>
        <polyline points="-1,0.5 5,0.5" stroke-width="0.25"/>
        <polyline points="-1,2.5 5,2.5" stroke-width="0.25"/>
        <polyline points="0.5,-1 0.5,5" stroke-width="0.25"/>
        <polyline points="2.5,-1 2.5,5" stroke-width="0.25"/>
      </symbol>
      <symbol id="pdpatfg4">
        <rect width="4" height="4" stroke="none"/>
        <polyline points="-0.5,1 1,-0.5" stroke-width="0.3535534"/>
        <polyline points="-0.5,3 3,-0.5" stroke-width="0.3535534"/>
        <polyline points="0,4.5 4.5,0" stroke-width="0.3535534"/>
        <polyline points="2,4.5 4.5,2" stroke-width="0.3535534"/>
        <polyline points="-0.5,2 2,4.5" stroke-width="0.3535534"/>
        <polyline points="-0.5,0 4,4.5" stroke-width="0.3535534"/>
        <polyline points="1,-0.5 4.5,3" stroke-width="0.3535534"/>
        <polyline points="3,-0.5 4.5,1" stroke-width="0.3535534"/>
      </symbol>
      <symbol id="pdpatfg5">
        <rect width="4" height="4" stroke="none"/>
        <polyline points="-0.5,2 2,4.5" stroke-width="0.3535534"/>
        <polyline points="-0.5,0 4,4.5" stroke-width="0.3535534"/>
        <polyline points="1,-0.5 4.5,3" stroke-width="0.3535534"/>
        <polyline points="3,-0.5 4.5,1" stroke-width="0.3535534"/>
      </symbol>
      <symbol id="pdpatfg6">
        <rect width="4" height="4" stroke="none"/>
        <polyline points="-1,0.5 5,0.5" stroke-width="0.25"/>
        <polyline points="-1,2.5 5,2.5" stroke-width="0.25"/>
      </symbol>
      <symbol id="pdpatfg7">
        <rect width="4" height="4" stroke="none"/>
        <polyline points="0.5,-1 0.5,5" stroke-width="0.25"/>
        <polyline points="2.5,-1 2.5,5" stroke-width="0.25"/>
      </symbol>
      <symbol id="pdpatfg8">
        <!-- The pattern is the same as 10, just the colors are reversed.
             Doing it this way makes the code easier -->
        <use xlink:href="#pdpatfg10" x="0" y="0"/>
      </symbol>
      <symbol id="pdpatfg9">
        <use xlink:href="#pdpatfg17" x="0" y="0" transform="scale(0.5)"/>
        <use xlink:href="#pdpatfg17" x="4" y="0" transform="scale(0.5)"/>
        <use xlink:href="#pdpatfg17" x="0" y="4" transform="scale(0.5)"/>
        <use xlink:href="#pdpatfg17" x="4" y="4" transform="scale(0.5)"/>
      </symbol>
      <symbol id="pdpatfg10"
        stroke-width="0.25" stroke-dasharray="0.25,0.25">
        <rect width="4" height="4" stroke="none"/>
        <polyline points="0.125,0 0.125,4"/>
        <polyline points="0.625,0 0.625,4" stroke-dashoffset="0.25"/>
        <polyline points="1.125,0 1.125,4"/>
        <polyline points="1.625,0 1.625,4" stroke-dashoffset="0.25"/>
        <polyline points="2.125,0 2.125,4"/>
        <polyline points="2.625,0 2.625,4" stroke-dashoffset="0.25"/>
        <polyline points="3.125,0 3.125,4"/>
        <polyline points="3.625,0 3.625,4" stroke-dashoffset="0.25"/>
      </symbol>
      <symbol id="pdpatfg11"
        stroke-width="0.25" stroke-dasharray="0.25,0.75">
        <rect width="4" height="4" stroke="none"/>
        <polyline points="0.125,0 0.125,4"/>
        <polyline points="0.625,0 0.625,4" stroke-dashoffset="0.5"/>
        <polyline points="1.125,0 1.125,4"/>
        <polyline points="1.625,0 1.625,4" stroke-dashoffset="0.5"/>
        <polyline points="2.125,0 2.125,4"/>
        <polyline points="2.625,0 2.625,4" stroke-dashoffset="0.5"/>
        <polyline points="3.125,0 3.125,4"/>
        <polyline points="3.625,0 3.625,4" stroke-dashoffset="0.5"/>
      </symbol>
      <symbol id="pdpatfg12"
        stroke-width="0.25" stroke-dasharray="0.25,0.75">
        <rect width="4" height="4" stroke="none"/>
        <polyline points="0.125,0 0.125,4"/>
        <polyline points="1.125,0 1.125,4" stroke-dashoffset="0.5"/>
        <polyline points="2.125,0 2.125,4"/>
        <polyline points="3.125,0 3.125,4" stroke-dashoffset="0.5"/>
      </symbol>
      <symbol id="pdpatfg13">
        <rect width="4" height="4" stroke="none"/>
        <polyline points="-1,0.5 5,0.5" stroke-width="0.5"/>
        <polyline points="-1,1.5 5,1.5" stroke-width="0.5"/>
        <polyline points="-1,2.5 5,2.5" stroke-width="0.5"/>
        <polyline points="-1,3.5 5,3.5" stroke-width="0.5"/>
      </symbol>
      <symbol id="pdpatfg14">
        <rect width="4" height="4" stroke="none"/>
        <polyline points="0.5,-1 0.5,5" stroke-width="0.5"/>
        <polyline points="1.5,-1 1.5,5" stroke-width="0.5"/>
        <polyline points="2.5,-1 2.5,5" stroke-width="0.5"/>
        <polyline points="3.5,-1 3.5,5" stroke-width="0.5"/>
      </symbol>
      <symbol id="pdpatfg15">
        <rect width="4" height="4" stroke="none"/>
        <polyline points="-0.5,3 1,4.5" stroke-width="0.3535534"/>
        <polyline points="-0.5,2 2,4.5" stroke-width="0.3535534"/>
        <polyline points="-0.5,1 3,4.5" stroke-width="0.3535534"/>
        <polyline points="-0.5,0 4,4.5" stroke-width="0.3535534"/>
        <polyline points="0,-0.5 4.5,4" stroke-width="0.3535534"/>
        <polyline points="1,-0.5 4.5,3" stroke-width="0.3535534"/>
        <polyline points="2,-0.5 4.5,2" stroke-width="0.3535534"/>
        <polyline points="3,-0.5 4.5,1" stroke-width="0.3535534"/>
      </symbol>
      <symbol id="pdpatfg16">
        <rect width="4" height="4" stroke="none"/>
        <polyline points="-0.5,1 1,-0.5" stroke-width="0.3535534"/>
        <polyline points="-0.5,2 2,-0.5" stroke-width="0.3535534"/>
        <polyline points="-0.5,3 3,-0.5" stroke-width="0.3535534"/>
        <polyline points="-0.5,4 4,-0.5" stroke-width="0.3535534"/>
        <polyline points="0,4.5 4.5,0" stroke-width="0.3535534"/>
        <polyline points="1,4.5 4.5,1" stroke-width="0.3535534"/>
        <polyline points="2,4.5 4.5,2" stroke-width="0.3535534"/>
        <polyline points="3,4.5 4.5,3" stroke-width="0.3535534"/>
      </symbol>
      <symbol id="pdpatfg17"
        stroke-width="0.5" stroke-dasharray="0.5,0.5">
        <rect width="4" height="4" stroke="none"/>
        <polyline points="0.25,0 0.25,4"/>
        <polyline points="0.75,0 0.75,4" stroke-dashoffset="0.5"/>
        <polyline points="1.25,0 1.25,4"/>
        <polyline points="1.75,0 1.75,4" stroke-dashoffset="0.5"/>
        <polyline points="2.25,0 2.25,4"/>
        <polyline points="2.75,0 2.75,4" stroke-dashoffset="0.5"/>
        <polyline points="3.25,0 3.25,4"/>
        <polyline points="3.75,0 3.75,4" stroke-dashoffset="0.5"/>
      </symbol>
      <symbol id="pdpatfg18"
        stroke-width="0.5" stroke-dasharray="0.25,0.75">
        <rect width="4" height="4" stroke="none"/>
        <polyline points="0.25,0 0.25,4"/>
        <polyline points="0.75,0 0.75,4" stroke-dashoffset="0.5"/>
        <polyline points="1.25,0 1.25,4"/>
        <polyline points="1.75,0 1.75,4" stroke-dashoffset="0.5"/>
        <polyline points="2.25,0 2.25,4"/>
        <polyline points="2.75,0 2.75,4" stroke-dashoffset="0.5"/>
        <polyline points="3.25,0 3.25,4"/>
        <polyline points="3.75,0 3.75,4" stroke-dashoffset="0.5"/>
      </symbol>
      <symbol id="pdpatfg19">
        <rect width="4" height="4" stroke="none"/>
        <polyline points="-1,0.5 5,0.5" stroke-width="0.25"/>
        <polyline points="-1,1.5 5,1.5" stroke-width="0.25"/>
        <polyline points="-1,2.5 5,2.5" stroke-width="0.25"/>
        <polyline points="-1,3.5 5,3.5" stroke-width="0.25"/>
      </symbol>
      <symbol id="pdpatfg20">
        <rect width="4" height="4" stroke="none"/>
        <polyline points="0.5,-1 0.5,5" stroke-width="0.25"/>
        <polyline points="1.5,-1 1.5,5" stroke-width="0.25"/>
        <polyline points="2.5,-1 2.5,5" stroke-width="0.25"/>
        <polyline points="3.5,-1 3.5,5" stroke-width="0.25"/>
      </symbol>
      <symbol id="pdpatfg21">
        <rect width="4" height="4" stroke="none"/>
        <polyline points="-0.5,3 1,4.5" stroke-width="0.176776695"/>
        <polyline points="-0.5,2 2,4.5" stroke-width="0.176776695"/>
        <polyline points="-0.5,1 3,4.5" stroke-width="0.176776695"/>
        <polyline points="-0.5,0 4,4.5" stroke-width="0.176776695"/>
        <polyline points="0,-0.5 4.5,4" stroke-width="0.176776695"/>
        <polyline points="1,-0.5 4.5,3" stroke-width="0.176776695"/>
        <polyline points="2,-0.5 4.5,2" stroke-width="0.176776695"/>
        <polyline points="3,-0.5 4.5,1" stroke-width="0.176776695"/>
      </symbol>
      <symbol id="pdpatfg22">
        <rect width="4" height="4" stroke="none"/>
        <polyline points="-0.5,1 1,-0.5" stroke-width="0.176776695"/>
        <polyline points="-0.5,2 2,-0.5" stroke-width="0.176776695"/>
        <polyline points="-0.5,3 3,-0.5" stroke-width="0.176776695"/>
        <polyline points="-0.5,4 4,-0.5" stroke-width="0.176776695"/>
        <polyline points="0,4.5 4.5,0" stroke-width="0.176776695"/>
        <polyline points="1,4.5 4.5,1" stroke-width="0.176776695"/>
        <polyline points="2,4.5 4.5,2" stroke-width="0.176776695"/>
        <polyline points="3,4.5 4.5,3" stroke-width="0.176776695"/>
      </symbol>
      <symbol id="pdpatfg23">
        <rect width="4" height="4" stroke="none"/>
        <polyline points="-1,0.5 5,0.5" stroke-width="0.25"/>
        <polyline points="-1,1.5 5,1.5" stroke-width="0.25"/>
        <polyline points="-1,2.5 5,2.5" stroke-width="0.25"/>
        <polyline points="-1,3.5 5,3.5" stroke-width="0.25"/>
        <polyline points="0.5,-1 0.5,5" stroke-width="0.25"/>
        <polyline points="1.5,-1 1.5,5" stroke-width="0.25"/>
        <polyline points="2.5,-1 2.5,5" stroke-width="0.25"/>
        <polyline points="3.5,-1 3.5,5" stroke-width="0.25"/>
      </symbol>
      <symbol id="pdpatfg24">
        <rect width="4" height="4" stroke="none"/>
        <polyline points="-0.5,3 1,4.5" stroke-width="0.176776695"/>
        <polyline points="-0.5,2 2,4.5" stroke-width="0.176776695"/>
        <polyline points="-0.5,1 3,4.5" stroke-width="0.176776695"/>
        <polyline points="-0.5,0 4,4.5" stroke-width="0.176776695"/>
        <polyline points="0,-0.5 4.5,4" stroke-width="0.176776695"/>
        <polyline points="1,-0.5 4.5,3" stroke-width="0.176776695"/>
        <polyline points="2,-0.5 4.5,2" stroke-width="0.176776695"/>
        <polyline points="3,-0.5 4.5,1" stroke-width="0.176776695"/>
        <polyline points="-0.5,1 1,-0.5" stroke-width="0.176776695"/>
        <polyline points="-0.5,2 2,-0.5" stroke-width="0.176776695"/>
        <polyline points="-0.5,3 3,-0.5" stroke-width="0.176776695"/>
        <polyline points="-0.5,4 4,-0.5" stroke-width="0.176776695"/>
        <polyline points="0,4.5 4.5,0" stroke-width="0.176776695"/>
        <polyline points="1,4.5 4.5,1" stroke-width="0.176776695"/>
        <polyline points="2,4.5 4.5,2" stroke-width="0.176776695"/>
        <polyline points="3,4.5 4.5,3" stroke-width="0.176776695"/>
      </symbol>
    </defs>
  </xsl:template>

  <!-- Predefined line markers -->
  <xsl:template name="predefined-markers">
    <defs>
      <!-- Name format is: [Begin|End]Arrow-styleno-sizeno -->
      <marker id="EndArrow-13-2"
        viewBox="0 0 .135 .090" refX=".135" refY=".045" 
        markerUnits="strokeWidth"
        markerWidth="13.5" markerHeight="9.0"
        orient="auto">
        <path d="M 0 0 L .135 .045 L 0 .090 z" />
      </marker>
    </defs>
  </xsl:template>

  <!-- This template creates a pattern for the shape, using the specified
       foreground and background colors -->
  <xsl:template match="v:Fill" mode="Shape">
    <xsl:variable name="foregnd">
      <xsl:call-template name="lookup-color">
        <xsl:with-param name="c_el" select="./v:FillForegnd"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="backgnd">
      <xsl:call-template name="lookup-color">
        <xsl:with-param name="c_el" select="./v:FillBkgnd"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="patname">
      <xsl:value-of select="generate-id(..)"/><xsl:text>-pat</xsl:text>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="(v:FillPattern >= 2) and (v:FillPattern &lt; 25)">
        <xsl:variable name="pattern">
          <pattern id="{$patname}" x="0" y="0" width="{$patternSize}"
            height="{$patternSize}" patternUnits="userSpaceOnUse"
            patternTransform="scale({$userScale div ($patternSize *
                              $patternsPerUserScale)})">
            <xsl:choose>
              <!-- Patterns 8 & 18 are special cases: the colors are reversed
                   -->
              <xsl:when test="(v:FillPattern = 8) or (v:FillPattern = 18)">
                <use fill="{$foregnd}" stroke="{$backgnd}">
                  <xsl:attribute name="xlink:href">
                    <xsl:text>#pdpatfg</xsl:text>
                    <xsl:value-of select="v:FillPattern"/>
                  </xsl:attribute>
                </use>
              </xsl:when>
              <xsl:otherwise>
                <use fill="{$backgnd}" stroke="{$foregnd}">
                  <xsl:attribute name="xlink:href">
                    <xsl:text>#pdpatfg</xsl:text>
                    <xsl:value-of select="v:FillPattern"/>
                  </xsl:attribute>
                </use>
              </xsl:otherwise>
            </xsl:choose>
          </pattern>
        </xsl:variable>
        <xsl:copy-of select="$pattern"/>
      </xsl:when>
      <xsl:when test="v:FillPattern = 25">
        <linearGradient id="{$patname}">
          <stop offset="0" stop-color="{$foregnd}"/>
          <stop offset="100%" stop-color="{$backgnd}"/>
        </linearGradient>
      </xsl:when>
      <xsl:when test="v:FillPattern = 26">
        <linearGradient id="{$patname}" x1="50%" spreadMethod="reflect">
          <stop offset="0" stop-color="{$foregnd}"/>
          <stop offset="100%" stop-color="{$backgnd}"/>
        </linearGradient>
      </xsl:when>
      <xsl:when test="v:FillPattern = 27">
        <linearGradient id="{$patname}">
          <stop offset="0" stop-color="{$backgnd}"/>
          <stop offset="100%" stop-color="{$foregnd}"/>
        </linearGradient>
      </xsl:when>
      <xsl:when test="v:FillPattern = 28">
        <linearGradient id="{$patname}" x2="0" y2="100%">
          <stop offset="0" stop-color="{$foregnd}"/>
          <stop offset="100%" stop-color="{$backgnd}"/>
        </linearGradient>
      </xsl:when>
      <xsl:when test="v:FillPattern = 29">
        <linearGradient id="{$patname}" x2="0" y1="50%" y2="100%"
          spreadMethod="reflect">
          <stop offset="0" stop-color="{$foregnd}"/>
          <stop offset="100%" stop-color="{$backgnd}"/>
        </linearGradient>
      </xsl:when>
      <xsl:when test="v:FillPattern = 30">
        <linearGradient id="{$patname}" x2="0" y2="100%">
          <stop offset="0" stop-color="{$backgnd}"/>
          <stop offset="100%" stop-color="{$foregnd}"/>
        </linearGradient>
      </xsl:when>
      <xsl:when test="v:FillPattern = 31">
        <linearGradient id="{$patname}-r">
          <stop offset="0" stop-color="{$foregnd}"/>
          <stop offset="100%" stop-color="{$backgnd}"/>
        </linearGradient>
        <linearGradient id="{$patname}-d" x2="0" y2="100%">
          <stop offset="0" stop-color="{$foregnd}"/>
          <stop offset="100%" stop-color="{$backgnd}"/>
        </linearGradient>
        <pattern id="{$patname}" viewBox="0 0 1 1" preserveAspectRatio="none"
          width="100%" height="100%">
          <path d="M0,0 L0,1 L1,1 L1,0 z"
            style="fill:url(#{$patname}-d);stroke:none"/>
          <path d="M0,0 L1,0 L1,1 z"
            style="fill:url(#{$patname}-r);stroke:none"/>
        </pattern>
      </xsl:when>
      <xsl:when test="v:FillPattern = 32">
        <linearGradient id="{$patname}-l" x1="100%" x2="0">
          <stop offset="0" stop-color="{$foregnd}"/>
          <stop offset="100%" stop-color="{$backgnd}"/>
        </linearGradient>
        <linearGradient id="{$patname}-d" x2="0" y2="100%">
          <stop offset="0" stop-color="{$foregnd}"/>
          <stop offset="100%" stop-color="{$backgnd}"/>
        </linearGradient>
        <pattern id="{$patname}" viewBox="0 0 1 1" preserveAspectRatio="none"
          width="100%" height="100%">
          <path d="M0,0 L0,1 L1,1 L1,0 z"
            style="fill:url(#{$patname}-d);stroke:none"/>
          <path d="M1,0 L0,1 L0,0 z"
            style="fill:url(#{$patname}-l);stroke:none"/>
        </pattern>
      </xsl:when>
      <xsl:when test="v:FillPattern = 33">
        <linearGradient id="{$patname}-r">
          <stop offset="0" stop-color="{$foregnd}"/>
          <stop offset="100%" stop-color="{$backgnd}"/>
        </linearGradient>
        <linearGradient id="{$patname}-u" x2="0" y1="100%">
          <stop offset="0" stop-color="{$foregnd}"/>
          <stop offset="100%" stop-color="{$backgnd}"/>
        </linearGradient>
        <pattern id="{$patname}" viewBox="0 0 1 1" preserveAspectRatio="none"
          width="100%" height="100%">
          <path d="M0,0 L0,1 L1,1 L1,0 z"
            style="fill:url(#{$patname}-u);stroke:none"/>
          <path d="M0,1 L1,0 L1,1 z"
            style="fill:url(#{$patname}-r);stroke:none"/>
        </pattern>
      </xsl:when>
      <xsl:when test="v:FillPattern = 34">
        <linearGradient id="{$patname}-l" x1="100%" x2="0">
          <stop offset="0" stop-color="{$foregnd}"/>
          <stop offset="100%" stop-color="{$backgnd}"/>
        </linearGradient>
        <linearGradient id="{$patname}-u" x2="0" y1="100%">
          <stop offset="0" stop-color="{$foregnd}"/>
          <stop offset="100%" stop-color="{$backgnd}"/>
        </linearGradient>
        <pattern id="{$patname}" viewBox="0 0 1 1" preserveAspectRatio="none"
          width="100%" height="100%">
          <path d="M0,0 L0,1 L1,1 L1,0 z"
            style="fill:url(#{$patname}-u);stroke:none"/>
          <path d="M0,0 L0,1 L1,1 z"
            style="fill:url(#{$patname}-l);stroke:none"/>
        </pattern>
      </xsl:when>
      <xsl:when test="v:FillPattern = 35">
        <linearGradient id="{$patname}-r">
          <stop offset="0" stop-color="{$foregnd}"/>
          <stop offset="100%" stop-color="{$backgnd}"/>
        </linearGradient>
        <linearGradient id="{$patname}-d" x2="0" y2="100%">
          <stop offset="0" stop-color="{$foregnd}"/>
          <stop offset="100%" stop-color="{$backgnd}"/>
        </linearGradient>
        <linearGradient id="{$patname}-l" x1="100%" x2="0">
          <stop offset="0" stop-color="{$foregnd}"/>
          <stop offset="100%" stop-color="{$backgnd}"/>
        </linearGradient>
        <linearGradient id="{$patname}-u" x2="0" y1="100%">
          <stop offset="0" stop-color="{$foregnd}"/>
          <stop offset="100%" stop-color="{$backgnd}"/>
        </linearGradient>
        <pattern id="{$patname}" viewBox="0 0 1 1" preserveAspectRatio="none"
          width="100%" height="100%">
          <path d="M0,0.5 L0,1 L1,1 L1,0.5 z"
            style="fill:url(#{$patname}-d);stroke:none"/>
          <path d="M0,0 L0,0.5 L1,0.5 L1,0 z"
            style="fill:url(#{$patname}-u);stroke:none"/>
          <path d="M1,0 L0.5,0.5 L1,1 z"
            style="fill:url(#{$patname}-r);stroke:none"/>
          <path d="M0,0 L0.5,0.5 L0,1 z"
            style="fill:url(#{$patname}-l);stroke:none"/>
        </pattern>
      </xsl:when>
      <xsl:when test="v:FillPattern = 36">
        <radialGradient id="{$patname}" cx="0%" cy="0%" r="100%">
          <stop offset="0" stop-color="{$foregnd}"/>
          <stop offset="100%" stop-color="{$backgnd}"/>
        </radialGradient>
      </xsl:when>
      <xsl:when test="v:FillPattern = 37">
        <radialGradient id="{$patname}" cx="100%" cy="0%" r="100%">
          <stop offset="0" stop-color="{$foregnd}"/>
          <stop offset="100%" stop-color="{$backgnd}"/>
        </radialGradient>
      </xsl:when>
      <xsl:when test="v:FillPattern = 38">
        <radialGradient id="{$patname}" cx="0%" cy="100%" r="100%">
          <stop offset="0" stop-color="{$foregnd}"/>
          <stop offset="100%" stop-color="{$backgnd}"/>
        </radialGradient>
      </xsl:when>
      <xsl:when test="v:FillPattern = 39">
        <radialGradient id="{$patname}" cx="100%" cy="100%" r="100%">
          <stop offset="0" stop-color="{$foregnd}"/>
          <stop offset="100%" stop-color="{$backgnd}"/>
        </radialGradient>
      </xsl:when>
      <xsl:when test="v:FillPattern = 40">
        <radialGradient id="{$patname}">
          <stop offset="0" stop-color="{$foregnd}"/>
          <stop offset="100%" stop-color="{$backgnd}"/>
        </radialGradient>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="v:LinePattern" mode="style">
    <xsl:text>stroke-dasharray:</xsl:text>
    <!-- I don't know any other way to do this than hardcoding it -->
    <xsl:choose>
      <xsl:when test=". = 2">
        <xsl:value-of select="concat(.08*$userScale,',',.04*$userScale)"/>
      </xsl:when>
      <xsl:when test=". = 3">
        <xsl:value-of select="concat(.01*$userScale,',',.04*$userScale)"/>
      </xsl:when>
      <xsl:when test=". = 4">
        <xsl:value-of select="concat(.08*$userScale,',',.04*$userScale,
                              ',',.01*$userScale,',',.04*$userScale)"/>
      </xsl:when>
      <xsl:when test=". = 5">
        <xsl:value-of select="concat(.08*$userScale,',',.04*$userScale,
                              ',',.01*$userScale,',',.04*$userScale,
                              ',',.01*$userScale,',',.04*$userScale)"/>
      </xsl:when>
      <xsl:when test=". = 6">
        <xsl:value-of select="concat(.08*$userScale,',',.04*$userScale,
                              ',',.08*$userScale,',',.04*$userScale,
                              ',',.01*$userScale,',',.04*$userScale)"/>
      </xsl:when>
      <xsl:when test=". = 7">
        <xsl:value-of select="concat(.20*$userScale,',',.04*$userScale,
                              ',',.08*$userScale,',',.04*$userScale)"/>
      </xsl:when>
      <xsl:when test=". = 8">
        <xsl:value-of select="concat(.20*$userScale,',',.04*$userScale,
                              ',',.08*$userScale,',',.04*$userScale,
                              ',',.08*$userScale,',',.04*$userScale)"/>
      </xsl:when>
      <xsl:when test=". = 9">
        <xsl:value-of select="concat(.04*$userScale,',',.02*$userScale)"/>
      </xsl:when>
      <xsl:when test=". = 10">
        <xsl:value-of select="concat(.01*$userScale,',',.02*$userScale)"/>
      </xsl:when>
      <xsl:when test=". = 11">
        <xsl:value-of select="concat(.04*$userScale,',',.02*$userScale,
                              ',',.01*$userScale,',',.02*$userScale)"/>
      </xsl:when>
      <xsl:when test=". = 12">
        <xsl:value-of select="concat(.04*$userScale,',',.02*$userScale,
                              ',',.01*$userScale,',',.02*$userScale,
                              ',',.01*$userScale,',',.02*$userScale)"/>
      </xsl:when>
      <xsl:when test=". = 13">
        <xsl:value-of select="concat(.04*$userScale,',',.02*$userScale,
                              ',',.04*$userScale,',',.02*$userScale,
                              ',',.01*$userScale,',',.02*$userScale)"/>
      </xsl:when>
      <xsl:when test=". = 14">
        <xsl:value-of select="concat(.10*$userScale,',',.02*$userScale,
                              ',',.04*$userScale,',',.02*$userScale)"/>
      </xsl:when>
      <xsl:when test=". = 23">
        <xsl:value-of select="concat(.02*$userScale,',',.01*$userScale)"/>
      </xsl:when>
    </xsl:choose>
    <xsl:text>;</xsl:text>
  </xsl:template>


</xsl:stylesheet>
