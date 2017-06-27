<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:import href="copy.xslt"/>

<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no" omit-xml-declaration="yes"/>
<!-- List books published by Addison-Wesley after 1991, including their year and title.  -->
	
<xsl:template match="book[publisher = 'Addison-Wesley' and @year > 1991]">
  <xsl:copy-of select="."/>
</xsl:template>

<xsl:template match="book"/>
	
</xsl:stylesheet>
