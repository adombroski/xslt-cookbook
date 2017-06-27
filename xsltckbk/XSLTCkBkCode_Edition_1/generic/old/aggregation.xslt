<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:f="http://www.ora.com/XSLTCookbook/f"
	exclude-result-prefixes="f">

	
	<xsl:variable name="aggregation-stylesheet" select="document('')"/> 
	<xsl:variable name="stylesheet" select="$aggregation-stylesheet"/> 
	
	<!-- Primitive functions on set -->	

	<f:func name="identity"/>
	<xsl:template match="f:func[@name='identity']">
		<xsl:param name="x"/>
		<xsl:value-of select="$x"/>
	</xsl:template>
	
	<f:func name="square"/>
	<xsl:template match="f:func[@name='square']">
		<xsl:param name="x"/>
		<xsl:value-of select="$x * $x"/>
	</xsl:template>


	<f:func name="cube"/>
	<xsl:template match="f:func[@name='cube']">
		<xsl:param name="x"/>
	      <xsl:message>Original One!</xsl:message>
		<xsl:value-of select="$x * $x * $x"/>
	</xsl:template>

	<f:func name="incr"/>
	<xsl:template match="f:func[@name='incr']">
		<xsl:param name="x"/>
		<xsl:value-of select="$x + 1"/>
	</xsl:template>

	<xsl:template match="f:func">
		<xsl:message terminate="yes">
			BAD FUNC! Template may not match f:func declaration.
		</xsl:message>
	</xsl:template>

	<!--Aggregation functions on Primitive -->	

	<f:aggr-func name="sum" identity="0"/>
	<xsl:template match="f:aggr-func[@name='sum']">
		<xsl:param name="a"/>
		<xsl:param name="b"/>
		<xsl:value-of select="$a + $b"/>
	</xsl:template>

	<f:aggr-func name="product" identity="1"/>
	<xsl:template match="f:aggr-func[@name='product']">
		<xsl:param name="a"/>
		<xsl:param name="b"/>
		<xsl:value-of select="$a * $b"/>
	</xsl:template>

	<f:aggr-func name="min" identity=""/>
	<xsl:template match="f:aggr-func[@name='min']">
		<xsl:param name="a"/>
		<xsl:param name="b"/>
		<xsl:choose>
			<xsl:when test="$a = ''"> 
				<xsl:value-of select="$b"/>
			</xsl:when>
			<xsl:when test="$b = '' "> 
				<xsl:value-of select="$a"/>
			</xsl:when>
			<xsl:when test="$a >= $b">
				<xsl:value-of select="$b"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$a"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<f:aggr-func name="max" identity=""/>
	<xsl:template match="f:aggr-func[@name='max']">
		<xsl:param name="a"/>
		<xsl:param name="b"/>
		<xsl:choose>
			<xsl:when test="$a=''"> 
				<xsl:value-of select="$b"/>
			</xsl:when>
			<xsl:when test="$b=''"> 
				<xsl:value-of select="$a"/>
			</xsl:when>
			<xsl:when test="$a > $b">
				<xsl:value-of select="$a"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$b"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<f:aggr-func name="avg" identity=""/>
	<xsl:template match="f:aggr-func[@name='avg']">
		<xsl:param name="a"/>
		<xsl:param name="b"/>
		<xsl:param name="i"/>
		<xsl:choose>
			<xsl:when test="$i = 1"> 
				<xsl:value-of select="$a"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="(($i - 1) * $b + $a) div $i"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="f:aggr-func">
		<xsl:message terminate="yes">
			BAD AGGR-FUNC! Template may not match f:aggr-func declaration.
		</xsl:message>
	</xsl:template>

	<!-- Predicates -->
	<f:pred name="FALSE"/>
	<xsl:template match="f:pred[@name='FALSE']">
		<xsl:message>Matched FALSE!</xsl:message>
		<xsl:value-of select="false()"/>
	</xsl:template>

	<f:pred name="less-than"/>
	<xsl:template match="f:pred[@name='less-than']">
		<xsl:param name="x"/>
		<!-- limit -->
		<xsl:param name="pred-param1"/> 
		<xsl:value-of select="$x &lt; $pred-param1"/>
	</xsl:template>

	<f:pred name="less-than-eq"/>
	<xsl:template match="f:pred[@name='less-than-eq']">
		<xsl:param name="x"/>
		<!-- limit -->
		<xsl:param name="pred-param1"/> 
		<xsl:value-of select="$x &lt;= $pred-param1"/>
	</xsl:template>

	<f:pred name="f-of-x-less-than"/>
	<xsl:template match="f:pred[@name='f-of-x-less-than']">
		<xsl:param name="x"/>
		<!-- name of f -->
		<xsl:param name="pred-param1"/> 
		<!-- limit -->
		<xsl:param name="pred-param2"/> 
		
		<xsl:variable name="f-of-x">
			<xsl:apply-templates select="$stylesheet/*/f:func[@name = $pred-param1]">
				<xsl:with-param name="x" select="$x"/>
			</xsl:apply-templates>
		</xsl:variable>
		<xsl:value-of select="$f-of-x &lt; $pred-param2"/>
	</xsl:template>

	<f:pred name="f-of-x-less-than-eq"/>
	<xsl:template match="f:pred[@name='f-of-x-less-than-eq']">
		<xsl:param name="x"/>
		<!-- name of f -->
		<xsl:param name="pred-param1"/> 
		<!-- limit -->
		<xsl:param name="pred-param2"/> 

		<xsl:variable name="f-of-x">
			<xsl:apply-templates select="$stylesheet/*/f:func[@name = $pred-param1]">
				<xsl:with-param name="x" select="$x"/>
			</xsl:apply-templates>
		</xsl:variable>
	
		<xsl:value-of select="$f-of-x &lt; $pred-param2"/>
	</xsl:template>

	<xsl:template match="f:pred">
		<xsl:message terminate="yes">
			BAD PREDICATE! Template may not match f:pred declaration.
		</xsl:message>
	</xsl:template>

