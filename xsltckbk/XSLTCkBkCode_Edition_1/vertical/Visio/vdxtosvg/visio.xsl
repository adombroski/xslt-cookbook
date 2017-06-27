<?xml version='1.0'?>
<!-- $Id: visio.xsl,v 1.32 2002/07/19 01:46:02 jabreen Exp $ -->
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

     XSL file for translating Visio XML to SVG

     I map the Visio elements to SVG as follows:
     - VisioDocument -> 
       - Colors ->
         - ColorEntry -> color value
       - StyleSheets ->
         - StyleSheet -> style
       - Pages -> 
         - Page -> svg
           - Shapes -> 
             - Shape -> g
               - @NameU -> @id
               - XForm -> transform
                 - PinX, PinY -> "translate()"
               - Fill -> 
                 - FillForegnd -> @fill (with lookup)
               - Geom -> path
                 - MoveTo -> @d "M"
                 - LineTo -> @d "L"
                 - NoFill (0) -> @d "z"

     My plan is to have a stencil that contains masters to represent
     specific non-graphic SVG constructs, like animation and viewBoxes.
     Therefore, masters from other stencils probably won't be supported.
     ======================================================================
     Restrictions:
     - Predefined fill patterns are supported but need to be calculated
       and filled in.
     - Predefined line patterns are not fully supported yet.
     - Line ends (aka arrowheads) are not fully supported yet.
     - Ellipses are partially supported.
     - Elliptical arcs are supported only if math library is available.
     - Masters are not supported in general.
     ====================================================================== -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:v="urn:schemas-microsoft-com:office:visio"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:math="java.lang.Math"
  xmlns:jDouble="java.lang.Double"
  xmlns:saxon="http://icl.com/saxon"
  exclude-result-prefixes="v math"
  xmlns="http://www.w3.org/2000/svg"
  version="1.0">

  <xsl:output method="xml"
    version="1.0"
    omit-xml-declaration="no"
    media-type="image/svg+xml"
    encoding="iso-8859-1"
    indent="yes"
    cdata-section-elements="style"
    doctype-public="-//W3C//DTD SVG 20010904//EN"
    doctype-system="http://www.w3.org/TR/2001/REC-SVG-20010904/DTD/svg10.dtd"
    />

  <!-- ============= Parameters =========================================== -->
  <!-- Page number (for multi-page drawings) (some XSLT processors allow
       top-level parameters to be overridden externally) -->
  <xsl:param name="pageNumber" select="1"/>
  <!-- Amount by which to scale Visio units to user units -->
  <xsl:param name="userScale"
    select="100"/>

  <!-- ============= Variables (ie, Constants) ============================ -->
  <!-- Color map -->
  <xsl:variable name="Colors"
    select="//v:Colors[position()=1]/v:ColorEntry"/>
  <!-- Page being processed -->
  <xsl:variable name="Page"
    select="/v:VisioDocument/v:Pages/v:Page[number($pageNumber)]"/>
  <!-- Template Masters -->
  <xsl:variable name="Masters"
    select="//v:Masters[position()=1]/v:Master"/>
  <!-- viewBox Master -->
  <xsl:variable name="viewBoxMaster"
    select="$Masters[@NameU='viewBox']"/>
  <!-- Ratio of font height to width (fudge factor) -->
  <xsl:variable name="fontRatio"
    select="2"/>
  <!-- Pi (SVG uses degrees, Visio uses radians) -->
  <xsl:variable name="pi" select="3.14159265358979323846264338327"/>

  <!-- ============= Motherhood stuff ===================================== -->
  
  <!-- Included files -->
  <xsl:include href="visio-style.xsl"/>
  <xsl:include href="visio-text.xsl"/>
  <xsl:include href="visio-masters.xsl"/>
  <xsl:include href="visio-nurbs.xsl"/>

   <!-- Scripts -->
  <xsl:template name="required-scripts">
    <script xlink:href="wordwrap.js" type="text/ecmascript"/>
  </xsl:template>

  <!-- ============= Root ================================================= -->
  <xsl:template match="/v:VisioDocument">
    <xsl:apply-templates
      select="$Page"/>
  </xsl:template>

  <!-- ============= Page ================================================= -->
  <xsl:template match="v:Page">
    <xsl:message>
      <xsl:value-of select="@NameU"/>
    </xsl:message>
    <svg xmlns="http://www.w3.org/2000/svg">
      <xsl:attribute name="id">
        <xsl:value-of select="@NameU"/>
      </xsl:attribute>
      <xsl:attribute name="xml:space">
        <xsl:value-of select="'preserve'"/>
      </xsl:attribute>
      <xsl:choose>
        <!-- Use viewBox with name 'default' if present -->
        <xsl:when test="//v:Shape[@Master=$viewBoxMaster/@ID
                        and @NameU='default'][1]">
          <xsl:for-each
            select="//v:Shape[@Master=$viewBoxMaster/@ID
                    and @NameU='default']">
            <xsl:attribute name="viewBox">
              <xsl:value-of select="concat(
                                    v:XForm/v:PinX*$userScale, ' ',
                                    -v:XForm/v:PinY*$userScale, ' ',
                                    v:XForm/v:Width*$userScale, ' ',
                                    v:XForm/v:Height*$userScale)"/>
            </xsl:attribute>
          </xsl:for-each>
        </xsl:when>
        <!-- Otherwise, center on sheet -->
        <xsl:otherwise>
          <xsl:attribute name="viewBox">
            <xsl:value-of select="concat('0 ', 
                                  -v:PageSheet/v:PageProps/v:PageHeight
                                    *$userScale, ' ', 
                                  v:PageSheet/v:PageProps/v:PageWidth
                                    *$userScale, ' ',
                                  v:PageSheet/v:PageProps/v:PageHeight
                                    *$userScale)"/>
          </xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:call-template name="required-scripts"/>
      <xsl:call-template name="predefined-pattern-fgnds"/>
      <xsl:call-template name="predefined-markers"/>
      <!-- The real parsing starts here -->
      <xsl:apply-templates select="../../v:StyleSheets"/>
      <xsl:apply-templates select="v:Shapes/v:Shape"/>
    </svg>
  </xsl:template>

  <!-- ============= StyleSheets ========================================== -->
  <xsl:template match="v:StyleSheets">
    <defs>
      <xsl:for-each select="v:StyleSheet">
        <!-- Line style -->
        <style id="ss-line-{@ID}" type="text/css">
          <xsl:text>*.ss-line-</xsl:text><xsl:value-of select="@ID"/>
          <xsl:text> { </xsl:text>
          <xsl:call-template name="recursive-line-style">
            <xsl:with-param name="ss" select="."/>
          </xsl:call-template>
          <xsl:text> }</xsl:text>
        </style>
        <!-- Fill style -->
        <style id="ss-fill-{@ID}" type="text/css">
          <xsl:text>*.ss-fill-</xsl:text><xsl:value-of select="@ID"/>
          <xsl:text> { </xsl:text>
          <xsl:call-template name="recursive-fill-style">
            <xsl:with-param name="ss" select="."/>
          </xsl:call-template>
          <xsl:text> }</xsl:text>
        </style>
        <!-- Text style -->
        <style id="ss-text-{@ID}" type="text/css">
          <xsl:text>*.ss-text-</xsl:text><xsl:value-of select="@ID"/>
          <xsl:text> { </xsl:text>
          <xsl:call-template name="recursive-text-style">
            <xsl:with-param name="ss" select="."/>
          </xsl:call-template>
          <xsl:text> } </xsl:text>
        </style>
      </xsl:for-each>
    </defs>
  </xsl:template>

  <!-- Recurse through StyleSheet inheritance -->
  <xsl:template name="recursive-line-style">
    <xsl:param name="ss"/>
    <xsl:if test="$ss/@LineStyle">
      <xsl:call-template name="recursive-line-style">
        <xsl:with-param name="ss"
          select="$ss/../v:StyleSheet[@ID=$ss/@LineStyle]"/>
      </xsl:call-template>
    </xsl:if>
    <xsl:apply-templates select="$ss/v:Line" mode="style"/>
  </xsl:template>

  <xsl:template name="recursive-fill-style">
    <xsl:param name="ss"/>
    <xsl:if test="$ss/@FillStyle">
      <xsl:call-template name="recursive-fill-style">
        <xsl:with-param name="ss"
          select="$ss/../v:StyleSheet[@ID=$ss/@FillStyle]"/>
      </xsl:call-template>
    </xsl:if>
    <xsl:apply-templates select="$ss/v:Fill" mode="style"/>
  </xsl:template>

  <xsl:template name="recursive-text-style">
    <xsl:param name="ss"/>
    <xsl:if test="$ss/@TextStyle">
      <xsl:call-template name="recursive-text-style">
        <xsl:with-param name="ss"
          select="$ss/../v:StyleSheet[@ID=$ss/@TextStyle]"/>
      </xsl:call-template>
    </xsl:if>
    <xsl:apply-templates select="$ss/v:Char|$ss/v:Para" mode="style"/>
  </xsl:template>

  <!-- This template returns a string for the line style -->
  <xsl:template match="v:Line" mode="style">
    <xsl:for-each select="v:LineWeight">
      <xsl:text>stroke-width:</xsl:text>
      <xsl:value-of select=". * $userScale"/><xsl:text>;</xsl:text>
    </xsl:for-each>
    <xsl:for-each select="v:LineColor">
      <xsl:choose>
        <xsl:when test="../v:LinePattern > 0">
          <xsl:text>stroke:</xsl:text>
          <xsl:call-template name="lookup-color">
            <xsl:with-param name="c_el" select="."/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="../v:LinePattern = 0">
          <xsl:text>stroke:none</xsl:text>
        </xsl:when>
      </xsl:choose>
      <xsl:text>;</xsl:text>
    </xsl:for-each>
    <xsl:for-each select="v:EndArrow">
      <xsl:choose>
        <xsl:when test=". = 0">
          <xsl:value-of select="string('marker-end:none;')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat('marker-end:url(#EndArrow-', .,
                                '-', ../v:EndArrowSize, ');')"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
    <xsl:apply-templates select="v:LinePattern[. &gt; 1]" mode="style"/>
  </xsl:template>

  <!-- This template returns a string for the fill style -->
  <xsl:template match="v:Fill" mode="style">
    <xsl:for-each select="v:FillForegnd">
      <xsl:choose>
        <xsl:when test="../v:FillPattern = 1">
          <xsl:text>fill:</xsl:text>
          <xsl:call-template name="lookup-color">
            <xsl:with-param name="c_el" select="."/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="../v:FillPattern = 0">
          <xsl:text>fill:none</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>fill:url(#</xsl:text>
          <xsl:value-of select="generate-id(../..)"/>
          <xsl:text>-pat)</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text>;</xsl:text>
    </xsl:for-each>
  </xsl:template>

  <!-- This template returns a string for the text style -->
  <xsl:template match="v:Char|v:Para" mode="style">
    <xsl:for-each select="v:Color">
      <!-- I don't think Visio handles filled characters -->
      <xsl:text>stroke:none</xsl:text>
      <xsl:text>;fill:</xsl:text>
      <xsl:call-template name="lookup-color">
        <xsl:with-param name="c_el" select="."/>
      </xsl:call-template>
      <xsl:text>;</xsl:text>
    </xsl:for-each>
    <xsl:for-each select="v:Size">
      <xsl:text>font-size:</xsl:text>
      <xsl:value-of select=". * $userScale"/><xsl:text>;</xsl:text>
    </xsl:for-each>
    <xsl:for-each select="v:HorzAlign">
      <xsl:text>text-anchor:</xsl:text>
      <xsl:choose>
        <xsl:when test="(. = 0) or (. = 3)">
          <xsl:text>start</xsl:text>
        </xsl:when>
        <xsl:when test=". = 1">
          <xsl:text>middle</xsl:text>
        </xsl:when>
        <xsl:when test=". = 2">
          <xsl:text>end</xsl:text>
        </xsl:when>
      </xsl:choose>
      <xsl:text>;</xsl:text>
    </xsl:for-each>
  </xsl:template>

  <!-- Ignore all other StyleSheet elements -->
  <xsl:template match="*[parent::v:StyleSheet]" priority="-100"/>

  <!-- ============= Shape ================================================ -->
  <xsl:template match="v:Shape">
    <xsl:variable name="master"
      select="/v:VisioDocument//v:Masters[1]
              /v:Master[@ID=current()/@Master]"/>
    <xsl:variable name="svgElement">
      <xsl:choose>
        <xsl:when test="./v:Prop/v:Label[.='svgElement']">
          <xsl:value-of
            select="./v:Prop/v:Label[.='svgElement']/../v:Value"/>
        </xsl:when>
        <xsl:when test="@Master and $master//v:Prop/v:Label[.='svgElement']">
          <xsl:value-of
            select="$master//v:Prop/v:Label[.='svgElement']/../v:Value"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="'g'"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="@Master and string($svgElement)
                      and contains($specialMasters, $svgElement)">
        <xsl:call-template name="choose-special-master">
          <xsl:with-param name="master" select="$master"/>
          <xsl:with-param name="masterElement" select="$svgElement"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="($svgElement = 'defs') or ($svgElement = 'g') or
                      ($svgElement = 'symbol')">
        <xsl:choose>
          <xsl:when test="v:Hyperlink">
            <!-- Surround shape with 'a' element -->
            <!-- This is a minimal implementation.  It doesn't support
                 multiple links, subaddress, etc. -->
            <a xlink:title="{v:Hyperlink/v:Description}"
              xlink:href="{v:Hyperlink/v:Address}">
              <xsl:if test="v:Hyperlink/v:NewWindow">
                <xsl:attribute name="show">
                  <xsl:value-of select="new"/>
                </xsl:attribute>
              </xsl:if>
              <xsl:element name="{$svgElement}">
                <xsl:call-template name="userShape"/>
              </xsl:element>
            </a>
          </xsl:when>
          <xsl:otherwise>
            <xsl:element name="{$svgElement}">
              <xsl:call-template name="userShape"/>
            </xsl:element>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <!-- Not sure what to do here; are there any other cases? -->
        <xsl:message>
          <xsl:text>Warning: illegal svgElement value </xsl:text>
          <xsl:if test="function-available('saxon:path') and
                        function-available('saxon:lineNumber')">
            <xsl:value-of select="concat('(', $svgElement, ')')"/>
            <xsl:value-of select="concat(' on ', saxon:path(),
                                  ' (', saxon:lineNumber(), ')')"/>
          </xsl:if>
        </xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- This does the processing for normal 'user' shapes -->
  <xsl:template name="userShape">
    <!--
    <xsl:message>
      <xsl:value-of select="concat('Node ', saxon:path())"/>
    </xsl:message>
    -->
    <xsl:variable name="master"
      select="/v:VisioDocument/v:Masters
              /v:Master[(@ID=current()/@Master)
                        and (current()/@Type != 'Group')]
              /v:Shapes/v:Shape |
              /v:VisioDocument/v:Masters
              /v:Master[@ID=current()
              /ancestor::v:Shape[@Master]/@Master]
              //v:Shape[@ID=current()/@MasterShape] | ."/>
    <xsl:call-template name="setIdAttribute"/>
    <xsl:attribute name="class">
      <xsl:for-each select="($master[@LineStyle])[last()]">
        <xsl:text> ss-line-</xsl:text>
        <xsl:value-of select="@LineStyle"/>
      </xsl:for-each>
      <xsl:for-each select="($master[@FillStyle])[last()]">
        <xsl:text> ss-fill-</xsl:text>
        <xsl:value-of select="@FillStyle"/>
      </xsl:for-each>
    </xsl:attribute>
    <xsl:attribute name="style">
      <xsl:for-each select="$master">
        <xsl:apply-templates select="./v:Line" mode="style"/>
        <xsl:apply-templates select="./v:Fill" mode="style"/>
      </xsl:for-each>
    </xsl:attribute>
    <xsl:for-each select="v:XForm">
      <xsl:call-template name="transformAttribute">
      </xsl:call-template>
    </xsl:for-each>
    <!-- This is to create the custom pattern -->
    <xsl:apply-templates select="v:Fill" mode="Shape"/>
    <!-- This needs work.  Masters can have graphics that aren't
         explicitly shown in the instance; but I need to make sure
         the graphics isn't drawn twice.
    <xsl:for-each select="$master/v:Geom">
      -->
    <xsl:for-each select="v:Geom">
      <xsl:apply-templates select="v:Ellipse"/>
      <xsl:if test="v:MoveTo or v:LineTo">
        <xsl:call-template name="pathElement"/>
      </xsl:if>
    </xsl:for-each>
    <xsl:for-each select="($master/v:Text)[last()]">
      <xsl:apply-templates select="."/>
    </xsl:for-each>
    <xsl:apply-templates select="v:Shapes/v:Shape"/>
    <!-- Add elements from properties -->
    <xsl:for-each select="v:Prop">
      <xsl:choose>
        <xsl:when test="starts-with(v:Label, 'svg-element')">
          <!-- This is sort of ugly - it may disappear some day -->
          <xsl:value-of disable-output-escaping="yes" select="v:Value"/>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <!-- Need to put support for masters here -->
  <xsl:template match="v:Shape[@Master]" priority="-100"/>

  <xsl:template match="v:Ellipse">
    <!-- This is a somewhat limited translation.  It assumes that the
         axes are parallel to the x & y axes, and the lower-left corner
         of the bounding box is at the origin (which appears to be the
         way Visio draws them by default). -->
    <ellipse id="ellipse-{generate-id(ancestor::v:Shape[1])}"
      cx="{v:X*$userScale}" cy="{-v:Y*$userScale}"
      rx="{v:X*$userScale}" ry="{v:Y*$userScale}"/>
  </xsl:template>
  <!-- ====================================================================
       Utility templates
       ==================================================================== -->

  <!-- Lookup color value in Colors element -->
  <xsl:template name="lookup-color">
    <xsl:param name="c_el"/>
    <xsl:choose>
      <xsl:when test="starts-with($c_el, '#')">
        <xsl:value-of select="$c_el"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$Colors[@IX=string($c_el)]/@RGB"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Set id attribute of current element -->
  <xsl:template name="setIdAttribute">
    <xsl:attribute name="id">
      <xsl:choose>
        <xsl:when test="@NameU">
          <xsl:value-of select="@NameU"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="generate-id(.)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>

  <!-- Translate XForm element into transform attribute -->
  <xsl:template name="transformAttribute">
    <xsl:attribute name="transform">
      <xsl:text>translate(</xsl:text>
      <xsl:value-of select="concat((v:PinX - v:LocPinX)*$userScale,
                            ',', -(v:PinY - v:LocPinY)*$userScale)"/>
      <xsl:if test="v:Angle != 0">
        <xsl:text>) rotate(</xsl:text>
        <xsl:value-of select="-v:Angle*180 div $pi"/>
        <xsl:value-of select="concat(',', v:LocPinX*$userScale,
                              ',', -v:LocPinY*$userScale)"/>
      </xsl:if>
      <xsl:text>)</xsl:text>
    </xsl:attribute>
  </xsl:template>

  <!-- Translate Geom element into path element -->
  <xsl:template name="pathElement">
    <xsl:variable name="pathID">
      <xsl:text>path-</xsl:text>
      <xsl:choose>
        <xsl:when test="ancestor::v:Shape[1]/@NameU">
          <xsl:value-of select="ancestor::v:Shape[1]/@NameU"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="generate-id(ancestor::v:Shape[1])"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <path id="{$pathID}">
      <xsl:attribute name="d">
        <xsl:for-each select="v:*">
          <xsl:choose>
            <xsl:when test="name() = 'MoveTo'">
              <xsl:value-of select="concat('M', v:X*$userScale,
                                    ',', -v:Y*$userScale, ' ')"/>
            </xsl:when>
            <xsl:when test="name() = 'LineTo'">
              <!-- This was a test of ways to handle scientific notation.
                   It works, but it's not portable, and it would be
                   very cumbersome to do on each calculation.  Not sure
                   what to do about this one...
              <xsl:message>
                LineTo
                <xsl:value-of select="v:Y"/>
                <xsl:text>
                </xsl:text>
                <xsl:value-of
                  select="jDouble:parseDouble(v:Y)"/>
              </xsl:message>
              -->
              <xsl:value-of select="concat('L', v:X*$userScale,
                                    ',', -v:Y*$userScale, ' ')"/>
            </xsl:when>
            <xsl:when test="name() = 'EllipticalArcTo'">
              <!-- If we don't have access to trig functions, the
                   arc will just be represented by two line segments-->
              <xsl:choose>
                <xsl:when test="function-available('math:atan2')">
                  <xsl:call-template name="ellipticalArcPath"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="concat('L', v:A*$userScale,
                                        ',', -v:B*$userScale,
                                        ' L', v:X*$userScale,
                                        ',', -v:Y*$userScale, ' ')"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:when test="(name() = 'NoFill') or (name() = 'NoLine') or
                            (name() = 'NoShow') or (name() = 'NoSnap')">
              <!-- Ignore these -->
            </xsl:when>
            <xsl:when test="name() = 'NURBSTo'">
              <xsl:call-template name="NURBSPath"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:message>
                <xsl:text>Warning: unsupported path command found:</xsl:text>
                <xsl:value-of select="name()"/>
                <xsl:text>; replacing with LineTo</xsl:text>
              </xsl:message>
              <xsl:value-of select="concat('L', v:X*$userScale,
                                    ',', -v:Y*$userScale, ' ')"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </xsl:attribute>
      <xsl:if test="v:NoFill = 1">
        <xsl:attribute name="fill"><xsl:text>none</xsl:text></xsl:attribute>
      </xsl:if>
    </path>
  </xsl:template>

  <!-- This template calculates the path string for an elliptical arc -->
  <xsl:template name="ellipticalArcPath">
    <!-- Figure sweep based on angle from current point to (X,Y) and (A,B) -->
    <!-- TODO: figure a better way to make sure the preceding
         sibling is a drawing element -->
    <xsl:variable name="lastX"
      select="preceding-sibling::*[1]/v:X"/>
    <xsl:variable name="lastY"
      select="preceding-sibling::*[1]/v:Y"/>
    <xsl:variable name="angle"
      select="math:atan2(v:Y - $lastY, v:X - $lastX)
              - math:atan2(v:B - $lastY, v:A - $lastX)"/>
    <xsl:variable name="sweep">
      <xsl:choose>
        <xsl:when test="$angle &gt; 0
                        and math:abs($angle) &lt; 180">
          <xsl:value-of select='0'/>
        </xsl:when>
        <xsl:when test="$angle &lt; 0
                        and math:abs($angle) &gt; 180">
          <xsl:value-of select='0'/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select='1'/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:value-of select="concat('A',
                          (preceding-sibling::*[1]/v:X - v:X)*$userScale, ',',
                          (preceding-sibling::*[1]/v:Y - v:Y)*$userScale, ' ',
                          v:C,  ' 0,', $sweep, ' ', v:X*$userScale, ',',
                          -v:Y*$userScale, ' ')"/>
  </xsl:template>

  <!-- This template traces through the stylesheets, starting with $ssID,
       until it finds the node specified by $ssProp, then returns the
       value -->
  <xsl:template name="lookup-style-property">
    <xsl:param name="ssNode"/>
    <xsl:param name="ssProp"/>

    <xsl:choose>
      <xsl:when test="false()">
        <!-- This isn't general enough; probably need another parameter
             for the @???Style attribute -->
