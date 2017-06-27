<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE stylesheet [
	<!ENTITY ATextNode "<xsl:text>
	This is some
	text
	seperated
	by newlines.
	</xsl:text>">

	<!ENTITY External SYSTEM "copyright.xml">
	<!ENTITY lookup SYSTEM "lookup-table.xml">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:include href="lookup-table.xml"/>

	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

	<xsl:template match="/">

<foo>
	&ATextNode;
	&External;
</foo>
	
	</xsl:template>
	
</xsl:stylesheet>
