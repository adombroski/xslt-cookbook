<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:ren="http://www.ora.com/namespaces/rename">

<xsl:import href="TableDrivenRename.xslt"/>

<!-- Load the lookup table. We define it locally but it can also
 come from an external file -->	
<xsl:variable name="lookup"  select="document('')/*[ren:*]"/>

<!-- Define the renaming rules -->
<ren:attribute from="name" to="title"/>

<!--OVEVRIDE: Simply copy all names that are not attributes of position element -->
<xsl:template match="@name[not(../../position)]">
	<xsl:copy/>
</xsl:template>

</xsl:stylesheet>

