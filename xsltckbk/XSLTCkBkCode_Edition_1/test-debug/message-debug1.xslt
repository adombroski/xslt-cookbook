<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="someElement[someChild = 'someValue']">
  <xsl:message>Matched someElement[someChild = 'someValue']</xsl:message>
</xsl:template>

</xsl:stylesheet>
