<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="text"/>

  <xsl:param name="process" select=" '*' "/>

  <xsl:variable name="message-dir" select=" 'messages' "/>
  <xsl:variable name="directory-sep" select=" '/' "/>
  <xsl:variable name="include-ext" select=" '.h' "/>
  

  <xsl:template match="MessageRepository">
    <!-- Generate source file preliminaries -->
    <xsl:call-template name="file-start"/>
    
    <!-- Generate includes for messages this process recives -->
    <xsl:apply-templates select="Messages/
                                                Message[Receivers/
                                                              ProcessRef = 
                                                              $process or $process = '*']" 
                                    mode="includes"/>
    
    <!-- Generate message switch preliminaries -->                                
    <xsl:call-template name="switch-start"/>
    
    <!-- Generate switch body -->
    <xsl:apply-templates select="Messages/
                                                Message[Receivers/
                                                              ProcessRef = 
                                                              $process or $process = '*']" 
                                    mode="switch"/>
    
    <!-- Generate switch end -->                                
    <xsl:call-template name="switch-end"/>
    
    <!-- Generate file end -->
    <xsl:call-template name="file-end"/>
  </xsl:template>	

  <!-- Generate an include for each message -->	
  <xsl:template match="Message" mode="includes">
    <xsl:text>#include &lt;</xsl:text>
    <xsl:value-of select="$message-dir"/>
    <xsl:value-of select="$directory-sep"/>
    <xsl:value-of select="Name"/>
    <xsl:value-of select="$include-ext"/>
    <xsl:text>&gt;&#xa;</xsl:text>
  </xsl:template>

  <!-- Generate handler case for each message type -->
  <xsl:template match="Message" mode="switch">
    case <xsl:value-of select="Name"/>_ID:
      <xsl:call-template name="case-action"/>
  </xsl:template>

<!-- Generate the message handler action -->
<xsl:template name="case-action">
      return <xsl:value-of select="Name"/>(*static_cast&lt;const <xsl:value-of select="DataTypeName"/>*&gt;(msg.getData())).process() ;
</xsl:template>

  <!-- Do nothing by default. Users will override if necessary -->
  <xsl:template name="file-start"/>
  <xsl:template name="file-end"/>

  <!-- Generate satrt of switch statement --> 
  <xsl:template name="switch-start">
#include &lt;transport/Message.h&gt;
#include &lt;transport/MESSAGE_IDS.h&gt;

<xsl:text>&#xa;&#xa;</xsl:text>
<xsl:call-template name="process-function"/>
{
  switch (msg.getId())
  {
  </xsl:template>
  
  <xsl:template name="switch-end">
    return false ;
  }
}
  </xsl:template>

<!-- Generate signiture for message processing entry point -->
<xsl:template name="process-function">
bool processMessage(const Message&amp; msg)
</xsl:template>


</xsl:stylesheet>
