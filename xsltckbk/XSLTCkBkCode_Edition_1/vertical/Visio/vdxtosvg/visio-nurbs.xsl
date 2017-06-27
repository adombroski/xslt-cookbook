<?xml version='1.0'?>
<!-- $Id: visio-nurbs.xsl,v 1.2 2002/07/04 20:33:20 jabreen Exp $ -->
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

     XSL include file that encapsulates the templates for translating
     MicroSoft Visio NURBS curves to SVG Bezier splines.

     This file is meant to be included in a top-level XSLT stylesheet
     ====================================================================== -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:v="urn:schemas-microsoft-com:office:visio"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:math="java.lang.Math"
  xmlns:saxon="http://icl.com/saxon"
  exclude-result-prefixes="v math"
  xmlns="http://www.w3.org/2000/svg"
  version="1.0">

  <!-- This file implements the templates required to translate NURBS
       curves to Bezier splines.  This is done by adding knots so that
       each segment of the NURBS is equivalent to a Bezier.

       Since Visio's freehand tool appears to always generate degree 3
       NURBS with weights of 1, this is all I'll implement for now. -->
  <!-- Visio's NURBSTo format:
       X, Y: the coordinates of the last point of the curve
       A: the second-to-last knot
       B: the last weight (assumed repeated degree+1 times)
       C: the first knot
       D: the first weight
       E: NURBS() function:
          knotlast: last knot (assumed repeated degree+1 times)
          degree: degree of curve
          xtype, ytype: 0 = percentage of width; 1 = actual coordinate
          xi, yi, knoti, weighti: remaining curve data -->

  <xsl:template name="NURBSPath">
    <!-- Might as well include hooks for other degrees of NURBS -->
    <xsl:choose>
      <xsl:when test="substring-before(substring-after(v:E, ','), ',') = 3">
        <xsl:call-template name="NURBSPath-d3"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- Template to generate a vector from every 4th value (starting with
       the first) of the given comma-separated list.
       NOTE that the result ends with a comma (as required by later templates),
       but the input vector SHOULD NOT end with a comma. -->
  <xsl:template name="NURBSVector4x">
    <xsl:param name="vector"/>
    <xsl:param name="scale"/>
    <xsl:choose>
      <xsl:when test="contains($vector, ',')">
        <xsl:value-of select="concat(substring-before($vector, ',')*$scale,
                              ',')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat($vector*$scale, ',')"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:choose>
      <xsl:when test="contains(substring-after(substring-after(
                      substring-after($vector, ','), ','), ','), ',')">
        <xsl:call-template name="NURBSVector4x">
          <xsl:with-param name="vector"
            select="substring-after(substring-after(substring-after(
                    substring-after($vector, ','), ','), ','), ',')"/>
          <xsl:with-param name="scale" select="$scale"/>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- Template to handle 3rd-degree NURBS curves -->
  <xsl:template name="NURBSPath-d3">
    <!-- NURBS control point scale for x -->
    <xsl:variable name="xNS">
      <xsl:choose>
        <xsl:when test="substring-before(substring-after(
                        substring-after(v:E, ','), ','), ',') = 0">
          <xsl:value-of select="../../v:XForm/v:Width"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="1"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <!-- NURBS control point scale for y -->
    <xsl:variable name="yNS">
      <xsl:choose>
        <xsl:when test="substring-before(substring-after(substring-after(
                        substring-after(v:E, ','), ','), ','), ',') = 0">
          <xsl:value-of select="../../v:XForm/v:Height"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="1"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <!-- k vector (note that k(0) isn't included, since it's not needed -->
    <xsl:variable name="k">
      <!-- Knots in NURBS() function call -->
      <xsl:call-template name="NURBSVector4x">
        <xsl:with-param name="vector"
          select="substring-after(substring-after(substring-after(
                  substring-after(substring-after(
                  substring-after(v:E, ','), ','), ','), ','), ','), ',')"/>
        <xsl:with-param name="scale" select="1"/>
      </xsl:call-template>
      <!-- Second-to-last knot -->
      <xsl:value-of select="concat(v:A, ',')"/>
      <!-- Last knot (needs to be repeated twice) -->
      <xsl:value-of select="concat(substring-before(substring-after(v:E,
                            'NURBS('), ','), ',')"/>
      <xsl:value-of select="concat(substring-before(substring-after(v:E,
                            'NURBS('), ','), ',')"/>
    </xsl:variable>
    <!-- y vector (note that y(0) isn't included, since it's not needed -->
    <xsl:variable name="y">
      <xsl:call-template name="NURBSVector4x">
        <xsl:with-param name="vector"
          select="substring-after(substring-after(substring-after(
                  substring-after(
                  substring-after(v:E, ','), ','), ','), ','), ',')"/>
        <xsl:with-param name="scale" select="$yNS"/>
      </xsl:call-template>
      <!-- Last point -->
      <xsl:value-of select="concat(v:Y, ',')"/>
    </xsl:variable>
    <!-- x vector (note that x(0) isn't included, since it's not needed -->
    <xsl:variable name="x">
      <xsl:call-template name="NURBSVector4x">
        <xsl:with-param name="vector"
          select="substring-after(substring-after(substring-after(
                  substring-after(v:E, ','), ','), ','), ',')"/>
        <xsl:with-param name="scale" select="$xNS"/>
      </xsl:call-template>
      <!-- Last point -->
      <xsl:value-of select="concat(v:X, ',')"/>
    </xsl:variable>
    <!-- Output initial control point -->
    <xsl:value-of select="concat('C', substring-before($x, ',')*$userScale,
                          ',', -substring-before($y, ',')*$userScale, ' ')"/>
    <xsl:call-template name="NURBSSegment-d3">
      <xsl:with-param name="k" select="substring-after(
                                       substring-after($k, ','), ',')"/>
      <xsl:with-param name="x" select="$x"/>
      <xsl:with-param name="y" select="$y"/>
    </xsl:call-template>
  </xsl:template>

  <!-- Template to handle calculation of 3rd-degree NURBS control points
       for the segment between knots k(i-1) and k(i).  This is a recursive
       template: after it calculates and outputs the values, it calls
       itself for the next segment.
       For an n-point NURBS, the initial parameters should look like this
       (with k(0)/x(0)/y(0) being the first values):
           k: k(3),k(5),k(6),...,k(n-1),k(n),k(n+1)
           x: x(1),x(2),x(3),...,x(n-2),x(n-1)
           y: y(1),y(2),y(3),...,y(n-2),y(n-1)
       This assumes that k(0)..k(3) are equal and k(n)..k(n+3) are equal
       (i.e., the curve terminates at x(0),y(0) and x(n-1),y(n-1))
       -->
  <xsl:template name="NURBSSegment-d3">
    <!-- k values: k(i-1) to k(i+2) (comma-separated & terminated) -->
    <xsl:param name="k"/>
    <!-- x values: xhat, x(i-2), x(i-1) (comma-separated & terminated)
         xhat is the last x value from the previous segment -->
    <xsl:param name="x"/>
    <!-- y values: yhat, y(i-2, y(i-1) (comma-separated & terminated)
         yhat is the last y value from the previous segment -->
    <xsl:param name="y"/>
    <!-- xhat2 -->
    <xsl:variable name="xhat2">
      <xsl:call-template name="NURBSCoord-d3">
        <xsl:with-param name="k0" select="substring-before($k, ',')"/>
        <xsl:with-param name="k1"
          select="substring-before(substring-after($k, ','), ',')"/>
        <xsl:with-param name="k2"
          select="substring-before(substring-after(substring-after($k, ','),
                  ','), ',')"/>
        <xsl:with-param name="B0" select="substring-before($x, ',')"/>
        <xsl:with-param name="B1"
          select="substring-before(substring-after($x, ','), ',')"/>
      </xsl:call-template>
    </xsl:variable>
    <!-- yhat2 -->
    <xsl:variable name="yhat2">
      <xsl:call-template name="NURBSCoord-d3">
        <xsl:with-param name="k0" select="substring-before($k, ',')"/>
        <xsl:with-param name="k1"
          select="substring-before(substring-after($k, ','), ',')"/>
        <xsl:with-param name="k2"
          select="substring-before(substring-after(substring-after($k, ','),
                  ','), ',')"/>
        <xsl:with-param name="B0" select="substring-before($y, ',')"/>
        <xsl:with-param name="B1"
          select="substring-before(substring-after($y, ','), ',')"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="concat($xhat2*$userScale, ',',
                          -$yhat2*$userScale, ' ')"/>
    <!-- xhat3 -->
    <xsl:variable name="xhat3">
      <xsl:call-template name="NURBSCoord-d3">
        <xsl:with-param name="k0" select="substring-before($k, ',')"/>
        <xsl:with-param name="k1"
          select="substring-before(substring-after($k, ','), ',')"/>
        <xsl:with-param name="k2"
          select="substring-before(substring-after(substring-after(
                  substring-after($k, ','), ','), ','), ',')"/>
        <xsl:with-param name="B0"
          select="substring-before(substring-after($x, ','), ',')"/>
        <xsl:with-param name="B1"
          select="substring-before(substring-after(
                  substring-after($x, ','), ','), ',')"/>
      </xsl:call-template>
    </xsl:variable>
    <!-- yhat3 -->
    <xsl:variable name="yhat3">
      <xsl:call-template name="NURBSCoord-d3">
        <xsl:with-param name="k0" select="substring-before($k, ',')"/>
        <xsl:with-param name="k1"
          select="substring-before(substring-after($k, ','), ',')"/>
        <xsl:with-param name="k2"
          select="substring-before(substring-after(substring-after(
                  substring-after($k, ','), ','), ','), ',')"/>
        <xsl:with-param name="B0"
          select="substring-before(substring-after($y, ','), ',')"/>
        <xsl:with-param name="B1"
          select="substring-before(substring-after(
                  substring-after($y, ','), ','), ',')"/>
      </xsl:call-template>
    </xsl:variable>
    <!-- xdoublehat -->
    <xsl:variable name="xhathat">
      <xsl:call-template name="NURBSCoord-d3">
        <xsl:with-param name="k0" select="substring-before($k, ',')"/>
        <xsl:with-param name="k1"
          select="substring-before(substring-after($k, ','), ',')"/>
        <xsl:with-param name="k2"
          select="substring-before(substring-after(substring-after($k, ','),
                  ','), ',')"/>
        <xsl:with-param name="B0" select="$xhat2"/>
        <xsl:with-param name="B1" select="$xhat3"/>
      </xsl:call-template>
    </xsl:variable>
    <!-- ydoublehat -->
    <xsl:variable name="yhathat">
      <xsl:call-template name="NURBSCoord-d3">
        <xsl:with-param name="k0" select="substring-before($k, ',')"/>
        <xsl:with-param name="k1"
          select="substring-before(substring-after($k, ','), ',')"/>
        <xsl:with-param name="k2"
          select="substring-before(substring-after(substring-after($k, ','),
                  ','), ',')"/>
        <xsl:with-param name="B0" select="$yhat2"/>
        <xsl:with-param name="B1" select="$yhat3"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="concat($xhathat*$userScale, ',',
                          -$yhathat*$userScale, ' ')"/>
    <!-- Output xhat3, yhat3 (note that this is actually the first point of
         the next spline) -->
    <xsl:value-of select="concat('C', $xhat3*$userScale, ',',
                          -$yhat3*$userScale, ' ')"/>
    <xsl:choose>
      <xsl:when test="contains(substring-after(substring-after(
                      substring-after(substring-after($k, ','), ','), ','),
                      ','), ',')">
        <!-- Process next segment -->
        <xsl:call-template name="NURBSSegment-d3">
          <xsl:with-param name="k" select="substring-after($k, ',')"/>
          <xsl:with-param name="x"
            select="concat($xhat3, ',',
                    substring-after(substring-after($x, ','), ','))"/>
          <xsl:with-param name="y"
            select="concat($yhat3, ',',
                    substring-after(substring-after($y, ','), ','))"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <!-- Output last two points -->
        <xsl:value-of select="substring-before(substring-after(
                              substring-after($x, ','), ','), ',')
                              *$userScale"/>
        <xsl:text>,</xsl:text>
        <xsl:value-of select="-substring-before(substring-after(
                              substring-after($y, ','), ','), ',')
                              *$userScale"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="substring-before(substring-after(
                              substring-after(substring-after($x, ','), ','),
                              ','), ',')*$userScale"/>
        <xsl:text>,</xsl:text>
        <xsl:value-of select="-substring-before(substring-after(
                              substring-after(substring-after($y, ','), ','),
                              ','), ',')*$userScale"/>
        <xsl:text> </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Calculate one coordinate (ordinate?) of control point, using
       the following formula:
       (k(1) - k(0))/(k(2) - k(0))*(B(1) - B(0)) + B(0) -->
  <xsl:template name="NURBSCoord-d3">
    <xsl:param name="k0"/>
    <xsl:param name="k1"/>
    <xsl:param name="k2"/>
    <xsl:param name="B0"/>
    <xsl:param name="B1"/>
    <xsl:value-of select="($k1 - $k0) div ($k2 - $k0)*($B1 - $B0) + $B0"/>
  </xsl:template>

  <!-- Debug
  <xsl:template match="*">
    <xsl:apply-templates select="./*"/>
  </xsl:template>

  <xsl:template match="//v:Page[last()]//v:NURBSTo">
    <xsl:message>
      Matched NURBSTo...
    </xsl:message>
    <xsl:call-template name="NURBSPath"/>
  </xsl:template>
  
  <xsl:param name="userScale" select="1"/>
  -->

</xsl:stylesheet>
