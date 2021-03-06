<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:generic="http://www.ora.com/XSLTCookbook/namespaces/generic"
  xmlns:exslt="http://exslt.org/common"
  extension-element-prefixes="exslt" exclude-result-prefixes="generic">

  <xsl:variable name="generic:public-generics" 
  			select="document('')/*/generic:*"/> 
  
  <xsl:variable name="generic:generics" select="$generic:public-generics"/>
  
  
  <!-- Primitive generic functions on x -->	
  
  <generic:func name="identity"/>
  <xsl:template match="generic:func[@name='identity']">
  	<xsl:param name="x"/>
  	<xsl:value-of select="$x"/>
  </xsl:template>
  
  <generic:func name="square"/>
  <xsl:template match="generic:func[@name='square']">
  	<xsl:param name="x"/>
  	<xsl:value-of select="$x * $x"/>
  </xsl:template>
  
  <generic:func name="cube"/>
  <xsl:template match="generic:func[@name='cube']">
  	<xsl:param name="x"/>
  	<xsl:value-of select="$x * $x * $x"/>
  </xsl:template>
  
  <generic:func name="incr" param1="1"/>
  <xsl:template match="generic:func[@name='incr']">
  	<xsl:param name="x"/>
  	<xsl:param name="param1" select="@param1"/> 
  	<xsl:value-of select="$x + $param1"/>
  </xsl:template>

  <generic:func name="decr" param1="1"/>
  <xsl:template match="generic:func[@name='decr']">
  	<xsl:param name="x"/>
  	<xsl:param name="param1" select="@param1"/> 
  	<xsl:value-of select="$x - $param1"/>
  </xsl:template>

  <!-- Predicates on x -->
  
  <generic:func name="less-than"/>
  <xsl:template match="generic:func[@name='less-than']">
  	<xsl:param name="x"/>
  	<!-- limit -->
  	<xsl:param name="param1"/> 
  	<xsl:if test="$x &lt; $param1"><xsl:value-of select="$x"/></xsl:if>
  </xsl:template>
  
  <generic:func name="less-than-eq"/>
  <xsl:template match="generic:func[@name='less-than-eq']">
  	<xsl:param name="x"/>
  	<!-- limit -->
  	<xsl:param name="param1"/> 
  	<xsl:if test="$x &lt;= $param1"><xsl:value-of select="$x"/></xsl:if>
  </xsl:template>

  <generic:func name="greater-than"/>
  <xsl:template match="generic:func[@name='greater-than']">
  	<xsl:param name="x"/>
  	<!-- limit -->
  	<xsl:param name="param1"/> 
  	<xsl:if test="$x > $param1"><xsl:value-of select="$x"/></xsl:if>
  </xsl:template>
  
  <generic:func name="greater-than-eq"/>
  <xsl:template match="generic:func[@name='greater-than-eq']">
  	<xsl:param name="x"/>
  	<!-- limit -->
  	<xsl:param name="param1"/> 
  	<xsl:if test="$x >= $param1"><xsl:value-of select="$x"/></xsl:if>
  </xsl:template>
  
  <generic:func name="f-of-x-less-than"/>
  <xsl:template match="generic:func[@name='f-of-x-less-than']">
  	<xsl:param name="x"/>
  	<!-- name of f -->
  	<xsl:param name="param1"/> 
  	<!-- limit -->
  	<xsl:param name="param2"/> 
  	
  	<xsl:variable name="f-of-x">
  		<xsl:apply-templates select="$generic:generics[self::generic:func and @name = $param1]">
  			<xsl:with-param name="x" select="$x"/>
  		</xsl:apply-templates>
  	</xsl:variable>
  	<xsl:if test="$f-of-x &lt; $param1"><xsl:value-of select="$x"/></xsl:if>
  </xsl:template>
  
  <generic:func name="f-of-x-less-than-eq"/>
  <xsl:template match="generic:func[@name='f-of-x-less-than-eq']">
  	<xsl:param name="x"/>
  	<!-- name of f -->
  	<xsl:param name="param1"/> 
  	<!-- limit -->
  	<xsl:param name="param2"/> 
  
  	<xsl:variable name="f-of-x">
  		<xsl:apply-templates select="$generic:generics[self::generic:func and @name = $param1]">
  			<xsl:with-param name="x" select="$x"/>
  		</xsl:apply-templates>
  	</xsl:variable>
  
  	<xsl:if test="$f-of-x &lt;= $param1"><xsl:value-of select="$x"/></xsl:if>
  </xsl:template>

  <generic:func name="f-of-x-greater-than"/>
  <xsl:template match="generic:func[@name='f-of-x-greater-than']">
  	<xsl:param name="x"/>
  	<!-- name of f -->
  	<xsl:param name="param1"/> 
  	<!-- limit -->
  	<xsl:param name="param2"/> 
  	
  	<xsl:variable name="f-of-x">
  		<xsl:apply-templates select="$generic:generics[self::generic:func and @name = $param1]">
  			<xsl:with-param name="x" select="$x"/>
  		</xsl:apply-templates>
  	</xsl:variable>
  	<xsl:if test="$f-of-x > $param1"><xsl:value-of select="$x"/></xsl:if>
  </xsl:template>
  
  <generic:func name="f-of-x-greater-than-eq"/>
  <xsl:template match="generic:func[@name='f-of-x-greater-than-eq']">
  	<xsl:param name="x"/>
  	<!-- name of f -->
  	<xsl:param name="param1"/> 
  	<!-- limit -->
  	<xsl:param name="param2"/> 
  
  	<xsl:variable name="f-of-x">
  		<xsl:apply-templates select="$generic:generics[self::generic:func and @name = $param1]">
  			<xsl:with-param name="x" select="$x"/>
  		</xsl:apply-templates>
  	</xsl:variable>
  
  	<xsl:if test="$f-of-x >= $param1"><xsl:value-of select="$x"/></xsl:if>
  </xsl:template>
  
  <xsl:template match="generic:func">
  	<xsl:message terminate="yes">
  		BAD FUNC! Template may not match generic:func declaration.
  	</xsl:message>
  </xsl:template>
  
