<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:str="http://www.ora.com/XSLTCookbook/namespaces/strings" 
  extension-element-prefixes="str"
  id="str.find-last2">

<xsl:template name="str:substring-before-last"> 

  <xsl:param name="input"/>
  <xsl:param name="substr"/>
  
  <xsl:variable name="mid" select="ceiling(string-length($input) div 2)"/>
  <xsl:variable name="temp1" select="substring($input,1, $mid)"/>
  <xsl:variable name="temp2" select="substring($input,$mid +1)"/>
  <xsl:choose>
    <xsl:when test="$temp2 and contains($temp2,$substr)">
      <!--search string is in second half so just append first half and recuse on second -->
      <xsl:value-of select="$temp1"/>
      <xsl:call-template name="str:substring-before-last">
        <xsl:with-param name="input" select="$temp2"/>
        <xsl:with-param name="substr" select="$substr"/>
      </xsl:call-template>
    </xsl:when>
    <!--search string is in boundary so a simple  substring-before will do the trick-->
    <xsl:when test="contains(substring($input,$mid - string-length($substr) +1), $substr)">
      <xsl:value-of select="substring-before($input,$substr)"/>
    </xsl:when>
    <!--search string is in first half so through away second half-->
    <xsl:when test="contains($temp1,$substr)">
      <xsl:call-template name="str:substring-before-last">
      <xsl:with-param name="input" select="$temp1"/>
      <xsl:with-param name="substr" select="$substr"/>
      </xsl:call-template>
    </xsl:when>
    <!-- No occurances of search string so we are done -->
    <xsl:otherwise/>
  </xsl:choose>
  
</xsl:template>

<xsl:template match="xsl:stylesheet[@id='str.find-last2'] | xsl:include[@href='str.find-last2.xslt'] " >

<tests>

<!-- before -->
	<test name="str:substring-before-last with no occurences of yes">
	<xsl:call-template name="str:substring-before-last">
		<xsl:with-param name="input" select=" 'No occurences' "/>
		<xsl:with-param name="substr" select=" 'yes' "/>
	</xsl:call-template>
	</test>
	
	<test name="str:substring-before-last starts with yes">
	<xsl:call-template name="str:substring-before-last">
		<xsl:with-param name="input" select=" 'yes occurences' "/>
		<xsl:with-param name="substr" select=" 'yes' "/>
	</xsl:call-template>
	</test>

	<test name="str:substring-before-last starts with yes and ends with yes">
	<xsl:call-template name="str:substring-before-last">
		<xsl:with-param name="input" select=" 'yes occurences yes' "/>
		<xsl:with-param name="substr" select=" 'yes' "/>
	</xsl:call-template>
	</test>

	<test name="str:substring-before-last 3 yes">
	<xsl:call-template name="str:substring-before-last">
		<xsl:with-param name="input" select=" 'yesyesyes' "/>
		<xsl:with-param name="substr" select=" 'yes' "/>
	</xsl:call-template>
	</test>
	<test name="str:substring-before-last empty input">
	<xsl:call-template name="str:substring-before-last">
		<xsl:with-param name="substr" select=" 'yes' "/>
	</xsl:call-template>
	</test>
	
	<test name="str:substring-before-last empty search">
	<xsl:call-template name="str:substring-before-last">
		<xsl:with-param name="input" select=" 'No occurences' "/>
	</xsl:call-template>
	</test>

	<test name="str:substring-before-last large">
	<xsl:call-template name="str:substring-before-last">
		<xsl:with-param name="input" select=" 'yesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyesyes' "/>
		<xsl:with-param name="substr" select=" 'yes' "/>
	</xsl:call-template>


	</test>

<!-- after -->

	<test name="str:substring-after-last with no occurences of yes">
	<xsl:call-template name="str:substring-after-last">
		<xsl:with-param name="input" select=" 'No occurences' "/>
		<xsl:with-param name="substr" select=" 'yes' "/>
	</xsl:call-template>
	</test>
	
	<test name="str:substring-after-last starts with yes">
	<xsl:call-template name="str:substring-after-last">
		<xsl:with-param name="input" select=" 'yes occurences' "/>
		<xsl:with-param name="substr" select=" 'yes' "/>
	</xsl:call-template>
	</test>

	<test name="str:substring-after-last starts with yes and ends with yes">
	<xsl:call-template name="str:substring-after-last">
		<xsl:with-param name="input" select=" 'yes occurences yes' "/>
		<xsl:with-param name="substr" select=" 'yes' "/>
	</xsl:call-template>
	</test>

	<test name="str:substring-after-last 3 yes">
	<xsl:call-template name="str:substring-after-last">
		<xsl:with-param name="input" select=" 'yesyesyes' "/>
		<xsl:with-param name="substr" select=" 'yes' "/>
	</xsl:call-template>
	</test>

	<test name="str:substring-after-last 3 yes then no">
	<xsl:call-template name="str:substring-after-last">
		<xsl:with-param name="input" select=" 'yesyesyesno' "/>
		<xsl:with-param name="substr" select=" 'yes' "/>
	</xsl:call-template>
	</test>
	
	<test name="str:substring-after-last empty input">
	<xsl:call-template name="str:substring-after-last">
		<xsl:with-param name="substr" select=" 'yes' "/>
	</xsl:call-template>
	</test>
	
	<test name="str:substring-after-last empty search">
	<xsl:call-template name="str:substring-after-last">
		<xsl:with-param name="input" select=" 'No occurences' "/>
	</xsl:call-template>

	</test>

</tests>
</xsl:template>

</xsl:stylesheet>
