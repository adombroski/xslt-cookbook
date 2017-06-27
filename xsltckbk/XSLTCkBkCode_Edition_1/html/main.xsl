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
     <xsl:apply-templates/>
     </body>
    </html>
</xsl:template>

<xsl:template match="salesperson">
     <h1><a name="{@name}"><center>Sales By Salesperson</center></a></h1>
      <h2><xsl:value-of select="@name"/></h2>
      <table border="1" cellpadding="3">
        <tbody >
          <tr>
            <th>SKU</th>
            <th>Sales (in US $)</th>
          </tr>
          <xsl:apply-templates />
        </tbody>
      </table>
      <div style="padding-top:1000"/>
</xsl:template>

<xsl:template match="product">
    <tr>
      <td><xsl:value-of select="@sku"/></td>
      <td align="right"><xsl:value-of select="@totalSales"/></td>
    </tr>
    
</xsl:template>

  	
	
</xsl:stylesheet>