<!-- Primitive generic aggregators -->	

  <generic:aggr-func name="sum" identity="0"/>
  <xsl:template match="generic:aggr-func[@name='sum']">
  	<xsl:param name="x"/>
  	<xsl:param name="accum"/>
  	<xsl:value-of select="$x + $accum"/>
  </xsl:template>
  
  <generic:aggr-func name="product" identity="1"/>
  <xsl:template match="generic:aggr-func[@name='product']">
  	<xsl:param name="x"/>
  	<xsl:param name="accum"/>
  	<xsl:value-of select="$x * $accum"/>
  </xsl:template>

<generic:aggr-func name="min" identity="min"/>
<xsl:template match="generic:aggr-func[@name='min']">
	<xsl:param name="x"/>
	<xsl:param name="accum"/>
  <xsl:choose>
    <xsl:when test="$accum = @identity or $accum >= $x"> 
      <xsl:value-of select="$x"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$accum"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<generic:aggr-func name="max" identity="max"/>
<xsl:template match="generic:aggr-func[@name='max']">
	<xsl:param name="x"/>
	<xsl:param name="accum"/>
  <xsl:choose>
    <xsl:when test="$accum = @identity or $accum &lt; $x"> 
      <xsl:value-of select="$x"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$accum"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<generic:aggr-func name="avg" identity="0"/>
<xsl:template match="generic:aggr-func[@name='avg']">
	<xsl:param name="x"/>
	<xsl:param name="accum"/>
	<xsl:param name="i"/>
	<xsl:value-of select="(($i - 1) * $accum + $x) div $i"/>
</xsl:template>

<generic:aggr-func name="variance" identity=""/>
<xsl:template match="generic:aggr-func[@name='variance']">
  <xsl:param name="x"/>
  <xsl:param name="accum"/>
  <xsl:param name="i"/>
	
  <xsl:choose>
    <xsl:when test="$accum = @identity">
      <!-- Initialize the sum, sum of squares and variance. The variance of a single number is zero -->
      <variance sum="{$x}" sumSq="{$x * $x}">0</variance>
    </xsl:when>
    <xsl:otherwise>
      <!--Use node-set to convert $accum to a nodes set containing the variance element -->
      <xsl:variable name="accumElem" select="exslt:node-set($accum)"/>
      <!-- Aggregate the sum of $x component -->
      <xsl:variable name="sum" select="$accumElem/*/@sum + $x"/>
      <!-- Aggregate the sum of $x squared component -->
      <xsl:variable name="sumSq" select="$accumElem/*/@sumSq + $x * $x"/>
      <!--Return the element with attributes and the current variance as its value -->
      <variance sum="{$sum}" sumSq="{$sumSq}">
        <xsl:value-of select="($sumSq - ($sum * $sum) div $i) div ($i - 1)"/>
      </variance>
    </xsl:otherwise>
  </xsl:choose>
 
