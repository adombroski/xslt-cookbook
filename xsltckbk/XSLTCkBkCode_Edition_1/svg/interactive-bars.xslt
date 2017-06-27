<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
  xmlns:svg="http://www.w3.org/2000/svg"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:svgu="http://www.ora.com/XSLTCookbook/ns/svg-utils"
  xmlns:test="http://www.ora.com/XSLTCookbook/ns/test"
  exclude-result-prefixes="svgu test">

<xsl:import href="svg-utils.xslt"/>

<xsl:output method="html"/>

<test:data>1.0</test:data> 
<test:data>2.0</test:data> 
<test:data>3.0</test:data> 
<test:data>4.0</test:data> 
<test:data>5.0</test:data> 
<test:data>13.0</test:data> 
<test:data>2.7</test:data> 
<test:data>13.9</test:data> 
<test:data>22.0</test:data> 
<test:data>8.5</test:data> 


<xsl:template match="/">
<html>
  <head>
    <title>Interactive Bar Chart</title>
    <object id="AdobeSVG" 
      classid="clsid:78156a80-c6a1-4bbf-8e6a-3cd390eeb4e2"/>
    <xsl:processing-instruction name="import">
      <xsl:text>namespace="svg" implementation="#AdobeSVG"</xsl:text>
    </xsl:processing-instruction>
<script><![CDATA[

function on_change (ID,VALUE)
{
      //Get the svg doc
	var svgDocument = document.all.item('figure').getSVGDocument();
	
	//The bars id is prefixed with the context value + _bar_ + ID
	var barName = "interact_bar_" + ID ;
	
	var barObj = svgDocument.getElementById(barName);
	if (barObj != null)
	{
	  barObj.setAttribute('y2', VALUE);
	}
	
	return true;
}

]]></script>
  </head>
  <body>
    <div align="center">
      <svg:svg width="400" height="400" id="figure">
        <xsl:call-template name="svgu:bars">
          <xsl:with-param name="data" select="document('')/*/test:data"/>
          <xsl:with-param name="width" select=" '300' "/> 
          <xsl:with-param name="height" select=" '350' "/>
          <xsl:with-param name="offsetX" select=" '50' "/>
          <xsl:with-param name="offsetY" select=" '25' "/>
          <xsl:with-param name="boundingBox" select="1"/>
          <xsl:with-param name="max" select="25"/>
          <xsl:with-param name="context" select=" 'interact' "/>
        </xsl:call-template>
      </svg:svg>
    </div>
    <table border="1" cellspacing="1" cellpadding="1">
      <tbody>
        <xsl:for-each select="document('')/*/test:data">
          <xsl:variable name="pos" select="position()"/>
          <xsl:variable name="last" select="last()"/>
          <tr>
            <td>Bar <xsl:value-of select="$pos"/></td>
            <td>
              <input type="text">
                <xsl:attribute name="value">
                  <xsl:value-of select="."/>
                </xsl:attribute> 
                <xsl:attribute name="onchange">
                  <xsl:text>on_change(</xsl:text>
                  <!-- Bars oriented upward are rotated so the ids need to be reversed. -->
                  <!-- See svgu:bars implementation for clarification. -->
                  <xsl:value-of select="$last - $pos + 1"/>
                  <xsl:text>, this.value)</xsl:text>
                </xsl:attribute>
              </input>
              </td>
          </tr>
        </xsl:for-each>
      </tbody>
    </table>    
  </body>
</html>
</xsl:template>

</xsl:stylesheet>
