<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="html"/>

<xsl:param name="URL"/>

<xsl:template match="/">
  <xsl:apply-templates select="*" mode="frameset"/>
  <xsl:apply-templates select="*" mode="salespeople_frame"/>
  <xsl:apply-templates select="*" mode="sales_frames"/>
</xsl:template>

<!-- ============================================================== -->
<!--              Create frameset container (mode ="frameset")                                      -->
<!-- ============================================================== -->
<xsl:template match="salesBySalesperson" mode="frameset">
  <!-- Non-standard xsl: saxon:document! -->
  <xsl:document href="index.html">	
    <html>
     <head>
      <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>
     </head>
     <frameset rows="100%" cols="25%, 75%" border="0">
       <frame name="salespeople" src="salespeople_frame.html" noresize=""/>
       <frame name="mainFrame" src="default_sales.html" noresize=""/>
     </frameset>
     <body bgcolor="#FFFFFF" text="#000000">
     </body>
    </html>
  </xsl:document>
</xsl:template>


<!-- ============================================================== -->
<!--              Create salespeople_frame.html  (mode = "salespeople_frame")            -->
<!-- ============================================================== -->
<xsl:template match="salesBySalesperson" mode="salespeople_frame">
  <!-- Non-standard xsl: saxon:document! -->
  <xsl:document href="salespeople_frame.html">	
    <html>
     <head>
      <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>
     </head>
     <body bgcolor="#FFFFFF" text="#000000">
       <table>
        <tbody>
          <xsl:apply-templates mode="index"/>
        </tbody>
      </table>
     </body>
    </html>
  </xsl:document>
</xsl:template>

<xsl:template match="salesperson" mode="index">
  <tr>
    <td>
      <a href="{concat(@name,'.html')}" target="mainFrame"><xsl:value-of select="@name"/></a>
    </td>
  </tr>
</xsl:template>

<!-- ============================================================== -->
<!--                           Create @name.html  (mode = "content")                                    -->
<!-- ============================================================== -->


<xsl:template match="salesperson" mode="sales_frames">

  <xsl:document href="default_sales.html">	
    <html>
     <head>
      <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>
     </head>
    
     <body bgcolor="#FFFFFF" text="#000000">
     <h1><center>Sales By Salesperson</center></h1>
	 <br/>
     Click on a salesperson on the left to load his or her sales figures.
     </body>
    </html>
  </xsl:document>

  <xsl:document href="{concat(@name,'.html')}">	
    <html>
     <head>
      <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>
     </head>
    
     <body bgcolor="#FFFFFF" text="#000000">
     <h1><center>Sales By Salesperson</center></h1>
      <h2><xsl:value-of select="@name"/></h2>
      <table border="1" cellpadding="3">
        <tbody >
          <tr>
            <th>SKU</th>
            <th>Sales (in US $)</th>
          </tr>
          <xsl:apply-templates mode="content"/>
        </tbody>
      </table>
     </body>
    </html>
  </xsl:document>
</xsl:template>

<xsl:template match="product" mode="content">
    <tr>
      <td><xsl:value-of select="@sku"/></td>
      <td align="right"><xsl:value-of select="@totalSales"/></td>
    </tr>
    
</xsl:template>

</xsl:stylesheet>