</xsl:template>


  <!-- Generic aggregation template -->
  <xsl:template name="generic:aggregation">
    <xsl:param name="nodes"/>
    <xsl:param name="aggr-func" select=" 'sum' "/>
    <xsl:param name="func" select=" 'identity' "/>
    <xsl:param name="func-param1" select="$generic:generics[self::generic:func and 
                                  @name = $func]/@param1"/>
    <xsl:param name="i" select="1"/>
    <xsl:param name="accum" select="$generic:generics[self::generic:aggr-func and 
                                    @name = $aggr-func]/@identity"/>
    
    <xsl:choose>
      <xsl:when test="$nodes">
        
       <!--Compute func($x) --> 
        <xsl:variable name="f-of-x">
          <xsl:apply-templates select="$generic:generics[self::generic:func and @name = $func]">
            <xsl:with-param name="x" select="$nodes[1]"/>
            <xsl:with-param name="i" select="$i"/>
            <xsl:with-param name="param1" select="$func-param1"/>
          </xsl:apply-templates>
        </xsl:variable>

        <!-- Aggregate current $f-of-x with $accum -->    
        <xsl:variable name="temp">
          <xsl:apply-templates 
    		select="$generic:generics[self::generic:aggr-func and 
    						@name = $aggr-func]">
            <xsl:with-param name="x" select="$f-of-x"/>
            <xsl:with-param name="accum" select="$accum"/>
            <xsl:with-param name="i" select="$i"/>
          </xsl:apply-templates>
        </xsl:variable>       
        
        <!--We tail recursivly process the remaining nodes using position() -->
        <xsl:call-template name="generic:aggregation">
          <xsl:with-param name="nodes" select="$nodes[position()!=1]"/>
          <xsl:with-param name="aggr-func" select="$aggr-func"/>
          <xsl:with-param name="func" select="$func"/>
          <xsl:with-param name="func-param1" select="$func-param1"/>
          <xsl:with-param name="i" select="$i + 1"/>
          <xsl:with-param name="accum" select="$temp"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$accum"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Generic reverse aggregation template -->
  <xsl:template name="generic:reverse-aggregation">
    <xsl:param name="nodes"/>
    <xsl:param name="aggr-func" select=" 'sum' "/>
    <xsl:param name="func" select=" 'identity' "/>
    <xsl:param name="func-param1" select="$generic:generics[self::generic:func and 
                                  @name = $func]/@param1"/>
    <xsl:param name="i" select="1"/>
    <xsl:param name="accum" select="$generic:generics[self::generic:aggr-func and 
                                    @name = $aggr-func]/@identity"/>
    
    <xsl:choose>
      <xsl:when test="$nodes">
        
       <!--Compute func($x) --> 
        <xsl:variable name="f-of-x">
          <xsl:apply-templates select="$generic:generics[self::generic:func and @name = $func]">
            <xsl:with-param name="x" select="$nodes[last()]"/>
            <xsl:with-param name="i" select="$i"/>
            <xsl:with-param name="param1" select="$func-param1"/>
          </xsl:apply-templates>
        </xsl:variable>

        <!-- Aggregate current $f-of-x with $accum -->    
        <xsl:variable name="temp">
          <xsl:apply-templates 
    		select="$generic:generics[self::generic:aggr-func and 
    						@name = $aggr-func]">
            <xsl:with-param name="x" select="$f-of-x"/>
            <xsl:with-param name="accum" select="$accum"/>
            <xsl:with-param name="i" select="$i"/>
          </xsl:apply-templates>
        </xsl:variable>       
        
        <!--We tail recursivly process the remaining nodes using position() -->
        <xsl:call-template name="generic:aggregation">
          <xsl:with-param name="nodes" select="$nodes[position()!=last()]"/>
          <xsl:with-param name="aggr-func" select="$aggr-func"/>
          <xsl:with-param name="func" select="$func"/>
          <xsl:with-param name="func-param1" select="$func-param1"/>
          <xsl:with-param name="i" select="$i + 1"/>
          <xsl:with-param name="accum" select="$temp"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$accum"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template name="generic:bounded-aggregation">
    <xsl:param name="x" select="0"/>
    <xsl:param name="func" select=" 'identity' "/>
    <xsl:param name="func-param1" select="$generic:generics[self::generic:func and 
                                  @name = $func]/@param1"/>
    <xsl:param name="test-func" select=" 'less-than' "/>
    <xsl:param name="test-param1" select="$x + 1"/> 
    <xsl:param name="incr-func" select=" 'incr' "/>
    <xsl:param name="incr-param1" select="1"/> 
    <xsl:param name="i" select="1"/>
    <xsl:param name="aggr-func" select=" 'sum' "/>
    <xsl:param name="aggr-param1"/> 
    <xsl:param name="accum" select="$generic:generics[self::generic:aggr-func and 
                                  @name = $aggr-func]/@identity"/>

    
    <!-- Check if aggregation should continue -->  
    <xsl:variable name="continue">
      <xsl:apply-templates select="$generic:generics[self::generic:func and @name = $test-func]">
        <xsl:with-param name="x" select="$x"/>
        <xsl:with-param name="param1" select="$test-param1"/>
      </xsl:apply-templates>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="string($continue)">
       <!--Compute func($x) --> 
        <xsl:variable name="f-of-x">
          <xsl:apply-templates select="$generic:generics[self::generic:func and @name = $func]">
            <xsl:with-param name="x" select="$x"/>
            <xsl:with-param name="i" select="$i"/>
            <xsl:with-param name="param1" select="$func-param1"/>
          </xsl:apply-templates>
        </xsl:variable>

        <!-- Aggregate current $f-of-x with $accum -->    
        <xsl:variable name="temp">
          <xsl:apply-templates select="$generic:generics[self::generic:aggr-func and @name = $aggr-func]">
            <xsl:with-param name="x" select="$f-of-x"/>
            <xsl:with-param name="i" select="$i"/>
            <xsl:with-param name="param1" select="$aggr-param1"/>
            <xsl:with-param name="accum" select="$accum"/>
          </xsl:apply-templates>
        </xsl:variable>       

        <!-- Compute the next value of $x-->    
        <xsl:variable name="next-x">
          <xsl:apply-templates select="$generic:generics[self::generic:func and @name = $incr-func]">
            <xsl:with-param name="x" select="$x"/>
            <xsl:with-param name="param1" select="$incr-param1"/>
          </xsl:apply-templates>
        </xsl:variable>    
      
          <!--We tail recursivly process the remaining nodes using position() -->
          <xsl:call-template name="generic:bounded-aggregation">
            <xsl:with-param name="x" select="$next-x"/>
            <xsl:with-param name="func" select="$func"/>
            <xsl:with-param name="func-param1" select="$func-param1"/>
            <xsl:with-param name="test-func" select="$test-func"/>
            <xsl:with-param name="test-param1" select="$test-param1"/> 
            <xsl:with-param name="incr-func" select="$incr-func"/>
            <xsl:with-param name="incr-param1" select="$incr-param1"/> 
            <xsl:with-param name="i" select="$i + 1"/>
            <xsl:with-param name="aggr-func" select="$aggr-func"/>
            <xsl:with-param name="aggr-param1" select="$aggr-param1"/> 
            <xsl:with-param name="accum" select="$temp"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$accum"/>
        </xsl:otherwise>
      </xsl:choose>
  </xsl:template>

