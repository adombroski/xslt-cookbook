<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:f="http://www.ora.com/XSLTCookbook/f"
	exclude-result-prefixes="f">


<xsl:import href="aggregation.xslt"/>
<xsl:variable name="stylesheet" select="document('') | $aggregation-stylesheet"/>

	
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

<!-- Extend the primitives -->
<f:func name="commision"/>
<xsl:template match="f:func[@name='commision']">
	<xsl:param name="x"/>
	<xsl:apply-templates select="$x" mode="commision"/>
</xsl:template>

<f:func name="cube"/>
<xsl:template match="f:func[@name='cube']">
	<xsl:param name="x"/>
	<xsl:message>New One!</xsl:message>
	<xsl:value-of select="$x * $x * $x"/>
</xsl:template>


<!-- By default salespeople get 2% commsison and no base salary -->
<xsl:template match="salesperson" mode="commision">
	<xsl:value-of select="0.02 * sum(product/@totalSales)"/>
</xsl:template>

<!-- salespeople with seniority > 4 get $10000.00 base + 0.5% commsison -->
<xsl:template match="salesperson[@seniority > 4]" mode="commision" priority="1">
	<xsl:value-of select="10000.00 + 0.05 * sum(product/@totalSales)"/>
</xsl:template>

<!-- salespeople with seniority > 8 get (seniority * $2000.00) base + 0.8% commsison -->
<xsl:template match="salesperson[@seniority > 8]" mode="commision" priority="2">
	<xsl:value-of select="@seniority * 2000.00 + 0.08 * 
		sum(product/@totalSales)"/>
</xsl:template>

<xsl:template match="salesBySalesperson">
	<results>

		<result>
		<xsl:text>Total commision = </xsl:text>
		<xsl:call-template name="aggregation">
			<xsl:with-param name="aggr-func" select=" 'sum' "/>
			<xsl:with-param name="func" select=" 'commision' "/>
			<xsl:with-param name="node-set" select="*"/>
		</xsl:call-template>
		</result>
		<result>
		<xsl:text>Min commision = </xsl:text>
		<xsl:call-template name="aggregation">
			<xsl:with-param name="aggr-func" select=" 'min' "/>
			<xsl:with-param name="func" select=" 'commision' "/>
			<xsl:with-param name="node-set" select="*"/>
		</xsl:call-template>
		</result>

		<result>
		<xsl:text>Max commision = </xsl:text>
		<xsl:call-template name="aggregation">
			<xsl:with-param name="aggr-func" select=" 'max' "/>
			<xsl:with-param name="func" select=" 'commision' "/>
			<xsl:with-param name="node-set" select="*"/>
		</xsl:call-template>
		</result>

		<result>
		<xsl:text>Avg commision = </xsl:text>
		<xsl:call-template name="aggregation">
			<xsl:with-param name="aggr-func" select=" 'avg' "/>
			<xsl:with-param name="func" select=" 'commision' "/>
			<xsl:with-param name="node-set" select="*"/>
		</xsl:call-template>
		</result>

		<result>
		<xsl:text>Avg sales = </xsl:text>
		<xsl:call-template name="aggregation">
			<xsl:with-param name="aggr-func" select=" 'avg' "/>
			<xsl:with-param name="func" select=" 'commision' "/>
			<xsl:with-param name="node-set" select="//product/@totalSales"/>
		</xsl:call-template>
		</result>
		
		<result>
		<xsl:text>Square of sales = </xsl:text>
		<xsl:call-template name="aggregation">
			<xsl:with-param name="aggr-func" select=" 'sum' "/>
			<xsl:with-param name="func" select=" 'square' "/>
			<xsl:with-param name="node-set" select="//product/@totalSales"/>
		</xsl:call-template>
		</result>

		<result>
		<xsl:text>Min sales = </xsl:text>
		<xsl:call-template name="aggregation">
			<xsl:with-param name="aggr-func" select=" 'min' "/>
			<xsl:with-param name="func" select=" 'identity' "/>
			<xsl:with-param name="node-set" select="//product/@totalSales"/>
		</xsl:call-template>
		</result>

		<result>
		<xsl:text>Max sales = </xsl:text>
		<xsl:call-template name="aggregation">
			<xsl:with-param name="aggr-func" select=" 'max' "/>
			<xsl:with-param name="func" select=" 'identity' "/>
			<xsl:with-param name="node-set" select="//product/@totalSales"/>
		</xsl:call-template>
		</result>

		<result>
		<xsl:text>Factorial = </xsl:text>
		<xsl:call-template name="bounded-aggregation">
			<xsl:with-param name="aggr-func" select=" 'product' "/>
			<xsl:with-param name="func" select=" 'identity' "/>
			<xsl:with-param name="from" select="1"/>
			<xsl:with-param name="to" select="4"/>
		</xsl:call-template>
		</result>

		<result>
		<xsl:text>Sum x cubed (while x &lt;= 20) = </xsl:text>
		<xsl:call-template name="aggregation-while">
			<xsl:with-param name="aggr-func" select=" 'sum' "/>
			<xsl:with-param name="func" select=" 'cube' "/>
			<xsl:with-param name="from" select="1"/>
			<xsl:with-param name="predicate" select=" 'less-than-eq' "/> 
			<xsl:with-param name="pred-param1" select="20"/>
		</xsl:call-template>
		</result>

		<result>
		<xsl:text>Sum x cubed (while x squared &lt;= 200) = </xsl:text>
		<xsl:call-template name="aggregation-while">
			<xsl:with-param name="aggr-func" select=" 'sum' "/>
			<xsl:with-param name="func" select=" 'cube' "/>
			<xsl:with-param name="from" select="1"/>
			<xsl:with-param name="predicate" select=" 'f-of-x-less-than-eq' "/>
			<xsl:with-param name="pred-param1" select=" 'square' "/>
			<xsl:with-param name="pred-param2" select="200"/>
		</xsl:call-template>
		</result>

		<result>
		<xsl:text>Sum x cubed (while x squared &lt;= 200) = </xsl:text>
		<xsl:call-template name="aggregation-while">
			<xsl:with-param name="aggr-func" select=" 'sum' "/>
			<xsl:with-param name="func" select=" 'cube' "/>
			<xsl:with-param name="from" select="1"/>
			<xsl:with-param name="predicate" select=" 'f-of-x-less-than-eq' "/>
			<xsl:with-param name="pred-param1" select=" 'square' "/>
			<xsl:with-param name="pred-param2" select="200"/>
		</xsl:call-template>
		</result>
	</results>
</xsl:template>
	
</xsl:stylesheet>
