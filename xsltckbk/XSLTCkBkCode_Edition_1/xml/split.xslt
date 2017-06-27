<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:saxon="http://icl.com/saxon">

<xsl:import href="copy.xslt"/>

<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
<xsl:strip-space elements="*"/>
	
<xsl:template match="salesperson">
  <xsl:variable name="outFile" select="concat('salesperson.',translate(@name,' ','_'),'.xml')"/>        
  <xsl:document href="{$outFile}">	<!-- Non-standard xsl: saxon:document! -->
  	<xsl:copy>
  	       <xsl:copy-of select="@*"/>
  		<xsl:apply-templates/>
  	</xsl:copy>
  </xsl:document>
</xsl:template>	

<xsl:template match="salesBySalesperson">
  <xsl:apply-templates/>
</xsl:template>

</xsl:stylesheet>