<xsl:template name="generic:pos-aggregation">
    <xsl:param name="nodes"/>
    <xsl:param name="aggr-func" select=" 'sum' "/>
    <xsl:param name="func"/>
    <xsl:param name="func-param1" select="$generic:generics[self::generic:func and 
                                  @name = $func]/@param1"/>
    <xsl:param name="i" select="1"/>
    <xsl:param name="accum" select="$generic:generics[self::generic:aggr-func and 
                                    @name = $aggr-func]/@identity"/>

    <xsl:choose>
      <xsl:when test="$nodes">
        
       <!--Compute func($x) --> 
        <xsl:variable name="f-of-x">
              <xsl:apply-templates select="($generic:generics[self::generic:func and @name = $func and (@n = $i or @n = '*')])[1]">
                <xsl:with-param name="x" select="$nodes[1]"/>
                <xsl:with-param name="i" select="$i"/>
                <xsl:with-param name="param1" select="$func-param1"/>
              </xsl:apply-templates>
        </xsl:variable>

        <!-- Aggregate current $f-of-x with $accum -->    
        <xsl:variable name="temp">
          <xsl:apply-templates 
    		select="$generic:generics[self::generic:aggr-func and 
    						@name = $aggr-func]">
            <xsl:with-param name="x" select="$f-of-x"/>
            <xsl:with-param name="accum" select="$accum"/>
            <xsl:with-param name="i" select="$i"/>
          </xsl:apply-templates>
        </xsl:variable>       
        
        <!--We tail recursivly process the remaining nodes using position() -->
        <xsl:call-template name="generic:pos-aggregation">
          <xsl:with-param name="nodes" select="$nodes[position()!=1]"/>
          <xsl:with-param name="aggr-func" select="$aggr-func"/>
          <xsl:with-param name="func" select="$func"/>
          <xsl:with-param name="func-param1" select="$func-param1"/>
          <xsl:with-param name="i" select="$i + 1"/>
          <xsl:with-param name="accum" select="$temp"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$accum"/>
      </xsl:otherwise>
    </xsl:choose>
  
