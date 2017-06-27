<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="selfcontained.xsl"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:pf="http://www.ora.com/XSLTCookbook/namespaces/portfolio">

<pf:portfolio xmlns="http://www.ora.com/XSLTCookbook/namespaces/portfolio">
  <investment>
    <symbol>IBM</symbol>
    <current>72.70</current>
    <paid>65.00</paid>
    <qty>1000</qty>
  </investment>
  <investment>
    <symbol>JMAR</symbol>
    <current>1.90</current>
    <paid>5.10</paid>
    <qty>5000</qty>
  </investment>
  <investment>
    <symbol>DELL</symbol>
    <current>24.50</current>
    <paid>18.00</paid>
    <qty>100000</qty>
  </investment>
  <investment>
    <symbol>P</symbol>
    <current>57.33</current>
    <paid>63</paid>
    <qty>100</qty>
  </investment>
</pf:portfolio>
	
<xsl:output method="html" />

  <xsl:attribute-set name="gain-loss-font">
    <xsl:attribute name="color">
      <xsl:choose>
        <xsl:when test="(pf:current - pf:paid) * pf:qty >= 0">black</xsl:when>
        <xsl:otherwise>red</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:attribute-set> 	

<xsl:template match="xsl:stylesheet">
  <xsl:apply-templates select="pf:portfolio"/>
</xsl:template>

<xsl:template match="pf:portfolio">
    <html>
     <head>
      <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>
      <title>My Portfolio</title>
     </head>
    
     <body bgcolor="#FFFFFF" text="#000000">
      <h1>Portfolio</h1>
      <table border="1" cellpadding="2">
        <tbody>
          <tr>
            <th>Symbol</th>
            <th>Current</th>
            <th>Paid</th>
            <th>Qty</th>
            <th>Gain/Loss</th>
          </tr>
          <xsl:apply-templates/>
        </tbody>
      </table>
     </body>
    </html>
</xsl:template>

<xsl:template match="pf:investment">
  <tr>
    <td><xsl:value-of select="pf:symbol"/></td>
    <td><xsl:value-of select="pf:current"/></td>
    <td><xsl:value-of select="pf:paid"/></td>
    <td><xsl:value-of select="pf:qty"/></td>
    <td><font xsl:use-attribute-sets="gain-loss-font"><xsl:value-of select="format-number((pf:current - pf:paid) * pf:qty, '#,##0.00')"/></font></td>
  </tr>
</xsl:template>	

	
</xsl:stylesheet>
