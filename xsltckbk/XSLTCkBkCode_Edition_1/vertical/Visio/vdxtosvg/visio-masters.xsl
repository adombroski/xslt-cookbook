<?xml version='1.0'?>
<!-- $Id: visio-masters.xsl,v 1.10 2002/06/23 02:06:03 jabreen Exp $ -->
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
     special Master elements to SVG.  In most cases, these masters
     are specifically used to represent SVG elements, like 'animate'.

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

  <!-- This variable lists the masters that are implemented here, so
       that the general Shape template can easily decide what to do -->
  <xsl:variable name="specialMasters"
    select="concat(
            'animate ',
            'animateMotion ',
            'viewBox ')"/>
  
  <!-- This template determines which template to call to handle this
       master.  It's just a brute-force 'choose' element -->
  <xsl:template name="choose-special-master">
    <xsl:param name="master"/>
    <xsl:param name="masterElement"/>
    <!-- <xsl:message>
      <xsl:value-of select="concat(':',$masterElement)"/>
    </xsl:message> -->
    <xsl:choose>
      <xsl:when test="$masterElement='animate'">
        <xsl:call-template name="animate-master">
          <xsl:with-param name="master" select="$master"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$masterElement='animateMotion'">
        <xsl:call-template name="animateMotion-master">
          <xsl:with-param name="master" select="$master"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="not(contains($specialMasters, $masterElement))">
          <xsl:message>
            <xsl:value-of
              select="concat('Master ', $master/@ID,
                      ' is not a special master')"/>
          </xsl:message>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- This template creates an attribute from the given Connect element -->
  <!-- Notes:
           FromSheet: the ID of the connector (line) Shape element
           FromCell: BeginX or EndX
           FromPart: ?
           ToSheet: the ID of the shape that this end is connected to
           ToCell: Connector on ToSheet (?) (plus 1?)
           ToPart: ? (always seems to be 100)
       Call with something like:
           apply-templates select="v:Connect[@ToSheet=current()/@ID
                                             and @FromCell='BeginX']"
       -->
  <xsl:template match="v:Connect">
    <!-- Set up all the references we need -->
    <xsl:variable name="connectEnd"
      select="../v:Connect[@FromSheet=current()/@FromSheet
              and @FromCell='EndX']"/>
    <xsl:variable name="arc"
      select="$Page/v:Shapes//v:Shape[@ID=current()/@FromSheet]"/>
    <xsl:variable name="src"
      select="$Page/v:Shapes//v:Shape[@ID=current()/@ToSheet]"/>
    <xsl:variable name="dest"
      select="$Page/v:Shapes//v:Shape[@ID=$connectEnd/@ToSheet]"/>
    <xsl:variable name="destMaster"
      select="/v:VisioDocument//v:Masters[1]
              /v:Master[@ID=$dest/@Master]
              //v:Prop/v:Label[.='svgElement']/../v:Value"/>
    <!-- Find the name of the attribute -->
    <xsl:variable name="attributeName">
      <xsl:choose>
        <xsl:when test="$arc/v:Prop[v:Label='svgAttribute']">
          <xsl:value-of
            select="$arc/v:Prop/v:Value[../v:Label='svgAttribute']"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="'xlink:href'"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <!-- Find the value of the attribute (this may depend on the name,
         the destination, etc.) -->
    <xsl:variable name="attributeValue">
      <xsl:choose>
        <xsl:when test="$attributeName = 'xlink:href'">
          <!-- xlink:href -->
          <xsl:choose>
            <xsl:when test="$dest/@NameU">
              <xsl:value-of select="concat('#', $dest/@NameU)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="concat('#', generate-id($dest))"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="$destMaster = 'viewBox'">
          <!-- viewBox -->
          <xsl:value-of select="concat($dest/v:XForm/v:PinX*$userScale,
                                ' ', -$dest/v:XForm/v:PinY*$userScale,
                                ' ', $dest/v:XForm/v:Width*$userScale,
                                ' ', $dest/v:XForm/v:Height*$userScale)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="$dest/@NameU">
              <xsl:value-of select="concat($dest/@NameU, '')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="concat(generate-id($dest), '')"/>
            </xsl:otherwise>
          </xsl:choose>
          
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="not(starts-with($attributeName, 'begin')) and
                  not(starts-with($attributeName, 'end')) and
                  not(starts-with($attributeName, 'mpath'))">
      <!--
      <xsl:message>
        <xsl:value-of select="concat($attributeName,' = ',$attributeValue)"/>
      </xsl:message>
      -->
      <xsl:attribute name="{$attributeName}">
        <xsl:value-of select="$attributeValue"/>
      </xsl:attribute>
    </xsl:if>
  </xsl:template>

  <!-- This template returns the ID of the element at the connectEnd
       of $connect (a Connect node).  If $master is given (a string),
       the ID is only returned if the element's master's svgElement
       property matches $master. -->
  <xsl:template name="getDestId">
    <xsl:param name="connect"/>
    <xsl:param name="master"/>
    <xsl:variable name="connectEnd"
      select="$connect/../v:Connect[@FromSheet=$connect/@FromSheet
              and @FromCell='EndX']"/>
    <xsl:variable name="arc"
      select="$Page/v:Shapes//v:Shape[@ID=$connect/@FromSheet]"/>
    <xsl:variable name="dest"
      select="$Page/v:Shapes//v:Shape[@ID=$connectEnd/@ToSheet]"/>
    <xsl:variable name="destMaster"
      select="/v:VisioDocument//v:Masters[1]
              /v:Master[@ID=$dest/@Master]
              //v:Prop/v:Label[.='svgElement']/../v:Value"/>
    <xsl:if test="not($master) or
                  ($destMaster and contains($master, $destMaster))">
      <xsl:choose>
        <xsl:when test="$dest/@NameU">
          <xsl:value-of select="$dest/@NameU"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="generate-id($dest)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <!-- This template returns a list of values, determined either from
       the property on the current element, or connections from the
       current element to other elements.  The main use of this is the
       'begin' and 'end' attributes in animation. -->
  <xsl:template name="getListValue">
    <xsl:param name="attr"/>
    <xsl:param name="master"/>
    <xsl:variable name="listValue">
      <xsl:for-each
        select="$master/v:Shapes//v:Prop[v:Label=concat('@', $attr)]">
        <xsl:if test="not(./v:Value/@F = 'No Formula')
                      and not(./v:Value/@F = 'Inh')
                      and (./v:Value != '')
                      and (./v:Value != '&#xe000;')">
          <xsl:value-of select="./v:Value"/>
          <xsl:text>;</xsl:text>
        </xsl:if>
      </xsl:for-each>
      <xsl:for-each
        select="$Page/v:Connects/v:Connect[@ToSheet=current()/@ID
                and @FromCell='BeginX']">
        <xsl:variable name="connAttribute"
          select="$Page/v:Shapes//v:Shape[@ID=current()
                  /@FromSheet]/v:Prop[v:Label='svgAttribute']/v:Value"/>
        <xsl:if test="starts-with($connAttribute, $attr)">
          <xsl:variable name="id">
            <xsl:call-template name="getDestId">
              <xsl:with-param name="connect" select="."/>
              <xsl:with-param name="master" select="'animate animateMotion'"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:if test="$id != ''">
            <xsl:value-of select="$id"/>
            <xsl:value-of select="substring-after($connAttribute,
                                  concat($attr, ':'))"/>
            <xsl:text>;</xsl:text>
          </xsl:if>
        </xsl:if>
      </xsl:for-each>
    </xsl:variable>
    <xsl:if test="$listValue != ';'">
      <xsl:value-of select="substring($listValue, 1,
                            string-length($listValue) - 1)"/>
    </xsl:if>
  </xsl:template>

  <!-- ============= Masters ============================================== -->

  <!-- animate -->
  <xsl:template name="animate-master">
    <xsl:param name="master"/>
    <xsl:message>
      <xsl:text>Found 'animate' master...</xsl:text>
    </xsl:message>
    <xsl:element name="animate">
      <xsl:call-template name="setIdAttribute"/>
      <!-- Find attributes 
           Since @begin and @end can be lists, they have to be handled
           separately. -->
      <!-- @begin -->
      <xsl:variable name="beginValue">
        <xsl:call-template name="getListValue">
          <xsl:with-param name="attr" select="begin"/>
          <xsl:with-param name="master" select="$master"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:if test="$beginValue != ''">
        <xsl:attribute name="begin">
          <xsl:value-of select="$beginValue"/>
        </xsl:attribute>
      </xsl:if>
      <!-- @end -->
      <!-- Master properties -->
      <xsl:for-each
        select="$master/v:Shapes//v:Prop[starts-with(v:Label, '@')]">
        <!-- I have no idea what this &#xe000; character is, but it seems
             to pop up as the default property value a lot -->
        <xsl:if test="not(./v:Value/@F = 'No Formula')
                      and not(./v:Value/@F = 'Inh')
                      and (./v:Value != '')
                      and (./v:Value != '&#xe000;')
                      and not(./v:Label = 'begin')
                      and not(./v:Label = 'end')">
          <xsl:attribute name="{substring(./v:Label, 2)}">
            <xsl:value-of select="./v:Value"/>
          </xsl:attribute>
        </xsl:if>
      </xsl:for-each>
      <!-- Instance properties -->
      <xsl:for-each select="./v:Prop[starts-with(v:Label, '@')]">
        <xsl:if test="not(./v:Value/@F = 'No Formula')
                      and not(./v:Value/@F = 'Inh')
                      and (./v:Value != '')
                      and (./v:Value != '&#xe000;')
                      and not(./v:Label = 'begin')
                      and not(./v:Label = 'end')">
          <!-- <xsl:message>
            <xsl:value-of select="concat('@', ./v:Label)"/>
          </xsl:message> -->
          <xsl:attribute name="{substring(./v:Label, 2)}">
            <xsl:value-of select="./v:Value"/>
          </xsl:attribute>
        </xsl:if>
      </xsl:for-each>
      <!-- Connectors -->
      <xsl:for-each
        select="$Page/v:Connects/v:Connect[@ToSheet=current()/@ID
                and @FromCell='BeginX']">
        <xsl:apply-templates select="."/>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>

  <!-- animateMotion -->
  <xsl:template name="animateMotion-master">
    <xsl:param name="master"/>
    <xsl:message>
      <xsl:text>Found 'animateMotion' master...</xsl:text>
    </xsl:message>
    <xsl:element name="animateMotion">
      <xsl:call-template name="setIdAttribute"/>
      <!-- Find attributes 
           Since @begin and @end can be lists, they have to be handled
           separately. -->
      <!-- @begin -->
      <xsl:variable name="beginValue">
        <xsl:call-template name="getListValue">
          <xsl:with-param name="attr" select="begin"/>
          <xsl:with-param name="master" select="$master"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:if test="$beginValue != ''">
        <xsl:attribute name="begin">
          <xsl:value-of select="$beginValue"/>
        </xsl:attribute>
      </xsl:if>
      <!-- @end -->
      <!-- Master properties -->
      <xsl:for-each
        select="$master/v:Shapes//v:Prop[starts-with(v:Label, '@')]">
        <xsl:if test="not(./v:Value/@F = 'No Formula')
                      and not(./v:Value/@F = 'Inh')
                      and (./v:Value != '')
                      and (./v:Value != '&#xe000;')
                      and not(./v:Label = 'begin')
                      and not(./v:Label = 'end')
                      and not(./v:Label = 'mpath')">
          <xsl:attribute name="{substring(./v:Label, 2)}">
            <xsl:value-of select="./v:Value"/>
          </xsl:attribute>
        </xsl:if>
      </xsl:for-each>
      <!-- Instance properties -->
      <xsl:for-each select=".//v:Prop[starts-with(v:Label, '@')]">
        <xsl:if test="not(./v:Value/@F = 'No Formula')
                      and not(./v:Value/@F = 'Inh')
                      and (./v:Value != '')
                      and (./v:Value != '&#xe000;')
                      and not(./v:Label = 'begin')
                      and not(./v:Label = 'end')
                      and not(./v:Label = 'mpath')">
          <xsl:attribute name="{substring(./v:Label, 2)}">
            <xsl:value-of select="./v:Value"/>
          </xsl:attribute>
        </xsl:if>
      </xsl:for-each>
      <!-- Connectors -->
      <xsl:for-each
        select="$Page/v:Connects/v:Connect[@ToSheet=current()/@ID
                and @FromCell='BeginX']">
        <xsl:apply-templates select="."/>
      </xsl:for-each>
      <!-- mpath is a subelement, so it has to be added after the
           attributes -->
      <xsl:for-each
        select="$Page/v:Connects/v:Connect[@ToSheet=current()/@ID
                and @FromCell='BeginX']">
        <xsl:variable name="connAttribute"
          select="$Page/v:Shapes//v:Shape[@ID=current()
                  /@FromSheet]/v:Prop[v:Label='svgAttribute']/v:Value"/>
        <xsl:if test="starts-with($connAttribute, 'mpath')">
          <xsl:variable name="id">
            <xsl:call-template name="getDestId">
              <xsl:with-param name="connect" select="."/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:if test="$id != ''">
            <mpath>
              <xsl:attribute name="xlink:href">
                <xsl:value-of select="concat('#path-', $id)"/>
                <xsl:value-of select="substring-after($connAttribute,
                                      'mlink:')"/>
              </xsl:attribute>
            </mpath>
          </xsl:if>
        </xsl:if>
      </xsl:for-each>

    </xsl:element>
  </xsl:template>

</xsl:stylesheet>