</xsl:template>

<xsl:template name="generic:map">
  <xsl:param name="nodes" select="/.."/>
  <xsl:param name="func" select=" 'identity' "/>
  <xsl:param name="func-param1" select="$generic:generics[self::generic:func and @name = $func]/@param1"/>
  <xsl:param name="i" select="1"/>
  <xsl:param name="result" select="/.."/>
  
  <xsl:choose>
    <xsl:when test="$nodes">
      <xsl:variable name="temp">
        <xsl:apply-templates select="$generic:generics[self::generic:func and @name = $func]">
            <xsl:with-param name="x" select="$nodes[1]"/>
            <xsl:with-param name="i" select="$i"/>
            <xsl:with-param name="param1" select="$func-param1"/>
        </xsl:apply-templates>
      </xsl:variable>

      <xsl:call-template name="generic:map">
        <xsl:with-param name="nodes" select="$nodes[position() > 1]"/>
        <xsl:with-param name="func" select="$func"/>
        <xsl:with-param name="func-param1" select="$func-param1"/>
        <xsl:with-param name="i" select="$i +1"/>
        <xsl:with-param name="result" select="$result | exslt:node-set($temp)"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="$result" mode="generic:map"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="/ | node() | @*" mode="generic:map">
  <node>
    <xsl:copy-of select="."/>
  </node>
</xsl:template>

<xsl:template name="generic:map2">
  <xsl:param name="nodes1" select="/.."/>
  <xsl:param name="nodes2" select="/.."/>
  <xsl:param name="func" select=" 'identity' "/>
  <xsl:param name="func-param1" select="$generic:generics[self::generic:func and @name = $func]/@param1"/>
  <xsl:param name="i" select="1"/>
  <xsl:param name="result" select="/.."/>
  
  <xsl:choose>
    <xsl:when test="$nodes1 and $nodes2">
      <xsl:variable name="temp">
        <xsl:apply-templates select="$generic:generics[self::generic:aggr-func and @name = $func]">
            <xsl:with-param name="x" select="$nodes1[1]"/>
            <xsl:with-param name="accum" select="$nodes2[1]"/>
            <xsl:with-param name="i" select="$i"/>
            <xsl:with-param name="param1" select="$func-param1"/>
        </xsl:apply-templates>
      </xsl:variable>

      <xsl:call-template name="generic:map2">
        <xsl:with-param name="nodes1" select="$nodes1[position() > 1]"/>
        <xsl:with-param name="nodes2" select="$nodes2[position() > 1]"/>
        <xsl:with-param name="func" select="$func"/>
        <xsl:with-param name="func-param1" select="$func-param1"/>
        <xsl:with-param name="i" select="$i +1"/>
        <xsl:with-param name="result" select="$result | exslt:node-set($temp)"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="$result" mode="generic:map2"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="/ | node() | @*" mode="generic:map2">
  <node>
    <xsl:copy-of select="."/>
  </node>
</xsl:template>

