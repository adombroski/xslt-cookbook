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

  <xi:include href="{$outFile}" xmlns:xi="http://www.w3.org/2001/XInclude"/>

<!--
  <xsl:element name="xi:include" namespace="http://www.w3.org/2001/XInclude" xmlns:xi="http://www.w3.org/2001/XInclude">
    <xsl:attribute name="href">
      <xsl:value-of select="$outFile"/>
    </xsl:attribute> 
  </xsl:element>
-->
  
</xsl:template>	

</xsl:stylesheet>
