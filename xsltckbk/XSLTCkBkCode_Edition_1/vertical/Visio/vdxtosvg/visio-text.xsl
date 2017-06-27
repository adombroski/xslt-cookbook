<?xml version='1.0'?>
<!-- $Id: visio-text.xsl,v 1.12 2002/06/20 18:47:54 jabreen Exp $ -->
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

     XSL include file that encapsulates the text templates for translating
     MicroSoft Visio to SVG.

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

  <!-- This is the main template for Text nodes.  It no longer depends on
       Saxon extensions, but it does use javascript.  I'm debating whether
       to put the crude XSLT-only word wrapping back in. -->
  <!-- Some Visio text notes:
       TxtPinX/Y: text pin offset from group origin (after text rotation)
       TxtWidth/Height: size of text block (before rotation)
       TxtLocPinX/Y: text pin offset from text block origin (lower-left
          corner) (before rotation)
       TxtAngle: text rotation about text pin
       Alignment is wrt text block boundary (not text pin) -->
  <!-- More notes:
       Style is a bitfield:
         1 - bold
         2 - italic
         4 - underline
         8 - small caps for lowercase
       Trailing spaces don't affect alignment; leading spaces do;
       If the word is wrapped, spaces at wrap point are considered trailing;
       Spaces may cause a wrap at the beginning of text if the first word
       won't fit;
       Characters wrap at border if word is too long;
       Tabs don't count as word breaks;
       Hyphens count as word breaks, but will wrap as part of word if too
       long (eg, WORD_XXX will wrap like WORD_\nX if necessary, but
       WORD______XXX may wrap like WORD___\n___XXX) (note that I had to
       use _ instead of hyphen, to keep XML happy);
       -->
  <xsl:template match="v:Text">
    <text>
      <xsl:attribute name="class">
        <xsl:for-each select="(/v:VisioDocument/v:Masters
                              /v:Master[(@ID=current()/../@Master)
                                and (current()/../@Type != 'Group')]
                              /v:Shapes/v:Shape |
                              /v:VisioDocument/v:Masters
                              /v:Master[@ID=current()
                              /ancestor::v:Shape[@Master]/@Master]
                              //v:Shape[@ID=current()/../@MasterShape] | ..)
                              [@TextStyle][last()]">
          <xsl:text> ss-text-</xsl:text>
          <xsl:value-of select="./@TextStyle"/>
        </xsl:for-each>
      </xsl:attribute>
      <!-- Text transformation -->
      <xsl:variable name="hAlign">
        <xsl:call-template name="lookup-style-property">
          <xsl:with-param name="ssNode" select=".."/>
          <xsl:with-param name="ssProp"
            select="string('v:Para/v:HorzAlign')"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="vAlign">
        <xsl:call-template
          name="lookup-style-property">
          <xsl:with-param name="ssNode" select=".."/>
          <xsl:with-param name="ssProp"
            select="string('v:TextBlock/v:VerticalAlign')"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="lSpace">
        <xsl:call-template name="lookup-style-property">
          <xsl:with-param name="ssNode" select=".."/>
          <xsl:with-param name="ssProp"
            select="string('v:Para/v:SpLine')"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="lMargin">
        <xsl:call-template name="lookup-style-property">
          <xsl:with-param name="ssNode" select=".."/>
          <xsl:with-param name="ssProp"
            select="string('v:TextBlock/v:LeftMargin')"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="rMargin">
        <xsl:call-template name="lookup-style-property">
          <xsl:with-param name="ssNode" select=".."/>
          <xsl:with-param name="ssProp"
            select="string('v:TextBlock/v:RightMargin')"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="tMargin">
        <xsl:call-template name="lookup-style-property">
          <xsl:with-param name="ssNode" select=".."/>
          <xsl:with-param name="ssProp"
            select="string('v:TextBlock/v:TopMargin')"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="bMargin">
        <xsl:call-template name="lookup-style-property">
          <xsl:with-param name="ssNode" select=".."/>
          <xsl:with-param name="ssProp"
            select="string('v:TextBlock/v:BottomMargin')"/>
        </xsl:call-template>
      </xsl:variable>
      <!-- This really needs to be broken up into smaller templates -->
      <xsl:choose>
        <xsl:when test="../v:TextXForm">
          <!-- Text box is shifted or rotated -->
          <xsl:for-each select="../v:TextXForm">
            <xsl:attribute name="transform">
              <xsl:value-of select="concat('translate(',
                                    (v:TxtPinX)*$userScale, ',',
                                    -(v:TxtPinY)*$userScale)"/>
              <xsl:if test="v:TxtAngle != 0">
                <xsl:value-of select="concat(') rotate(',
                                      -v:TxtAngle*180 div $pi)"/>
              </xsl:if>
              <!-- Figure alignment (this is messy) -->
              <xsl:text>) translate(</xsl:text>
              <xsl:choose>
                <xsl:when test="$hAlign = 0">
                  <xsl:value-of select="-(v:TxtLocPinX - $lMargin)
                                        *$userScale"/>
                </xsl:when>
                <xsl:when test="$hAlign = 2">
                  <xsl:value-of select="(v:TxtLocPinX - $rMargin)*$userScale"/>
                </xsl:when>
                <xsl:otherwise>
                  <!-- Justify & Force will currently be handled as
                       centered -->
                  <xsl:text>0</xsl:text>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:text>,</xsl:text>
              <xsl:choose>
                <xsl:when test="$vAlign = 0">
                  <xsl:value-of select="(v:TxtLocPinY + $tMargin)*$userScale"/>
                </xsl:when>
                <xsl:when test="$vAlign = 2">
                  <xsl:value-of select="-(v:TxtLocPinY + $bMargin)
                                        *$userScale"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:text>0</xsl:text>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:text>)</xsl:text>
            </xsl:attribute>
          </xsl:for-each>
          <xsl:attribute name="onload">
            <xsl:value-of
              select="concat('wrap_text(evt,',
                      (../v:TextXForm/v:TxtWidth - $lMargin - $rMargin)
                      *$userScale, ',',
                      $hAlign, ',', $vAlign, ',',
                      $lSpace, ')')"/>
          </xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <!-- Untransformed -->
          <xsl:attribute name="x">
            <xsl:choose>
              <xsl:when test="$hAlign = 0">
                <xsl:value-of select="$lMargin*$userScale"/>
              </xsl:when>
              <xsl:when test="$hAlign = 2">
                <xsl:value-of select="(../v:XForm/v:Width - $rMargin)
                                      *$userScale"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="../v:XForm/v:LocPinX*$userScale"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:attribute name="y">
            <xsl:choose>
              <xsl:when test="$vAlign = 0">
                <xsl:value-of select="(-../v:XForm/v:Height + $tMargin)
                                      *$userScale"/>
              </xsl:when>
              <xsl:when test="$vAlign = 2">
                <xsl:value-of select="-$bMargin*$userScale"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="-../v:XForm/v:LocPinY*$userScale"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:attribute name="onload">
            <xsl:value-of
              select="concat('wrap_text(evt,',
                      (../v:XForm/v:Width - $lMargin - $rMargin)*$userScale,
                      ',', $hAlign, ',', $vAlign, ',',
                      $lSpace, ')')"/>
          </xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:attribute name="style">
        <xsl:apply-templates select="../v:Char|../v:Para" mode="style"/>
      </xsl:attribute>
      <xsl:value-of select="."/>
    </text>
  </xsl:template>

  <!-- These templates do specific property searches in the StyleSheets,
       to avoid having to use Saxon extensions -->

  <xsl:template name="lookup-style-property-Para-HorzAlign">
    <xsl:param name="ssNode"/>
    <!-- ssProp isn't really used -->
    <xsl:param name="ssProp"/>

    <xsl:for-each select="$ssNode">
      <xsl:choose>
        <xsl:when test="v:Para/v:HorzAlign">
          <xsl:value-of select="v:Para/v:HorzAlign"/>
        </xsl:when>
        <xsl:when test="@Master">
          <xsl:call-template name="lookup-style-property-Para-HorzAlign">
            <xsl:with-param name="ssNode" 
              select="/v:VisioDocument/v:Masters/
                      v:Master[@ID=$ssNode/@Master]/v:Shapes/v:Shape"/>
            <xsl:with-param name="ssProp" select="$ssProp"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="@MasterShape">
          <xsl:call-template name="lookup-style-property-Para-HorzAlign">
            <xsl:with-param name="ssNode" 
              select="/v:VisioDocument/v:Masters
                      /v:Master[@ID=$ssNode
                        /ancestor::v:Shape[@Master]/@Master]
                      //v:Shapes/v:Shape[@ID=$ssNode/@MasterShape]"/>
            <xsl:with-param name="ssProp" select="$ssProp"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="@TextStyle">
          <xsl:call-template name="lookup-style-property-Para-HorzAlign">
            <xsl:with-param name="ssNode" 
              select="/v:VisioDocument/v:StyleSheets/
                      v:StyleSheet[@ID=$ssNode/@TextStyle]"/>
            <xsl:with-param name="ssProp" select="$ssProp"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="0"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="lookup-style-property-TextBlock-VerticalAlign">
    <xsl:param name="ssNode"/>
    <!-- ssProp isn't really used -->
    <xsl:param name="ssProp"/>

    <xsl:for-each select="$ssNode">
      <xsl:choose>
        <xsl:when test="v:TextBlock/v:VerticalAlign">
          <xsl:value-of select="v:TextBlock/v:VerticalAlign"/>
        </xsl:when>
        <xsl:when test="@Master">
          <xsl:call-template
            name="lookup-style-property-TextBlock-VerticalAlign">
            <xsl:with-param name="ssNode" 
              select="/v:VisioDocument/v:Masters/
                      v:Master[@ID=$ssNode/@Master]/v:Shapes/v:Shape"/>
            <xsl:with-param name="ssProp" select="$ssProp"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="@MasterShape">
          <xsl:call-template
            name="lookup-style-property-TextBlock-VerticalAlign">
            <xsl:with-param name="ssNode" 
              select="/v:VisioDocument/v:Masters
                      /v:Master[@ID=$ssNode
                        /ancestor::v:Shape[@Master]/@Master]
                      //v:Shapes/v:Shape[@ID=$ssNode/@MasterShape]"/>
            <xsl:with-param name="ssProp" select="$ssProp"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="@TextStyle">
          <xsl:call-template
            name="lookup-style-property-TextBlock-VerticalAlign">
            <xsl:with-param name="ssNode" 
              select="/v:VisioDocument/v:StyleSheets/
                      v:StyleSheet[@ID=$ssNode/@TextStyle]"/>
            <xsl:with-param name="ssProp" select="$ssProp"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="0"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="lookup-style-property-Para-SpLine">
    <xsl:param name="ssNode"/>
    <!-- ssProp isn't really used -->
    <xsl:param name="ssProp"/>

    <xsl:for-each select="$ssNode">
      <xsl:choose>
        <xsl:when test="v:Para/v:SpLine">
          <xsl:value-of select="v:Para/v:SpLine"/>
        </xsl:when>
        <xsl:when test="@Master">
          <xsl:call-template name="lookup-style-property-Para-SpLine">
            <xsl:with-param name="ssNode" 
              select="/v:VisioDocument/v:Masters/
                      v:Master[@ID=$ssNode/@Master]/v:Shapes/v:Shape"/>
            <xsl:with-param name="ssProp" select="$ssProp"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="@MasterShape">
          <xsl:call-template name="lookup-style-property-Para-SpLine">
            <xsl:with-param name="ssNode" 
              select="/v:VisioDocument/v:Masters
                      /v:Master[@ID=$ssNode
                        /ancestor::v:Shape[@Master]/@Master]
                      //v:Shapes/v:Shape[@ID=$ssNode/@MasterShape]"/>
            <xsl:with-param name="ssProp" select="$ssProp"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="@TextStyle">
          <xsl:call-template name="lookup-style-property-Para-SpLine">
            <xsl:with-param name="ssNode" 
              select="/v:VisioDocument/v:StyleSheets/
                      v:StyleSheet[@ID=$ssNode/@TextStyle]"/>
            <xsl:with-param name="ssProp" select="$ssProp"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="0"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="lookup-style-property-TextBlock-LeftMargin">
    <xsl:param name="ssNode"/>
    <!-- ssProp isn't really used -->
    <xsl:param name="ssProp"/>

    <xsl:for-each select="$ssNode">
      <xsl:choose>
        <xsl:when test="v:TextBlock/v:LeftMargin">
          <xsl:value-of select="v:TextBlock/v:LeftMargin"/>
        </xsl:when>
        <xsl:when test="@Master">
          <xsl:call-template name="lookup-style-property-TextBlock-LeftMargin">
            <xsl:with-param name="ssNode" 
              select="/v:VisioDocument/v:Masters/
                      v:Master[@ID=$ssNode/@Master]/v:Shapes/v:Shape"/>
            <xsl:with-param name="ssProp" select="$ssProp"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="@MasterShape">
          <xsl:call-template name="lookup-style-property-TextBlock-LeftMargin">
            <xsl:with-param name="ssNode" 
              select="/v:VisioDocument/v:Masters
                      /v:Master[@ID=$ssNode
                        /ancestor::v:Shape[@Master]/@Master]
                      //v:Shapes/v:Shape[@ID=$ssNode/@MasterShape]"/>
            <xsl:with-param name="ssProp" select="$ssProp"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="@TextStyle">
          <xsl:call-template name="lookup-style-property-TextBlock-LeftMargin">
            <xsl:with-param name="ssNode" 
              select="/v:VisioDocument/v:StyleSheets/
                      v:StyleSheet[@ID=$ssNode/@TextStyle]"/>
            <xsl:with-param name="ssProp" select="$ssProp"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="0"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="lookup-style-property-TextBlock-RightMargin">
    <xsl:param name="ssNode"/>
    <!-- ssProp isn't really used -->
    <xsl:param name="ssProp"/>

    <xsl:for-each select="$ssNode">
      <xsl:choose>
        <xsl:when test="v:TextBlock/v:RightMargin">
          <xsl:value-of select="v:TextBlock/v:RightMargin"/>
        </xsl:when>
        <xsl:when test="@Master">
          <xsl:call-template
            name="lookup-style-property-TextBlock-RightMargin">
            <xsl:with-param name="ssNode" 
              select="/v:VisioDocument/v:Masters/
                      v:Master[@ID=$ssNode/@Master]/v:Shapes/v:Shape"/>
            <xsl:with-param name="ssProp" select="$ssProp"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="@MasterShape">
          <xsl:call-template
            name="lookup-style-property-TextBlock-RightMargin">
            <xsl:with-param name="ssNode" 
              select="/v:VisioDocument/v:Masters
                      /v:Master[@ID=$ssNode
                        /ancestor::v:Shape[@Master]/@Master]
                      //v:Shapes/v:Shape[@ID=$ssNode/@MasterShape]"/>
            <xsl:with-param name="ssProp" select="$ssProp"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="@TextStyle">
          <xsl:call-template
            name="lookup-style-property-TextBlock-RightMargin">
            <xsl:with-param name="ssNode" 
              select="/v:VisioDocument/v:StyleSheets/
                      v:StyleSheet[@ID=$ssNode/@TextStyle]"/>
            <xsl:with-param name="ssProp" select="$ssProp"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="0"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="lookup-style-property-TextBlock-TopMargin">
    <xsl:param name="ssNode"/>
    <!-- ssProp isn't really used -->
    <xsl:param name="ssProp"/>

    <xsl:for-each select="$ssNode">
      <xsl:choose>
        <xsl:when test="v:TextBlock/v:TopMargin">
          <xsl:value-of select="v:TextBlock/v:TopMargin"/>
        </xsl:when>
        <xsl:when test="@Master">
          <xsl:call-template
            name="lookup-style-property-TextBlock-TopMargin">
            <xsl:with-param name="ssNode" 
              select="/v:VisioDocument/v:Masters/
                      v:Master[@ID=$ssNode/@Master]/v:Shapes/v:Shape"/>
            <xsl:with-param name="ssProp" select="$ssProp"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="@MasterShape">
          <xsl:call-template
            name="lookup-style-property-TextBlock-TopMargin">
            <xsl:with-param name="ssNode" 
              select="/v:VisioDocument/v:Masters
                      /v:Master[@ID=$ssNode
                        /ancestor::v:Shape[@Master]/@Master]
                      //v:Shapes/v:Shape[@ID=$ssNode/@MasterShape]"/>
            <xsl:with-param name="ssProp" select="$ssProp"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="@TextStyle">
          <xsl:call-template name="lookup-style-property-TextBlock-TopMargin">
            <xsl:with-param name="ssNode" 
              select="/v:VisioDocument/v:StyleSheets/
                      v:StyleSheet[@ID=$ssNode/@TextStyle]"/>
            <xsl:with-param name="ssProp" select="$ssProp"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="0"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="lookup-style-property-TextBlock-BottomMargin">
    <xsl:param name="ssNode"/>
    <!-- ssProp isn't really used -->
    <xsl:param name="ssProp"/>

    <xsl:for-each select="$ssNode">
      <xsl:choose>
        <xsl:when test="v:TextBlock/v:BottomMargin">
          <xsl:value-of select="v:TextBlock/v:BottomMargin"/>
        </xsl:when>
        <xsl:when test="@Master">
          <xsl:call-template
            name="lookup-style-property-TextBlock-BottomMargin">
            <xsl:with-param name="ssNode" 
              select="/v:VisioDocument/v:Masters/
                      v:Master[@ID=$ssNode/@Master]/v:Shapes/v:Shape"/>
            <xsl:with-param name="ssProp" select="$ssProp"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="@MasterShape">
          <xsl:call-template
            name="lookup-style-property-TextBlock-BottomMargin">
            <xsl:with-param name="ssNode" 
              select="/v:VisioDocument/v:Masters
                      /v:Master[@ID=$ssNode
                        /ancestor::v:Shape[@Master]/@Master]
                      //v:Shapes/v:Shape[@ID=$ssNode/@MasterShape]"/>
            <xsl:with-param name="ssProp" select="$ssProp"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="@TextStyle">
          <xsl:call-template
            name="lookup-style-property-TextBlock-BottomMargin">
            <xsl:with-param name="ssNode" 
              select="/v:VisioDocument/v:StyleSheets/
                      v:StyleSheet[@ID=$ssNode/@TextStyle]"/>
            <xsl:with-param name="ssProp" select="$ssProp"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="0"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>
