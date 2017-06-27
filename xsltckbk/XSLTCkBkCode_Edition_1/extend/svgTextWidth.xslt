<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	
<xsl:template match="/">
  <svg width="300" height="300">
   <rect x="1" y="1" height="14pt" width="200"/>
   <text x="2" y="2" style="font-size: 12pt; font-family:Serif">The rain in Spain falls mainly in the plain</text>
  </svg>
</xsl:template>
</xsl:stylesheet>
