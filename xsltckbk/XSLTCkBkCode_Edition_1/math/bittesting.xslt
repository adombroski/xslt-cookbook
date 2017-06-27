<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" id="bittesting">

<!--powers of two-->
<xsl:variable name="bit15" select="32768"/>
<xsl:variable name="bit14" select="16384"/>
<xsl:variable name="bit13" select="8192"/>
<xsl:variable name="bit12" select="4096"/>
<xsl:variable name="bit11" select="2048"/>
<xsl:variable name="bit10" select="1024"/>
<xsl:variable name="bit9"  select="512"/>
<xsl:variable name="bit8"  select="256"/>
<xsl:variable name="bit7"  select="128"/>
<xsl:variable name="bit6"  select="64"/>
<xsl:variable name="bit5"  select="32"/>
<xsl:variable name="bit4"  select="16"/>
<xsl:variable name="bit3"  select="8"/>
<xsl:variable name="bit2"  select="4"/>
<xsl:variable name="bit1"  select="2"/>
<xsl:variable name="bit0"  select="1"/>

<xsl:template name="bitTest">
  <xsl:param name="num"/>
  <xsl:param name="bit" select="$bit0"/>
  <xsl:choose>
    <xsl:when test="( $num mod ( $bit * 2 ) ) -
                    ( $num mod ( $bit     ) )">1</xsl:when>
    <xsl:otherwise>0</xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="bitAnd">
  <xsl:param name="num1"/>
  <xsl:param name="num2"/>
  <xsl:param name="result" select="0"/>
  <xsl:param name="test" select="$bit15"/>
  
  <xsl:variable name="nextN1" select="($num1 >= $test) * ($num1 - $test) + not($num1 >= $test) * $num1"/>
  <xsl:variable name="nextN2" select="($num2 >= $test) * ($num2 - $test) + not($num2 >= $test) * $num2"/>
  
  <xsl:choose>
    <xsl:when test="$test &lt; 1">
      <xsl:value-of select="$result"/>
    </xsl:when>  
    <xsl:when test="$num1 >= $test and $num2 >= $test">
      <xsl:call-template name="bitAnd">
        <xsl:with-param name="num1" select="$nextN1"/>
        <xsl:with-param name="num2" select="$nextN2"/>
        <xsl:with-param name="result" select="$result + $test"/>
        <xsl:with-param name="test" select="$test div 2"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="bitAnd">
        <xsl:with-param name="num1" select="$nextN1"/>
        <xsl:with-param name="num2" select="$nextN2"/>
        <xsl:with-param name="result" select="$result"/>
        <xsl:with-param name="test" select="$test div 2"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="bitOr">
  <xsl:param name="num1"/>
  <xsl:param name="num2"/>
  <xsl:param name="result" select="0"/>
  <xsl:param name="test" select="$bit15"/>

  <xsl:variable name="nextN1" select="($num1 >= $test) * ($num1 - $test) + not($num1 >= $test) * $num1"/>
  <xsl:variable name="nextN2" select="($num2 >= $test) * ($num2 - $test) + not($num2 >= $test) * $num2"/>
  
  <xsl:choose>
    <xsl:when test="$test &lt; 1">
      <xsl:value-of select="$result"/>
    </xsl:when>  
    <xsl:when test="$num1 >= $test or $num2 >= $test">
      <xsl:call-template name="bitOr">
        <xsl:with-param name="num1" select="$nextN1"/>
        <xsl:with-param name="num2" select="$nextN2"/>
        <xsl:with-param name="result" select="$result + $test"/>
        <xsl:with-param name="test" select="$test div 2"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="bitOr">
        <xsl:with-param name="num1" select="$nextN1"/>
        <xsl:with-param name="num2" select="$nextN2"/>
        <xsl:with-param name="result" select="$result"/>
        <xsl:with-param name="test" select="$test div 2"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="bitXor">
  <xsl:param name="num1"/>
  <xsl:param name="num2"/>
  <xsl:param name="result" select="0"/>
  <xsl:param name="test" select="$bit15"/>

  <xsl:variable name="nextN1" select="($num1 >= $test) * ($num1 - $test) + not($num1 >= $test) * $num1"/>
  <xsl:variable name="nextN2" select="($num2 >= $test) * ($num2 - $test) + not($num2 >= $test) * $num2"/>
  
  <xsl:choose>
    <xsl:when test="$test &lt; 1">
      <xsl:value-of select="$result"/>
    </xsl:when>  
    <xsl:when test="$num1 >= $test and not($num2 >= $test) or not($num1 >= $test) and $num2 >= $test">
      <xsl:call-template name="bitXor">
        <xsl:with-param name="num1" select="$nextN1"/>
        <xsl:with-param name="num2" select="$nextN2"/>
        <xsl:with-param name="result" select="$result + $test"/>
        <xsl:with-param name="test" select="$test div 2"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="bitXor">
        <xsl:with-param name="num1" select="$nextN1"/>
        <xsl:with-param name="num2" select="$nextN2"/>
        <xsl:with-param name="result" select="$result"/>
        <xsl:with-param name="test" select="$test div 2"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="bitNot">
  <xsl:param name="num"/>
  <xsl:param name="result" select="0"/>
  <xsl:param name="test" select="$bit15"/>
  
  <xsl:choose>
    <xsl:when test="$test &lt; 1">
      <xsl:value-of select="$result"/>
    </xsl:when>  
    <xsl:when test="$num >= $test">
      <xsl:call-template name="bitNot">
        <xsl:with-param name="num" select="$num - $test"/>
        <xsl:with-param name="result" select="$result"/>
        <xsl:with-param name="test" select="$test div 2"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="bitNot">
        <xsl:with-param name="num" select="$num"/>
        <xsl:with-param name="result" select="$result + $test"/>
        <xsl:with-param name="test" select="$test div 2"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="xsl:stylesheet[@id='bittesting'] | xsl:include[@href='bittesting.xslt']"   
	               xmlns:test="http://www.ora.com/XSLTCookbook/test">

  <xsl:message>TESTING bit tests</xsl:message>
  <xsl:for-each select="document('')/*/test:tests/*">
  	<xsl:variable name="ansAnd">
  		<xsl:call-template name="bitAnd">
  			<xsl:with-param name="num1" select="@n1"/>
  			<xsl:with-param name="num2" select="@n2"/>
  		</xsl:call-template>
  	</xsl:variable>
  	<xsl:if test="$ansAnd != @ansAnd">
  		<xsl:message>
  			bitAnd TEST <xsl:value-of select="@num"/> FAILED [<xsl:value-of select="$ansAnd"/>]
  		</xsl:message>
  	</xsl:if>
  	
  	<xsl:variable name="ansOr">
  		<xsl:call-template name="bitOr">
  			<xsl:with-param name="num1" select="@n1"/>
  			<xsl:with-param name="num2" select="@n2"/>
  		</xsl:call-template>
  	</xsl:variable>
  	<xsl:if test="$ansOr != @ansOr">
  		<xsl:message>
  			bitOr TEST <xsl:value-of select="@num"/> FAILED [<xsl:value-of select="$ansOr"/>]
  		</xsl:message>
  	</xsl:if>
  	
  	<xsl:variable name="ansXor">
  		<xsl:call-template name="bitXor">
  			<xsl:with-param name="num1" select="@n1"/>
  			<xsl:with-param name="num2" select="@n2"/>
  		</xsl:call-template>
  	</xsl:variable>
  	<xsl:if test="$ansXor != @ansXor">
  		<xsl:message>
  			bitXor TEST <xsl:value-of select="@num"/> FAILED [<xsl:value-of select="$ansXor"/>]
  		</xsl:message>
  	</xsl:if>
  	
  </xsl:for-each>
  