<!--
      <xsl:when test="function-available('saxon:evaluate')">
        <xsl:for-each select="$ssNode">
          <xsl:choose>
            <xsl:when test="saxon:evaluate($ssProp)">
              <xsl:value-of select="saxon:evaluate($ssProp)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="lookup-style-property">
                <xsl:with-param name="ssNode" 
                  select="/v:VisioDocument/v:StyleSheets/
                          v:StyleSheet[@ID=$ssNode/@TextStyle]"/>
                <xsl:with-param name="ssProp" select="$ssProp"/>
              </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
-->
      </xsl:when>
      <xsl:otherwise>
        <!-- Select specific lookup template if evaluate() isn't available -->
        <xsl:choose>
          <xsl:when test="$ssProp = 'v:Para/v:HorzAlign'">
            <xsl:call-template
              name="lookup-style-property-Para-HorzAlign">
              <xsl:with-param name="ssNode" select="$ssNode"/>
              <xsl:with-param name="ssProp" select="$ssProp"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$ssProp = 'v:TextBlock/v:VerticalAlign'">
            <xsl:call-template
              name="lookup-style-property-TextBlock-VerticalAlign">
              <xsl:with-param name="ssNode" select="$ssNode"/>
              <xsl:with-param name="ssProp" select="$ssProp"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$ssProp = 'v:Para/v:SpLine'">
            <xsl:call-template
              name="lookup-style-property-Para-SpLine">
              <xsl:with-param name="ssNode" select="$ssNode"/>
              <xsl:with-param name="ssProp" select="$ssProp"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$ssProp = 'v:TextBlock/v:LeftMargin'">
            <xsl:call-template
              name="lookup-style-property-TextBlock-LeftMargin">
              <xsl:with-param name="ssNode" select="$ssNode"/>
              <xsl:with-param name="ssProp" select="$ssProp"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$ssProp = 'v:TextBlock/v:RightMargin'">
            <xsl:call-template
              name="lookup-style-property-TextBlock-RightMargin">
              <xsl:with-param name="ssNode" select="$ssNode"/>
              <xsl:with-param name="ssProp" select="$ssProp"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$ssProp = 'v:TextBlock/v:TopMargin'">
            <xsl:call-template
              name="lookup-style-property-TextBlock-TopMargin">
              <xsl:with-param name="ssNode" select="$ssNode"/>
              <xsl:with-param name="ssProp" select="$ssProp"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$ssProp = 'v:TextBlock/v:BottomMargin'">
            <xsl:call-template
              name="lookup-style-property-TextBlock-BottomMargin">
              <xsl:with-param name="ssNode" select="$ssNode"/>
              <xsl:with-param name="ssProp" select="$ssProp"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:message>
              <xsl:value-of
                select="concat('Internal Error: no template for ',
                        $ssProp)"/>
            </xsl:message>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
