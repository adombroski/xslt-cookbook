<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" />

  <xsl:param name="message"/>

  <!--Key to locate data types by name -->
  <xsl:key name="dataTypes" match="Structure" use="Name" /> 
  <xsl:key name="dataTypes" match="Primitive" use="Name" /> 
  <xsl:key name="dataTypes" match="Array" use="Name" /> 
  <xsl:key name="dataTypes" match="Enumeration" use="Name" /> 
  
  <xsl:template match="/">
    <html>
      <head>
        <title><xsl:value-of select="$message"/> Entry</title>
      </head>
      <body bgcolor="#FFFFFF" text="#000000">
        <h1><xsl:value-of select="$message"/> Entry</h1>
        <form name="{concat($message,'Form')}" method="post" action="{concat('/cgi-bin/',$message,'Process.pl')}">
          <xsl:apply-templates select="*/Messages/Message[Name=$message]"/>
          <br/><center><input type="submit" name="Submit" value="Submit"/></center>
        </form>
      </body>
    </html>
  </xsl:template>	

  <xsl:template match="Message">
    <xsl:apply-templates select="key('dataTypes',DataTypeName)">
      <xsl:with-param name="field" select="Name"/>
    </xsl:apply-templates>
  </xsl:template>  

<xsl:template match="Structure">
  <xsl:param name="field"/>
  <table width="100%" border="0" cellspacing="1" cellpadding="1">
    <tbody>
      <xsl:for-each select="Members/Member">
        <tr>
          <td valign="top"><xsl:value-of select="Name"/></td>
          <td>
            <xsl:apply-templates select="key('dataTypes',DataTypeName)">
              <xsl:with-param name="field" select="concat($field,'_',Name)"/>
            </xsl:apply-templates>
          </td>
        </tr>
     </xsl:for-each>
    </tbody>
  </table>
</xsl:template>

<xsl:template match="*">
  <xsl:param name="field"/>
  <input type="text" name="{$field}" size="30"/>
</xsl:template>
  
</xsl:stylesheet>
