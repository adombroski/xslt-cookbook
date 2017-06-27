<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xslt [
  <!--Used to control code intenting -->
  <!ENTITY INDENT "    ">
]>
<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="text"/>
  <xsl:strip-space elements="*"/>

  <!--The message to generate data for. '*' for all -->
  <xsl:param name="message" select=" '*' "/>
  <!--The directory to generate code -->
  <xsl:param name="generationDir" select=" 'src/' "/>
  <!--The C++ header extension to use -->
  <xsl:param name="headerExt" select=" '.h' "/>
  <!--The C++ source extension to use -->
  <xsl:param name="sourceExt" select=" '.C' "/>

  <!--Key to locate data types by name -->
  <xsl:key name="dataTypes" match="Structure" use="Name" /> 
  <xsl:key name="dataTypes" match="Primitive" use="Name" /> 
  <xsl:key name="dataTypes" match="Array" use="Name" /> 
  <xsl:key name="dataTypes" match="Enumeration" use="Name" /> 
  

  <!-- Top level template determines which messages to process -->
  <xsl:template match="/"> 
    <xsl:choose>
        <xsl:when test="$message = '*'">
          <xsl:apply-templates select="*/Messages/*"/>
        </xsl:when>
        <xsl:when test="*/Messages/Message[Name=$message]">
          <xsl:apply-templates select="*/Messages/Message[Name=$message]"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:message terminate="yes">No such message name [<xsl:value-of select="$message"/>]</xsl:message>
        </xsl:otherwise>
      </xsl:choose>
  </xsl:template>

<!-- If the messages data type is contained in the repository then gnerate data wrapper header and source file for it -->
<xsl:template match="Message">
  <xsl:choose>
    <xsl:when test="key('dataTypes',DataTypeName)">
      <xsl:apply-templates select="key('dataTypes',DataTypeName)" mode="source">
        <xsl:with-param name="msg" select="Name"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
            <xsl:message>Message name [<xsl:value-of select="Name"/>] uses data [<xsl:value-of select="DataTypeName"/>] that is not defined in the repository.</xsl:message>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>	

<!-- We only generate source if a messages data type is a Stucture. -->
<!-- The only other typical message data type is XML. We don't          -->
<!-- generate wrappers for XML payloads.                                          -->
<xsl:template match="Structure" mode="source">
  <xsl:param name="msg"/>

  <xsl:document href="{concat($generationDir,Name,'CGI',$sourceExt)}">

<xsl:text>
#include &lt;stdio.h&gt;
#include "cgi.h"
#include "msg_ids.h"
#include "</xsl:text>
<xsl:value-of select="Name"/><xsl:value-of select="$headerExt"/>
<xsl:text>"

void cgi_main(cgi_info *cgi)
{
    </xsl:text>
    <xsl:value-of select="Name"/> 
    <xsl:text> data ;
    form_entry* form_data = get_form_entries(cgi) ;   
</xsl:text>
  
  <xsl:for-each select="Members/Member">
    <xsl:apply-templates select="key('dataTypes',DataTypeName)" mode="variables">
      <xsl:with-param name="field" select="concat($msg,'_',Name)"/>
      <xsl:with-param name="var" select="Name"/>
    </xsl:apply-templates>
   </xsl:for-each>

  <xsl:for-each select="Members/Member">
    <xsl:apply-templates select="key('dataTypes',DataTypeName)" mode="load">
      <xsl:with-param name="field" select="concat('data.',Name)"/>
      <xsl:with-param name="var" select="Name"/>
    </xsl:apply-templates>
  </xsl:for-each>

<xsl:text>
&INDENT;//Enque data to the process being tested 
&INDENT;enqueData(</xsl:text>
<xsl:value-of select="$msg"/>
<xsl:text>,data) ;

}</xsl:text>   
</xsl:document>
</xsl:template>

<!-- Declare and initialize variables for each field -->
<xsl:template match="Structure" mode="variables">
  <xsl:param name="field"/>
  <xsl:param name="var"/>
      <xsl:for-each select="Members/Member">
            <xsl:apply-templates select="key('dataTypes',DataTypeName)" mode="variables">
              <xsl:with-param name="field" select="concat($field,'_',Name)"/>
              <xsl:with-param name="var" select="$var"/>
            </xsl:apply-templates>
     </xsl:for-each>
</xsl:template>

<xsl:template match="*" mode="variables">
  <xsl:param name="field"/>
  <xsl:param name="var"/>
  
  <xsl:text>&INDENT;const char * </xsl:text>
  <xsl:value-of select="$var"/>
  <xsl:text> = parmval(form_data, "</xsl:text>
  <xsl:value-of select="$field"/>
  <xsl:text>");&#xa;</xsl:text>
</xsl:template>

<!-- Initialize data form the converted value -->
<xsl:template match="Structure" mode="load">
  <xsl:param name="field"/>
  <xsl:param name="var"/>
  <xsl:for-each select="Members/Member">
        <xsl:apply-templates select="key('dataTypes',DataTypeName)" mode="load">
          <xsl:with-param name="field" select="concat($field,'.',Name)"/>
          <xsl:with-param name="var" select="concat($field,'_',Name)"/>
        </xsl:apply-templates>
  </xsl:for-each>
</xsl:template>

<xsl:template match="Primitive" mode="load">
  <xsl:param name="field"/>
  <xsl:param name="var"/>
 
  <xsl:text>&INDENT;</xsl:text>
  <xsl:value-of select="$field"/>  
  <xsl:text> = </xsl:text>
  <xsl:value-of select="Name"/>
  <xsl:text>(</xsl:text>
  <xsl:value-of select="$var"/>
  <xsl:text>);&#xa;</xsl:text>
</xsl:template>
  
<xsl:template match="Enumeration" mode="load">
 <xsl:param name="field"/>
  <xsl:param name="var"/>
 
  <xsl:text>&INDENT;</xsl:text>
  <xsl:value-of select="$field"/>  
  <xsl:text> = Enum</xsl:text>
  <xsl:value-of select="Name"/>
  <xsl:text>NameToVal(</xsl:text>
  <xsl:value-of select="$var"/>
  <xsl:text>);&#xa;</xsl:text>
</xsl:template>

</xsl:stylesheet>
