<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="text"/>

  <!-- Specifies which process to generate handlers for -->
  <xsl:param name="process"/>
  <!-- Specifies which message to generate handlers for. A special value of %ALL% signifies all messages -->
  <xsl:param name="message" select=" '%ALL%' "/>


  <!-- The directory where -->
  <xsl:variable name="message-dir" select=" 'messages' "/>
  <xsl:variable name="directory-sep" select=" '/' "/>
  <xsl:variable name="include-ext" select=" '.h' "/>

  
  <xsl:template match="MessageRepository">
    <xsl:choose>
      <xsl:when test="$message='%ALL%'"  >
          <xsl:apply-templates select="Messages/Message[Receivers/ProcessRef = $process]"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="Messages/Message[Receivers/ProcessRef = $process and Name=$message]"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>	


  <xsl:template match="Message"	>
    <xsl:document href="{concat(Name,'.h')}">
      <xsl:call-template name="makeHeader"/>
    </xsl:document>
    <xsl:document href="{concat(Name,'.cpp')}">
      <xsl:call-template name="makeSource"/>
    </xsl:document>
    </xsl:template>

  <xsl:template name="makeHeader">
#ifndef <xsl:value-of select="Name"/>_h
#define <xsl:value-of select="Name"/>_h

#include &lt;transport/MessageHandler.h&gt;

//Forward Declarations
class <xsl:value-of select="DataTypeName"/> ;
/*!TODO:  Insert addition forward declarations here.*/   

class <xsl:value-of select="Name"/> : public MessageHandler
{
public:
    <xsl:value-of select="Name"/>(const <xsl:value-of select="DataTypeName"/>&amp; data) ;
    bool process() ;
private:

    const <xsl:value-of select="DataTypeName"/>&amp; m_Data ;
} ;

#endif
  </xsl:template>  
  
  <xsl:template name="makeSource">
#include &lt;messages/<xsl:value-of select="Name"/>.h&gt;

/*!TODO:  Insert addition includes here.*/   

<xsl:value-of select="Name"/>::<xsl:value-of select="Name"/>(const <xsl:value-of select="DataTypeName"/>&amp; data)
  : m_Data(data)
{
}

bool <xsl:value-of select="Name"/>::process()
{
  /*!TODO:  Insert message handler code here. */
  return true; 
}
  </xsl:template>  
  
</xsl:stylesheet>
