<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xslt [
  <!--Used to control code intenting -->
  <!ENTITY INDENT "    ">
  <!ENTITY INDENT2 "&INDENT;&INDENT;">
  <!ENTITY LS "&lt;&lt;">
]>
<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- This pretty-printer generator needs a message switch so we -->
<!-- reuse the one we already wrote. -->
<xsl:import href="messageSwitch.xslt"/>

  <!--The directory to generate code -->
  <xsl:param name="generationDir" select=" 'src/' "/>
  <!--The C++ header file name -->
  <xsl:param name="prettyPrintHeader" select=" 'prettyPrint.h' "/>
  <!--The C++ source file name -->
  <xsl:param name="prettyPrintSource" select=" 'prettyPrint.C' "/>

  <!--Key to locate data types by name -->
  <xsl:key name="dataTypes" match="Structure" use="Name" /> 
  <xsl:key name="dataTypes" match="Primitive" use="Name" /> 
  <xsl:key name="dataTypes" match="Array" use="Name" /> 
  <xsl:key name="dataTypes" match="Enumeration" use="Name" /> 

  <xsl:template match="MessageRepository">
    <xsl:document href="{concat($generationDir,$prettyPrintHeader)}">
      <xsl:text>void prettyPrintMessage</xsl:text>
       <xsl:text>(ostream&amp; stream, const Message&amp; msg);&#xa;</xsl:text>
      <xsl:apply-templates select="DataTypes/Structure" mode="declare"/>
    </xsl:document>

    <xsl:document href="{concat($generationDir,$prettyPrintSource)}">
      <xsl:apply-imports/>
      <xsl:apply-templates select="DataTypes/Structure" mode="printers"/>
    </xsl:document>
      
  </xsl:template>	

<!--Override the message processing function name from messageSwitch.xslt -->
<!-- to customize the function signiture to take a stream -->
<xsl:template name="process-function">
<xsl:text>void prettyPrintMessage</xsl:text>
<xsl:text>(ostream&amp; stream, const Message&amp; msg)</xsl:text>
</xsl:template>

<!--Override case action from messageSwitch.xslt to generate -->
<!-- call to prettyPrinter for message data -->
<xsl:template name="case-action">
 <xsl:text>   prettyPrint(stream, *static_cast&lt;const </xsl:text>
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
<!--Forward declare the message prettyPrint function -->
<xsl:text>ostream prettyPrint(ostream &amp; stream, const </xsl:text>
<xsl:value-of select="Name"/>
<xsl:text>&amp; data);&#xa;</xsl:text>
</xsl:template>

<!--Generate the body of  a pretty-printer -->
<xsl:template match="Structure" mode="printers">
<xsl:text>ostream prettyPrint(ostream &amp; stream, const </xsl:text>
<xsl:value-of select="Name"/>
<xsl:text>&amp; data)&#xa;</xsl:text>
<xsl:text>{&#xa;</xsl:text>
<xsl:text>&INDENT;stream &#xa;</xsl:text>  
<xsl:text>&INDENT2;&LS; "</xsl:text>
<xsl:value-of select="Name"/>
<xsl:text>" &LS;  endl  &LS; "{"  &LS; endl &#xa;</xsl:text>  
  <xsl:for-each select="Members/Member">
      <xsl:text>&INDENT2;&LS; "</xsl:text>
      <xsl:value-of select="Name"/>: " &LS; <xsl:text/>
      <xsl:apply-templates select="key('dataTypes',DataTypeName)" mode="print">
        <xsl:with-param name="name" select="Name"/>
      </xsl:apply-templates> 
      <xsl:text>&#xa;</xsl:text> 
  </xsl:for-each>
  <xsl:text>&INDENT2;&LS; "}"  &LS; endl ; &#xa;</xsl:text>
  <xsl:text>&INDENT;return stream ;&#xa;</xsl:text>
  <xsl:text>}&#xa;&#xa;</xsl:text> 
</xsl:template>

<!--Nested structures invoke the pretty-printer for that structure -->
<xsl:template match="Structure" mode="print">
  <xsl:param name="name"/>
  <xsl:text>prettyPrint(stream, data.get_</xsl:text>
  <xsl:value-of select="$name"/><xsl:text>())</xsl:text>
</xsl:template>

<!--We assume there is a get function for each -->
<!-- primitive component of the message -->
<xsl:template match="*" mode="print">
  <xsl:param name="name"/>
  <xsl:text>data.get_</xsl:text>
  <xsl:value-of select="$name"/>() &lt;&lt; endl<xsl:text/>
</xsl:template>

</xsl:stylesheet>