<xsl:template name="aggregate-validate">
	<xsl:param name="context"/>
	<xsl:param name="func" select=" 'identity' "/>
	<xsl:param name="aggr-func" select=" 'sum' "/>
	<xsl:param name="predicate" select=" 'FALSE' "/>
	
	<xsl:choose>
		<xsl:when test="not($func)">
			<xsl:message terminate="yes">
				<xsl:text>No func in call to </xsl:text><xsl:value-of select="$context"/>. Did you forget to quote it?
			</xsl:message>
		</xsl:when>
		<xsl:when test="not($aggr-func)">
			<xsl:message terminate="yes">
				<xsl:text>No aggr-func in call to </xsl:text><xsl:value-of select="$context"/>. Did you forget to quote it?
			</xsl:message>
		</xsl:when>
		<xsl:when test="not($stylesheet/*/f:func[@name = $func])">
			<xsl:message terminate="yes">
				<xsl:text>No func called </xsl:text><xsl:value-of select="$func"/>. Did you mistype or forget to define it?
			</xsl:message>
		</xsl:when>
		<xsl:when test="not($stylesheet/*/f:aggr-func[@name = $aggr-func])">
			<xsl:message terminate="yes">
				<xsl:text>No aggr-func called </xsl:text><xsl:value-of select="$aggr-func"/> in call to <xsl:value-of select="$context"/>. Did you mistype or /get to define it?
			</xsl:message>
		</xsl:when>
		<xsl:when test="not($stylesheet/*/f:pred[@name = $predicate])">
			<xsl:message terminate="yes">
				<xsl:text>No predicate called </xsl:text><xsl:value-of select="$predicate"/> in call to <xsl:value-of select="$context"/>. Did you mistype or forget to define it?
			</xsl:message>
		</xsl:when>
	</xsl:choose>
</xsl:template>


