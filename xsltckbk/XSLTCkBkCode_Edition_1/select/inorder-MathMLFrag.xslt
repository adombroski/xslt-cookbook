<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
						xmlns:C="http:www.oreilly.com/TheXSLTCoobook/nampespaces/C">
	<xsl:output method="text"/>
	<xsl:strip-space elements="*"/>

	<!-- Table to convert from MathML operation names to C operators -->
	<C:operator mathML="plus" c="+" precedence="2"/>
	<C:operator mathML="minus" c="-" precedence="2"/>
	<C:operator mathML="times" c="*" precedence="3"/>
	<C:operator mathML="div" c="/" precedence="3"/>
	<C:operator mathML="mod" c="%" precedence="3"/>
	<C:operator mathML="eq" c="==" precedence="1"/>
	
	<!-- load operation conversion table into a variable -->			
	<xsl:variable name="ops" select="document('')/*/C:operator"/>
		
	<xsl:template match="apply"> 
		<xsl:param name="parent-precedence" select="0"/>
		
		<!-- Map mathML operation to operator name and precedence -->
		<xsl:variable name="mathML-opName" select="local-name(*[1])"/>
		<xsl:variable name="c-opName" select="$ops[@mathML=$mathML-opName]/@c"/>
		<xsl:variable name="c-opPrecedence" select="$ops[@mathML=$mathML-opName]/@precedence"/>
		
		<!-- Parenthises required if if the precedence of the containing expression is greater than current sub-expression -->
		<xsl:if test="$parent-precedence > $c-opPrecedence"><xsl:text>(</xsl:text></xsl:if>

		<!-- Recursively process the left sub-tree which is at position 2 in MathML apply element-->		
		<xsl:apply-templates select="*[2]">
			<xsl:with-param name="parent-precedence" select="$c-opPrecedence"/>
		</xsl:apply-templates>
		
		<!-- Process the current node (i.e. the operator at position 1 in MathML apply element -->
		<xsl:value-of select="concat(' ',$c-opName,' ')"/>
		
		<!-- Recursively process middle children -->
		<xsl:for-each select="*[position()>2 and position() &lt; last()]">
			<xsl:apply-templates select=".">
				<xsl:with-param name="parent-precedence" select="$c-opPrecedence"/>
			</xsl:apply-templates>
			<xsl:value-of select="concat(' ',$c-opName,' ')"/>
		</xsl:for-each>
		
		<!-- Recursively process right subtree-->
		<xsl:apply-templates select="*[last()]">
			<xsl:with-param name="parent-precedence" select="$c-opPrecedence"/>
		</xsl:apply-templates>

		<!-- Parenthises required if if the precedence of the containing expression is greater than current sub-expression -->
		<xsl:if test="$parent-precedence > $c-opPrecedence"><xsl:text>)</xsl:text></xsl:if>
		
	</xsl:template>	

	<xsl:template match="ci|cn">
		<xsl:value-of select="."/>
	</xsl:template>

</xsl:stylesheet>
