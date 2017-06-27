<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
<xsl:output method="html"/>

<xsl:template match="xi:include" xmlns:xi="http://www.w3.org/2001/XInclude">
  <xsl:for-each select="document(@href)"> 
    <xsl:apply-templates/>
  </xsl:for-each>
</xsl:template> 

<xsl:template match="salesBySalesperson">
  <html>
   <head>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>
   </head>
   <body bgcolor="#FFFFFF" text="#000000">
     <table>
      <tbody>
        <xsl:apply-templates/>
      </tbody>
    </table>
   </body>
  </html>
</xsl:template>

<xsl:template match="salesperson">
  <tr>
    <td>
      <a href="{concat('main.xml#',@name)}" target="mainFrame"><xsl:value-of select="@name"/></a>
    </td>
  </tr>
</xsl:template>
  	
</xsl:stylesheet>
