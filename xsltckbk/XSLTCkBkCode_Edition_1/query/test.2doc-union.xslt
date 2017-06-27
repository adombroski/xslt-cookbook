<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	
<xsl:template match="/">
  <people>
    <xsl:copy-of select="//person | document('people2.xml')//person"/>
  </people>
</xsl:template>

</xsl:stylesheet>