<xsl:template name="aggregation">
	<xsl:param name="node-set"/>
	<xsl:param name="aggr-func" select=" 'sum' "/>
	<xsl:param name="func" select=" 'identity' "/>
	<xsl:param name="i" select="count($node-set)"/>

	<xsl:call-template name="aggregate-validate">
		<xsl:with-param name="context" select=" 'bounded-aggregation' "/>
		<xsl:with-param name="func" select="$func"/>
		<xsl:with-param name="aggr-func" select="$aggr-func"/>
	</xsl:call-template>

	<xsl:choose>
		<xsl:when test="$node-set">
			<!--We compute some function of the first element that produces 
    a value that we want to aggregate. The function may depend on
    the type of the element (i.e. it can be polymorphic)-->
			<xsl:variable name="first">
				<xsl:apply-templates select="$stylesheet/*/f:func[@name = $func]">
					<xsl:with-param name="x" select="$node-set[1]"/>
					<xsl:with-param name="i" select="$i"/>
				</xsl:apply-templates>
			</xsl:variable>
			<!--We recursivly process the remaining nodes using position() -->
			<xsl:variable name="rest">
				<xsl:call-template name="aggregation">
					<xsl:with-param name="node-set" select="$node-set[position()!=1]"/>
					<xsl:with-param name="aggr-func" select="$aggr-func"/>
					<xsl:with-param name="func" select="$func"/>
					<xsl:with-param name="i" select="$i - 1"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:apply-templates select="$stylesheet/*/f:aggr-func[@name = $aggr-func]">
				<xsl:with-param name="a" select="$first"/>
				<xsl:with-param name="b" select="$rest"/>
				<xsl:with-param name="i" select="$i"/>
			</xsl:apply-templates>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$stylesheet/*/f:aggr-func[@name = $aggr-func]/@identity"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="bounded-aggregation">
	<xsl:param name="from" select="0"/>
	<xsl:param name="to" select="$from"/>
	<xsl:param name="by" select=" 'incr' "/>
	<xsl:param name="aggr-func" select=" 'sum' "/>
	<xsl:param name="func" select=" 'identity' "/>

	<xsl:call-template name="aggregate-validate">
		<xsl:with-param name="context" select=" 'bounded-aggregation' "/>
		<xsl:with-param name="func" select="$func"/>
		<xsl:with-param name="aggr-func" select="$aggr-func"/>
	</xsl:call-template>

	<xsl:choose>
	  <xsl:when test="$from &lt;= $to">
	    <!--We compute some function of the first element that produces 
	    a value that we want to aggregate. The function may depend on
	    the type of the element (i.e. it can be polymorphic)-->
	    <xsl:variable name="first">
		<xsl:apply-templates select="$stylesheet/*/f:func[@name = $func]">
			<xsl:with-param name="x" select="$from"/>
		</xsl:apply-templates> 
	    </xsl:variable>
	    
	    <!--We recursivly process the remaining nodes using position() -->
	    <xsl:variable name="rest">
		<xsl:call-template name="bounded-aggregation">
		  <xsl:with-param name="from">
		  </xsl:with-param>  "/>
		  <xsl:with-param name="to"  select="$to"/>
		  <xsl:with-param name="aggr-func" select="$aggr-func"/>
		  <xsl:with-param name="func" select="$func"/>
		</xsl:call-template>
	    </xsl:variable>
		<xsl:apply-templates select="$stylesheet/*/f:aggr-func[@name = $aggr-func]">
			<xsl:with-param name="a" select="$first"/>	
			<xsl:with-param name="b" select="$rest"/>	
		</xsl:apply-templates> 
	  </xsl:when>
	  <xsl:otherwise>
	  	<xsl:value-of select="$stylesheet/*/f:aggr-func[@name = $aggr-func]/@identity"/>
	  </xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="aggregation-while">
	<xsl:param name="from" select="0"/>
	<xsl:param name="predicate" select=" 'FALSE' "/>
	<xsl:param name="pred-param1"/>
	<xsl:param name="pred-param2"/>
	<xsl:param name="aggr-func" select=" 'sum' "/>
	<xsl:param name="func" select=" 'identity' "/>

	<xsl:call-template name="aggregate-validate">
		<xsl:with-param name="context" select=" 'aggregation-while' "/>
		<xsl:with-param name="func" select="$func"/>
		<xsl:with-param name="aggr-func" select="$aggr-func"/>
		<xsl:with-param name="predicate" select="$predicate"/>
	</xsl:call-template>

	<xsl:variable name="test">
		<xsl:apply-templates select="$stylesheet/*/f:pred[@name = $predicate]">
			<xsl:with-param name="x" select="$from"/>
			<xsl:with-param name="pred-param1" select="$pred-param1"/>
			<xsl:with-param name="pred-param2" select="$pred-param2"/>
		</xsl:apply-templates> 
	</xsl:variable>
	
	<xsl:choose>
	  <xsl:when test="$test and $test != 'false'">
	    <!--We compute some function of the first element that produces 
	    a value that we want to aggregate. The function may depend on
	    the type of the element (i.e. it can be polymorphic)-->
	    <xsl:variable name="first">
		<xsl:apply-templates select="$stylesheet/*/f:func[@name = $func]">
			<xsl:with-param name="x" select="$from"/>
		</xsl:apply-templates> 
	    </xsl:variable>
	    
	    <!--We recursivly process the remaining nodes using position() -->
	    <xsl:variable name="rest">
		<xsl:call-template name="aggregation-while">
		  <xsl:with-param name="from"  select="$from + 1"/>
		  <xsl:with-param name="predicate" select="$predicate"/>
		  <xsl:with-param name="pred-param1" select="$pred-param1"/>
		  <xsl:with-param name="pred-param2" select="$pred-param2"/>
		  <xsl:with-param name="aggr-func" select="$aggr-func"/>
		  <xsl:with-param name="func" select="$func"/>
		</xsl:call-template>
	    </xsl:variable>
		<xsl:apply-templates select="$stylesheet/*/f:aggr-func[@name = $aggr-func]">
			<xsl:with-param name="a" select="$first"/>	
			<xsl:with-param name="b" select="$rest"/>	
		</xsl:apply-templates> 
	  </xsl:when>
	  <xsl:otherwise>
	  	<xsl:value-of select="$stylesheet/*/f:aggr-func[@name = $aggr-func]/@identity"/>
	  </xsl:otherwise>
	</xsl:choose>
</xsl:template>

	
</xsl:stylesheet>