</xsl:template>

<test:tests xmlns:test="http://www.ora.com/XSLTCookbook/test">
  <test:test num="1" n1="1" n2="1" ansAnd="1" ansOr="1" ansXor="0"/>
  <test:test num="2" n1="1" n2="0" ansAnd="0" ansOr="1" ansXor="1"/>
  <test:test num="3" n1="0" n2="1" ansAnd="0" ansOr="1" ansXor="1"/>
  <test:test num="4" n1="0" n2="0" ansAnd="0" ansOr="0" ansXor="0"/>
  <test:test num="5" n1="3" n2="1" ansAnd="1" ansOr="3" ansXor="2"/>
  <test:test num="6" n1="3" n2="2" ansAnd="2" ansOr="3" ansXor="1"/>
  <test:test num="7" n1="3" n2="3" ansAnd="3" ansOr="3" ansXor="0"/>
  <test:test num="8" n1="65535" n2="65535" ansAnd="65535" ansOr="65535" ansXor="0"/>
  <test:test num="9" n1="65535" n2="65534" ansAnd="65534" ansOr="65535" ansXor="1"/>
  <test:test num="10" n1="32768" n2="16384" ansAnd="0" ansOr="49152" ansXor="49152"/>
</test:tests>

</xsl:stylesheet>

