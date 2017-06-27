<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:date="http://exslt.org/dates-and-times">

<xsl:output method="html" version="1.0" encoding="UTF-8" indent="yes"/>

<xsl:template match="/">
  <html>
    <head><title>My Dull Home Page</title></head>
    <body>
      <h1>My Dull Homepage</h1>
      <div class="date">It's <xsl:value-of select="date:time()"/> on <xsl:value-of select="date:date()"/> and this page is as dull as it was yesterday.</div>
    </body>
  </html>

</xsl:template>
	
</xsl:stylesheet>
