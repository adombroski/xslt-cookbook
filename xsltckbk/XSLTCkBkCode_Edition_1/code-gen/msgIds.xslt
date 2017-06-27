<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="text"/>
  <xsl:strip-space elements="*"/>

  <!--The name of the output source code file. --> 
  <xsl:param name="file" select=" 'MESSAGE_IDS.h' "/>
  
  <!-- The default behavior is to generate C++ style constants -->
  <xsl:variable name="constant-type" select=" 'const int' "/>

  <!-- The default behavior is to generate C++ style constants -->
  <xsl:variable name="constant-suffix" select=" '_ID' "/>


  <!-- The default C++ assigment operator -->
  <xsl:variable name="assignment" select=" ' = ' "/>

  <!-- The default C++ statement terminator -->
  <xsl:variable name="terminator" select=" ';' "/>


  <!--Transform repository into a sequence of message constant definitions -->  
  <xsl:template match="MessageRepository">
    <xsl:call-template name="constants-start"/>
    <xsl:apply-templates select="Messages/Message"/>
    <xsl:call-template name="constants-end"/>
  </xsl:template>  

  <!--Each meesage becomes a comment and an constant definition -->
  <xsl:template match="Message"	>
    <xsl:call-template name="message-doc"/>
    <xsl:call-template name="message-constant"/>
  </xsl:template>

  <!-- C++ header files start with an inclusion guard -->
  <xsl:template name="constants-start">
    <xsl:variable name="guard" select="translate($file,'.','_')"/>
    <xsl:text>#ifndef </xsl:text>
    <xsl:value-of select="$guard"/>
    <xsl:text>&#xa;</xsl:text> 
    <xsl:text>#define </xsl:text>
    <xsl:value-of select="$guard"/>
    <xsl:text>&#xa;&#xa;&#xa;</xsl:text>
  </xsl:template>

  <!-- C++ header files end with the closure of the top level inclusion guard -->
  <xsl:template name="constants-end">
    <xsl:variable name="guard" select="translate($file,'.','_')"/>
    <xsl:text>&#xa;&#xa;&#xa;#endif /* </xsl:text>
    <xsl:value-of select="$guard"/>
    <xsl:text> */&#xa;</xsl:text> 
  </xsl:template>

  <!-- Each constant definition is preceeded by a cooment describing the associated message -->
  <xsl:template name="message-doc">
  /*
  * Purpose:     <xsl:call-template name="format-comment"> 
  			       <xsl:with-param name="text" select="Documentation"/>
  		            </xsl:call-template>
  * Data Format: <xsl:value-of select="DataTypeName"/>
  * From:        <xsl:apply-templates select="Senders"/>
  * To:          <xsl:apply-templates select="Receivers"/>
  */
  </xsl:template>

  <!-- Used in the generation of message documentation. Lists sender or receiver processes -->
  <xsl:template match="Senders|Receivers">
    <xsl:for-each select="ProcessRef">
      <xsl:value-of select="."/><xsl:if test="position() != last()"><xsl:text>, </xsl:text></xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- This utility wraps comments at 40 characters wide -->
  <xsl:template name="format-comment">
    <xsl:param name="text"/>
    <xsl:choose>
      <xsl:when test="string-length($text)&lt;40">
        <xsl:value-of select="$text"/>
      </xsl:when>
      <xsl:otherwise>
        <!-- A crude but generally effective way to break only on white space.  -->
        <xsl:variable name="first-part"  select="substring($text,1,39)"/>
        <xsl:variable name="line" select="concat($first-part,substring-before(substring($text,40),'&#x20;'))" />
        <xsl:value-of select="$line"/>
        <xsl:text>&#xa;  *             </xsl:text>
        <xsl:call-template name="format-comment"><xsl:with-param name="text" select="substring($text,string-length($line)+1)"/></xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Each message name becomes a constant whose value is the message id -->
  <xsl:template name="message-constant">
    <xsl:value-of select="$constant-type"/><xsl:text> </xsl:text>
    <xsl:value-of select="Name"/>
    <xsl:value-of select="$constant-suffix"/>
    <xsl:value-of select="$assignment"/>
    <xsl:value-of select="MsgId"/>
    <xsl:value-of select="$terminator"/>
    <xsl:text>&#xa;</xsl:text>
  </xsl:template>
  
  <!-- Ignore text elements not explicitly handled by above templates -->
  <xsl:template match="text()"/>

  
</xsl:stylesheet>
