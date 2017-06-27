<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:ren="http://www.ora.com/namespaces/rename">

<xsl:import href="TableDrivenRename.xslt"/>
	
<xsl:variable name="lookup"  select="document('')/*[ren:*]"/>

<ren:element from="person" to="individual"/>
<ren:attribute from="firstname" to="givenname"/>
<ren:attribute from="lastname" to="surname"/>
<ren:attribute from="age" to="yearsOld"/>

</xsl:stylesheet>
