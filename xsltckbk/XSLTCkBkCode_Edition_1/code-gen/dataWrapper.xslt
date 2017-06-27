<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="text"/>
  <xsl:strip-space elements="*"/>

  <!--The message to generate data for. '*' for all -->
  <xsl:param name="message" select=" '*' "/>
  <!--The directory to generate code -->
  <xsl:param name="generationDir" select=" 'src/' "/>
  <!--The C++ header extension to use -->
  <xsl:param name="headerExt" select=" '.h' "/>
  <!--The C++ source extension to use -->
  <xsl:param name="sourceExt" select=" '.C' "/>

  <!--Key to locate data types by name -->
  <xsl:key name="dataTypes" match="Structure" use="Name" /> 
  <xsl:key name="dataTypes" match="Primitive" use="Name" /> 
  <xsl:key name="dataTypes" match="Array" use="Name" /> 
  <xsl:key name="dataTypes" match="Enumeration" use="Name" /> 
  

  <!-- Top level template determines which messages to process -->
  <xsl:template match="/">
    <xsl:choose>
        <xsl:when test="$message = '*'">
          <xsl:apply-templates select="*/Messages/*"/>
        </xsl:when>
        <xsl:when test="*/Messages/Message[Name=$message]">
          <xsl:apply-templates select="*/Messages/Message[Name=$message]"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:message terminate="yes">No such message name [<xsl:value-of select="$message"/>]</xsl:message>
        </xsl:otherwise>
      </xsl:choose>
  </xsl:template>

<!-- If the messages data type is contained in the repository then gnerate data wrapper header and source file for it -->
<xsl:template match="Message">
  <xsl:choose>
    <xsl:when test="key('dataTypes',DataTypeName)">
      <xsl:apply-templates select="key('dataTypes',DataTypeName)" mode="header"/>
      <xsl:apply-templates select="key('dataTypes',DataTypeName)" mode="source"/>
    </xsl:when>
    <xsl:otherwise>
            <xsl:message>Message name [<xsl:value-of select="Name"/>] uses data [<xsl:value-of select="DataTypeName"/>] that is not defined in the repository.</xsl:message>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>	

<!-- We only generate headers if a messages data type is a Stucture. 
The only other typical message data type is XML. We don't generate wrappers for XML payloads.-->
<xsl:template match="Structure" mode="header">
<xsl:document href="{concat($generationDir,Name,$headerExt)}">
#include &lt;primitives/primitives.h&gt;

class <xsl:value-of select="Name"/>
{
public:<xsl:text>&#xa;&#xa;</xsl:text>
  <xsl:for-each select="Members/Member">
    <xsl:text>    </xsl:text>
    <xsl:apply-templates select="key('dataTypes',DataTypeName)" mode="returnType"/> get_<xsl:value-of select="Name"/>() const ;<xsl:text/>
    <xsl:text>&#xa;</xsl:text>
   </xsl:for-each>
<xsl:text>&#xa;</xsl:text>
private:<xsl:text>&#xa;&#xa;</xsl:text>
  <xsl:for-each select="Members/Member">
    <xsl:text>    </xsl:text>
    <xsl:apply-templates select="key('dataTypes',DataTypeName)" mode="data"/>  m_<xsl:value-of select="Name"/> ;<xsl:text/>
    <xsl:text>&#xa;</xsl:text>
  </xsl:for-each>
} ;
</xsl:document>
</xsl:template>

<!-- We only generate source if a messages data type is a Stucture. -->
<!-- The only other typical message data type is XML. We don't          -->
<!-- generate wrappers for XML payloads.                                          -->
<xsl:template match="Structure" mode="source">
<xsl:document href="{concat($generationDir,Name,$sourceExt)}">
#include "<xsl:value-of select="Name"/><xsl:value-of select="$headerExt"/>"

<xsl:text/>

  <xsl:for-each select="Members/Member">
    <xsl:apply-templates select="key('dataTypes',DataTypeName)" mode="returnType"/><xsl:text>  </xsl:text>
    <xsl:value-of select="../../Name"/>::get_<xsl:value-of select="Name"/>() const<xsl:text>&#xa;</xsl:text>
    <xsl:text>{&#xa;</xsl:text>
    <xsl:text>    return m_</xsl:text><xsl:value-of select="Name"/><xsl:text>;&#xa;</xsl:text>
    <xsl:text>}&#xa;&#xa;</xsl:text>
   </xsl:for-each>
   
</xsl:document>
</xsl:template>

<!-- We assume members that are themselves structures are returned by reference. -->
<xsl:template match="Structure" mode="returnType">
const <xsl:value-of select="Name"/>&amp;<xsl:text/>
</xsl:template>

<!-- We map primitives that can be represented by native C++ types to those native types. -->
<!-- Otherwise we assume the primitive is externally defined. -->
<xsl:template match="Primitive" mode="returnType">
  <xsl:choose>
    <xsl:when test="Name='Integer' ">int</xsl:when>
    <xsl:when test="Name='Real' ">double</xsl:when>
    <xsl:otherwise><xsl:value-of select="Name"/></xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="*" mode="returnType">
<xsl:value-of select="Name"/>
</xsl:template>

<xsl:template match="Primitive" mode="data">
  <xsl:choose>
    <xsl:when test="Name='Integer' ">int</xsl:when>
    <xsl:when test="Name='Real' ">double</xsl:when>
    <xsl:otherwise><xsl:value-of select="Name"/></xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="*" mode="data">
<xsl:value-of select="Name"/>
</xsl:template>

</xsl:stylesheet>
