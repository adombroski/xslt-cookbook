<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xslt [
  <!--Used to control code intenting -->
  <!ENTITY INDENT "    ">
  <!ENTITY INDENT2 "&INDENT;&INDENT;">
  <!ENTITY LS "&lt;&lt;">
]>
<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- This mesage parse generator needs a message switch so we -->
<!-- reuse the one we already wrote. -->
<xsl:import href="messageSwitch.xslt"/>

  <!--The directory to generate code -->
  <xsl:param name="generationDir" select=" 'src/' "/>
  <!--The C++ header file name -->
  <xsl:param name="msgParseHeader" select=" 'msgParse.h' "/>
  <!--The C++ source file name -->
  <xsl:param name="msgParseSource" select=" 'msgParse.C' "/>

  <!--Key to locate data types by name -->
  <xsl:key name="dataTypes" match="Structure" use="Name" /> 
  <xsl:key name="dataTypes" match="Primitive" use="Name" /> 
  <xsl:key name="dataTypes" match="Array" use="Name" /> 
  <xsl:key name="dataTypes" match="Enumeration" use="Name" /> 

  <xsl:template match="MessageRepository">
    <xsl:document href="{concat($generationDir,$msgParseHeader)}">
      <xsl:text>void parseMessage</xsl:text>
       <xsl:text>(MessageHandler&amp; handler, const Message&amp; msg);&#xa;</xsl:text>
      <xsl:apply-templates select="DataTypes/Structure" mode="declare"/>
    </xsl:document>

    <xsl:document href="{concat($generationDir,$msgParseSource)}">
      <xsl:apply-imports/>
      <xsl:apply-templates select="DataTypes/Structure" mode="parsers"/>
    </xsl:document>
      
  </xsl:template>	

<!--Override the message processing function name from messageSwitch.xslt -->
<!-- to customize the function signiture to take a handler -->
<xsl:template name="process-function">
<xsl:text>void parseMessage</xsl:text>
<xsl:text>(MessageHandler&amp; handler, const Message&amp; msg)</xsl:text>
</xsl:template>

<!--Override case action from messageSwitch.xslt to generate -->
<!-- call to parse for message data -->
<xsl:template name="case-action">
 <xsl:text>   parse(handler, *static_cast&lt;const </xsl:text>
 <xsl:value-of select="DataTypeName"/>
 <xsl:text>*&gt;(msg.getData())) ;
         break;</xsl:text>
</xsl:template>

<!--Generate declarations for each message data type -->
<xsl:template match="Structure" mode="declare">
<!--Forward declare the message data class -->
<xsl:text>class </xsl:text>
<xsl:value-of select="Name"/>
<xsl:text> ;&#xa;</xsl:text>
<!--Forward declare the message parse function -->
<xsl:text>void parse(MessageHandler &amp; handler, const </xsl:text>
<xsl:value-of select="Name"/>
<xsl:text>&amp; data);&#xa;</xsl:text>
</xsl:template>

<!--Generate the body of  a parser -->
<xsl:template match="Structure" mode="parsers">
<xsl:text>void parse(MessageHandler &amp; handler, const </xsl:text>
<xsl:value-of select="Name"/>
<xsl:text>&amp; data)&#xa;</xsl:text>
<xsl:text>{&#xa;</xsl:text>
<xsl:text>&INDENT;handler.beginStruct("</xsl:text>  
<xsl:value-of select="Name"/>
<xsl:text>") ;&#xa;</xsl:text>  
  <xsl:for-each select="Members/Member">
      <xsl:apply-templates select="key('dataTypes',DataTypeName)" mode="parse">
        <xsl:with-param name="name" select="Name"/>
      </xsl:apply-templates> 
  </xsl:for-each>
<xsl:text>&INDENT;handler.endStruct("</xsl:text>  
<xsl:value-of select="Name"/>
<xsl:text>") ;&#xa;</xsl:text>  
  <xsl:text>}&#xa;&#xa;</xsl:text> 
</xsl:template>

<!--Nested structures invoke the parser for that structure -->
<xsl:template match="Structure" mode="parse">
  <xsl:param name="name"/>
  <xsl:text>&INDENT;parse(handler, data.get_</xsl:text>
  <xsl:value-of select="$name"/><xsl:text>());&#xa;</xsl:text>
</xsl:template>

<!--We assume there is a get function for each -->
<!-- primitive component of the message -->
<xsl:template match="*" mode="parse">
  <xsl:param name="name"/>
  <xsl:text>&INDENT;handler.field("</xsl:text>
  <xsl:value-of select="$name"/>","<xsl:text/>
  <xsl:value-of select="Name"/>",<xsl:text/>
  <xsl:text>data.get_</xsl:text>
  <xsl:value-of select="$name"/>()<xsl:text/>
  <xsl:text>);&#xa;</xsl:text> 
  
</xsl:template>

</xsl:stylesheet>
