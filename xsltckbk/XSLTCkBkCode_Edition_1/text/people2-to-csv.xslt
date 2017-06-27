<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:csv="http://www.ora.com/XSLTCookbook/namespaces/csv">

<xsl:import href="generic-elem-to-csv.xslt"/>

<!--Defines the mapping from attributes to columns -->
<xsl:variable name="columns" select="document('')/*/csv:column"/>

<csv:column name="Name" elem="name"/>
<csv:column name="Age" elem="age"/>
<csv:column name="Gender" elem="sex"/>
<csv:column name="Smoker" elem="smoker"/>

</xsl:stylesheet>