<xsl:template name="generic:gen-set">
  <xsl:param name="x" select="1"/>
  <xsl:param name="func" select=" 'identity' "/>
  <xsl:param name="func-param1" select="$generic:generics[self::generic:func and @name = $func]/@param1"/>
  <xsl:param name="test-func" select=" 'less-than' "/>
  <xsl:param name="test-param1" select="$x + 1"/> 
  <xsl:param name="incr-func" select=" 'incr' "/>
  <xsl:param name="incr-param1" select="1"/> 
  <xsl:param name="i" select="1"/>
  <xsl:param name="result" select="/.."/>

    <!-- Check if aggregation should continue -->  
    <xsl:variable name="continue">
      <xsl:apply-templates select="$generic:generics[self::generic:func and @name = $test-func]">
        <xsl:with-param name="x" select="$x"/>
        <xsl:with-param name="param1" select="$test-param1"/>
      </xsl:apply-templates>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="string($continue)">
       <!--Compute func($x) --> 
        <xsl:variable name="f-of-x">
          <xsl:apply-templates select="$generic:generics[self::generic:func and @name = $func]">
            <xsl:with-param name="x" select="$x"/>
            <xsl:with-param name="i" select="$i"/>
            <xsl:with-param name="param1" select="$func-param1"/>
          </xsl:apply-templates>
        </xsl:variable>

        <!-- Compute the next value of $x-->    
        <xsl:variable name="next-x">
          <xsl:apply-templates select="$generic:generics[self::generic:func and @name = $incr-func]">
            <xsl:with-param name="x" select="$x"/>
            <xsl:with-param name="param1" select="$incr-param1"/>
          </xsl:apply-templates>
        </xsl:variable>    
      
          <xsl:call-template name="generic:gen-set">
            <xsl:with-param name="x" select="$next-x"/>
            <xsl:with-param name="func" select="$func"/>
            <xsl:with-param name="func-param1" select="$func-param1"/>
            <xsl:with-param name="test-func" select="$test-func"/>
            <xsl:with-param name="test-param1" select="$test-param1"/> 
            <xsl:with-param name="incr-func" select="$incr-func"/>
            <xsl:with-param name="incr-param1" select="$incr-param1"/> 
            <xsl:with-param name="i" select="$i + 1"/>
            <xsl:with-param name="result" select="$result | exslt:node-set($f-of-x)"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="$result" mode="generic:gen-set"/>
        </xsl:otherwise>
      </xsl:choose>
</xsl:template>

<xsl:template match="node()" mode="generic:gen-set">
  <gen-set>
    <xsl:copy-of select="."/>
  </gen-set>
</xsl:template>

<xsl:template name="generic:gen-nested">
  <xsl:param name="x" select="1"/>
  <xsl:param name="func" select=" 'identity' "/>
  <xsl:param name="func-param1" select="$generic:generics[self::generic:func and @name = $func]/@param1"/>
  <xsl:param name="i" select="1"/>
  <xsl:param name="n" select="2"/>
  <xsl:param name="result">
    <xsl:value-of select="$x"/>
  </xsl:param> 

    <xsl:choose>
      <xsl:when test="$i &lt;= $n">
       <!--Compute func($x) --> 
        <xsl:variable name="f-of-x">
          <xsl:apply-templates select="$generic:generics[self::generic:func and @name = $func]">
            <xsl:with-param name="x" select="$x"/>
            <xsl:with-param name="i" select="$i"/>
            <xsl:with-param name="param1" select="$func-param1"/>
          </xsl:apply-templates>
        </xsl:variable>

          <xsl:call-template name="generic:gen-nested">
            <xsl:with-param name="x" select="$f-of-x"/>
            <xsl:with-param name="func" select="$func"/>
            <xsl:with-param name="func-param1" select="$func-param1"/>
            <xsl:with-param name="i" select="$i + 1"/>
            <xsl:with-param name="n" select="$n"/>
            <xsl:with-param name="result" select="exslt:node-set($result) | exslt:node-set($f-of-x)"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="$result" mode="generic:gen-nested"/>
        </xsl:otherwise>
      </xsl:choose>
</xsl:template>

<xsl:template match="node()" mode="generic:gen-nested">
  <gen-nested>
    <xsl:copy-of select="."/>
  </gen-nested>
</xsl:template>



</xsl:stylesheet>
